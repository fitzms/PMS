page 80838 "PMS Tenant Movement List"
{
    Caption = 'Tenant Movements';
    PageType = List;
    SourceTable = "PMS Tenant Movement";
    ApplicationArea = All;
    UsageCategory = None;
    CardPageId = "PMS Tenant Movement";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    StyleExpr = RowStyle;
                    ToolTip = 'Specifies the entry number.';
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    StyleExpr = RowStyle;
                    ToolTip = 'Specifies the tenant.';
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    StyleExpr = RowStyle;
                    ToolTip = 'Specifies the status of the tenant for this movement.';
                }
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    StyleExpr = RowStyle;
                    ToolTip = 'Specifies the property associated with this movement.';
                }
                field("Property Known As"; Rec."Property Known As")
                {
                    ApplicationArea = All;
                    StyleExpr = RowStyle;
                    ToolTip = 'Specifies the known-as name of the property.';
                }
                field("Unit ID"; Rec."Unit ID")
                {
                    ApplicationArea = All;
                    StyleExpr = RowStyle;
                    ToolTip = 'Specifies the unit associated with this movement.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    StyleExpr = RowStyle;
                    ToolTip = 'Specifies the start date of the tenancy.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    StyleExpr = RowStyle;
                    ToolTip = 'Specifies the end date of the tenancy.';
                }
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                    StyleExpr = RowStyle;
                    ToolTip = 'Specifies the date of the movement entry.';
                }
                field("Notes"; Rec."Notes")
                {
                    ApplicationArea = All;
                    StyleExpr = RowStyle;
                    ToolTip = 'Specifies additional notes for this movement entry.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    StyleExpr = RowStyle;
                    ToolTip = 'Specifies the user who created this entry.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec.Status = Rec.Status::Current then
            RowStyle := 'Strong'
        else
            RowStyle := '';
    end;

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Entry No.");
        Rec.Ascending(false);
    end;

    var
        RowStyle: Text;
}
