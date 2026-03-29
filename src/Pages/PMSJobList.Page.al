page 80827 "PMS Job List"
{
    Caption = 'PMS Jobs';
    PageType = List;
    SourceTable = "PMS Job";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "PMS Job";

    layout
    {
        area(Content)
        {
            repeater(JobLines)
            {
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the job number.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the job description.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyle;
                    ToolTip = 'Specifies the current status of the job.';
                }
                field("Job Type"; Rec."Job Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this is an external or internal job.';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the origin of the job.';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source document number.';
                }
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the property.';
                }
                field("Scheduled Date"; Rec."Scheduled Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the scheduled date for this job.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the priority.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor (external jobs).';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee (internal jobs).';
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the linked purchase order.';
                }
                field("Estimated Cost"; Rec."Estimated Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the estimated cost.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(DeleteAll)
            {
                ApplicationArea = All;
                Caption = 'Delete All';
                Image = Delete;
                ToolTip = 'Delete all job records. Use for test data cleanup only.';

                trigger OnAction()
                var
                    PMSJob: Record "PMS Job";
                begin
                    if not Confirm('Are you sure you want to delete ALL job records? This cannot be undone.', false) then
                        exit;
                    PMSJob.DeleteAll(true);
                    Message('All job records have been deleted.');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
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
    end;

    var
        StatusStyle: Text;
}
