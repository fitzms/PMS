page 80821 "PMS Tenant List"
{
    Caption = 'Tenants';
    PageType = List;
    SourceTable = "PMS Tenant";
    CardPageId = "PMS Tenant";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the tenant.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the tenant.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the tenant.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewTenant)
            {
                ApplicationArea = All;
                Caption = 'New';
                Image = New;
                RunObject = page "PMS Tenant";
                RunPageMode = Create;
                ToolTip = 'Create a new tenant.';
            }
        }
        area(Promoted)
        {
            actionref(NewTenant_Promoted; NewTenant) { }
        }
    }
}
