page 80809 "PMS Helpdesk Call List"
{
    Caption = 'Helpdesk Calls';
    PageType = List;
    SourceTable = "PMS Helpdesk Call";
    CardPageId = "PMS Helpdesk Call";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Call No."; Rec."Call No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the helpdesk call.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a short description of the issue.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    StyleExpr = PriorityStyle;
                    ToolTip = 'Specifies the priority of this helpdesk call.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the helpdesk call.';
                }
                field("Reported Date"; Rec."Reported Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the issue was reported.';
                }
                field("Assigned To"; Rec."Assigned To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who the call is assigned to.';
                }
                field("Target Resolution Date"; Rec."Target Resolution Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the target date by which this call should be resolved.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewCall)
            {
                ApplicationArea = All;
                Caption = 'New';
                Image = New;
                RunObject = page "PMS Helpdesk Call";
                RunPageMode = Create;
                ToolTip = 'Log a new helpdesk call.';
            }
        }
        area(Promoted)
        {
            group(Category_New)
            {
                Caption = 'New';
                actionref(NewCall_Promoted; NewCall) { }
            }
        }
    }

    var
        PriorityStyle: Text;

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
