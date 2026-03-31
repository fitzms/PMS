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
                field("Single Unit"; Rec."Single Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this property is a single-unit property with an auto-created matching unit.';
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
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the global dimension 1 code (e.g. cost centre) for this property.';
                }
                field("Property Dimension Value"; Rec."Property Dimension Value")
                {
                    ApplicationArea = All;
                    Caption = 'Property Dimension';
                    ToolTip = 'Specifies the property dimension value for this property.';
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
                ToolTip = 'View or edit dimensions for this property.';

                trigger OnAction()
                var
                    DefaultDim: Record "Default Dimension";
                    DefaultDimPage: Page "Default Dimensions";
                    PMSSetup: Record "PMS Setup";
                begin
                    DefaultDim.SetRange("Table ID", Database::"PMS Property");
                    DefaultDim.SetRange("No.", Rec."Property ID");
                    DefaultDimPage.SetTableView(DefaultDim);
                    DefaultDimPage.RunModal();

                    PMSSetup.GetRecordOnce();
                    if PMSSetup."Property Dimension Code" <> '' then begin
                        if DefaultDim.Get(Database::"PMS Property", Rec."Property ID", PMSSetup."Property Dimension Code") then
                            Rec."Property Dimension Value" := DefaultDim."Dimension Value Code"
                        else
                            Rec."Property Dimension Value" := '';
                        Rec.Modify(true);
                        CurrPage.Update(false);
                    end;
                end;
            }
            action(LedgerEntries)
            {
                ApplicationArea = All;
                Caption = 'Ledger Entries';
                Image = GeneralLedger;
                ToolTip = 'View general ledger entries posted against this property.';

                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                    DimSetEntry: Record "Dimension Set Entry";
                    PMSSetup: Record "PMS Setup";
                    DimSetFilter: Text;
                begin
                    PMSSetup.GetRecordOnce();
                    PMSSetup.TestField("Property Dimension Code");

                    DimSetEntry.SetRange("Dimension Code", PMSSetup."Property Dimension Code");
                    DimSetEntry.SetRange("Dimension Value Code", Rec."Property ID");
                    if DimSetEntry.FindSet() then begin
                        repeat
                            if DimSetFilter <> '' then
                                DimSetFilter += '|';
                            DimSetFilter += Format(DimSetEntry."Dimension Set ID");
                        until DimSetEntry.Next() = 0;
                        GLEntry.SetFilter("Dimension Set ID", DimSetFilter);
                    end else
                        GLEntry.SetRange("Dimension Set ID", -1); // no results
                    Page.Run(Page::"General Ledger Entries", GLEntry);
                end;
            }
        }
        area(Processing)
        {
            action(NewHelpdeskCall)
            {
                ApplicationArea = All;
                Caption = 'New Helpdesk Call';
                Image = ServiceLedger;
                ToolTip = 'Log a new helpdesk call for this property.';

                trigger OnAction()
                var
                    HelpdeskCall: Record "PMS Helpdesk Call";
                    HelpdeskPage: Page "PMS Helpdesk Call";
                begin
                    CurrPage.SaveRecord();
                    HelpdeskCall.Init();
                    HelpdeskCall."Property ID" := Rec."Property ID";
                    if Rec."Single Unit" then
                        HelpdeskCall."Unit ID" := Rec."Property ID";
                    HelpdeskCall.Insert(true);
                    Commit();
                    HelpdeskPage.SetRecord(HelpdeskCall);
                    HelpdeskPage.RunModal();
                end;
            }
            action(NewTenantMovement)
            {
                ApplicationArea = All;
                Caption = 'New Tenant Movement';
                Image = Allocate;
                ToolTip = 'Create a new tenant movement for this property.';

                trigger OnAction()
                var
                    TenantMovement: Record "PMS Tenant Movement";
                    MovementPage: Page "PMS Tenant Movement";
                begin
                    CurrPage.SaveRecord();
                    TenantMovement.Init();
                    TenantMovement."Entry No." := 0;
                    TenantMovement."Property ID" := Rec."Property ID";
                    if Rec."Single Unit" then
                        TenantMovement."Unit ID" := Rec."Property ID";
                    TenantMovement."Date" := WorkDate();
                    TenantMovement."User ID" := CopyStr(UserId(), 1, MaxStrLen(TenantMovement."User ID"));
                    TenantMovement.Insert(true);
                    Commit();
                    MovementPage.SetRecord(TenantMovement);
                    MovementPage.RunModal();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Navigate)
            {
                Caption = 'Property';

                actionref(Dimensions_Promoted; Dimensions) { }
                actionref(LedgerEntries_Promoted; LedgerEntries) { }
            }
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(NewHelpdeskCall_Promoted; NewHelpdeskCall) { }
                actionref(NewTenantMovement_Promoted; NewTenantMovement) { }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if GuiAllowed then
            if Dialog.Confirm('Do you want to create a single unit for this property?', false) then
                Rec."Single Unit" := true;
        exit(true);
    end;

    trigger OnOpenPage()
    var
        PMSSetup: Record "PMS Setup";
    begin
        PMSSetup.GetRecordOnce();
        if PMSSetup."Property Dimension Code" <> '' then
            Rec.FilterGroup(2);
        Rec.SetFilter("Property Dimension Filter", PMSSetup."Property Dimension Code");
        Rec.FilterGroup(0);
    end;
}

