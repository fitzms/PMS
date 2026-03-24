page 80822 "PMS Tenant"
{
    Caption = 'Tenant';
    PageType = Card;
    SourceTable = "PMS Tenant";
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    ToolTip = 'Specifies the unique identifier for the tenant.';

                    trigger OnAssistEdit()
                    var
                        PMSSetup: Record "PMS Setup";
                        NoSeriesMgt: Codeunit NoSeriesManagement;
                    begin
                        PMSSetup.GetRecordOnce();
                        PMSSetup.TestField("Tenant Nos.");
                        if NoSeriesMgt.SelectSeries(PMSSetup."Tenant Nos.", xRec."No. Series", Rec."No. Series") then begin
                            NoSeriesMgt.SetSeries(Rec."Tenant ID");
                            CurrPage.Update();
                        end;
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the name of the tenant.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the current status of the tenant.';
                }
                field("Unit ID"; Rec."Unit ID")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the unit this tenant is linked to.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date the tenancy started.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date the tenancy ended or is due to end.';
                }
                field(PropertyAddress; PropertyAddress)
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                    Editable = false;
                    ToolTip = 'Specifies the address of the property linked to the unit.';
                }
                field(PropertyAddress2; PropertyAddress2)
                {
                    ApplicationArea = All;
                    Caption = 'Address 2';
                    Editable = false;
                    ToolTip = 'Specifies the second address line of the property linked to the unit.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        PMSUnit: Record "PMS Unit";
        PMSProperty: Record "PMS Property";
    begin
        PropertyAddress := '';
        PropertyAddress2 := '';
        if Rec."Unit ID" <> '' then
            if PMSUnit.Get(Rec."Unit ID") then
                if PMSUnit."Property ID" <> '' then
                    if PMSProperty.Get(PMSUnit."Property ID") then begin
                        PropertyAddress := PMSProperty.Address;
                        PropertyAddress2 := PMSProperty."Address 2";
                    end;
    end;

    var
        PropertyAddress: Text[100];
        PropertyAddress2: Text[50];
}
