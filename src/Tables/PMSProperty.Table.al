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

        field(5; Tenure; Option)
        {
            Caption = 'Tenure';
            OptionCaption = ' ,Freehold,Leasehold';
            OptionMembers = " ",Freehold,Leasehold;

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
        field(34; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(false));
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
        field(7; "VAT Elected"; Boolean)
        {
            Caption = 'VAT Elected';
        }
        field(8; "Local Authority"; Text[50])
        {
            Caption = 'Local Authority';
        }
        field(9; "Water Company"; Text[50])
        {
            Caption = 'Water Company';
        }
        field(10; Sewerage; Text[50])
        {
            Caption = 'Sewerage';
        }

        field(40; "Single Unit"; Boolean)
        {
            Caption = 'Single Unit';
            Editable = false;
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
            UnitRec.Tenure := Tenure;
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
            UnitRec.Tenure := Tenure;
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
}
