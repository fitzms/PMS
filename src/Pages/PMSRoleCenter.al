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
            // Headline
            part(HeadlinePart; "PMS Headline Part")
            {
                ApplicationArea = All;
            }
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
            // Top 10 contracts by value chart
            part(TopContractsChart; "PMS Top Contracts Chart")
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

                action(UnitList)
                {
                    ApplicationArea = All;
                    Caption = 'Units';
                    RunObject = page "PMS Unit List";
                    Image = ContactPerson;
                    ToolTip = 'View and manage all units.';
                }

                action(TenantList)
                {
                    ApplicationArea = All;
                    Caption = 'Tenants';
                    RunObject = page "PMS Tenant List";
                    Image = ContactPerson;
                    ToolTip = 'View and manage all tenants.';
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

            }


            // ── Helpdesk section ──────────────────────────────────────────────
            group("Helpdesk")
            {
                Caption = 'Helpdesk';

                action(HelpdeskCallList)
                {
                    ApplicationArea = All;
                    Caption = 'Helpdesk Calls';
                    RunObject = page "PMS Helpdesk Call List";
                    Image = ServiceLedger;
                    ToolTip = 'View and manage reactive helpdesk calls for property issues.';
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
                RunObject = page "PMS Tenant List";
                Image = ContactPerson;
                ToolTip = 'Open the Tenants list.';
            }
            action(NavHelpdesk)
            {
                ApplicationArea = All;
                Caption = 'Helpdesk';
                RunObject = page "PMS Helpdesk Call List";
                Image = ServiceLedger;
                ToolTip = 'Open the Helpdesk Calls list.';
            }

        }

        area(Processing)
        {
            // Quick-create actions shown in the top action bar
            action(QuickNewHelpdeskCall)
            {
                ApplicationArea = All;
                Caption = 'New Call';
                Image = NewDocument;
                ToolTip = 'Quickly log a new helpdesk call.';
                RunObject = page "PMS Helpdesk Call";
                RunPageMode = Create;
            }
            group(QuickNewGroup)
            {
                Caption = 'New';
                action(QuickNewTenant)
                {
                    ApplicationArea = All;
                    Caption = 'New Tenant';
                    Image = NewCustomer;
                    ToolTip = 'Quickly create a new tenant.';
                    RunObject = page "PMS Tenant";
                    RunPageMode = Create;
                }
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
                    RunObject = page "PMS Unit";
                    RunPageMode = Create;
                }
            }
        }
    }
}
