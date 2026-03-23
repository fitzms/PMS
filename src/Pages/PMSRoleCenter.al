page 80802 "PMS Role Center"
{
    Caption = 'Property Management';
    PageType = RoleCenter;
    // TODO (Sam): Set ApplicationArea and assign to the correct profile
    ApplicationArea = All;

    layout
    {
        area(RoleCenter)
        {
            // Properties & Tenants KPI cues
            part(CuesPart; "PMS Cues Part")
            {
                ApplicationArea = All;
            }
            // Contracts KPI cues
            part(ContractsCuesPart; "PMS Contracts Cues Part")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Sections)
        {
            // ── Properties section ─────────────────────────────────────────────
            group("Properties")
            {
                Caption = 'Properties';
                Image = Home;

                action(PropertyList)
                {
                    ApplicationArea = All;
                    Caption = 'Properties';
                    RunObject = page "PMS Property List";
                    Image = ResourcePlanning;
                    ToolTip = 'View and manage all properties.';
                }
                action(NewProperty)
                {
                    ApplicationArea = All;
                    Caption = 'New Property';
                    Image = New;
                    ToolTip = 'Create a new property record.';
                    RunObject = page "PMS Property";
                    RunPageMode = Create;
                }
            }

            // ── Contracts section ──────────────────────────────────────────────
            group("Contracts")
            {
                Caption = 'Contracts';

                action(ContractList)
                {
                    ApplicationArea = All;
                    Caption = 'Contracts';
                    RunObject = page "PMS Contract List";
                    Image = Document;
                    ToolTip = 'View and manage all contracts.';
                }
                action(CopyContract)
                {
                    ApplicationArea = All;
                    Caption = 'Copy Contract';
                    Image = Copy;
                    ToolTip = 'Copy an existing contract to use as a starting point for a new one.';
                    // TODO (Sam): Replace RunObject with a dedicated Copy Contract report/page
                    RunObject = page "PMS Contract List";
                }
            }

            // ── Units section ────────────────────────────────────────────────
            group("Units")
            {
                Caption = 'Units';

                action(UnitList)
                {
                    ApplicationArea = All;
                    Caption = 'Units';
                    RunObject = page "PMS Unit List";
                    Image = ContactPerson;
                    ToolTip = 'View and manage all units.';
                }
                action(NewUUnit)
                {
                    ApplicationArea = All;
                    Caption = 'New Unit';
                    Image = NewCustomer;
                    ToolTip = 'Create a new Unit record.';
                    RunObject = page "PMS Unit";
                    RunPageMode = Create;
                }
            }


            // ── Tenants section ────────────────────────────────────────────────
            group("Tenants")
            {
                Caption = 'Tenants';

                action(TenantList)
                {
                    ApplicationArea = All;
                    Caption = 'Tenants';
                    RunObject = page "Chart of Accounts";    // TODO (Sam): Swap for real Tenant List page
                    Image = ContactPerson;
                    ToolTip = 'View and manage all tenants.';
                }
                action(NewTenant)
                {
                    ApplicationArea = All;
                    Caption = 'New Tenant';
                    Image = NewCustomer;
                    ToolTip = 'Create a new tenant record.';
                    // TODO (Sam): Replace RunObject with the real Tenant Card page
                    RunObject = page "G/L Account Card";    // placeholder - swap out
                }

            }

            // ── Administration ─────────────────────────────────────────────────
            group("Administration")
            {
                Caption = 'Administration';
                Image = Setup;

                action(PMSSetup)
                {
                    ApplicationArea = All;
                    Caption = 'PMS Setup';
                    RunObject = page "PMS Setup";
                    Image = Setup;
                    ToolTip = 'Configure property management settings.';
                }

                action(PMSCategoryPostingGroupList)
                {
                    ApplicationArea = All;
                    Caption = 'PMS Cat. Posting Groups';
                    RunObject = page "PMS Cat. Posting Group List";
                    Image = Setup;
                    ToolTip = 'View and manage PMS category posting groups.';
                }
            }
        }

        area(Embedding)
        {
            // Shortcut actions that appear in the navigation bar
            action(NavProperties)
            {
                ApplicationArea = All;
                Caption = 'Properties';
                RunObject = page "PMS Property List";
                Image = ResourcePlanning;
                ToolTip = 'Open the Properties list.';
            }
            action(NavContracts)
            {
                ApplicationArea = All;
                Caption = 'Contracts';
                RunObject = page "PMS Contract List";
                Image = Document;
                ToolTip = 'Open the Contracts list.';
            }
            action(NavTenants)
            {
                ApplicationArea = All;
                Caption = 'Tenants';
                RunObject = page "Chart of Accounts";    // TODO (Sam): Swap for real Tenant List page
                Image = ContactPerson;
                ToolTip = 'Open the Tenants list.';
            }
        }

        area(Processing)
        {
            // Quick-create actions shown in the top action bar
            action(QuickNewProperty)
            {
                ApplicationArea = All;
                Caption = 'New Property';
                Image = New;
                ToolTip = 'Quickly create a new property.';
                RunObject = page "PMS Property";
                RunPageMode = Create;
            }

            action(QuickNewUnit)
            {
                ApplicationArea = All;
                Caption = 'New Unit';
                Image = NewCustomer;
                ToolTip = 'Quickly create a new unit.';
                // TODO (Sam): Replace RunObject with the real Unit Card page
                RunObject = page "G/L Account Card";    // placeholder - swap out
            }

            action(QuickNewTenant)
            {
                ApplicationArea = All;
                Caption = 'New Tenant';
                Image = NewCustomer;
                ToolTip = 'Quickly create a new tenant.';
                // TODO (Sam): Replace RunObject with the real Tenant Card page
                RunObject = page "G/L Account Card";    // placeholder - swap out
            }
            action(QuickCopyContract)
            {
                ApplicationArea = All;
                Caption = 'Copy Contract';
                Image = Copy;
                ToolTip = 'Copy an existing contract.';
                // TODO (Sam): Replace RunObject with a dedicated Copy Contract report/page
                RunObject = page "Chart of Accounts";    // placeholder - swap out
            }
        }
    }
}
