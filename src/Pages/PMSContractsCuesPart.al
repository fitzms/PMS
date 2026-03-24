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
                Caption = '';

                field("Active Contracts"; Rec."Active Contracts")
                {
                    ApplicationArea = All;
                    Caption = 'Active';
                    DrillDownPageId = "PMS Contract List";
                    trigger OnDrillDown()
                    var
                        ContractHdr: Record "PMS Contract Header";
                        ContractList: Page "PMS Contract List";
                    begin
                        ContractHdr.SetRange(Status, ContractHdr.Status::Active);
                        ContractList.SetTableView(ContractHdr);
                        ContractList.Run();
                    end;
                }
                field("Open Contracts"; Rec."Open Contracts")
                {
                    ApplicationArea = All;
                    Caption = 'Open';
                    DrillDownPageId = "PMS Contract List";
                    trigger OnDrillDown()
                    var
                        ContractHdr: Record "PMS Contract Header";
                        ContractList: Page "PMS Contract List";
                    begin
                        ContractHdr.SetRange(Status, ContractHdr.Status::Open);
                        ContractList.SetTableView(ContractHdr);
                        ContractList.Run();
                    end;
                }
                field("Closed Contracts"; Rec."Closed Contracts")
                {
                    ApplicationArea = All;
                    Caption = 'Closed';
                    DrillDownPageId = "PMS Contract List";
                    trigger OnDrillDown()
                    var
                        ContractHdr: Record "PMS Contract Header";
                        ContractList: Page "PMS Contract List";
                    begin
                        ContractHdr.SetRange(Status, ContractHdr.Status::Closed);
                        ContractList.SetTableView(ContractHdr);
                        ContractList.Run();
                    end;
                }
                field("Start in 30 Days"; Rec."Start in 30 Days")
                {
                    ApplicationArea = All;
                    Caption = 'Start in <30 Days';
                    StyleExpr = StartIn30Style;
                    DrillDownPageId = "PMS Contract List";
                }
                field("Ends in 30 Days"; Rec."End in 30 Days")
                {
                    ApplicationArea = All;
                    Caption = 'Ends in <30 Days';
                    StyleExpr = EndsIn30Style;
                    DrillDownPageId = "PMS Contract List";
                }
            }
        }
    }

    var
        StartIn30Style: Text;
        EndsIn30Style: Text;

    trigger OnAfterGetRecord()
    var
        ContractHdr: Record "PMS Contract Header";
    begin
        Rec.CalcFields(
            "Active Contracts",
            "Open Contracts",
            "Closed Contracts");

        ContractHdr.SetRange("Start Date", Today, CalcDate('<+30D>', Today));
        Rec."Start in 30 Days" := ContractHdr.Count();
        if Rec."Start in 30 Days" > 0 then
            StartIn30Style := 'Unfavorable'
        else
            StartIn30Style := 'Favorable';

        ContractHdr.Reset();
        ContractHdr.SetRange("End Date", Today, CalcDate('<+30D>', Today));
        Rec."End in 30 Days" := ContractHdr.Count();
        if Rec."End in 30 Days" > 0 then
            EndsIn30Style := 'Unfavorable'
        else
            EndsIn30Style := 'Favorable';
    end;

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
