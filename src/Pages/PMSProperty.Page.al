page 80813 "PMS Property"
{
    Caption = 'Property';
    PageType = Card;
    SourceTable = "PMS Property";
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the property.';
                }
                field("Known As"; Rec."Known As")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the commonly used name for the property.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the address of the property.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the second address line of the property.';
                }
                field("Address 3"; Rec."Address 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the third address line of the property.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city of the property.';
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the county of the property.';
                }
                field(Postcode; Rec.Postcode)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the postcode for the property.';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the country or region of the property.';
                }
                field("Property Type Code"; Rec."Property Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of property.';
                }
                field(Tenure; Rec.Tenure)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the tenure of the property.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the property.';
                }
                field("VAT Elected"; Rec."VAT Elected")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies whether VAT has been elected for this property.';
                }
                field("Local Authority"; Rec."Local Authority")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the local authority for the property.';
                }
                field("Water Company"; Rec."Water Company")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the water company serving the property.';
                }
                field(Sewerage; Rec.Sewerage)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sewerage provider for the property.';
                }
            }
        }

        area(FactBoxes)
        {
            part("Property Stats"; "PMS Property Stats Part")
            {
                ApplicationArea = All;
                SubPageLink = "Property ID" = field("Property ID");
            }
        }
    }

}

