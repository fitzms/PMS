page 80828 "PMS Jobs Part"
{
    Caption = 'Jobs';
    PageType = ListPart;
    SourceTable = "PMS Job";
    ApplicationArea = All;

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
                field("Occurrence No."; Rec."Occurrence No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the occurrence number within the contract line.';
                }
                field("Scheduled Date"; Rec."Scheduled Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the scheduled date for this job.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyle;
                    ToolTip = 'Specifies the job status.';
                }
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the property.';
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
            action(OpenJob)
            {
                ApplicationArea = All;
                Caption = 'Open Job';
                Image = Open;
                ToolTip = 'Open the selected job card.';

                trigger OnAction()
                begin
                    Page.Run(Page::"PMS Job", Rec);
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
