codeunit 80800 "PMS Job Management"
{
    var
        JobsAlreadyCreatedErr: Label 'Jobs have already been created for contract %1. Delete the existing jobs before creating new ones.', Comment = '%1 = Contract ID';
        JobsCreatedMsg: Label '%1 job(s) created for contract %2.', Comment = '%1 = count, %2 = Contract ID';
        NoContractLinesErr: Label 'Contract %1 has no lines. Add contract lines before creating jobs.', Comment = '%1 = Contract ID';
        JobCreatedMsg: Label 'Job %1 has been created from helpdesk call %2.', Comment = '%1 = Job No., %2 = Call No.';
        PurchOrderCreatedMsg: Label 'Purchase Order %1 has been created for job %2.', Comment = '%1 = PO No., %2 = Job No.';
        JobAlreadyHasPOErr: Label 'Job %1 is already linked to purchase order %2.', Comment = '%1 = Job No., %2 = PO No.';
        EmailSendFailedMsg: Label 'Email notification could not be sent to %1.', Comment = '%1 = Email address';

    /// <summary>
    /// Creates one PMS Job per contract-line occurrence and one Purchase Order (with
    /// one line per job) for External contracts. Internal contracts get jobs only.
    /// </summary>
    procedure CreateJobsFromContract(ContractHeader: Record "PMS Contract Header")
    var
        ContractLine: Record "PMS Contract Line";
        PMSJob: Record "PMS Job";
        PMSSetup: Record "PMS Setup";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        NoSeries: Codeunit "No. Series";
        NextPurchLineNo: Integer;
        OccurrenceDate: Date;
        OccurrenceNo: Integer;
        JobsCreated: Integer;
        IsExternal: Boolean;
    begin
        ContractHeader.TestField("Contract ID");
        ContractHeader.TestField("Start Date");
        ContractHeader.TestField("End Date");

        IsExternal := ContractHeader."Contract Type" = ContractHeader."Contract Type"::External;

        if IsExternal then
            ContractHeader.TestField("Vendor No.")
        else
            ContractHeader.TestField("Employee No.");

        // Prevent duplicate creation
        PMSJob.SetRange("Source Type", PMSJob."Source Type"::Contract);
        PMSJob.SetRange("Source No.", ContractHeader."Contract ID");
        if not PMSJob.IsEmpty() then
            Error(JobsAlreadyCreatedErr, ContractHeader."Contract ID");

        // Must have at least one line
        ContractLine.SetRange("Contract ID", ContractHeader."Contract ID");
        if ContractLine.IsEmpty() then
            Error(NoContractLinesErr, ContractHeader."Contract ID");

        PMSSetup.GetRecordOnce();
        PMSSetup.TestField("Job Nos.");

        // Create one Purchase Order for the entire contract (external only)
        if IsExternal then begin
            PurchHeader.Init();
            PurchHeader.Validate("Document Type", PurchHeader."Document Type"::Order);
            PurchHeader.Insert(true);
            PurchHeader.Validate("Buy-from Vendor No.", ContractHeader."Vendor No.");
            PurchHeader."Your Reference" := ContractHeader."Contract ID";
            PurchHeader."PMS Contract ID" := ContractHeader."Contract ID";
            PurchHeader.Modify(true);

            ContractHeader."Purchase Order No." := PurchHeader."No.";
            ContractHeader.Modify(true);

            NextPurchLineNo := 10000;
        end;

        // Loop through each contract line and generate one job per occurrence
        if ContractLine.FindSet() then
            repeat
                OccurrenceDate := ContractHeader."Start Date";
                OccurrenceNo := 0;

                while OccurrenceDate <= ContractHeader."End Date" do begin
                    OccurrenceNo += 1;

                    // Build the PMS Job record
                    PMSJob.Init();
                    PMSJob."Job No." := NoSeries.GetNextNo(PMSSetup."Job Nos.", OccurrenceDate, true);
                    PMSJob."No. Series" := PMSSetup."Job Nos.";
                    PMSJob.Description := ContractLine.Description;
                    PMSJob."Source Type" := PMSJob."Source Type"::Contract;
                    PMSJob."Source No." := ContractHeader."Contract ID";
                    PMSJob."Source Line No." := ContractLine."Line No.";
                    PMSJob."Occurrence No." := OccurrenceNo;
                    PMSJob."Property ID" := ContractLine."Property ID";
                    PMSJob."Job Type" := ContractHeader."Contract Type";
                    PMSJob."Vendor No." := ContractHeader."Vendor No.";
                    PMSJob."Vendor Name" := ContractHeader."Vendor Name";
                    PMSJob."Employee No." := ContractHeader."Employee No.";
                    PMSJob."Employee Name" := ContractHeader."Employee Name";
                    PMSJob."Scheduled Date" := OccurrenceDate;
                    PMSJob."Estimated Cost" := ContractLine."Unit Price" * ContractLine.Quantity;
                    PMSJob."G/L Account No." := ContractLine."G/L Account No.";
                    PMSJob."Global Dimension 1 Code" := ContractLine."Global Dimension 1 Code";
                    PMSJob."Special Instructions" := ContractLine."Special Instructions";
                    PMSJob.Status := PMSJob.Status::Open;

                    if IsExternal then begin
                        PMSJob."Purchase Order No." := PurchHeader."No.";
                        PMSJob."Purchase Order Line No." := NextPurchLineNo;
                    end;

                    PMSJob.Insert(false);

                    // Create matching Purchase Line (external contracts only)
                    if IsExternal then begin
                        PurchLine.Init();
                        PurchLine."Document Type" := PurchHeader."Document Type";
                        PurchLine."Document No." := PurchHeader."No.";
                        PurchLine."Line No." := NextPurchLineNo;
                        PurchLine.Insert(true);
                        PurchLine.Validate(Type, PurchLine.Type::"G/L Account");
                        PurchLine.Validate("No.", ContractLine."G/L Account No.");
                        PurchLine.Description := CopyStr(
                            StrSubstNo('%1 - %2', ContractLine.Description, Format(OccurrenceDate)),
                            1, MaxStrLen(PurchLine.Description));
                        PurchLine.Validate(Quantity, ContractLine.Quantity);
                        PurchLine.Validate("Direct Unit Cost", ContractLine."Unit Price");
                        PurchLine."Expected Receipt Date" := OccurrenceDate;
                        PurchLine."PMS Job No." := PMSJob."Job No.";
                        PurchLine."PMS Property ID" := ContractLine."Property ID";
                        if ContractLine."Global Dimension 1 Code" <> '' then
                            PurchLine.Validate("Shortcut Dimension 1 Code", ContractLine."Global Dimension 1 Code");
                        ApplyPropertyDimension(PurchLine, ContractLine."Property ID");
                        PurchLine.Modify(true);

                        NextPurchLineNo += 10000;
                    end;

                    JobsCreated += 1;

                    // Single Charge or blank frequency = one occurrence only
                    if ContractLine."Job Frequency" in [ContractLine."Job Frequency"::"Single Charge",
                                                        ContractLine."Job Frequency"::" "] then
                        break;

                    OccurrenceDate := CalcNextOccurrenceDate(OccurrenceDate, ContractLine."Job Frequency");
                end;
            until ContractLine.Next() = 0;

        Message(JobsCreatedMsg, JobsCreated, ContractHeader."Contract ID");
    end;

    /// <summary>
    /// Creates a single PMS Job from a Helpdesk Call. Defaults to Internal type.
    /// The user can change the Job Type on the job card and then run CreatePurchaseOrderForJob
    /// if supplier involvement is required.
    /// </summary>
    procedure CreateJobFromCall(HelpdeskCall: Record "PMS Helpdesk Call"): Code[20]
    var
        PMSJob: Record "PMS Job";
        PMSSetup: Record "PMS Setup";
        NoSeries: Codeunit "No. Series";
    begin
        HelpdeskCall.TestField("Call No.");

        PMSSetup.GetRecordOnce();
        PMSSetup.TestField("Job Nos.");

        PMSJob.Init();
        PMSJob."Job No." := NoSeries.GetNextNo(PMSSetup."Job Nos.", WorkDate(), true);
        PMSJob."No. Series" := PMSSetup."Job Nos.";
        PMSJob.Description := HelpdeskCall.Description;
        PMSJob.Details := HelpdeskCall.Details;
        PMSJob."Source Type" := PMSJob."Source Type"::"Helpdesk Call";
        PMSJob."Source No." := HelpdeskCall."Call No.";
        PMSJob."Property ID" := HelpdeskCall."Property ID";
        PMSJob."Unit ID" := HelpdeskCall."Unit ID";
        PMSJob.Priority := HelpdeskCall.Priority;
        PMSJob."Job Type" := PMSJob."Job Type"::Internal;
        PMSJob."Employee No." := HelpdeskCall."Employee No.";
        PMSJob."Employee Name" := HelpdeskCall."Employee Name";
        PMSJob."Resource No." := HelpdeskCall."Resource No.";
        PMSJob."Resource Name" := HelpdeskCall."Resource Name";
        PMSJob."Scheduled Date" := HelpdeskCall."Target Resolution Date";
        PMSJob."Created Date" := HelpdeskCall."Reported Date";  // Use call's reported date
        PMSJob.Status := PMSJob.Status::Open;
        PMSJob.Insert(false);

        // Copy all dimensions from the Helpdesk Call to the Job
        if HelpdeskCall."Property ID" <> '' then
            PMSJob.CopyDimensionsFromPropertyPublic(HelpdeskCall."Property ID");

        // Send email notification for internal jobs
        if PMSJob."Job Type" = PMSJob."Job Type"::Internal then
            SendJobAssignmentEmail(PMSJob);

        Message(JobCreatedMsg, PMSJob."Job No.", HelpdeskCall."Call No.");
        exit(PMSJob."Job No.");
    end;

    /// <summary>
    /// Completes an internal helpdesk job and spawns a new External (supplier) job
    /// linked to the same helpdesk call. The call remains In Progress.
    /// </summary>
    procedure CompleteAndSpawnExternalJob(var CurrentJob: Record "PMS Job"): Code[20]
    var
        NewJob: Record "PMS Job";
        PMSSetup: Record "PMS Setup";
        NoSeries: Codeunit "No. Series";
        SpawnDlg: Page "PMS Spawn Job Dlg";
        UserRec: Record User;
        SpawnReason: Text[250];
        SuggestedVendor: Code[20];
        SpawnedByName: Text[80];
    begin
        CurrentJob.TestField("Source Type", CurrentJob."Source Type"::"Helpdesk Call");
        CurrentJob.TestField("Source No.");

        // Show spawn dialog to capture details
        SpawnDlg.SetDefaults(CurrentJob."Estimated Cost", CurrentJob.Priority);
        SpawnDlg.RunModal();

        if not SpawnDlg.WasConfirmed() then
            exit('');

        SpawnReason := SpawnDlg.GetSpawnReason();
        SuggestedVendor := SpawnDlg.GetSuggestedVendor();

        // Get user's full name
        SpawnedByName := UserId();
        UserRec.SetRange("User Security ID", UserSecurityId());
        if UserRec.FindFirst() then
            if UserRec."Full Name" <> '' then
                SpawnedByName := UserRec."Full Name";

        PMSSetup.GetRecordOnce();
        PMSSetup.TestField("Job Nos.");

        // Mark the current job as Completed (engineer's work is done)
        CurrentJob.Validate(Status, CurrentJob.Status::Completed);
        if CurrentJob."Completed Date" = 0DT then
            CurrentJob."Completed Date" := CurrentDateTime;
        CurrentJob."Spawned By" := CopyStr(UserId(), 1, 50);
        CurrentJob."Spawn Reason" := SpawnReason;
        CurrentJob.Modify(true);

        // Spawn new External job linked to the same call
        NewJob.Init();
        NewJob."Job No." := NoSeries.GetNextNo(PMSSetup."Job Nos.", WorkDate(), true);
        NewJob."No. Series" := PMSSetup."Job Nos.";
        NewJob.Description := CurrentJob.Description;
        NewJob."Source Type" := CurrentJob."Source Type"::"Helpdesk Call";
        NewJob."Source No." := CurrentJob."Source No.";
        NewJob."Property ID" := CurrentJob."Property ID";
        NewJob."Unit ID" := CurrentJob."Unit ID";
        NewJob.Priority := SpawnDlg.GetPriority();
        NewJob."Job Type" := NewJob."Job Type"::External;
        NewJob."Scheduled Date" := CurrentJob."Scheduled Date";
        NewJob."Estimated Quantity" := SpawnDlg.GetQuantity();
        NewJob."Estimated Unit Cost" := SpawnDlg.GetDirectUnitCost();
        NewJob."Estimated Cost" := SpawnDlg.GetLineAmount();
        NewJob."G/L Account No." := CurrentJob."G/L Account No.";
        
        // Inherit Global Dimension 1 from current job, or from Property if not set
        if CurrentJob."Global Dimension 1 Code" <> '' then
            NewJob."Global Dimension 1 Code" := CurrentJob."Global Dimension 1 Code"
        else
            NewJob."Global Dimension 1 Code" := GetPropertyGlobalDimension1(CurrentJob."Property ID");
            
        NewJob."Created Date" := CurrentJob."Created Date";  // Inherit created date from original job
        NewJob.Status := NewJob.Status::Open;
        NewJob."Related Job No." := CurrentJob."Job No.";
        NewJob."Suggested Vendor No." := SuggestedVendor;
        if SuggestedVendor <> '' then
            NewJob.Validate("Vendor No.", SuggestedVendor);
        NewJob.Notes := 'Spawned from job ' + CurrentJob."Job No." + ' by ' + SpawnedByName + '. Reason: ' + SpawnReason;
        NewJob.Insert(false);

        // Copy all dimensions from Property to Job
        if NewJob."Property ID" <> '' then
            NewJob.CopyDimensionsFromPropertyPublic(NewJob."Property ID");

        // Create initial expense line from spawn dialog values
        CreateInitialExpenseLine(NewJob, SpawnDlg.GetCategoryPostingGroup(), NewJob.Description, SpawnDlg.GetQuantity(), SpawnDlg.GetDirectUnitCost());

        // Link back from original job to new job
        CurrentJob."Related Job No." := NewJob."Job No.";
        CurrentJob.Modify(true);

        // Send email notification to office team
        SendSpawnedJobNotification(NewJob, CurrentJob, SpawnReason, SpawnedByName);

        exit(NewJob."Job No.");
    end;

    /// <summary>
    /// Creates a standalone Purchase Order for a call-based External job.
    /// Called from the Job Card when the user has set Vendor No. and G/L Account.
    /// </summary>
    procedure CreatePurchaseOrderForJob(var PMSJob: Record "PMS Job")
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        JobExpenseLine: Record "PMS Job Expense Line";
        LineNo: Integer;
    begin
        PMSJob.TestField("Vendor No.");

        if PMSJob."Purchase Order No." <> '' then
            Error(JobAlreadyHasPOErr, PMSJob."Job No.", PMSJob."Purchase Order No.");

        // Ensure at least one expense line exists
        JobExpenseLine.SetRange("Job No.", PMSJob."Job No.");
        if not JobExpenseLine.FindSet() then
            Error('Cannot create purchase order. Please add at least one expense line to job %1.', PMSJob."Job No.");

        PurchHeader.Init();
        PurchHeader.Validate("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.Insert(true);
        PurchHeader.Validate("Buy-from Vendor No.", PMSJob."Vendor No.");
        PurchHeader."Your Reference" := PMSJob."Job No.";
        PurchHeader.Modify(true);

        // Loop through expense lines and create PO lines
        LineNo := 10000;
        repeat
            JobExpenseLine.TestField("G/L Account No.");
            PurchLine.Init();
            PurchLine."Document Type" := PurchHeader."Document Type";
            PurchLine."Document No." := PurchHeader."No.";
            PurchLine."Line No." := LineNo;
            PurchLine.Insert(true);
            PurchLine.Validate(Type, PurchLine.Type::"G/L Account");
            PurchLine.Validate("No.", JobExpenseLine."G/L Account No.");
            PurchLine.Description := JobExpenseLine.Description;
            PurchLine.Validate(Quantity, JobExpenseLine.Quantity);
            PurchLine.Validate("Direct Unit Cost", JobExpenseLine."Direct Unit Cost");
            PurchLine."Expected Receipt Date" := PMSJob."Scheduled Date";
            PurchLine."PMS Job No." := PMSJob."Job No.";
            PurchLine."PMS Property ID" := PMSJob."Property ID";
            
            // Copy dimensions from expense line and apply property dimension
            CopyDimensionsFromExpenseLine(PurchLine, JobExpenseLine);
            
            PurchLine.Modify(true);
            LineNo += 10000;
        until JobExpenseLine.Next() = 0;

        PMSJob."Purchase Order No." := PurchHeader."No.";
        PMSJob."Purchase Order Line No." := 10000;
        PMSJob.Modify(true);

        Message(PurchOrderCreatedMsg, PurchHeader."No.", PMSJob."Job No.");
    end;

    local procedure CreateInitialExpenseLine(var PMSJob: Record "PMS Job"; CategoryPostingGroup: Code[20]; Description: Text[100]; Quantity: Decimal; DirectUnitCost: Decimal)
    var
        ExpenseLine: Record "PMS Job Expense Line";
        CatPostingGroup: Record "PMS Cat. Posting Group";
    begin
        ExpenseLine.Init();
        ExpenseLine."Job No." := PMSJob."Job No.";
        ExpenseLine."Line No." := 10000;
        ExpenseLine.Description := Description;
        if CategoryPostingGroup <> '' then begin
            ExpenseLine.Validate("Category Posting Group", CategoryPostingGroup);
            // OnValidate automatically populates G/L Account and Description
        end;
        ExpenseLine.Quantity := Quantity;
        ExpenseLine."Direct Unit Cost" := DirectUnitCost;
        ExpenseLine."Line Amount" := Quantity * DirectUnitCost;
        // Insert(true) triggers OnInsert which automatically copies dimensions from Job
        ExpenseLine.Insert(true);
    end;

    local procedure ApplyDimensionsToPurchLine(var PurchLine: Record "Purchase Line"; PMSJob: Record "PMS Job")
    var
        PMSPropertyRec: Record "PMS Property";
    begin
        // Inherit Global Dimension 1 from Property if Job doesn't have it
        if (PMSJob."Global Dimension 1 Code" = '') and (PMSJob."Property ID" <> '') then begin
            if PMSPropertyRec.Get(PMSJob."Property ID") then
                if PMSPropertyRec."Global Dimension 1 Code" <> '' then
                    PurchLine.Validate("Shortcut Dimension 1 Code", PMSPropertyRec."Global Dimension 1 Code");
        end else
            if PMSJob."Global Dimension 1 Code" <> '' then
                PurchLine.Validate("Shortcut Dimension 1 Code", PMSJob."Global Dimension 1 Code");

        // Apply Property dimensions
        ApplyPropertyDimension(PurchLine, PMSJob."Property ID");
    end;

    local procedure CalcNextOccurrenceDate(CurrentDate: Date; Frequency: Enum "PMS Job Frequency"): Date
    begin
        case Frequency of
            Frequency::Daily:
                exit(CurrentDate + 1);
            Frequency::Weekly:
                exit(CalcDate('<7D>', CurrentDate));
            Frequency::Fortnightly:
                exit(CalcDate('<14D>', CurrentDate));
            Frequency::Monthly:
                exit(CalcDate('<1M>', CurrentDate));
            Frequency::Quarterly:
                exit(CalcDate('<3M>', CurrentDate));
            Frequency::"Bi-Annually":
                exit(CalcDate('<6M>', CurrentDate));
            Frequency::Yearly:
                exit(CalcDate('<1Y>', CurrentDate));
            else
                exit(CurrentDate + 1);
        end;
    end;

    local procedure ApplyPropertyDimension(var PurchLine: Record "Purchase Line"; PropertyID: Code[20])
    var
        PMSSetup: Record "PMS Setup";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
        DimSetID: Integer;
    begin
        if PropertyID = '' then
            exit;
        PMSSetup.GetRecordOnce();
        if PMSSetup."Property Dimension Code" = '' then
            exit;

        DimMgt.GetDimensionSet(TempDimSetEntry, PurchLine."Dimension Set ID");
        TempDimSetEntry.SetRange("Dimension Code", PMSSetup."Property Dimension Code");
        if not TempDimSetEntry.IsEmpty() then
            TempDimSetEntry.DeleteAll();
        TempDimSetEntry.Reset();

        Clear(TempDimSetEntry);
        TempDimSetEntry."Dimension Code" := PMSSetup."Property Dimension Code";
        TempDimSetEntry."Dimension Value Code" := PropertyID;
        TempDimSetEntry.Insert(false);

        DimSetID := DimMgt.GetDimensionSetID(TempDimSetEntry);
        PurchLine."Dimension Set ID" := DimSetID;
    end;

    local procedure GetPropertyGlobalDimension1(PropertyID: Code[20]): Code[20]
    var
        PropertyRec: Record "PMS Property";
    begin
        if PropertyID = '' then
            exit('');
        if PropertyRec.Get(PropertyID) then
            exit(PropertyRec."Global Dimension 1 Code");
        exit('');
    end;

    local procedure CopyDimensionsFromExpenseLine(var PurchLine: Record "Purchase Line"; ExpenseLine: Record "PMS Job Expense Line")
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
        PMSSetup: Record "PMS Setup";
        DimSetID: Integer;
        PropertyID: Code[20];
    begin
        // Get Property ID from expense line
        ExpenseLine.CalcFields("Property ID");
        PropertyID := ExpenseLine."Property ID";

        // Start with expense line dimensions
        if ExpenseLine."Dimension Set ID" <> 0 then begin
            DimMgt.GetDimensionSet(TempDimSetEntry, ExpenseLine."Dimension Set ID");
        end;

        // Add/update property dimension if configured
        if PropertyID <> '' then begin
            PMSSetup.GetRecordOnce();
            if PMSSetup."Property Dimension Code" <> '' then begin
                TempDimSetEntry.SetRange("Dimension Code", PMSSetup."Property Dimension Code");
                if not TempDimSetEntry.IsEmpty() then
                    TempDimSetEntry.DeleteAll();
                TempDimSetEntry.Reset();

                Clear(TempDimSetEntry);
                TempDimSetEntry."Dimension Code" := PMSSetup."Property Dimension Code";
                TempDimSetEntry."Dimension Value Code" := PropertyID;
                TempDimSetEntry.Insert(false);
            end;
        end;

        // Apply the final dimension set to the purchase line
        if TempDimSetEntry.FindFirst() then begin
            DimSetID := DimMgt.GetDimensionSetID(TempDimSetEntry);
            PurchLine."Dimension Set ID" := DimSetID;
            DimMgt.UpdateGlobalDimFromDimSetID(DimSetID, PurchLine."Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 2 Code");
        end;
    end;

    local procedure SendJobAssignmentEmail(PMSJob: Record "PMS Job")
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        UserRec: Record User;
        RecipientEmail: Text[250];
        Subject: Text[250];
        Body: Text;
        JobUrl: Text;
    begin
        if PMSJob."Employee No." = '' then
            exit;

        // Get employee email from User table
        UserRec.SetRange("User Name", PMSJob."Employee No.");
        if not UserRec.FindFirst() then
            exit;

        if UserRec."Contact Email" = '' then
            exit;

        RecipientEmail := UserRec."Contact Email";

        // Generate URL to job card
        JobUrl := GetJobUrl(PMSJob);

        // Build email content
        Subject := StrSubstNo('[%1] New Job Assigned: %2 - %3', CompanyName, PMSJob."Job No.", PMSJob.Description);

        Body := 'You have been assigned a new job:' + '<br><br>' +
                '<b>Job No.:</b> ' + PMSJob."Job No." + '<br>' +
                '<b>Description:</b> ' + PMSJob.Description + '<br>';

        if PMSJob."Property ID" <> '' then begin
            Body += '<b>Property:</b> ' + PMSJob."Property ID";
            if PMSJob."Property Known As" <> '' then
                Body += ' (' + PMSJob."Property Known As" + ')';
            Body += '<br>';
        end;

        Body += '<b>Priority:</b> ' + Format(PMSJob.Priority) + '<br>';

        if PMSJob."Scheduled Date" <> 0D then
            Body += '<b>Scheduled Date:</b> ' + Format(PMSJob."Scheduled Date") + '<br>';

        if PMSJob."Source Type" = PMSJob."Source Type"::"Helpdesk Call" then
            Body += '<b>From Helpdesk Call:</b> ' + PMSJob."Source No." + '<br>';

        if PMSJob.Details <> '' then
            Body += '<br><b>Details:</b><br>' + PMSJob.Details;

        // Add clickable link to job
        if JobUrl <> '' then
            Body += '<br><br><a href="' + JobUrl + '">Open Job in Business Central</a>';

        // Create and send email
        EmailMessage.Create(RecipientEmail, Subject, Body, true); // true = HTML format

        if not Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
            Message(EmailSendFailedMsg, RecipientEmail);
    end;

    local procedure GetJobUrl(PMSJob: Record "PMS Job"): Text
    var
        PMSSetup: Record "PMS Setup";
        BaseUrl: Text;
        JobUrl: Text;
    begin
        // Try to get configured base URL first
        PMSSetup.GetRecordOnce();
        if PMSSetup."Web Client Base URL" <> '' then
            BaseUrl := PMSSetup."Web Client Base URL"
        else
            // Fall back to automatic URL detection
            BaseUrl := GetUrl(ClientType::Web);

        if BaseUrl = '' then
            exit('');

        // Remove trailing slash if present
        if BaseUrl.EndsWith('/') then
            BaseUrl := CopyStr(BaseUrl, 1, StrLen(BaseUrl) - 1);

        // Build URL to job card page (80826 is PMS Job page ID)
        JobUrl := BaseUrl + '/?page=80826&filter=%27PMS%20Job%27.%27Job%20No.%27%20IS%20%27' + PMSJob."Job No." + '%27';

        exit(JobUrl);
    end;

    local procedure SendSpawnedJobNotification(NewJob: Record "PMS Job"; OriginalJob: Record "PMS Job"; SpawnReason: Text[250]; SpawnedByName: Text[80])
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        PMSSetup: Record "PMS Setup";
        RecipientEmail: Text;
        Recipients: List of [Text];
        Subject: Text[250];
        Body: Text;
        JobUrl: Text;
        EmailList: List of [Text];
        SingleEmail: Text;
    begin
        PMSSetup.GetRecordOnce();

        // Get office team email(s) from setup
        if PMSSetup."Office Team Email" = '' then
            exit;

        // Parse semicolon-separated email list
        EmailList := PMSSetup."Office Team Email".Split(';');
        foreach SingleEmail in EmailList do begin
            SingleEmail := SingleEmail.Trim();
            if SingleEmail <> '' then
                if not Recipients.Contains(SingleEmail) then
                    Recipients.Add(SingleEmail);
        end;

        if Recipients.Count = 0 then
            exit;

        // Generate URL to new job card
        JobUrl := GetJobUrl(NewJob);

        // Build email content
        Subject := StrSubstNo('[%1] Spawned Job Requires Action: %2', CompanyName, NewJob."Job No.");

        Body := '<b>A new external job has been spawned and requires office team action:</b><br><br>' +
                '<b>New Job No.:</b> ' + NewJob."Job No." + '<br>' +
                '<b>Original Job:</b> ' + OriginalJob."Job No." + ' (marked as Completed)<br>' +
                '<b>Spawned By:</b> ' + SpawnedByName + '<br>' +
                '<b>Description:</b> ' + NewJob.Description + '<br>';

        if NewJob."Property ID" <> '' then begin
            Body += '<b>Property:</b> ' + NewJob."Property ID";
            if NewJob."Property Known As" <> '' then
                Body += ' (' + NewJob."Property Known As" + ')';
            Body += '<br>';
        end;

        Body += '<b>Priority:</b> ' + Format(NewJob.Priority) + '<br>';

        if NewJob."Estimated Cost" <> 0 then
            Body += '<b>Estimated Cost:</b> ' + Format(NewJob."Estimated Cost") + '<br>';

        if NewJob."Suggested Vendor No." <> '' then
            Body += '<b>Suggested Vendor:</b> ' + NewJob."Suggested Vendor No." + '<br>';

        Body += '<br><b>Spawn Reason:</b><br>' + SpawnReason + '<br>';

        Body += '<br><b>Next Steps:</b><br>' +
                '• Review the spawned job details<br>' +
                '• Assign a vendor if not already suggested<br>' +
                '• Create a purchase order for approval<br>';

        // Add clickable link to new job
        if JobUrl <> '' then
            Body += '<br><a href="' + JobUrl + '">Open Spawned Job in Business Central</a>';

        // Send to each recipient
        foreach RecipientEmail in Recipients do begin
            EmailMessage.Create(RecipientEmail, Subject, Body, true);
            if not Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
                Message(EmailSendFailedMsg, RecipientEmail);
        end;
    end;

    /// <summary>
    /// Checks if all jobs for a helpdesk call are in a final state (Completed, Cancelled, or Spawned).
    /// If so, automatically closes the call and calculates resolution time.
    /// </summary>
    procedure CheckAndCloseHelpdeskCall(CallNo: Code[20]; CurrentJobNo: Code[20]; CurrentJobStatus: Enum "PMS Job Status")
    var
        HelpdeskCall: Record "PMS Helpdesk Call";
        PMSJob: Record "PMS Job";
        AllJobsComplete: Boolean;
    begin
        if CallNo = '' then
            exit;

        if not HelpdeskCall.Get(CallNo) then
            exit;

        // Don't process if already closed
        if HelpdeskCall.Status = HelpdeskCall.Status::Closed then
            exit;

        // Check if all jobs are in a final state
        AllJobsComplete := true;
        PMSJob.SetRange("Source Type", PMSJob."Source Type"::"Helpdesk Call");
        PMSJob.SetRange("Source No.", CallNo);
        if PMSJob.FindSet() then
            repeat
                // Use in-memory status for the current job being modified
                if PMSJob."Job No." = CurrentJobNo then begin
                    if not (CurrentJobStatus in [PMSJob.Status::Completed, PMSJob.Status::Cancelled]) then
                        AllJobsComplete := false;
                end else begin
                    if not (PMSJob.Status in [PMSJob.Status::Completed, PMSJob.Status::Cancelled]) then
                        AllJobsComplete := false;
                end;
            until (PMSJob.Next() = 0) or (not AllJobsComplete);

        // Close the call if all jobs are complete
        if AllJobsComplete then begin
            HelpdeskCall.Validate(Status, HelpdeskCall.Status::Closed);
            // Ensure fields are recalculated (OnValidate should handle this, but be explicit)
            if HelpdeskCall."Closed Date" = 0DT then
                HelpdeskCall."Closed Date" := CurrentDateTime;
            if (HelpdeskCall."Reported Date" <> 0DT) and (HelpdeskCall."Resolution Time" = 0) then
                HelpdeskCall."Resolution Time" := HelpdeskCall."Closed Date" - HelpdeskCall."Reported Date";
            HelpdeskCall.Modify(true);
        end;
    end;
}
