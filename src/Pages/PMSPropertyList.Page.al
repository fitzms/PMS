page 80812 "PMS Property List"
{
    Caption = 'Properties';
    PageType = List;
    SourceTable = "PMS Property";
    CardPageId = "PMS Property";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the property.';
                }
                field("Known As"; Rec."Known As")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the commonly used name for the property.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the address of the property.';
                }
                field(Postcode; Rec.Postcode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the postcode for the property.';
                }
                field("Property Type Code"; Rec."Property Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of property.';
                }
                field(Tenure; Rec.Tenure)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the tenure of the property.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the property.';
                }
                field("Single Unit"; Rec."Single Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this property is a single-unit property.';
                }
            }
        }
    }


}
