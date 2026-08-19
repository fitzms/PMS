page 80849 "PMS Job Expense Lines"
{
    Caption = 'Job Expense Lines';
    PageType = ListPart;
    SourceTable = "PMS Job Expense Line";
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of this expense line.';
                }
                field("Category Posting Group"; Rec."Category Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category posting group for this line.';
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L account to post this line to.';
                }
                field("G/L Account Description"; Rec."G/L Account Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L account description.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity for this line.';
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the direct unit cost for this line.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies the total amount: Quantity × Direct Unit Cost.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the shortcut dimension 1 code for this expense line.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the shortcut dimension 2 code for this expense line.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Dimensions)
            {
                ApplicationArea = All;
                Caption = 'Dimensions';
                Image = Dimensions;
                ToolTip = 'View or edit dimension values for this expense line.';
                Scope = Repeater;

                trigger OnAction()
                begin
                    Rec.ShowDimensions();
                    CurrPage.Update();
                end;
            }
        }
    }
}
