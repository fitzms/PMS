table 80811 "PMS Property"
{
    Caption = 'Property';
    DataClassification = CustomerContent;
    LookupPageId = "PMS Property List";
    DrillDownPageId = "PMS Property List";

    fields
    {
        field(1; "Property ID"; Code[20])
        {
            Caption = 'Property ID';
            NotBlank = true;

            trigger OnValidate()
            begin
                if "Property ID" <> xRec."Property ID" then begin
                    PMSSetup.GetRecordOnce();
                    NoSeries.TestManual(PMSSetup."Property Nos.");
                end;
            end;
        }
        field(11; "Known As"; Text[100])
        {
            Caption = 'Known As';

            trigger OnValidate()
            begin
                UpdateDimensionValueName();
            end;
        }
        field(2; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(21; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(22; "Address 3"; Text[50])
        {
            Caption = 'Address 3';
        }
        field(23; City; Text[30])
        {
            Caption = 'City';
        }
        field(25; County; Text[50])
        {
            Caption = 'County';
        }
        field(24; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(3; Postcode; Code[10])
        {
            Caption = 'Postcode';
            TableRelation = "Post Code";

            trigger OnValidate()
            var
                PostCodeRec: Record "Post Code";
            begin
                if Postcode = '' then begin
                    City := '';
                    County := '';
                    "Country/Region Code" := '';
                end else begin
                    PostCodeRec.SetRange(Code, Postcode);
                    if PostCodeRec.FindFirst() then begin
                        City := PostCodeRec.City;
                        County := PostCodeRec.County;
                        "Country/Region Code" := PostCodeRec."Country/Region Code";
                    end;
                end;
            end;
        }
        field(4; "Property Type Code"; Code[20])
        {
            Caption = 'Property Type';
            TableRelation = "PMS Property Type";

            trigger OnValidate()
            begin
                SyncToSingleUnit();
            end;
        }

        field(6; Status; Enum "PMS Property Status")
        {
            Caption = 'Status';

            trigger OnValidate()
            begin
                SyncToSingleUnit();
            end;
        }

        field(35; "Property Dimension Value"; Code[20])
        {
            Caption = 'Property Dimension';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Property Dimension Filter"), Blocked = const(false));

            trigger OnValidate()
            begin
                UpdateDefaultDimension();
            end;
        }

        field(36; "Property Dimension Filter"; Code[20])
        {
            Caption = 'Property Dimension Filter';
            FieldClass = FlowFilter;
        }

        field(34; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(false));

            trigger OnValidate()
            begin
                UpdateGlobalDim1DefaultDimension();
            end;
        }


        field(7; "VAT Elected"; Boolean)
        {
            Caption = 'VAT Elected';
        }
        field(8; "Local Authority"; Option)
        {

            Caption = 'Local Authority';
            OptionCaption = ' ,Forest Heath District Council,East Cambridgeshire District Council';
            OptionMembers = " ","Forest Heath District Council","East Cambridgeshire District Council";
        }
        field(9; "Water Company"; Option)
        {

            Caption = 'Water Company';
            OptionCaption = ' ,Anglian Water,Thames Water,Southern Water,Not Connected,See individual property details';
            OptionMembers = " ","Anglian Water","Thames Water","Southern Water","Not Connected","See individual property details";
        }
        field(10; Sewerage; Option)
        {

            Caption = 'Sewerage';
            OptionCaption = ' ,Anglian Water,Thames Water,Southern Water,Not Connected,See individual property details';
            OptionMembers = " ","Anglian Water","Thames Water","Southern Water","Not Connected","See individual property details";
        }

        field(112; "Meter Location"; Text[50])
        {
            Caption = 'Meter Location';
        }
        field(113; "Fuse box Location"; Text[50])
        {
            Caption = 'Fuse box Location';
        }
        field(114; "Boiler Location"; Text[50])
        {
            Caption = 'Boiler Location';
        }
        field(115; "Stopcock Location"; Text[50])
        {
            Caption = 'Stopcock Location';
        }
        field(116; "Total Floor Area (sqm)"; Decimal)
        {
            Caption = 'Total Floor Area (sqm)';
        }
        field(117; "Council Tax Reference"; Text[20])
        {
            Caption = 'Council Tax Reference';
        }
        field(118; "Council Tax Band"; Text[20])
        {
            Caption = 'Council Tax Band';
        }
        field(119; "Gas Meter Number"; Text[20])
        {
            Caption = 'Gas Meter Number';
        }
        field(120; "MPRN/MSN"; Text[20])
        {
            Caption = 'MPRN/MSN ';
        }
        field(121; "MPANNo."; Text[20])
        {
            Caption = 'MPAN No.';
        }
        field(122; "Electricity Meter Number"; Text[20])
        {
            Caption = 'Electricity Meter Number';
        }
        field(123; "Water Meter Number"; Text[20])
        {
            Caption = 'Water Meter Number';
        }
        field(124; "Property Fuel Type"; Option)
        {
            Caption = 'Property Fuel Type';
            OptionCaption = ' ,Air Conditioning,Air Source Heat Pump,Electric,Geothermal,LPG Gas,Natural Gas,Oil,Other';
            OptionMembers = " ","Air Conditioning","Air Source Heat Pump","Electric","Geothermal","LPG Gas","Natural Gas","Oil","Other";
        }
        field(125; "Heating Oil Tank No."; Text[20])
        {
            Caption = 'Heating Oil Tank No.';
        }
        field(126; "Oil Tank Capacity (Ltr)"; Decimal)
        {
            Caption = 'Oil Tank Capacity (Ltr)';
        }
        field(127; "Auto Top Up Heating Oil Tank"; Boolean)
        {
            Caption = 'Auto Top Up Heating Oil Tank';
        }
        field(128; "Oil Tank notes"; Text[100])
        {
            Caption = 'Oil Tank notes';
        }
        field(129; "Storey Count"; Integer)
        {
            Caption = 'Storey Count';
        }
        field(130; "Bedroom Count"; Integer)
        {
            Caption = 'Bedroom Count';
        }
        field(131; "Bathroom Count"; Integer)
        {
            Caption = 'Bathroom Count';
        }
        field(132; "Garage Count"; Integer)
        {
            Caption = 'Garage Count';
        }
        field(133; "House Type"; Enum "PMS House Type")
        {
            Caption = 'House Type';
        }
        field(134; "Furnishings Included"; Boolean)
        {
            Caption = 'Furnishings Included';
        }
        field(135; "Living Room Count"; Integer)
        {
            Caption = 'Living Room Count';
        }
        field(136; "Land Line"; Text[50])
        {
            Caption = 'Land Line';
        }
        field(137; "Broadband Username"; Text[50])
        {
            Caption = 'Broadband Username';
        }
        field(138; "Broadband Password"; Text[50])
        {
            Caption = 'Broadband Password';
        }
        field(139; "Wifi Name"; Text[50])
        {
            Caption = 'Wifi Name';
        }
        field(140; "Wifi Password"; Text[50])
        {
            Caption = 'Wifi Password';
        }
        field(141; "SharePoint Folder URL"; Text[500])
        {
            Caption = 'SharePoint Folder URL';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(142; "Qube Document History"; Text[100])
        {
            Caption = 'Qube Document History';
            DataClassification = CustomerContent;
        }



        field(40; "Single Unit"; Boolean)
        {
            Caption = 'Single Unit';
            Editable = false;
        }
        field(50; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(51; "Cost Centre Dimension Value"; Code[20])
        {
            Caption = 'Cost Centre';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Cost Centre Dimension Filter"), Blocked = const(false));

            trigger OnValidate()
            begin
                UpdateCostCentreDimension();
            end;
        }
        field(52; "Cost Centre Dimension Filter"; Code[20])
        {
            Caption = 'Cost Centre Dimension Filter';
            FieldClass = FlowFilter;
        }

        // ── Unit counts (FlowFields) ──────────────────────────────────────────
        field(30; "Total Units"; Integer)
        {
            Caption = 'Total Units';
            FieldClass = FlowField;
            CalcFormula = count("PMS Unit" where("Property ID" = field("Property ID"), "Single Unit" = const(false)));
            Editable = false;
        }
        field(32; "Operational Units"; Integer)
        {
            Caption = 'Operational';
            FieldClass = FlowField;
            CalcFormula = count("PMS Unit" where("Property ID" = field("Property ID"), Status = const(Operational), "Single Unit" = const(false)));
            Editable = false;
        }
        field(33; "Non Operational Units"; Integer)
        {
            Caption = 'Non Operational';
            FieldClass = FlowField;
            CalcFormula = count("PMS Unit" where("Property ID" = field("Property ID"), Status = const("Non Operational"), "Single Unit" = const(false)));
            Editable = false;
        }

    }

    keys
    {
        key(PK; "Property ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Property ID", "Known As", Postcode) { }
        fieldgroup(Brick; "Property ID", "Known As", Postcode) { }
    }

    var
        PMSSetup: Record "PMS Setup";
        NoSeries: Codeunit "No. Series";

    trigger OnInsert()
    var
        UnitRec: Record "PMS Unit";
    begin
        if "Property ID" = '' then begin
            PMSSetup.GetRecordOnce();
            PMSSetup.TestField("Property Nos.");
            "No. Series" := PMSSetup."Property Nos.";
            "Property ID" := NoSeries.GetNextNo(PMSSetup."Property Nos.", WorkDate(), true);
        end;

        CreateDimensionValue();
        "Property Dimension Value" := "Property ID";
        UpdateDefaultDimension();

        if "Single Unit" then begin
            UnitRec.Init();
            UnitRec."Unit ID" := "Property ID";
            UnitRec."Property ID" := "Property ID";
            UnitRec."Single Unit" := true;
            UnitRec."Unit Type Code" := "Property Type Code";
            UnitRec.Status := Status;
            UnitRec.Insert(true);
        end;
    end;

    local procedure SyncToSingleUnit()
    var
        UnitRec: Record "PMS Unit";
    begin
        if not "Single Unit" then
            exit;
        if UnitRec.Get("Property ID") then begin
            UnitRec."Unit Type Code" := "Property Type Code";
            UnitRec.Status := Status;
            UnitRec.Modify(false);
        end;
    end;

    local procedure CreateDimensionValue()
    var
        DimValue: Record "Dimension Value";
    begin
        PMSSetup.GetRecordOnce();
        if PMSSetup."Property Dimension Code" = '' then
            exit;
        if not DimValue.Get(PMSSetup."Property Dimension Code", "Property ID") then begin
            DimValue.Init();
            DimValue.Validate("Dimension Code", PMSSetup."Property Dimension Code");
            DimValue.Validate(Code, "Property ID");
            DimValue.Name := CopyStr("Known As", 1, MaxStrLen(DimValue.Name));
            DimValue.Insert(true);
        end;
    end;

    local procedure UpdateDimensionValueName()
    var
        DimValue: Record "Dimension Value";
    begin
        PMSSetup.GetRecordOnce();
        if PMSSetup."Property Dimension Code" = '' then
            exit;
        if DimValue.Get(PMSSetup."Property Dimension Code", "Property ID") then begin
            DimValue.Name := CopyStr("Known As", 1, MaxStrLen(DimValue.Name));
            DimValue.Modify(true);
        end;
    end;

    local procedure UpdateDefaultDimension()
    var
        DefaultDim: Record "Default Dimension";
    begin
        PMSSetup.GetRecordOnce();
        if PMSSetup."Property Dimension Code" = '' then
            exit;
        if "Property Dimension Value" = '' then begin
            if DefaultDim.Get(Database::"PMS Property", "Property ID", PMSSetup."Property Dimension Code") then
                DefaultDim.Delete(true);
            exit;
        end;
        if DefaultDim.Get(Database::"PMS Property", "Property ID", PMSSetup."Property Dimension Code") then begin
            DefaultDim.Validate("Dimension Value Code", "Property Dimension Value");
            DefaultDim.Modify(true);
        end else begin
            DefaultDim.Init();
            DefaultDim."Table ID" := Database::"PMS Property";
            DefaultDim."No." := "Property ID";
            DefaultDim.Validate("Dimension Code", PMSSetup."Property Dimension Code");
            DefaultDim.Validate("Dimension Value Code", "Property Dimension Value");
            DefaultDim.Insert(true);
        end;
    end;

    local procedure UpdateCostCentreDimension()
    var
        DefaultDim: Record "Default Dimension";
    begin
        PMSSetup.GetRecordOnce();
        if PMSSetup."Cost Centre Dimension Code" = '' then
            exit;
        if "Cost Centre Dimension Value" = '' then begin
            if DefaultDim.Get(Database::"PMS Property", "Property ID", PMSSetup."Cost Centre Dimension Code") then
                DefaultDim.Delete(true);
            exit;
        end;
        if DefaultDim.Get(Database::"PMS Property", "Property ID", PMSSetup."Cost Centre Dimension Code") then begin
            DefaultDim.Validate("Dimension Value Code", "Cost Centre Dimension Value");
            DefaultDim.Modify(true);
        end else begin
            DefaultDim.Init();
            DefaultDim."Table ID" := Database::"PMS Property";
            DefaultDim."No." := "Property ID";
            DefaultDim.Validate("Dimension Code", PMSSetup."Cost Centre Dimension Code");
            DefaultDim.Validate("Dimension Value Code", "Cost Centre Dimension Value");
            DefaultDim.Insert(true);
        end;
    end;

    local procedure UpdateGlobalDim1DefaultDimension()
    var
        GLSetup: Record "General Ledger Setup";
        DefaultDim: Record "Default Dimension";
    begin
        GLSetup.Get();
        if GLSetup."Global Dimension 1 Code" = '' then
            exit;
        if "Global Dimension 1 Code" = '' then begin
            if DefaultDim.Get(Database::"PMS Property", "Property ID", GLSetup."Global Dimension 1 Code") then
                DefaultDim.Delete(true);
            exit;
        end;
        if DefaultDim.Get(Database::"PMS Property", "Property ID", GLSetup."Global Dimension 1 Code") then begin
            DefaultDim.Validate("Dimension Value Code", "Global Dimension 1 Code");
            DefaultDim.Modify(true);
        end else begin
            DefaultDim.Init();
            DefaultDim."Table ID" := Database::"PMS Property";
            DefaultDim."No." := "Property ID";
            DefaultDim.Validate("Dimension Code", GLSetup."Global Dimension 1 Code");
            DefaultDim.Validate("Dimension Value Code", "Global Dimension 1 Code");
            DefaultDim.Insert(true);
        end;
    end;
}
