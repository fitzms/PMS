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
                Caption = 'Unit(s)';
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

            group(TenantCounts)
            {
                Caption = 'Tenants';
                ShowCaption = true;

                field(CurrentTenants; CurrentTenantCount)
                {
                    ApplicationArea = All;
                    Caption = 'Current Tenant(s)';
                    ToolTip = 'Specifies the number of current tenants at this property.';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        Movement: Record "PMS Tenant Movement";
                    begin
                        Movement.SetRange("Property ID", Rec."Property ID");
                        Movement.SetRange(Status, Movement.Status::Current);
                        Page.Run(Page::"PMS Tenant Movement", Movement);
                    end;
                }
                field(PreviousTenants; PreviousTenantCount)
                {
                    ApplicationArea = All;
                    Caption = 'Previous Tenant(s)';
                    ToolTip = 'Specifies the number of previous tenants at this property.';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        Movement: Record "PMS Tenant Movement";
                    begin
                        Movement.SetRange("Property ID", Rec."Property ID");
                        Movement.SetRange(Status, Movement.Status::Previous);
                        Page.Run(Page::"PMS Tenant Movement", Movement);
                    end;
                }
            }


        }
    }

    trigger OnAfterGetRecord()
    var
        Movement: Record "PMS Tenant Movement";
    begin
        Rec.CalcFields(
            "Total Units",
            "Operational Units",
            "Non Operational Units"
            );

        Movement.SetRange("Property ID", Rec."Property ID");
        Movement.SetRange(Status, Movement.Status::Current);
        CurrentTenantCount := Movement.Count();

        Movement.SetRange(Status, Movement.Status::Previous);
        PreviousTenantCount := Movement.Count();
    end;

    var
        CurrentTenantCount: Integer;
        PreviousTenantCount: Integer;
}
