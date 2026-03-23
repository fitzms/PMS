page 80805 "PMS Contract List"
{
    Caption = 'Contracts';
    PageType = List;
    SourceTable = "PMS Contract";
    CardPageId = "PMS Contract";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(ContractLines)
            {
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
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewContract)
            {
                ApplicationArea = All;
                Caption = 'New';
                Image = New;
                RunObject = page "PMS Contract";
                RunPageMode = Create;
                ToolTip = 'Create a new contract.';
            }
        }
        area(Promoted)
        {
            actionref(NewContract_Promoted; NewContract) { }
        }
    }
}
