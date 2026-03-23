page 80803 "PMS Contracts Cues Part"
{
    Caption = 'Contracts';
    PageType = CardPart;
    SourceTable = "PMS Role Center Cues"; // table 80800
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            // ── Contracts ─────────────────────────────────────────────────────
            cuegroup("Contracts")
            {
                Caption = 'Contracts';

                field("Active Contracts"; Rec."Active Contracts")
                {
                    ApplicationArea = All;
                    Caption = 'Active';
                    // TODO (Sam): Filter to active contracts
                    DrillDownPageId = "PMS Contract List";
                }
                field("Expiring This Month"; Rec."Expiring This Month")
                {
                    ApplicationArea = All;
                    Caption = 'Expiring This Month';
                    StyleExpr = ExpiringContractsStyle;
                    // TODO (Sam): Filter to contracts expiring this month
                    DrillDownPageId = "PMS Contract List";
                }
                field("Contracts Pending Approval"; Rec."Contracts Pending Approval")
                {
                    ApplicationArea = All;
                    Caption = 'Pending Approval';
                    StyleExpr = PendingContractsStyle;
                    // TODO (Sam): Filter to contracts pending approval
                    DrillDownPageId = "PMS Contract List";
                }
            }
        }
    }

    var
        ExpiringContractsStyle: Text;
        PendingContractsStyle: Text;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(
            "Active Contracts",
            "Expiring This Month",
            "Contracts Pending Approval");

        if Rec."Expiring This Month" > 0 then
            ExpiringContractsStyle := 'Unfavorable'
        else
            ExpiringContractsStyle := 'Favorable';

        if Rec."Contracts Pending Approval" > 0 then
            PendingContractsStyle := 'Ambiguous'
        else
            PendingContractsStyle := 'Favorable';
    end;

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
