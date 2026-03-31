page 80817 "PMS Unit List"
{
    Caption = 'Units';
    PageType = List;
    SourceTable = "PMS Unit";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "PMS Unit";

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Unit ID"; Rec."Unit ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the unit.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the unit.';
                }
                field("Unit Type Code"; Rec."Unit Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of unit.';
                }
                field(Tenure; Rec.Tenure)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the tenure of the unit.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the unit.';
                }
                field("Single Unit"; Rec."Single Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this unit is the sole unit of a single-unit property.';
                }
            }
        }
    }
}
