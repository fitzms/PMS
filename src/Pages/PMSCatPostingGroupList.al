page 80810 "PMS Cat. Posting Group List"
{
    Caption = 'Cat. Posting Groups';
    PageType = List;
    SourceTable = "PMS Cat. Posting Group";
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
                    ToolTip = 'Specifies the code for the category posting group.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the category posting group.';
                }
            }
        }
    }
}
