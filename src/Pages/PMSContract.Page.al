page 80806 "PMS Contract"
{
    Caption = 'Contract';
    PageType = Card;
    SourceTable = "PMS Contract";
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the contract.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the contract.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the contract starts.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the contract ends.';
                }
                field("Cat. Posting Group"; Rec."Cat. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category posting group for this contract.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CopyContract)
            {
                ApplicationArea = All;
                Caption = 'Copy Contract';
                Image = Copy;
                ToolTip = 'Copy this contract to create a new one.';
                trigger OnAction()
                begin
                    // TODO (Sam): Implement copy contract logic
                    Message('Copy Contract - to be implemented by Sam.');
                end;
            }
        }
        area(Promoted)
        {
            actionref(CopyContract_Promoted; CopyContract) { }
        }
    }
}
