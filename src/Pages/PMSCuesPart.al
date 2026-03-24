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
                field("Operational Properties"; Rec."Operational Properties")
                {
                    ApplicationArea = All;
                    Caption = 'Operational';

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
                field("Operational Staff Houses"; Rec."Operational Staff Houses")
                {
                    ApplicationArea = All;
                    Caption = 'Operational';

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


            // ── Units ───────────────────────────────────────────────────────
            cuegroup("Units")
            {
                Caption = 'Units';

                field("Total Units"; Rec."Total Units")
                {
                    ApplicationArea = All;
                    Caption = 'Total';
                    DrillDownPageId = "PMS Unit List";
                }




                field("Tenancy Occupied Units"; Rec."Tenancy Occupied Units")
                {
                    ApplicationArea = All;
                    Caption = 'Tenancy Occupied';
                    StyleExpr = TenancyOccupiedStyle;
                    DrillDownPageId = "PMS Unit List";
                }
                field("Non Operational Units"; Rec."Non Operational Units")
                {
                    ApplicationArea = All;
                    Caption = 'Non Operational';
                    StyleExpr = NonOperationalStyle;
                    DrillDownPageId = "PMS Unit List";
                }
                field("Operational Units"; Rec."Operational Units")
                {
                    ApplicationArea = All;
                    Caption = 'Operational';
                    DrillDownPageId = "PMS Unit List";
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
                    DrillDownPageId = "PMS Tenant List";
                }
                field("Active Tenants"; Rec."Active Tenants")
                {
                    ApplicationArea = All;
                    Caption = 'Current';
                    DrillDownPageId = "PMS Tenant List";
                }
                field("Previous Tenants"; Rec."Previous Tenants")
                {
                    ApplicationArea = All;
                    Caption = 'Previous';
                    DrillDownPageId = "PMS Tenant List";
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
        TenancyOccupiedStyle: Text;
        NonOperationalStyle: Text;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(
            "Total Properties",
            "Operational Properties",
            "Vacant Properties",
            "Total Staff Houses",
            "Operational Staff Houses",
            "Vacant Staff Houses",
            "Total Units",
            "Available Units",
            "Tenancy Occupied Units",
            "Non Operational Units",
            "Operational Units",
            "Total Tenants",
            "Active Tenants",
            "Previous Tenants");

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

        TenancyOccupiedStyle := 'Favorable';

        if Rec."Non Operational Units" > 0 then
            NonOperationalStyle := 'Unfavorable'
        else
            NonOperationalStyle := 'Favorable';

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
