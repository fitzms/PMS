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
            // ── Helpdesk ──────────────────────────────────────────────────────
            cuegroup("Helpdesk")
            {
                Caption = 'Helpdesk';

                field("My Calls"; Rec."My Calls")
                {
                    ApplicationArea = All;
                    Caption = 'My Calls';
                    StyleExpr = MyCallsStyle;

                    trigger OnDrillDown()
                    var
                        HelpdeskCall: Record "PMS Helpdesk Call";
                        HelpdeskList: Page "PMS Helpdesk Call List";
                    begin
                        HelpdeskCall.SetRange("Call Type", HelpdeskCall."Call Type"::Internal);
                        HelpdeskCall.SetRange("Employee No.", UserId());
                        HelpdeskCall.SetFilter(Status, '<>%1', HelpdeskCall.Status::Closed);
                        HelpdeskList.SetTableView(HelpdeskCall);
                        HelpdeskList.Run();
                    end;
                }
                field("Open Calls"; Rec."Open Calls")
                {
                    ApplicationArea = All;
                    Caption = 'Open Calls';
                    StyleExpr = OpenCallsStyle;

                    trigger OnDrillDown()
                    var
                        HelpdeskCall: Record "PMS Helpdesk Call";
                        HelpdeskList: Page "PMS Helpdesk Call List";
                    begin
                        HelpdeskCall.SetFilter(Status, '<>%1', HelpdeskCall.Status::Closed);
                        HelpdeskList.SetTableView(HelpdeskCall);
                        HelpdeskList.Run();
                    end;
                }
                field("New Helpdesk Calls"; Rec."New Helpdesk Calls")
                {
                    ApplicationArea = All;
                    Caption = 'New Calls';
                    StyleExpr = NewCallsStyle;
                    DrillDownPageId = "PMS Helpdesk Call List";

                    trigger OnDrillDown()
                    var
                        HelpdeskCall: Record "PMS Helpdesk Call";
                        HelpdeskList: Page "PMS Helpdesk Call List";
                    begin
                        HelpdeskCall.SetRange(Status, HelpdeskCall.Status::New);
                        HelpdeskList.SetTableView(HelpdeskCall);
                        HelpdeskList.Run();
                    end;
                }
                field("Critical Calls"; Rec."Critical Calls")
                {
                    ApplicationArea = All;
                    Caption = 'Critical';
                    StyleExpr = CriticalCallsStyle;
                    DrillDownPageId = "PMS Helpdesk Call List";

                    trigger OnDrillDown()
                    var
                        HelpdeskCall: Record "PMS Helpdesk Call";
                        HelpdeskList: Page "PMS Helpdesk Call List";
                    begin
                        HelpdeskCall.SetRange(Priority, HelpdeskCall.Priority::Critical);
                        HelpdeskList.SetTableView(HelpdeskCall);
                        HelpdeskList.Run();
                    end;
                }
            }

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
        OpenCallsStyle: Text;
        NewCallsStyle: Text;
        CriticalCallsStyle: Text;
        MyCallsStyle: Text;

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
            "Active Tenants",
            "New Helpdesk Calls",
            "Critical Calls",
            "Open Calls");

        OccupiedUnitsStyle := 'Favorable';

        TenancyOccupiedStyle := 'Favorable';

        if Rec."Non Operational Units" > 0 then
            NonOperationalStyle := 'Unfavorable'
        else
            NonOperationalStyle := 'Favorable';

        ActivePropertiesStyle := 'Favorable';

        if Rec."Open Calls" > 0 then
            OpenCallsStyle := 'Attention'
        else
            OpenCallsStyle := 'Favorable';

        if Rec."New Helpdesk Calls" > 0 then
            NewCallsStyle := 'Unfavorable'
        else
            NewCallsStyle := 'Favorable';

        if Rec."Critical Calls" > 0 then
            CriticalCallsStyle := 'Unfavorable'
        else
            CriticalCallsStyle := 'Favorable';

        Rec.SetRange("Employee No. Filter", UserId());
        Rec.CalcFields("My Calls");
        Rec.SetRange("Employee No. Filter");
        if Rec."My Calls" > 0 then
            MyCallsStyle := 'Attention'
        else
            MyCallsStyle := 'Favorable';
    end;

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
