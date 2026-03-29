page 80809 "PMS Helpdesk Call List"
{
    Caption = 'Helpdesk Calls';
    PageType = List;
    SourceTable = "PMS Helpdesk Call";
    CardPageId = "PMS Helpdesk Call";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTableView = sorting("Call No.") order(descending);

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Call ID"; Rec."Call No.")
                {
                    ApplicationArea = All;
                    Caption = 'Call ID';
                    ToolTip = 'Specifies the unique identifier for the helpdesk call.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a short description of the issue.';
                }
                field("Call Type"; Rec."Call Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this call is handled internally or externally.';
                }
                field(AssignedTo; AssignedTo)
                {
                    ApplicationArea = All;
                    Caption = 'Assigned To';
                    Editable = false;
                    ToolTip = 'Specifies the employee or vendor assigned to this call.';
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
            action(DeleteAll)
            {
                ApplicationArea = All;
                Caption = 'Delete All';
                Image = Delete;
                ToolTip = 'Delete all helpdesk call records. Use for test data cleanup only.';

                trigger OnAction()
                var
                    HelpdeskCall: Record "PMS Helpdesk Call";
                begin
                    if not Confirm('Are you sure you want to delete ALL helpdesk call records? This cannot be undone.', false) then
                        exit;
                    HelpdeskCall.DeleteAll(true);
                    Message('All helpdesk call records have been deleted.');
                end;
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
        AssignedTo: Text[100];

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
        if Rec."Call Type" = Rec."Call Type"::External then
            AssignedTo := Rec."Vendor Name"
        else
            AssignedTo := Rec."Employee Name";
    end;
}
