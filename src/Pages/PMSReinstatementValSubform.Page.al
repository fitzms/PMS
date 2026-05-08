page 80837 "PMS Reinstatement Val Subform"
{
    Caption = 'Reinstatement Valuations';
    PageType = ListPart;
    SourceTable = "PMS Reinstatement Valuation";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
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

    procedure SetPropertyID(NewPropertyID: Code[20])
    begin
        PropertyIDVar := NewPropertyID;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ReinstatementVal: Record "PMS Reinstatement Valuation";
    begin
        Rec."Property ID" := PropertyIDVar;
        ReinstatementVal.SetRange("Property ID", PropertyIDVar);
        if ReinstatementVal.FindLast() then
            Rec."Line No." := ReinstatementVal."Line No." + 10000
        else
            Rec."Line No." := 10000;
    end;

    var
        PropertyIDVar: Code[20];
}
