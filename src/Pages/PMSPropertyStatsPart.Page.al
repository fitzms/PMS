page 80819 "PMS Property Stats Part"
{
    Caption = 'Property Stats';
    PageType = CardPart;
    SourceTable = "PMS Property";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(UnitCounts)
            {
                Caption = 'Units';
                ShowCaption = true;

                field("Total Units"; Rec."Total Units")
                {
                    ApplicationArea = All;
                    Caption = 'Total Units';
                    DrillDownPageId = "PMS Unit List";
                    ToolTip = 'Specifies the total number of units linked to this property.';
                }
                field("Operational Units"; Rec."Operational Units")
                {
                    ApplicationArea = All;
                    Caption = 'Operational';
                    DrillDownPageId = "PMS Unit List";
                    ToolTip = 'Specifies the number of operational units.';
                }
                field("Non Operational Units"; Rec."Non Operational Units")
                {
                    ApplicationArea = All;
                    Caption = 'Non Operational';
                    DrillDownPageId = "PMS Unit List";
                    ToolTip = 'Specifies the number of non-operational units.';
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(
            "Total Units",
            "Operational Units",
            "Non Operational Units"
            );
    end;
}
