page 80842 "PMS Prop Improvement List"
{
    Caption = 'Improvement History';
    PageType = List;
    SourceTable = "PMS Property Improvement";
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
                    ToolTip = 'Specifies the property this improvement belongs to.';
                }
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
}
