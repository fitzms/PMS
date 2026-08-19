page 80826 "PMS Job"
{
    Caption = 'PMS Job';
    PageType = Card;
    SourceTable = "PMS Job";
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the unique job number.';
                }

                field("Job Type"; Rec."Job Type")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = IsCallFieldsEditable;
                    ToolTip = 'Specifies whether this is an external supplier job or an internal employee works order.';

                    trigger OnValidate()
                    begin
                        UpdateVisibility();
                    end;
                }



                group(InternalDetails)
                {
                    Caption = 'Internal Details';
                    Visible = ShowEmployeeFields;

                    field("Employee No."; Rec."Employee No.")
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                        Editable = IsCallFieldsEditable;
                        ToolTip = 'Specifies the employee responsible for this works order.';
                    }
                    field("Employee Name"; Rec."Employee Name")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the name of the employee.';
                    }
                    field("Resource No."; Rec."Resource No.")
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                        QuickEntry = true;
                        Editable = IsCallFieldsEditable;
                        ToolTip = 'Specifies the internal resource allocated to manage this job.';
                    }
                    field("Resource Name"; Rec."Resource Name")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the name of the allocated resource.';
                    }
                }

                group(ExternalDetails)
                {
                    Caption = 'External Details';
                    Visible = ShowVendorFields;

                    field("Vendor No."; Rec."Vendor No.")
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                        ToolTip = 'Specifies the vendor who will carry out this job.';
                    }
                    field("Vendor Name"; Rec."Vendor Name")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the name of the vendor.';
                    }
                    field("G/L Account No."; Rec."G/L Account No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the G/L account to post costs against.';
                    }
                    field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the global dimension 1 value for this job.';
                    }
                    field("Estimated Cost"; Rec."Estimated Cost")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the estimated cost of this job.';
                    }
                    field("Purchase Order No."; Rec."Purchase Order No.")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the purchase order number linked to this job.';
                    }
                }

                group(JobDetails)
                {
                    Caption = 'Job Details';

                    field(Description; Rec.Description)
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                        Editable = IsCallFieldsEditable;
                        ToolTip = 'Specifies a description of the job.';
                    }
                    field(Details; Rec.Details)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        Editable = IsCallFieldsEditable;
                        ToolTip = 'Specifies detailed information about the job.';
                    }

                    field("Property ID"; Rec."Property ID")
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                        Editable = IsCallFieldsEditable;
                        ToolTip = 'Specifies the property to which this job relates.';

                        trigger OnValidate()
                        var
                            PropertyRec: Record "PMS Property";
                        begin
                            IsSingleUnit := false;
                            if Rec."Property ID" <> '' then
                                if PropertyRec.Get(Rec."Property ID") then
                                    IsSingleUnit := PropertyRec."Single Unit";
                            CurrPage.Update(true);
                        end;
                    }
                    field("Property Known As"; Rec."Property Known As")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the known as name of the property.';
                    }
                    field("Unit ID"; Rec."Unit ID")
                    {
                        ApplicationArea = All;
                        Editable = (not IsSingleUnit) and IsCallFieldsEditable;
                        ToolTip = 'Specifies the unit within the property to which this job relates.';
                    }
                    field("Special Instructions"; Rec."Special Instructions")
                    {
                        ApplicationArea = All;
                        Editable = IsCallFieldsEditable;
                        ToolTip = 'Specifies any special instructions for carrying out this job.';
                    }

                    field(Priority; Rec.Priority)
                    {
                        ApplicationArea = All;
                        Editable = IsCallFieldsEditable;
                        ToolTip = 'Specifies the priority of the job.';
                    }
                    field("Scheduled Date"; Rec."Scheduled Date")
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                        Editable = IsCallFieldsEditable;
                        ToolTip = 'Specifies the scheduled date for this job occurrence.';
                    }


                }

                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the date and time the job was created. For helpdesk call jobs, this is the call''s reported date.';
                }

                field("Completed Date"; Rec."Completed Date")
                {
                    ApplicationArea = All;
                    Caption = 'Completed/Spawned Date';
                    Editable = false;
                    ToolTip = 'Specifies the date the job was completed or spawned.';
                }

                field("Resolution Time"; Rec."Resolution Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the time elapsed from when the job was created (or the helpdesk call was reported) to when it was completed.';
                }

                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies whether this job originated from a contract or a helpdesk call.';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the source document number (contract ID or call number).';
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = Rec."Source Type" = Rec."Source Type"::Contract;
                    ToolTip = 'Specifies the contract line number that generated this job.';
                }
                field("Related Job No."; Rec."Related Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the related job created when this job was spawned, or the original job this was spawned from.';
                }
                field("Spawned By"; Rec."Spawned By")
                {
                    ApplicationArea = All;
                    Visible = Rec."Spawned By" <> '';
                    Editable = false;
                    ToolTip = 'Specifies which engineer spawned this job.';
                }
                field("Spawn Reason"; Rec."Spawn Reason")
                {
                    ApplicationArea = All;
                    Visible = Rec."Spawned By" <> '';
                    Editable = false;
                    MultiLine = true;
                    ToolTip = 'Specifies why this job was spawned to an external vendor.';
                }
                field("Suggested Vendor No."; Rec."Suggested Vendor No.")
                {
                    ApplicationArea = All;
                    Visible = (Rec."Job Type" = Rec."Job Type"::External) and (Rec."Related Job No." <> '');
                    ToolTip = 'Specifies the vendor suggested by the engineer who spawned this job.';
                }
                field("Occurrence No."; Rec."Occurrence No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies which recurrence this job represents within its contract line (e.g. 3 = third visit).';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    StyleExpr = StatusStyle;
                    Editable = false;
                    ToolTip = 'Specifies the current status of the job.';
                }
            }
            group(NotesGroup)
            {
                Caption = 'Notes';

                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies any additional notes for this job.';
                }
            }
            group(ResolutionGroup)
            {
                Caption = 'Resolution';

                field("Resolution Notes"; Rec."Resolution Notes")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies notes on how the job was resolved. Required for internal jobs before completing.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreatePurchaseOrder)
            {
                ApplicationArea = All;
                Caption = 'Create Purchase Order';
                Enabled = (Rec."Job Type" = Rec."Job Type"::External) and (Rec."Purchase Order No." = '');
                Image = NewOrder;
                ToolTip = 'Create a purchase order for this external job. Set Vendor No. and G/L Account No. first.';

                trigger OnAction()
                var
                    PMSJobMgt: Codeunit "PMS Job Management";
                begin
                    CurrPage.SaveRecord();
                    PMSJobMgt.CreatePurchaseOrderForJob(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(OpenPurchaseOrder)
            {
                ApplicationArea = All;
                Caption = 'View Purchase Order';
                Enabled = Rec."Purchase Order No." <> '';
                Image = Order;
                ToolTip = 'Open the purchase order linked to this job.';

                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                begin
                    PurchHeader.Get(PurchHeader."Document Type"::Order, Rec."Purchase Order No.");
                    Page.Run(Page::"Purchase Order", PurchHeader);
                end;
            }
            action(ViewCall)
            {
                ApplicationArea = All;
                Caption = 'View Call';
                Enabled = (Rec."Source Type" = Rec."Source Type"::"Helpdesk Call") and (Rec."Source No." <> '');
                Image = Document;
                ToolTip = 'View the helpdesk call that created this job.';

                trigger OnAction()
                var
                    HelpdeskCall: Record "PMS Helpdesk Call";
                begin
                    if HelpdeskCall.Get(Rec."Source No.") then
                        Page.Run(Page::"PMS Helpdesk Call", HelpdeskCall);
                end;
            }
            action(MarkInProgress)
            {
                ApplicationArea = All;
                Caption = 'Mark In Progress';
                Enabled = Rec.Status = Rec.Status::Open;
                Image = Process;
                ToolTip = 'Mark this job as in progress.';

                trigger OnAction()
                begin
                    Rec.Validate(Status, Rec.Status::"In Progress");
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
            action(MarkCompleted)
            {
                ApplicationArea = All;
                Caption = 'Complete';
                Enabled = Rec.Status = Rec.Status::"In Progress";
                Image = Completed;
                ToolTip = 'Mark this job as completed and record the completion date.';

                trigger OnAction()
                begin
                    if Rec."Job Type" = Rec."Job Type"::Internal then
                        Rec.TestField("Resolution Notes");
                    Rec.Validate(Status, Rec.Status::Completed);
                    if Rec."Completed Date" = 0DT then
                        Rec."Completed Date" := CurrentDateTime;
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
            action(CloseAndSpawn)
            {
                ApplicationArea = All;
                Caption = 'Close & Spawn';
                Enabled = (Rec.Status = Rec.Status::"In Progress") and (Rec."Job Type" = Rec."Job Type"::Internal) and (Rec."Source Type" = Rec."Source Type"::"Helpdesk Call");
                Image = CreateDocument;
                ToolTip = 'Close this internal job and create a new external (supplier) job linked to the same helpdesk call. The call remains In Progress.';

                trigger OnAction()
                var
                    PMSJobMgt: Codeunit "PMS Job Management";
                    NewJobNo: Code[20];
                begin
                    CurrPage.SaveRecord();
                    NewJobNo := PMSJobMgt.CompleteAndSpawnExternalJob(Rec);
                    if NewJobNo <> '' then
                        CurrPage.Update(false);
                end;
            }
            action(CreateSPFolder)
            {
                ApplicationArea = All;
                Caption = 'Create SharePoint Folder';
                Image = Cloud;
                Enabled = Rec."SharePoint Folder URL" = '';
                ToolTip = 'Create the Jobs/{Job No.}/Documents folder structure in SharePoint and store the URL.';

                trigger OnAction()
                var
                    SPMgt: Codeunit "PMS SharePoint Mgt";
                begin
                    CurrPage.SaveRecord();
                    SPMgt.CreateJobFolder(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(OpenSPFolder)
            {
                ApplicationArea = All;
                Caption = 'Open in SharePoint';
                Image = Open;
                Enabled = Rec."SharePoint Folder URL" <> '';
                ToolTip = 'Open the SharePoint Documents folder for this job in a browser.';

                trigger OnAction()
                begin
                    HyperLink(Rec."SharePoint Folder URL");
                end;
            }
        }
        area(Navigation)
        {
            action(JobList)
            {
                ApplicationArea = All;
                Caption = 'Job List';
                Image = List;
                RunObject = page "PMS Job List";
                ToolTip = 'View all PMS jobs.';
            }
            action(Dimensions)
            {
                ApplicationArea = All;
                Caption = 'Dimensions';
                Image = Dimensions;
                ToolTip = 'View or edit dimension values for this job.';
                RunObject = page "Default Dimensions";
                RunPageLink = "Table ID" = const(80824), "No." = field("Job No.");
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                group(CompleteGroup)
                {
                    Caption = 'Complete';
                    ShowAs = SplitButton;
                    actionref(MarkCompleted_Promoted; MarkCompleted) { }
                    actionref(CloseAndSpawn_Promoted; CloseAndSpawn) { }
                }
                actionref(MarkInProgress_Promoted; MarkInProgress) { }
                actionref(CreatePurchaseOrder_Promoted; CreatePurchaseOrder) { }
                actionref(OpenPurchaseOrder_Promoted; OpenPurchaseOrder) { }
            }
            group(Category_SharePoint)
            {
                Caption = 'SharePoint';
                actionref(CreateSPFolder_Promoted; CreateSPFolder) { }
                actionref(OpenSPFolder_Promoted; OpenSPFolder) { }
            }
            group(Category_Navigate)
            {
                Caption = 'Navigate';
                actionref(ViewCall_Promoted; ViewCall) { }
                actionref(JobList_Promoted; JobList) { }
                actionref(Dimensions_Promoted; Dimensions) { }
            }
        }
    }


    var
        StatusStyle: Text;
        IsHelpdeskCallClosed: Boolean;
        IsSourceNoEditable: Boolean;
        IsSingleUnit: Boolean;
        ShowEmployeeFields: Boolean;
        ShowVendorFields: Boolean;
        IsCallFieldsEditable: Boolean;

    trigger OnOpenPage()
    begin
        IsCallFieldsEditable := true;
        UpdateVisibility();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PMSSetup: Record "PMS Setup";
        NoSeriesCU: Codeunit "No. Series";
    begin
        PMSSetup.GetRecordOnce();
        if PMSSetup."Job Nos." <> '' then begin
            Rec."No. Series" := PMSSetup."Job Nos.";
            Rec."Job No." := NoSeriesCU.GetNextNo(PMSSetup."Job Nos.", WorkDate(), true);
        end;

        IsCallFieldsEditable := true;
        UpdateVisibility();
    end;

    trigger OnAfterGetRecord()
    var
        HelpdeskCall: Record "PMS Helpdesk Call";
        PropertyRec: Record "PMS Property";
    begin
        case Rec.Status of
            Rec.Status::Completed:
                StatusStyle := 'Favorable';
            Rec.Status::Cancelled:
                StatusStyle := 'Unfavorable';
            Rec.Status::"In Progress":
                StatusStyle := 'Ambiguous';
            else
                StatusStyle := 'Standard';
        end;

        // Determine if related helpdesk call is closed
        IsHelpdeskCallClosed := false;
        if (Rec."Source Type" = Rec."Source Type"::"Helpdesk Call") and (Rec."Source No." <> '') then
            if HelpdeskCall.Get(Rec."Source No.") then
                IsHelpdeskCallClosed := (HelpdeskCall.Status = HelpdeskCall.Status::Closed);

        // Set Source No. field editability
        if (Rec."Source Type" = Rec."Source Type"::"Helpdesk Call") and IsHelpdeskCallClosed then
            IsSourceNoEditable := false
        else
            IsSourceNoEditable := true;

        IsSingleUnit := false;
        if Rec."Property ID" <> '' then
            if PropertyRec.Get(Rec."Property ID") then
                IsSingleUnit := PropertyRec."Single Unit";

        // Lock fields if job was created from a helpdesk call, EXCEPT for spawned external jobs that are still Open
        IsCallFieldsEditable := (Rec."Source Type" <> Rec."Source Type"::"Helpdesk Call") or
                                ((Rec."Job Type" = Rec."Job Type"::External) and (Rec."Related Job No." <> '') and (Rec.Status = Rec.Status::Open));

        UpdateVisibility();
    end;

    local procedure UpdateVisibility()
    begin
        ShowEmployeeFields := Rec."Job Type" = Rec."Job Type"::Internal;
        ShowVendorFields := Rec."Job Type" = Rec."Job Type"::External;
    end;
}
