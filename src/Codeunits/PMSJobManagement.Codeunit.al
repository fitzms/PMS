codeunit 80800 "PMS Job Management"
{
    var
        JobsAlreadyCreatedErr: Label 'Jobs have already been created for contract %1. Delete the existing jobs before creating new ones.', Comment = '%1 = Contract ID';
        JobsCreatedMsg: Label '%1 job(s) created for contract %2.', Comment = '%1 = count, %2 = Contract ID';
        NoContractLinesErr: Label 'Contract %1 has no lines. Add contract lines before creating jobs.', Comment = '%1 = Contract ID';
        JobCreatedMsg: Label 'Job %1 has been created from helpdesk call %2.', Comment = '%1 = Job No., %2 = Call No.';
        PurchOrderCreatedMsg: Label 'Purchase Order %1 has been created for job %2.', Comment = '%1 = PO No., %2 = Job No.';
        JobAlreadyHasPOErr: Label 'Job %1 is already linked to purchase order %2.', Comment = '%1 = Job No., %2 = PO No.';

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
        PMSJob."Source Type" := PMSJob."Source Type"::"Helpdesk Call";
        PMSJob."Source No." := HelpdeskCall."Call No.";
        PMSJob."Property ID" := HelpdeskCall."Property ID";
        PMSJob."Unit ID" := HelpdeskCall."Unit ID";
        PMSJob.Priority := HelpdeskCall.Priority;
        PMSJob."Job Type" := PMSJob."Job Type"::Internal;
        PMSJob."Employee No." := HelpdeskCall."Employee No.";
        PMSJob."Employee Name" := HelpdeskCall."Employee Name";
        PMSJob."Scheduled Date" := HelpdeskCall."Target Resolution Date";
        PMSJob.Status := PMSJob.Status::Open;
        PMSJob.Insert(false);

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
    begin
        CurrentJob.TestField("Resolution Notes");
        CurrentJob.TestField("Source Type", CurrentJob."Source Type"::"Helpdesk Call");
        CurrentJob.TestField("Source No.");

        PMSSetup.GetRecordOnce();
        PMSSetup.TestField("Job Nos.");

        // Mark the current job as Spawned (not Completed)
        CurrentJob.Validate(Status, CurrentJob.Status::Spawned);
        if CurrentJob."Completed Date" = 0DT then
            CurrentJob."Completed Date" := CurrentDateTime;
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
        NewJob.Priority := CurrentJob.Priority;
        NewJob."Job Type" := NewJob."Job Type"::External;
        NewJob."Scheduled Date" := CurrentJob."Scheduled Date";
        NewJob."Estimated Cost" := CurrentJob."Estimated Cost";
        NewJob."G/L Account No." := CurrentJob."G/L Account No.";
        NewJob."Global Dimension 1 Code" := CurrentJob."Global Dimension 1 Code";
        NewJob.Status := NewJob.Status::Open;
        NewJob."Related Job No." := CurrentJob."Job No.";
        NewJob.Insert(false);

        // Link back from original job to new job
        CurrentJob."Related Job No." := NewJob."Job No.";
        CurrentJob.Modify(true);

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
    begin
        PMSJob.TestField("Vendor No.");
        PMSJob.TestField("G/L Account No.");

        if PMSJob."Purchase Order No." <> '' then
            Error(JobAlreadyHasPOErr, PMSJob."Job No.", PMSJob."Purchase Order No.");

        PurchHeader.Init();
        PurchHeader.Validate("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.Insert(true);
        PurchHeader.Validate("Buy-from Vendor No.", PMSJob."Vendor No.");
        PurchHeader."Your Reference" := PMSJob."Job No.";
        PurchHeader.Modify(true);

        PurchLine.Init();
        PurchLine."Document Type" := PurchHeader."Document Type";
        PurchLine."Document No." := PurchHeader."No.";
        PurchLine."Line No." := 10000;
        PurchLine.Insert(true);
        PurchLine.Validate(Type, PurchLine.Type::"G/L Account");
        PurchLine.Validate("No.", PMSJob."G/L Account No.");
        PurchLine.Description := PMSJob.Description;
        PurchLine.Validate(Quantity, 1);
        PurchLine.Validate("Direct Unit Cost", PMSJob."Estimated Cost");
        PurchLine."Expected Receipt Date" := PMSJob."Scheduled Date";
        PurchLine."PMS Job No." := PMSJob."Job No.";
        PurchLine."PMS Property ID" := PMSJob."Property ID";
        if PMSJob."Global Dimension 1 Code" <> '' then
            PurchLine.Validate("Shortcut Dimension 1 Code", PMSJob."Global Dimension 1 Code");
        ApplyPropertyDimension(PurchLine, PMSJob."Property ID");
        PurchLine.Modify(true);

        PMSJob."Purchase Order No." := PurchHeader."No.";
        PMSJob."Purchase Order Line No." := 10000;
        PMSJob.Modify(true);

        Message(PurchOrderCreatedMsg, PurchHeader."No.", PMSJob."Job No.");
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

        TempDimSetEntry.Init();
        TempDimSetEntry."Dimension Code" := PMSSetup."Property Dimension Code";
        TempDimSetEntry."Dimension Value Code" := PropertyID;
        TempDimSetEntry.Insert();

        DimSetID := DimMgt.GetDimensionSetID(TempDimSetEntry);
        PurchLine."Dimension Set ID" := DimSetID;
    end;
}
