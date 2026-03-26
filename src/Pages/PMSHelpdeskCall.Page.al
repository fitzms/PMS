page 80825 "PMS Helpdesk Call"
{
    Caption = 'Helpdesk Call';
    PageType = Card;
    SourceTable = "PMS Helpdesk Call";
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                group(LeftCol)
                {
                    ShowCaption = false;
                    field("Call No."; Rec."Call No.")
                    {
                        ApplicationArea = All;
                        AssistEdit = true;
                        Importance = Promoted;
                        ToolTip = 'Specifies the unique identifier for the helpdesk call.';

                        trigger OnAssistEdit()
                        var
                            PMSSetup: Record "PMS Setup";
                            NoSeries: Codeunit "No. Series";
                        begin
                            PMSSetup.GetRecordOnce();
                            PMSSetup.TestField("Helpdesk Nos.");
                            if NoSeries.LookupRelatedNoSeries(PMSSetup."Helpdesk Nos.", Rec."No. Series") then begin
                                Rec."Call No." := NoSeries.GetNextNo(Rec."No. Series");
                                CurrPage.Update();
                            end;
                        end;
                    }
                    field(Status; Rec.Status)
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                        ToolTip = 'Specifies the current status of the helpdesk call.';
                    }
                    field("Property ID"; Rec."Property ID")
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                        ToolTip = 'Specifies the property this call relates to.';
                    }
                    field(PropertyKnownAs; PropertyKnownAs)
                    {
                        ApplicationArea = All;
                        Caption = 'Known As';
                        Editable = false;
                        ToolTip = 'Specifies the known-as name of the property.';
                    }
                    field("Unit ID"; Rec."Unit ID")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the unit within the property this call relates to.';
                    }
                    field(CurrentTenant; CurrentTenant)
                    {
                        ApplicationArea = All;
                        Caption = 'Current Tenant';
                        Editable = false;
                        ToolTip = 'Specifies the current tenant occupying this unit.';
                    }
                }
                group(RightCol)
                {
                    ShowCaption = false;
                    field(Priority; Rec.Priority)
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                        StyleExpr = PriorityStyle;
                        ToolTip = 'Specifies the priority of this helpdesk call.';
                    }
                    field("Call Type"; Rec."Call Type")
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                        ToolTip = 'Specifies whether this call is handled internally by an employee or externally by a supplier.';
                    }
                    group(VendorGroup)
                    {
                        ShowCaption = false;
                        Visible = Rec."Call Type" = Rec."Call Type"::External;
                        field("Vendor No."; Rec."Vendor No.")
                        {
                            ApplicationArea = All;
                            Importance = Promoted;
                            ToolTip = 'Specifies the supplier assigned to resolve this call.';
                        }
                        field("Vendor Name"; Rec."Vendor Name")
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Specifies the name of the supplier.';
                        }
                    }
                    group(EmployeeGroup)
                    {
                        ShowCaption = false;
                        Visible = Rec."Call Type" = Rec."Call Type"::Internal;
                        field("Employee No."; Rec."Employee No.")
                        {
                            ApplicationArea = All;
                            Importance = Promoted;
                            ToolTip = 'Specifies the employee assigned to resolve this call.';
                        }
                        field("Employee Name"; Rec."Employee Name")
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Specifies the name of the assigned employee.';
                        }
                    }
                    field(Description; Rec.Description)
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                        ToolTip = 'Specifies a short description of the issue.';
                    }
                    field(Details; Rec.Details)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'Specifies full details of the issue reported.';
                    }
                    field("Target Resolution Date"; Rec."Target Resolution Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the target date by which this call should be resolved.';
                    }
                }
            }
            group(Reporter)
            {
                Caption = 'Reporter';

                field("Reported Date"; Rec."Reported Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date the issue was reported.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who logged the call.';
                }
            }
            group(Resolution)
            {
                Caption = 'Resolution';

                field("Resolution Notes"; Rec."Resolution Notes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies notes on how the issue was resolved.';
                }
                field("Closed Date"; Rec."Closed Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the call was closed.';
                }
            }
            part(Jobs; "PMS Jobs Part")
            {
                ApplicationArea = All;
                Caption = 'Jobs';
                SubPageLink = "Source Type" = const("Helpdesk Call"), "Source No." = field("Call No.");
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(HelpdeskList)
            {
                ApplicationArea = All;
                Caption = 'Helpdesk Calls';
                Image = List;
                RunObject = page "PMS Helpdesk Call List";
                ToolTip = 'View the list of all helpdesk calls.';
            }
            action(ViewJob)
            {
                ApplicationArea = All;
                Caption = 'View Job';
                Image = ViewWorksheet;
                ToolTip = 'Open the job created from this helpdesk call.';

                trigger OnAction()
                var
                    PMSJob: Record "PMS Job";
                begin
                    PMSJob.SetRange("Source Type", PMSJob."Source Type"::"Helpdesk Call");
                    PMSJob.SetRange("Source No.", Rec."Call No.");
                    Page.Run(Page::"PMS Job List", PMSJob);
                end;
            }
        }
        area(Processing)
        {
            action(AcknowledgeCall)
            {
                ApplicationArea = All;
                Caption = 'Acknowledge';
                Enabled = Rec.Status = Rec.Status::New;
                Image = Approve;
                ToolTip = 'Acknowledge this call and mark it as In Progress.';

                trigger OnAction()
                begin
                    Rec.Validate(Status, Rec.Status::"In Progress");
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
            action(PutOnHold)
            {
                ApplicationArea = All;
                Caption = 'Put On Hold';
                Enabled = Rec.Status = Rec.Status::"In Progress";
                Image = Stop;
                ToolTip = 'Put this call on hold pending further information.';

                trigger OnAction()
                begin
                    Rec.Validate(Status, Rec.Status::"On Hold");
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
            action(ResumeCall)
            {
                ApplicationArea = All;
                Caption = 'Resume';
                Enabled = Rec.Status = Rec.Status::"On Hold";
                Image = RefreshLines;
                ToolTip = 'Resume work on this call.';

                trigger OnAction()
                begin
                    Rec.Validate(Status, Rec.Status::"In Progress");
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
            action(ResolveCall)
            {
                ApplicationArea = All;
                Caption = 'Resolve';
                Enabled = Rec.Status = Rec.Status::"In Progress";
                Image = Completed;
                ToolTip = 'Mark this call as Resolved.';

                trigger OnAction()
                begin
                    Rec.Validate(Status, Rec.Status::Resolved);
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
            action(CloseCall)
            {
                ApplicationArea = All;
                Caption = 'Close';
                Enabled = Rec.Status = Rec.Status::Resolved;
                Image = CloseDocument;
                ToolTip = 'Close this helpdesk call. The closed date will be set automatically.';

                trigger OnAction()
                begin
                    Rec.Validate(Status, Rec.Status::Closed);
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
            action(ReopenCall)
            {
                ApplicationArea = All;
                Caption = 'Reopen';
                Enabled = Rec.Status = Rec.Status::Resolved;
                Image = ReOpen;
                ToolTip = 'Reopen this helpdesk call and set the status back to New.';

                trigger OnAction()
                begin
                    Rec.Validate(Status, Rec.Status::New);
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
            action(CreateJob)
            {
                ApplicationArea = All;
                Caption = 'Create Job';
                Enabled = not HasJob;
                Image = NewDocument;
                ToolTip = 'Create a PMS job from this helpdesk call. The job defaults to Internal type; change it on the job card and use Create Purchase Order if a supplier is involved.';

                trigger OnAction()
                var
                    PMSJobMgt: Codeunit "PMS Job Management";
                    PMSJob: Record "PMS Job";
                    JobNo: Code[20];
                begin
                    CurrPage.SaveRecord();
                    JobNo := PMSJobMgt.CreateJobFromCall(Rec);
                    PMSJob.Get(JobNo);
                    Page.Run(Page::"PMS Job", PMSJob);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref(AcknowledgeCall_Promoted; AcknowledgeCall) { }
                actionref(PutOnHold_Promoted; PutOnHold) { }
                actionref(ResumeCall_Promoted; ResumeCall) { }
                actionref(ResolveCall_Promoted; ResolveCall) { }
                actionref(CloseCall_Promoted; CloseCall) { }
                actionref(ReopenCall_Promoted; ReopenCall) { }
                actionref(CreateJob_Promoted; CreateJob) { }
            }
            group(Category_Navigate)
            {
                Caption = 'Navigate';
                actionref(HelpdeskList_Promoted; HelpdeskList) { }
                actionref(ViewJob_Promoted; ViewJob) { }
            }
        }
    }

    var
        PriorityStyle: Text;
        HasJob: Boolean;
        PropertyKnownAs: Text[100];
        CurrentTenant: Text[100];

    trigger OnNewRecord(BelowRec: Boolean)
    var
        PMSSetup: Record "PMS Setup";
        NoSeries: Codeunit "No. Series";
    begin
        PMSSetup.GetRecordOnce();
        if PMSSetup."Helpdesk Nos." <> '' then begin
            Rec."No. Series" := PMSSetup."Helpdesk Nos.";
            Rec."Call No." := NoSeries.GetNextNo(PMSSetup."Helpdesk Nos.", WorkDate(), true);
        end;
        Rec."Created By" := CopyStr(UserId(), 1, MaxStrLen(Rec."Created By"));
        Rec."Reported Date" := CurrentDateTime;
        Rec.Priority := Rec.Priority::Normal;
    end;

    trigger OnAfterGetRecord()
    var
        PMSJob: Record "PMS Job";
        Prop: Record "PMS Property";
        Unit: Record "PMS Unit";
    begin
        case Rec.Priority of
            Rec.Priority::Critical:
                PriorityStyle := 'Unfavorable';
            Rec.Priority::High:
                PriorityStyle := 'Ambiguous';
            else
                PriorityStyle := 'Standard';
        end;

        PMSJob.SetRange("Source Type", PMSJob."Source Type"::"Helpdesk Call");
        PMSJob.SetRange("Source No.", Rec."Call No.");
        HasJob := not PMSJob.IsEmpty();

        if Prop.Get(Rec."Property ID") then
            PropertyKnownAs := Prop."Known As"
        else
            PropertyKnownAs := '';

        if Unit.Get(Rec."Unit ID") then begin
            Unit.CalcFields("Current Tenant");
            CurrentTenant := Unit."Current Tenant";
        end else
            CurrentTenant := '';
    end;
}
