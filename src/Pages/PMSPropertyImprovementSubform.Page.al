page 80834 "PMS Prop Improvement Subform"
{
    Caption = 'Improvement History';
    PageType = ListPart;
    SourceTable = "PMS Property Improvement";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Improvement Type"; Rec."Improvement Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of improvement carried out.';
                }
                field("Date of Improvement"; Rec."Date of Improvement")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the improvement was carried out.';
                }
                field("Area of Improvement"; Rec."Area of Improvement")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the area of the property where the improvement was carried out.';
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
        PropertyImprovement: Record "PMS Property Improvement";
    begin
        Rec."Property ID" := PropertyIDVar;
        PropertyImprovement.SetRange("Property ID", PropertyIDVar);
        if PropertyImprovement.FindLast() then
            Rec."Line No." := PropertyImprovement."Line No." + 10000
        else
            Rec."Line No." := 10000;
    end;

    var
        PropertyIDVar: Code[20];
}
