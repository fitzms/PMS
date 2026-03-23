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
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewProperty)
            {
                ApplicationArea = All;
                Caption = 'New';
                Image = New;
                RunObject = page "PMS Property";
                RunPageMode = Create;
                ToolTip = 'Create a new property.';
            }
        }
        area(Promoted)
        {
            actionref(NewProperty_Promoted; NewProperty) { }
        }
    }
}
