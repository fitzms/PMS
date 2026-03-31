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
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetRecordOnce();
    end;
}
