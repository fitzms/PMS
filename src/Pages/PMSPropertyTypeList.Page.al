page 80815 "PMS Property Type List"
{
    Caption = 'Property Types';
    PageType = List;
    SourceTable = "PMS Property Type";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the property type.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the property type.';
                }
            }
        }
    }
}
