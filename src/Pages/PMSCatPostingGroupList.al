page 80810 "PMS Cat. Posting Group List"
{
    Caption = 'PMS Cat. Posting Groups';
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
                    ToolTip = 'Specifies the code for the PMS category posting group.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the category posting group.';
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L account linked to this posting group.';
                }
                field("G/L Account Description"; Rec."G/L Account Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the linked G/L account.';
                }
            }
        }
    }
}
