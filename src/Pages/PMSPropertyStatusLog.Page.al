page 80845 "PMS Property Status Log"
{
    Caption = 'Property Status Log';
    PageType = List;
    SourceTable = "PMS Property Status Log";
    ApplicationArea = All;
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Changed On"; Rec."Changed On")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the status was changed.';
                }
                field("Changed By"; Rec."Changed By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who changed the status.';
                }
                field("Old Status"; Rec."Old Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the previous status.';
                }
                field("New Status"; Rec."New Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the new status.';
                }
                field(Note; Rec.Note)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reason for the status change.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Property ID", "Changed On");
        Rec.Ascending(false);
    end;
}
