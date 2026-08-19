page 80808 "PMS Setup"
{
    Caption = 'Property Management Setup';
    PageType = Card;
    SourceTable = "PMS Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Property Dimension Code"; Rec."Property Dimension Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the dimension code used for properties. A dimension value is automatically created for each new property.';
                }
                field("Employee Dimension Code"; Rec."Employee Dimension Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the dimension code used for tenant employee dimensions.';
                }
                field("Cost Centre Dimension Code"; Rec."Cost Centre Dimension Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the dimension code used for cost centres (e.g. COSTCENTRE).';
                }
                field("Default Job Type"; Rec."Default Job Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default job type for maintenance work: Planned Maintenance, Reactive, or Internal.';
                }
                field("Job Frequency"; Rec."Job Frequency")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default job frequency for contracts.';
                }
                field("Web Client Base URL"; Rec."Web Client Base URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Optional: Specify the base URL for email links. Leave blank to use automatic URL detection.';
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';

                field("Contract Nos."; Rec."Contract Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series used to assign IDs to new contracts.';
                }
                field("Property Nos."; Rec."Property Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series used to assign IDs to new properties.';
                }
                field("Unit Nos."; Rec."Unit Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series used to assign IDs to new units.';
                }
                field("Tenant Nos."; Rec."Tenant Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series used to assign IDs to new tenants.';
                }
                field("Helpdesk Nos."; Rec."Helpdesk Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series used to assign IDs to new helpdesk calls.';
                }
                field("Job Nos."; Rec."Job Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series used to assign IDs to new PMS jobs.';
                }
            }
            group(SharePoint)
            {
                Caption = 'SharePoint Integration';

                field("SP Tenant ID"; Rec."SP Tenant ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Azure AD tenant ID (GUID) for your Microsoft 365 tenant.';
                }
                field("SP Client ID"; Rec."SP Client ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Application (client) ID of the Azure App Registration.';
                }
                field("SP Site Host"; Rec."SP Site Host")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SharePoint hostname, e.g. teamgodolphin.sharepoint.com.';
                }
                field("SP Site Path"; Rec."SP Site Path")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SharePoint site path, e.g. /sites/UK-PROPERTY-BC.';
                }
                field("SP Document Library"; Rec."SP Document Library")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document library name, e.g. Documents.';
                }
                field("SP Has Client Secret"; Rec."SP Has Client Secret")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether a client secret has been stored in secure storage.';
                }
                field("SP Graph Site ID"; Rec."SP Graph Site ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Cached Graph API site ID. Populated automatically when you validate the connection.';
                }
                field("SP Graph Drive ID"; Rec."SP Graph Drive ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Cached Graph API drive ID. Populated automatically when you validate the connection.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(DeleteTenantMovements)
            {
                ApplicationArea = All;
                Caption = 'Delete Tenant Movements';
                ToolTip = 'Deletes all records from the Tenant Movement table.';
                Image = Delete;

                trigger OnAction()
                var
                    TenantMovement: Record "PMS Tenant Movement";
                begin
                    if not Confirm('Delete all Tenant Movement records?', false) then
                        exit;
                    TenantMovement.DeleteAll();
                    Message('All Tenant Movement records have been deleted.');
                end;
            }
            action(SetClientSecret)
            {
                ApplicationArea = All;
                Caption = 'Set Client Secret';
                Image = Lock;
                ToolTip = 'Store the Azure App Registration client secret in secure isolated storage.';

                trigger OnAction()
                var
                    SecretDlg: Page "PMS Set SP Secret Dlg";
                    SPMgt: Codeunit "PMS SharePoint Mgt";
                begin
                    SecretDlg.RunModal();
                    if not SecretDlg.WasConfirmed() then
                        exit;
                    SPMgt.SetClientSecret(SecretDlg.GetSecret());
                    CurrPage.Update(false);
                    Message('Client secret saved to secure storage.');
                end;
            }
            action(ClearClientSecret)
            {
                ApplicationArea = All;
                Caption = 'Clear Client Secret';
                Image = Delete;
                ToolTip = 'Remove the stored client secret from secure isolated storage.';

                trigger OnAction()
                var
                    SPMgt: Codeunit "PMS SharePoint Mgt";
                begin
                    if not Confirm('Clear the stored SharePoint client secret?', false) then
                        exit;
                    SPMgt.ClearClientSecret();
                    CurrPage.Update(false);
                end;
            }
            action(ValidateSPConnection)
            {
                ApplicationArea = All;
                Caption = 'Validate SP Connection';
                Image = TestFile;
                ToolTip = 'Test the SharePoint connection and cache the site and drive IDs.';

                trigger OnAction()
                var
                    SPMgt: Codeunit "PMS SharePoint Mgt";
                begin
                    CurrPage.SaveRecord();
                    SPMgt.ValidateConnection(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(ResetSPCache)
            {
                ApplicationArea = All;
                Caption = 'Reset Cached IDs';
                Image = Refresh;
                ToolTip = 'Clear cached Graph Site ID and Drive ID so they are re-fetched on next use.';

                trigger OnAction()
                begin
                    Rec."SP Graph Site ID" := '';
                    Rec."SP Graph Drive ID" := '';
                    Rec.Modify();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetRecordOnce();
    end;
}
