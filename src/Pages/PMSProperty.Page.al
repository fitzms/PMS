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
                    AssistEdit = true;
                    ToolTip = 'Specifies the unique identifier for the property.';

                    trigger OnAssistEdit()
                    var
                        PMSSetup: Record "PMS Setup";
                        NoSeries: Codeunit "No. Series";
                    begin
                        PMSSetup.GetRecordOnce();
                        PMSSetup.TestField("Property Nos.");
                        if NoSeries.LookupRelatedNoSeries(PMSSetup."Property Nos.", Rec."No. Series") then begin
                            Rec."Property ID" := NoSeries.GetNextNo(Rec."No. Series");
                            CurrPage.Update();
                        end;
                    end;
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
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the current status of the property.';
                }
                field("VAT Elected"; Rec."VAT Elected")
                {
                    ApplicationArea = All;

                    ToolTip = 'Specifies whether VAT has been elected for this property.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the global dimension 1 code (e.g. cost centre) for this property.';
                }
                field("Property Dimension Value"; Rec."Property Dimension Value")
                {
                    ApplicationArea = All;
                    Caption = 'Property Dimension';
                    ToolTip = 'Specifies the property dimension value for this property.';
                }
                field("SharePoint Folder URL"; Rec."SharePoint Folder URL")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the SharePoint Documents folder URL for this property.';
                }
                field("Qube Document History"; Rec."Qube Document History")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Qube document history reference for this property.';
                }
            }

            group(HousingAndCommunications)
            {
                Caption = 'Housing & Communications';

                group("QuickHouseFacts")
                {
                    Caption = 'Quick House Facts';
                    field("House Type"; Rec."House Type")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the type of house for this property.';
                        Importance = Promoted;
                    }

                    field("Furnishings Included"; Rec."Furnishings Included")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies whether furnishings are included with this property.';
                    }

                    field(HazardsExist; HazardsExist)
                    {
                        ApplicationArea = All;
                        Caption = 'Hazards Exist';
                        Editable = false;
                        ToolTip = 'Indicates whether any hazard records exist for this property.';
                    }

                    field("Meter Location"; Rec."Meter Location")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the location of the meter for this property.';
                    }

                    field("Fuse box Location"; Rec."Fuse box Location")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the location of the fuse box for this property.';
                    }
                    field("Boiler Location"; Rec."Boiler Location")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the location of the boiler for this property.';
                    }
                    field("Stopcock Location"; Rec."Stopcock Location")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the location of the stopcock for this property.';
                    }
                }

                group(PropertyCounts)
                {
                    Caption = 'Property Counts';
                    field("Storey Count"; Rec."Storey Count")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the number of storeys for this property.';
                    }
                    field("Living Room Count"; Rec."Living Room Count")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the number of living rooms for this property.';
                    }
                    field("Bedroom Count"; Rec."Bedroom Count")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the number of bedrooms for this property.';
                    }
                    field("Bathroom Count"; Rec."Bathroom Count")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the number of bathrooms for this property.';
                    }
                    field("Garage Count"; Rec."Garage Count")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the number of garages for this property.';
                    }
                    field("Total floor area (sqm)"; Rec."Total Floor Area (sqm)")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the total floor area of the property in square meters.';
                    }
                }
                group(Communications)
                {
                    Caption = 'Communications';
                    field("Land Line"; Rec."Land Line")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the type of land line available at this property.';
                    }
                    field("Broadband Username"; Rec."Broadband Username")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the broadband username for this property.';
                    }
                    field("Broadband Password"; Rec."Broadband Password")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the broadband password for this property.';
                    }
                    field("Wifi Name"; Rec."Wifi Name")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the Wi-Fi network name for this property.';
                    }
                    field("Wifi Password"; Rec."Wifi Password")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the Wi-Fi password for this property.';
                    }
                }

            }

            group(Utilities)
            {
                Caption = 'Utilities';

                Group("Local Authority & Council Tax")
                {
                    Caption = 'Local Authority & Council Tax';
                    field("Local Authority"; Rec."Local Authority")
                    {
                        Importance = Promoted;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the local authority for the property.';
                    }
                    field("Council Tax Reference"; Rec."Council Tax Reference")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the council tax reference for the property.';
                    }
                    field("Council Tax Band"; Rec."Council Tax Band")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the council tax band for the property.';
                    }
                }
                group("Water Service")
                {
                    Caption = 'Water Service';
                    field("Water Company"; Rec."Water Company")
                    {
                        Importance = Promoted;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the water company serving the property.';
                    }
                    field(Sewerage; Rec.Sewerage)
                    {
                        Importance = Promoted;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the sewerage provider for the property.';
                    }
                    field("Water Meter Number"; Rec."Water Meter Number")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the water meter number for the property.';
                    }
                }
                Group("Gas and Electricity")
                {
                    Caption = 'Gas and Electricity';
                    field("Gas Meter Number"; Rec."Gas Meter Number")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the gas meter number for the property.';
                    }
                    field("MPRN/MSN"; Rec."MPRN/MSN")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the MPRN/MSN for the property.';
                    }
                    field("MPANNo."; Rec."MPANNo.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the MPAN number for the property.';
                    }
                    field("Electricity Meter Number"; Rec."Electricity Meter Number")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the electricity meter number for the property.';
                    }
                }
                group("Heating Oil")
                {
                    Caption = 'Heating Oil';

                    field("Property Fuel Type"; Rec."Property Fuel Type")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the fuel type for the property.';
                    }
                    field("Heating Oil Tank No."; Rec."Heating Oil Tank No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the heating oil tank number for the property.';
                    }
                    field("Oil Tank Capacity (Ltr)"; Rec."Oil Tank Capacity (Ltr)")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the oil tank capacity in liters for the property.';
                    }
                    field("Auto Top Up Heating Oil Tank"; Rec."Auto Top Up Heating Oil Tank")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies whether the heating oil tank is on auto top-up.';
                    }
                    field("Oil Tank notes"; Rec."Oil Tank notes")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies any notes related to the oil tank for the property.';
                    }
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
#pragma warning disable AL0432
            part(Attachments; "Document Attachment Factbox")
#pragma warning restore AL0432
            {
                ApplicationArea = All;
                Caption = 'Documents';
                SubPageLink = "Table ID" = const(80811),
                              "No." = field("Property ID");
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Links; Links)
            {
                ApplicationArea = All;
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
                    GLSetup: Record "General Ledger Setup";
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
                    end;
                    if PMSSetup."Cost Centre Dimension Code" <> '' then begin
                        if DefaultDim.Get(Database::"PMS Property", Rec."Property ID", PMSSetup."Cost Centre Dimension Code") then
                            Rec."Cost Centre Dimension Value" := DefaultDim."Dimension Value Code"
                        else
                            Rec."Cost Centre Dimension Value" := '';
                    end;
                    GLSetup.Get();
                    if GLSetup."Global Dimension 1 Code" <> '' then begin
                        if DefaultDim.Get(Database::"PMS Property", Rec."Property ID", GLSetup."Global Dimension 1 Code") then
                            Rec."Global Dimension 1 Code" := DefaultDim."Dimension Value Code"
                        else
                            Rec."Global Dimension 1 Code" := '';
                    end;
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
            action(PropertyLedgerEntries)
            {
                ApplicationArea = All;
                Caption = 'Property Ledger Entries';
                Image = Ledger;
                ToolTip = 'View ledger entries for this property.';

                trigger OnAction()
                var
                    PropLedgEntry: Record "PMS Property Ledger Entry";
                begin
                    PropLedgEntry.SetRange("Property ID", Rec."Property ID");
                    Page.Run(Page::"PMS Property Ledger Entries", PropLedgEntry);
                end;
            }
            action(BackfillPropertyLedger)
            {
                ApplicationArea = All;
                Caption = 'Backfill Ledger Entries';
                Image = RefreshLines;
                ToolTip = 'Backfill property ledger entries from G/L history for a selected property.';

                trigger OnAction()
                var
                    BackfillDlg: Page "PMS Prop Ledger Backfill Dlg";
                    Backfill: Codeunit "PMS Prop Ledger Backfill";
                begin
                    BackfillDlg.SetPropertyID(Rec."Property ID");
                    BackfillDlg.RunModal();
                    if BackfillDlg.WasConfirmed() then
                        Backfill.RunBackfill(BackfillDlg.GetPropertyID());
                end;
            }
            action(DeletePropertyLedger)
            {
                ApplicationArea = All;
                Caption = 'Delete Ledger Entries';
                Image = Delete;
                ToolTip = 'Delete all property ledger entries for this property. Use during testing only.';

                trigger OnAction()
                var
                    Backfill: Codeunit "PMS Prop Ledger Backfill";
                begin
                    Backfill.DeletePropertyEntries(Rec."Property ID");
                end;
            }
            action(ViewTenantMovements)
            {
                ApplicationArea = All;
                Caption = 'Tenant History';
                Image = Entries;
                ToolTip = 'View all tenant history for this property.';

                trigger OnAction()
                var
                    TenantMovement: Record "PMS Tenant Movement";
                begin
                    TenantMovement.SetRange("Property ID", Rec."Property ID");
                    Page.Run(Page::"PMS Tenant Movement List", TenantMovement);
                end;
            }
            action(HazardEntries)
            {
                ApplicationArea = All;
                Caption = 'Hazard Entries';
                Image = Warning;
                ToolTip = 'View hazard entries for this property.';

                trigger OnAction()
                var
                    PropertyHazard: Record "PMS Property Hazard";
                begin
                    PropertyHazard.SetRange("Property ID", Rec."Property ID");
                    Page.Run(Page::"PMS Property Hazard List", PropertyHazard);
                end;
            }
            action(AlarmEntries)
            {
                ApplicationArea = All;
                Caption = 'Alarm Entries';
                Image = Alerts;
                ToolTip = 'View alarm entries for this property.';

                trigger OnAction()
                var
                    PropertyAlarm: Record "PMS Property Alarm";
                begin
                    PropertyAlarm.SetRange("Property ID", Rec."Property ID");
                    Page.Run(Page::"PMS Property Alarm List", PropertyAlarm);
                end;
            }

            action(BoilerEntries)
            {
                ApplicationArea = All;
                Caption = 'Boiler Entries';
                Image = ServiceLedger;
                ToolTip = 'View boiler entries for this property.';

                trigger OnAction()
                var
                    PropertyBoiler: Record "PMS Property Boiler";
                begin
                    PropertyBoiler.SetRange("Property ID", Rec."Property ID");
                    Page.Run(Page::"PMS Property Boiler List", PropertyBoiler);
                end;
            }

            action(ImprovementHistory)
            {
                ApplicationArea = All;
                Caption = 'Improvement History';
                Image = History;
                ToolTip = 'View improvement history for this property.';

                trigger OnAction()
                var
                    PropertyImprovement: Record "PMS Property Improvement";
                begin
                    PropertyImprovement.SetRange("Property ID", Rec."Property ID");
                    Page.Run(Page::"PMS Prop Improvement List", PropertyImprovement);
                end;
            }
            action(ReinstatementValuations)
            {
                ApplicationArea = All;
                Caption = 'Reinstatement Valuations';
                Image = Calculate;
                ToolTip = 'View reinstatement valuations for this property.';

                trigger OnAction()
                var
                    ReinstatementVal: Record "PMS Reinstatement Valuation";
                begin
                    ReinstatementVal.SetRange("Property ID", Rec."Property ID");
                    Page.Run(Page::"PMS Reinstatement Val List", ReinstatementVal);
                end;
            }



            action(StatusLog)
            {
                ApplicationArea = All;
                Caption = 'Status Log';
                Image = Log;
                ToolTip = 'View the status change history for this property.';

                trigger OnAction()
                var
                    StatusLog: Record "PMS Property Status Log";
                begin
                    StatusLog.SetRange("Property ID", Rec."Property ID");
                    Page.Run(Page::"PMS Property Status Log", StatusLog);
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
            action(ChangeStatus)
            {
                ApplicationArea = All;
                Caption = 'Change Status';
                Image = Edit;
                ToolTip = 'Change the status of this property.';

                trigger OnAction()
                var
                    StatusChangeDlg: Page "PMS Prop Status Change Dlg";
                    StatusLog: Record "PMS Property Status Log";
                    OldStatus: Enum "PMS Property Status";
                begin
                    if Rec.Status = Rec.Status::"Tenancy Occupied" then
                        Error('Cannot change the status of a property with an active tenancy. End the tenancy first.');
                    CurrPage.SaveRecord();
                    StatusChangeDlg.SetCurrentStatus(Rec.Status);
                    StatusChangeDlg.RunModal();
                    if not StatusChangeDlg.WasConfirmed() then
                        exit;
                    OldStatus := Rec.Status;
                    Rec.Status := StatusChangeDlg.GetNewStatus();
                    Rec.Modify(true);
                    StatusLog.Init();
                    StatusLog."Property ID" := Rec."Property ID";
                    StatusLog."Changed On" := CurrentDateTime();
                    StatusLog."Changed By" := CopyStr(UserId(), 1, MaxStrLen(StatusLog."Changed By"));
                    StatusLog."Old Status" := OldStatus;
                    StatusLog."New Status" := Rec.Status;
                    StatusLog.Note := CopyStr(StatusChangeDlg.GetNote(), 1, MaxStrLen(StatusLog.Note));
                    StatusLog.Insert(true);
                    CurrPage.Update(false);
                end;
            }
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
            action(CreateSPFolder)
            {
                ApplicationArea = All;
                Caption = 'Create SharePoint Folder';
                Image = Cloud;
                Enabled = Rec."SharePoint Folder URL" = '';
                ToolTip = 'Create the Properties/{ID}/Documents folder structure in SharePoint and store the URL.';

                trigger OnAction()
                var
                    SPMgt: Codeunit "PMS SharePoint Mgt";
                begin
                    CurrPage.SaveRecord();
                    SPMgt.CreatePropertyFolder(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(OpenSPFolder)
            {
                ApplicationArea = All;
                Caption = 'Open in SharePoint';
                Image = Open;
                Enabled = Rec."SharePoint Folder URL" <> '';
                ToolTip = 'Open the SharePoint Documents folder for this property in a browser.';

                trigger OnAction()
                begin
                    HyperLink(Rec."SharePoint Folder URL");
                end;
            }
            action(OpenQubeDocHistory)
            {
                ApplicationArea = All;
                Caption = 'Open Qube Document History';
                Image = Documents;
                Enabled = Rec."Qube Document History" <> '';
                ToolTip = 'Open the Qube Document History URL for this property in a browser.';

                trigger OnAction()
                begin
                    HyperLink(Rec."Qube Document History");
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Navigate)
            {
                Caption = 'Property';

                actionref(Dimensions_Promoted; Dimensions) { }
                actionref(PropertyLedgerEntries_Promoted; PropertyLedgerEntries) { }
                actionref(BackfillPropertyLedger_Promoted; BackfillPropertyLedger) { }
                actionref(StatusLog_Promoted; StatusLog) { }
                actionref(ViewTenantMovements_Promoted; ViewTenantMovements) { }
                actionref(HazardEntries_Promoted; HazardEntries) { }
                actionref(AlarmEntries_Promoted; AlarmEntries) { }
                actionref(BoilerEntries_Promoted; BoilerEntries) { }
                actionref(ImprovementHistory_Promoted; ImprovementHistory) { }
                actionref(ReinstatementValuations_Promoted; ReinstatementValuations) { }
                actionref(LedgerEntries_Promoted; LedgerEntries) { }
            }
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(NewHelpdeskCall_Promoted; NewHelpdeskCall) { }
                actionref(NewTenantMovement_Promoted; NewTenantMovement) { }
                actionref(ChangeStatus_Promoted; ChangeStatus) { }
                actionref(CreateSPFolder_Promoted; CreateSPFolder) { }
                actionref(OpenSPFolder_Promoted; OpenSPFolder) { }
                actionref(OpenQubeDocHistory_Promoted; OpenQubeDocHistory) { }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        PropertyHazard: Record "PMS Property Hazard";
    begin
        PropertyHazard.SetRange("Property ID", Rec."Property ID");
        HazardsExist := not PropertyHazard.IsEmpty();
        if PageJustOpened and HazardsExist then
            Message('Hazards exist at this property!');
        PageJustOpened := false;
    end;

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
        PageJustOpened := true;
    end;

    var
        HazardsExist: Boolean;
        PageJustOpened: Boolean;
}

