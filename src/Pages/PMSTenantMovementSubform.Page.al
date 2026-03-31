page 80831 "PMS Tenant Movement Subform"
{
    Caption = 'Tenant Movement';
    PageType = ListPart;
    SourceTable = "PMS Tenant Movement";
    SourceTableView = where("Tenant ID" = filter(<> ''));
    ApplicationArea = All;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
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
                    ToolTip = 'Specifies the entry number.';
                }
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the movement entry.';
                }

                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the property associated with this movement entry.';
                }

                field("Property Known As"; Rec."Property Known As")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the known-as name of the property.';
                }

                field("Unit ID"; Rec."Unit ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit associated with this movement entry.';
                }

                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the status of the tenant for this movement.';
                }

                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the start date of the tenancy.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the end date of the tenancy.';
                }
                field("Notes"; Rec."Notes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional notes for this movement entry.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who created this entry.';
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
    end;
}
