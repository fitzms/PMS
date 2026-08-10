page 80840 "PMS Property Boiler List"
{
    Caption = 'Boiler Entries';
    PageType = List;
    SourceTable = "PMS Property Boiler";
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the property this boiler belongs to.';
                }
                field("Boiler Type"; Rec."Boiler Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of boiler.';
                }
                field("Boiler Make"; Rec."Boiler Make")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the make of the boiler.';
                }
                field("Boiler Model"; Rec."Boiler Model")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the model of the boiler.';
                }
                field("Burner Model"; Rec."Burner Model")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the burner model for the boiler.';
                }
                field("Heating System Type"; Rec."Heating System Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of heating system.';
                }
                field("Boiler Location"; Rec."Boiler Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location of the boiler in the property.';
                }
                field("Date of Next Service"; Rec."Date of Next Service")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the next scheduled service.';
                }
                field("Landlord Cert Inspection Date"; Rec."Landlord Cert Inspection Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the new landlord certificate inspection.';
                }
            }
        }
    }
}
