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

                field("Total Staff Houses"; Rec."Total Staff Houses")
                {
                    ApplicationArea = All;
                    Caption = 'Staff Houses';
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

                field("Active Tenants"; Rec."Active Tenants")
                {
                    ApplicationArea = All;
                    Caption = 'Current';
                    DrillDownPageId = "PMS Tenant List";
                }
            }
        }
    }

    var
        ActivePropertiesStyle: Text;
        OccupiedUnitsStyle: Text;
        TenancyOccupiedStyle: Text;
        NonOperationalStyle: Text;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(
            "Total Properties",
            "Operational Properties",
            "Total Staff Houses",
            "Total Units",
            "Tenancy Occupied Units",
            "Non Operational Units",
            "Operational Units",
            "Active Tenants");

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
