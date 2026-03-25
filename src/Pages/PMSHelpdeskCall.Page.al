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
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    StyleExpr = PriorityStyle;
                    ToolTip = 'Specifies the priority of this helpdesk call.';
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
                    ToolTip = 'Specifies full details of the issue reported.';
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
                field("Assigned To"; Rec."Assigned To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who the call is assigned to for resolution.';
                }
                field("Target Resolution Date"; Rec."Target Resolution Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the target date by which this call should be resolved.';
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
                Image = Stop;
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
                Enabled = Rec.Status <> Rec.Status::New;
                Image = ReOpen;
                ToolTip = 'Reopen this helpdesk call and set the status back to New.';

                trigger OnAction()
                begin
                    Rec.Validate(Status, Rec.Status::New);
                    Rec.Modify(true);
                    CurrPage.Update(false);
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
            }
            group(Category_Navigate)
            {
                Caption = 'Navigate';
                actionref(HelpdeskList_Promoted; HelpdeskList) { }
            }
        }
    }

    var
        PriorityStyle: Text;

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
        Rec."Reported Date" := WorkDate();
        Rec.Priority := Rec.Priority::Normal;
    end;

    trigger OnAfterGetRecord()
    begin
        case Rec.Priority of
            Rec.Priority::Critical:
                PriorityStyle := 'Unfavorable';
            Rec.Priority::High:
                PriorityStyle := 'Ambiguous';
            else
                PriorityStyle := 'Standard';
        end;
    end;
}
