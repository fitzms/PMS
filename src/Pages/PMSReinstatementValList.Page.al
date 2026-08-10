page 80843 "PMS Reinstatement Val List"
{
    Caption = 'Reinstatement Valuations';
    PageType = List;
    SourceTable = "PMS Reinstatement Valuation";
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the property this valuation belongs to.';
                }
                field("Valuation Date"; Rec."Valuation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the reinstatement valuation.';
                }
                field("Valuation Type"; Rec."Valuation Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of valuation.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reinstatement valuation amount.';
                }
                field("Valuation Notes"; Rec."Valuation Notes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies any notes relating to the valuation.';
                }
            }
        }
    }
}
