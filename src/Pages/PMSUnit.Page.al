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
                field(CurrentTenantName; CurrentTenantName)
                {
                    ApplicationArea = All;
                    Caption = 'Current Tenant';
                    Editable = false;
                    ToolTip = 'Specifies the name of the current tenant occupying this unit.';
                }
                field(LastPreviousTenant; LastPreviousTenant)
                {
                    ApplicationArea = All;
                    Caption = 'Last Previous Tenant';
                    Editable = false;
                    ToolTip = 'Specifies the name of the most recent previous tenant of this unit.';
                }
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    Editable = not Rec."Single Unit";
                    Importance = Promoted;
                    ToolTip = 'Specifies the property this unit belongs to.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = not Rec."Single Unit";
                    ToolTip = 'Specifies a description of the unit.';
                }
                field("Unit Type Code"; Rec."Unit Type Code")
                {
                    ApplicationArea = All;
                    Editable = not Rec."Single Unit";
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
                    Editable = not Rec."Single Unit";
                    Importance = Promoted;
                    ToolTip = 'Specifies the tenure of the unit.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = not Rec."Single Unit";
                    Importance = Promoted;
                    ToolTip = 'Specifies the current status of the unit.';
                }
                field("Single Unit"; Rec."Single Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this unit is the sole unit of a single-unit property.';
                }
            }
            group(Property)
            {
                Caption = 'Property';

                field(PropertyKnownAs; PropertyKnownAs)
                {
                    ApplicationArea = All;
                    Caption = 'Known As';
                    Editable = false;
                    ToolTip = 'Specifies the known-as name of the linked property.';
                }
                field(PropertyAddress; PropertyAddress)
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                    Editable = false;
                    ToolTip = 'Specifies the address of the linked property.';
                }
                field(PropertyAddress2; PropertyAddress2)
                {
                    ApplicationArea = All;
                    Caption = 'Address 2';
                    Editable = false;
                    ToolTip = 'Specifies the second address line of the linked property.';
                }
                field(PropertyAddress3; PropertyAddress3)
                {
                    ApplicationArea = All;
                    Caption = 'Address 3';
                    Editable = false;
                    ToolTip = 'Specifies the third address line of the linked property.';
                }
                field(PropertyCity; PropertyCity)
                {
                    ApplicationArea = All;
                    Caption = 'City';
                    Editable = false;
                    ToolTip = 'Specifies the city of the linked property.';
                }
                field(PropertyCounty; PropertyCounty)
                {
                    ApplicationArea = All;
                    Caption = 'County';
                    Editable = false;
                    ToolTip = 'Specifies the county of the linked property.';
                }
                field(PropertyCountryRegionCode; PropertyCountryRegionCode)
                {
                    ApplicationArea = All;
                    Caption = 'Country/Region';
                    Editable = false;
                    ToolTip = 'Specifies the country or region of the linked property.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Current Tenant ID");
        CurrentTenantName := '';
        if Rec."Current Tenant ID" <> '' then begin
            PMSTenant.Reset();
            if PMSTenant.Get(Rec."Current Tenant ID") then
                CurrentTenantName := PMSTenant.Name;
        end;

        PMSTenantMovement.Reset();
        PMSTenantMovement.SetRange("Unit ID", Rec."Unit ID");
        PMSTenantMovement.SetRange(Status, PMSTenantMovement.Status::Previous);
        if PMSTenantMovement.FindLast() then begin
            if PMSTenant.Get(PMSTenantMovement."Tenant ID") then
                LastPreviousTenant := PMSTenant.Name
            else
                LastPreviousTenant := '';
        end else
            LastPreviousTenant := '';
        if Rec."Unit Type Code" <> '' then begin
            if PropertyType.Get(Rec."Unit Type Code") then
                UnitTypeDescription := PropertyType.Description
            else
                UnitTypeDescription := '';
        end else
            UnitTypeDescription := '';

        if Rec."Property ID" <> '' then begin
            if PMSProperty.Get(Rec."Property ID") then begin
                PropertyKnownAs := PMSProperty."Known As";
                PropertyAddress := PMSProperty.Address;
                PropertyAddress2 := PMSProperty."Address 2";
                PropertyAddress3 := PMSProperty."Address 3";
                PropertyCity := PMSProperty.City;
                PropertyCounty := PMSProperty.County;
                PropertyCountryRegionCode := PMSProperty."Country/Region Code";
            end else begin
                PropertyKnownAs := '';
                PropertyAddress := '';
                PropertyAddress2 := '';
                PropertyAddress3 := '';
                PropertyCity := '';
                PropertyCounty := '';
                PropertyCountryRegionCode := '';
            end;
        end else begin
            PropertyKnownAs := '';
            PropertyAddress := '';
            PropertyAddress2 := '';
            PropertyAddress3 := '';
            PropertyCity := '';
            PropertyCounty := '';
            PropertyCountryRegionCode := '';
        end;
    end;

    var
        PropertyType: Record "PMS Property Type";
        PMSProperty: Record "PMS Property";
        PMSTenant: Record "PMS Tenant";
        PMSTenantMovement: Record "PMS Tenant Movement";
        CurrentTenantName: Text[100];
        LastPreviousTenant: Text[100];
        UnitTypeDescription: Text[100];
        PropertyKnownAs: Text[100];
        PropertyAddress: Text[100];
        PropertyAddress2: Text[50];
        PropertyAddress3: Text[50];
        PropertyCity: Text[30];
        PropertyCounty: Text[50];
        PropertyCountryRegionCode: Code[10];
}
