page 80801 "PMS Cues Part"
{
    Caption = 'Property Management';
    PageType = CardPart;
    SourceTable = "PMS Role Center Cues"; // table 80800
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            // ── Properties ────────────────────────────────────────────────────
            cuegroup("Properties")
            {
                Caption = 'Properties';

                field("Total Properties"; Rec."Total Properties")
                {
                    ApplicationArea = All;
                    Caption = 'Total';
                    DrillDownPageId = "PMS Property List";
                }
                field("Active Properties"; Rec."Active Properties")
                {
                    ApplicationArea = All;
                    Caption = 'Active';
                    StyleExpr = ActivePropertiesStyle;
                    DrillDownPageId = "PMS Property List";
                }
                field("Vacant Properties"; Rec."Vacant Properties")
                {
                    ApplicationArea = All;
                    Caption = 'Vacant';
                    StyleExpr = VacantPropertiesStyle;
                    DrillDownPageId = "PMS Property List";
                }
            }

            // ── Staff Houses ───────────────────────────────────────────────────
            cuegroup("Staff Houses")
            {
                Caption = 'Staff Houses';

                field("Total Staff Houses"; Rec."Total Staff Houses")
                {
                    ApplicationArea = All;
                    Caption = 'Total';
                    DrillDownPageId = "PMS Property List";
                }
                field("Active Staff Houses"; Rec."Active Staff Houses")
                {
                    ApplicationArea = All;
                    Caption = 'Active';
                    StyleExpr = ActiveStaffHousesStyle;
                    DrillDownPageId = "PMS Property List";
                }
                field("Vacant Staff Houses"; Rec."Vacant Staff Houses")
                {
                    ApplicationArea = All;
                    Caption = 'Vacant';
                    StyleExpr = VacantStaffHousesStyle;
                    DrillDownPageId = "PMS Property List";
                }
            }

            // ── Units ─────────────────────────────────────────────────────────
            cuegroup("Units")
            {
                Caption = 'Units';

                field("Total Units"; Rec."Total Units")
                {
                    ApplicationArea = All;
                    Caption = 'Total';
                    // TODO (Sam): Wire DrillDown to the Unit list page
                    DrillDownPageId = "Chart of Accounts";    // placeholder - swap out
                }
                field("Occupied Units"; Rec."Occupied Units")
                {
                    ApplicationArea = All;
                    Caption = 'Occupied';
                    StyleExpr = OccupiedUnitsStyle;
                    // TODO (Sam): Wire DrillDown to occupied Units list
                    DrillDownPageId = "Chart of Accounts";    // placeholder - swap out
                }
                field("Available Units"; Rec."Available Units")
                {
                    ApplicationArea = All;
                    Caption = 'Available';
                    StyleExpr = AvailableUnitsStyle;
                    // TODO (Sam): Wire DrillDown to available Units list
                    DrillDownPageId = "Chart of Accounts";    // placeholder - swap out
                }
            }

            // ── Tenants ────────────────────────────────────────────────────────
            cuegroup("Tenants")
            {
                Caption = 'Tenants';

                field("Total Tenants"; Rec."Total Tenants")
                {
                    ApplicationArea = All;
                    Caption = 'Total';
                    // TODO (Sam): Wire DrillDown to Tenant list
                    DrillDownPageId = "Chart of Accounts";    // placeholder - swap out
                }
                field("New Tenants This Month"; Rec."New Tenants This Month")
                {
                    ApplicationArea = All;
                    Caption = 'New This Month';
                    // TODO (Sam): Wire DrillDown to new Tenants list filtered by month
                    DrillDownPageId = "Chart of Accounts";    // placeholder - swap out
                }
                field("Overdue Rent"; Rec."Overdue Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Overdue Rent';
                    StyleExpr = OverdueRentStyle;
                    // TODO (Sam): Wire DrillDown to overdue rent entries
                    DrillDownPageId = "Chart of Accounts";    // placeholder - swap out
                }
            }
        }
    }

    var
        ActivePropertiesStyle: Text;
        VacantPropertiesStyle: Text;
        ActiveStaffHousesStyle: Text;
        VacantStaffHousesStyle: Text;
        OccupiedUnitsStyle: Text;
        AvailableUnitsStyle: Text;
        OverdueRentStyle: Text;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(
            "Total Properties",
            "Active Properties",
            "Vacant Properties",
            "Total Staff Houses",
            "Active Staff Houses",
            "Vacant Staff Houses",
            "Total Units",
            "Occupied Units",
            "Available Units",
            "Total Tenants",
            "New Tenants This Month",
            "Overdue Rent");

        // Style: vacant properties amber, overdue & expiring red
        if Rec."Vacant Properties" > 0 then
            VacantPropertiesStyle := 'Ambiguous'
        else
            VacantPropertiesStyle := 'Favorable';

        if Rec."Vacant Staff Houses" > 0 then
            VacantStaffHousesStyle := 'Ambiguous'
        else
            VacantStaffHousesStyle := 'Favorable';

        ActiveStaffHousesStyle := 'Favorable';

        if Rec."Available Units" > 0 then
            AvailableUnitsStyle := 'Ambiguous'
        else
            AvailableUnitsStyle := 'Favorable';

        OccupiedUnitsStyle := 'Favorable';

        if Rec."Overdue Rent" > 0 then
            OverdueRentStyle := 'Unfavorable'
        else
            OverdueRentStyle := 'Favorable';

        ActivePropertiesStyle := 'Favorable';
    end;

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
