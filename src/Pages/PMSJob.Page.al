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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies a description of the job.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    StyleExpr = StatusStyle;
                    ToolTip = 'Specifies the current status of the job.';
                }
                field("Job Type"; Rec."Job Type")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies whether this is an external supplier job or an internal employee works order.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the priority of the job.';
                }
                field("Scheduled Date"; Rec."Scheduled Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the scheduled date for this job occurrence.';
                }
                field("Completed Date"; Rec."Completed Date")
                {
                    ApplicationArea = All;
                    Caption = 'Completed/Spawned Date';
                    Editable = false;
                    ToolTip = 'Specifies the date the job was completed or spawned.';
                }
                field("Related Job No."; Rec."Related Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the related job created when this job was spawned, or the original job this was spawned from.';
                }
                field("Occurrence No."; Rec."Occurrence No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies which recurrence this job represents within its contract line (e.g. 3 = third visit).';
                }
            }
            group(Location)
            {
                Caption = 'Location';

                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the property to which this job relates.';

                    trigger OnValidate()
                    var
                        PropertyRec: Record "PMS Property";
                    begin
                        IsSingleUnit := false;
                        if Rec."Property ID" <> '' then
                            if PropertyRec.Get(Rec."Property ID") then
                                IsSingleUnit := PropertyRec."Single Unit";
                        CurrPage.Update(false);
                    end;
                }
                field("Unit ID"; Rec."Unit ID")
                {
                    ApplicationArea = All;
                    Editable = not IsSingleUnit;
                    ToolTip = 'Specifies the unit within the property to which this job relates.';
                }
                field("Special Instructions"; Rec."Special Instructions")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies any special instructions for carrying out this job.';
                }
            }
            group(SupplierGroup)
            {
                Caption = 'Supplier';
                Visible = Rec."Job Type" = Rec."Job Type"::External;

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
            group(EmployeeGroup)
            {
                Caption = 'Employee';
                Visible = Rec."Job Type" = Rec."Job Type"::Internal;

                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee responsible for this works order.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the employee.';
                }
            }
            group(Source)
            {
                Caption = 'Source';

                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies whether this job originated from a contract or a helpdesk call.';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                    Editable = IsSourceNoEditable;
                    ToolTip = 'Specifies the source document number (contract ID or call number).';
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = Rec."Source Type" = Rec."Source Type"::Contract;
                    ToolTip = 'Specifies the contract line number that generated this job.';
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
                var
                    HelpdeskCall: Record "PMS Helpdesk Call";
                begin
                    if Rec."Job Type" = Rec."Job Type"::Internal then
                        Rec.TestField("Resolution Notes");
                    Rec.Validate(Status, Rec.Status::Completed);
                    if Rec."Completed Date" = 0DT then
                        Rec."Completed Date" := CurrentDateTime;
                    Rec.Modify(true);

                    if (Rec."Job Type" = Rec."Job Type"::Internal) and
                       (Rec."Source Type" = Rec."Source Type"::"Helpdesk Call") and
                       (Rec."Source No." <> '') then begin
                        if HelpdeskCall.Get(Rec."Source No.") then
                            if HelpdeskCall.Status <> HelpdeskCall.Status::Closed then begin
                                HelpdeskCall.Validate(Status, HelpdeskCall.Status::Closed);
                                HelpdeskCall.Modify(true);
                            end;
                    end;

                    CurrPage.Update(false);
                end;
            }
            action(CompleteAndSpawn)
            {
                ApplicationArea = All;
                Caption = 'Complete and Spawn';
                Enabled = (Rec.Status = Rec.Status::"In Progress") and (Rec."Job Type" = Rec."Job Type"::Internal) and (Rec."Source Type" = Rec."Source Type"::"Helpdesk Call");
                Image = CreateDocument;
                ToolTip = 'Complete this internal job and create a new external (supplier) job linked to the same helpdesk call. The call remains In Progress.';

                trigger OnAction()
                var
                    PMSJobMgt: Codeunit "PMS Job Management";
                    NewJob: Record "PMS Job";
                    NewJobNo: Code[20];
                begin
                    if not Confirm('Are you sure that you want to spawn a new job?', false) then
                        exit;
                    CurrPage.SaveRecord();
                    NewJobNo := PMSJobMgt.CompleteAndSpawnExternalJob(Rec);
                    CurrPage.Update(false);
                    NewJob.Get(NewJobNo);
                    Page.Run(Page::"PMS Job", NewJob);
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
                    actionref(CompleteAndSpawn_Promoted; CompleteAndSpawn) { }
                }
                actionref(MarkInProgress_Promoted; MarkInProgress) { }
                actionref(CreatePurchaseOrder_Promoted; CreatePurchaseOrder) { }
                actionref(OpenPurchaseOrder_Promoted; OpenPurchaseOrder) { }
            }
            group(Category_Navigate)
            {
                Caption = 'Navigate';
                actionref(JobList_Promoted; JobList) { }
            }
        }
    }


    var
        StatusStyle: Text;
        IsHelpdeskCallClosed: Boolean;
        IsSourceNoEditable: Boolean;
        IsSingleUnit: Boolean;

    trigger OnAfterGetRecord()
    var
        HelpdeskCall: Record "PMS Helpdesk Call";
        PropertyRec: Record "PMS Property";
    begin
        case Rec.Status of
            Rec.Status::Completed:
                StatusStyle := 'Favorable';
            Rec.Status::Spawned:
                StatusStyle := 'Subordinate';
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
    end;
}
