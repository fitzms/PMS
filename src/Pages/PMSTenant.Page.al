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
                        NoSeries: Codeunit "No. Series";
                    begin
                        PMSSetup.GetRecordOnce();
                        PMSSetup.TestField("Tenant Nos.");
                        if NoSeries.LookupRelatedNoSeries(PMSSetup."Tenant Nos.", Rec."No. Series") then begin
                            Rec."Tenant ID" := NoSeries.GetNextNo(Rec."No. Series");
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
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the current status of the tenant.';
                }
                field(CurrentPropertyKnownAs; CurrentPropertyKnownAs)
                {
                    ApplicationArea = All;
                    Caption = 'Property Known As';
                    Editable = false;

                    ToolTip = 'Specifies the property where the tenant currently resides.';
                }
            }
            group(Details)
            {
                Caption = 'Details';

                field("Billing Code"; Rec."Billing Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the billing code for this tenant.';

                    trigger OnValidate()
                    begin
                        UpdatePageVars();
                        CurrPage.Update(true);
                    end;
                }
                field(BillingDescription; BillingDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Billing Description';
                    Editable = false;
                    ToolTip = 'Specifies the description of the billing code.';
                }

                field("Employee Dimension Value"; Rec."Employee Dimension Value")
                {
                    ApplicationArea = All;
                    Caption = 'Employee Dimension';
                    ToolTip = 'Specifies the employee dimension value for this tenant.';

                    trigger OnValidate()
                    begin
                        UpdatePageVars();
                        CurrPage.Update(true);
                    end;
                }
                field(EmployeeDimCode; EmployeeDimCode)
                {
                    ApplicationArea = All;
                    Caption = 'Dimension Code';
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the employee dimension code from setup.';
                }

                field(EmployeeDimName; EmployeeDimName)
                {
                    ApplicationArea = All;
                    Caption = 'Dimension Value Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the employee dimension value.';
                }

                field("Cost Centre Code"; Rec."Cost Centre Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the cost centre automatically assigned from the employee dimension value.';
                }
                field(CostCentreName; CostCentreName)
                {
                    ApplicationArea = All;
                    Caption = 'Cost Centre Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the cost centre dimension value.';
                }

            }
            part(TenantMovement; "PMS Tenant Movement Subform")
            {
                ApplicationArea = All;
                Caption = 'Movement';
                Editable = false;
                SubPageLink = "Tenant ID" = field("Tenant ID");
            }
        }

        area(FactBoxes)
        {
            part(CustomerDetails; "Customer Details FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Tenant ID");
            }
            part(CustomerStatistics; "Customer Statistics FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Tenant ID");
            }
            part(SalesHistSellto; "Sales Hist. Sell-to FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Tenant ID");
            }
            // part(JobCost; "Job Cost FactBox")
            // {
            //     ApplicationArea = All;
            //     SubPageLink = "No." = field("Tenant ID");
            // }

        }
    }

    actions
    {
        area(Navigation)
        {
            action(Dimensions)
            {
                ApplicationArea = All;
                Caption = 'Dimensions';
                Image = Dimensions;
                ShortcutKey = 'Shift+Ctrl+D';
                ToolTip = 'View or edit dimensions for this tenant.';

                trigger OnAction()
                var
                    DefaultDim: Record "Default Dimension";
                    DefaultDimPage: Page "Default Dimensions";
                    PMSSetup: Record "PMS Setup";
                begin
                    DefaultDim.SetRange("Table ID", Database::"PMS Tenant");
                    DefaultDim.SetRange("No.", Rec."Tenant ID");
                    DefaultDimPage.SetTableView(DefaultDim);
                    DefaultDimPage.RunModal();

                    PMSSetup.GetRecordOnce();
                    if PMSSetup."Employee Dimension Code" <> '' then begin
                        if DefaultDim.Get(Database::"PMS Tenant", Rec."Tenant ID", PMSSetup."Employee Dimension Code") then
                            Rec."Employee Dimension Value" := DefaultDim."Dimension Value Code"
                        else
                            Rec."Employee Dimension Value" := '';
                    end;
                    if DefaultDim.Get(Database::"PMS Tenant", Rec."Tenant ID", 'COSTCENTRE') then
                        Rec."Cost Centre Code" := DefaultDim."Dimension Value Code"
                    else
                        Rec."Cost Centre Code" := '';
                    Rec.Modify(true);
                    UpdatePageVars();
                    CurrPage.Update(false);
                end;
            }
        }
        area(Processing)
        {
            action(NewMovement)
            {
                ApplicationArea = All;
                Caption = 'New Movement';
                Image = NewDocument;
                ToolTip = 'Create a new movement record for this tenant.';

                trigger OnAction()
                var
                    TenantMovement: Record "PMS Tenant Movement";
                    MovementPage: Page "PMS Tenant Movement";
                begin
                    TenantMovement.Init();
                    TenantMovement."Entry No." := 0;
                    TenantMovement."Tenant ID" := Rec."Tenant ID";
                    TenantMovement."Date" := WorkDate();
                    TenantMovement."User ID" := CopyStr(UserId(), 1, MaxStrLen(TenantMovement."User ID"));
                    TenantMovement.Insert(true);
                    Commit();
                    MovementPage.SetRecord(TenantMovement);
                    MovementPage.RunModal();
                    Rec.CalcStatusFromMovements();
                    CurrPage.TenantMovement.Page.Update(false);
                    CurrPage.Update(false);
                end;
            }
            action(EditMovement)
            {
                ApplicationArea = All;
                Caption = 'Edit Movement';
                Image = Edit;
                ToolTip = 'Edit the selected movement record.';

                trigger OnAction()
                var
                    TenantMovement: Record "PMS Tenant Movement";
                    MovementPage: Page "PMS Tenant Movement";
                begin
                    CurrPage.TenantMovement.Page.GetRecord(TenantMovement);
                    MovementPage.SetRecord(TenantMovement);
                    MovementPage.RunModal();
                    Rec.CalcStatusFromMovements();
                    CurrPage.TenantMovement.Page.Update(false);
                    CurrPage.Update(false);
                end;
            }
            action(DeleteMovement)
            {
                ApplicationArea = All;
                Caption = 'Delete Movement';
                Image = Delete;
                ToolTip = 'Delete the selected movement record.';

                trigger OnAction()
                var
                    TenantMovement: Record "PMS Tenant Movement";
                begin
                    CurrPage.TenantMovement.Page.GetRecord(TenantMovement);
                    if not Confirm('Delete movement entry %1?', false, TenantMovement."Entry No.") then
                        exit;
                    TenantMovement.Delete(true);
                    Rec.CalcStatusFromMovements();
                    CurrPage.TenantMovement.Page.Update(false);
                    CurrPage.Update(false);
                end;
            }
            action(NewHelpdeskCall)
            {
                ApplicationArea = All;
                Caption = 'New Helpdesk Call';
                Image = ServiceLedger;
                ToolTip = 'Log a new helpdesk call for this tenant.';

                trigger OnAction()
                var
                    HelpdeskCall: Record "PMS Helpdesk Call";
                    HelpdeskPage: Page "PMS Helpdesk Call";
                    Movement: Record "PMS Tenant Movement";
                begin
                    if Rec.Status <> Rec.Status::Current then
                        Error('You cannot create a tenant helpdesk ticket as tenant does not have a current status.');
                    CurrPage.SaveRecord();
                    HelpdeskCall.Init();
                    HelpdeskCall."Tenant ID" := Rec."Tenant ID";
                    Movement.SetRange("Tenant ID", Rec."Tenant ID");
                    Movement.SetRange(Status, Movement.Status::Current);
                    if Movement.FindFirst() then begin
                        HelpdeskCall."Property ID" := Movement."Property ID";
                        HelpdeskCall."Unit ID" := Movement."Unit ID";
                    end;
                    HelpdeskCall.Insert(true);
                    Commit();
                    HelpdeskPage.SetRecord(HelpdeskCall);
                    HelpdeskPage.RunModal();
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Movement';

                actionref(NewMovement_Promoted; NewMovement) { }
                actionref(EditMovement_Promoted; EditMovement) { }
                actionref(DeleteMovement_Promoted; DeleteMovement) { }
            }
            group(Category_Navigate)
            {
                Caption = 'Tenant';

                actionref(Dimensions_Promoted; Dimensions) { }
            }
            group(Category_Helpdesk)
            {
                Caption = 'Helpdesk';

                actionref(NewHelpdeskCall_Promoted; NewHelpdeskCall) { }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PMSSetup: Record "PMS Setup";
        NoSeries: Codeunit "No. Series";
    begin
        PMSSetup.GetRecordOnce();
        if PMSSetup."Tenant Nos." <> '' then begin
            Rec."No. Series" := PMSSetup."Tenant Nos.";
            Rec."Tenant ID" := NoSeries.GetNextNo(PMSSetup."Tenant Nos.", WorkDate(), true);
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        UpdatePageVars();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdatePageVars();
    end;

    trigger OnOpenPage()
    var
        PMSSetup: Record "PMS Setup";
    begin
        PMSSetup.GetRecordOnce();
        if PMSSetup."Employee Dimension Code" <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetFilter("Employee Dimension Filter", PMSSetup."Employee Dimension Code");
            Rec.FilterGroup(0);
        end;
        EmployeeDimCode := PMSSetup."Employee Dimension Code";
    end;

    local procedure UpdatePageVars()
    var
        Movement: Record "PMS Tenant Movement";
        DimValue: Record "Dimension Value";
        ServiceShelf: Record "Service Shelf";
    begin
        IsTenantCurrent := (Rec.Status = Rec.Status::Current);
        CurrentPropertyKnownAs := '';
        if IsTenantCurrent then begin
            Movement.SetRange("Tenant ID", Rec."Tenant ID");
            Movement.SetRange(Status, Movement.Status::Current);
            if Movement.FindFirst() then begin
                Movement.CalcFields("Property Known As");
                CurrentPropertyKnownAs := Movement."Property Known As";
            end;
        end;
        EmployeeDimName := '';
        HasEmployeeDim := false;
        if (EmployeeDimCode <> '') and (Rec."Employee Dimension Value" <> '') then
            if DimValue.Get(EmployeeDimCode, Rec."Employee Dimension Value") then begin
                EmployeeDimName := DimValue.Name;
                HasEmployeeDim := true;
            end;
        BillingDescription := '';
        if Rec."Billing Code" <> '' then
            if ServiceShelf.Get(Rec."Billing Code") then
                BillingDescription := ServiceShelf.Description;
        CostCentreName := '';
        if Rec."Cost Centre Code" <> '' then
            if DimValue.Get('COSTCENTRE', Rec."Cost Centre Code") then
                CostCentreName := DimValue.Name;
    end;

    var
        CurrentPropertyKnownAs: Text[100];
        IsTenantCurrent: Boolean;
        EmployeeDimCode: Code[20];
        EmployeeDimName: Text[50];
        HasEmployeeDim: Boolean;
        BillingDescription: Text[100];
        CostCentreName: Text[50];
}
