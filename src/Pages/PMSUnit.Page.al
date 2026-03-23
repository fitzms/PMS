page 80818 "PMS Unit"
{
    Caption = 'Unit';
    PageType = Card;
    SourceTable = "PMS Unit";
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Unit ID"; Rec."Unit ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the unit.';
                }
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the property this unit belongs to.';
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
                field("Unit Type Description"; UnitTypeDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Unit Type Description';
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the description of the unit type.';
                }
                field(Tenure; Rec.Tenure)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the tenure of the unit.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the current status of the unit.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Unit Type Code" <> '' then begin
            if PropertyType.Get(Rec."Unit Type Code") then
                UnitTypeDescription := PropertyType.Description
            else
                UnitTypeDescription := '';
        end else
            UnitTypeDescription := '';
    end;

    var
        PropertyType: Record "PMS Property Type";
        UnitTypeDescription: Text[100];
}
