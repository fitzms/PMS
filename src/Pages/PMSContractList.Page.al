page 80805 "PMS Contract List"
{
    Caption = 'Contracts';
    PageType = List;
    SourceTable = "PMS Contract Header";
    CardPageId = "PMS Contract Header";
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
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the vendor for this contract.';
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
                field("Contract Value"; Rec."Contract Value")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the total value of all contract lines.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the contract.';
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
                RunObject = page "PMS Contract Header";
                RunPageMode = Create;
                ToolTip = 'Create a new contract.';
            }
        }
        area(Promoted)
        {
            group(Category_New)
            {
                Caption = 'New';
                actionref(NewContract_Promoted; NewContract) { }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Contract Value");
    end;

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetFilter(Status, '<>%1', Rec.Status::Archived);
        Rec.FilterGroup(0);
    end;
}
