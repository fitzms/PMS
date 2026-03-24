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
        }

        field(5; Tenure; Option)
        {
            Caption = 'Tenure';
            OptionCaption = ' ,Freehold,Leasehold';
            OptionMembers = " ",Freehold,Leasehold;
        }
        field(6; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Allocated,In Construction,Non Operational,Operational,Rehoming,Relocated,Sold,Tenancy Occupied,Vacant';
            OptionMembers = " ",Allocated,"In Construction","Non Operational",Operational,Rehoming,Relocated,Sold,"Tenancy Occupied",Vacant;
        }
        field(34; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(false));
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

        // ── Unit counts (FlowFields) ──────────────────────────────────────────
        field(30; "Total Units"; Integer)
        {
            Caption = 'Total Units';
            FieldClass = FlowField;
            CalcFormula = count("PMS Unit" where("Property ID" = field("Property ID")));
            Editable = false;
        }
        field(32; "Operational Units"; Integer)
        {
            Caption = 'Operational';
            FieldClass = FlowField;
            CalcFormula = count("PMS Unit" where("Property ID" = field("Property ID"), Status = const(Operational)));
            Editable = false;
        }
        field(33; "Non Operational Units"; Integer)
        {
            Caption = 'Non Operational';
            FieldClass = FlowField;
            CalcFormula = count("PMS Unit" where("Property ID" = field("Property ID"), Status = const("Non Operational")));
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
    begin
        if "Property ID" = '' then begin
            PMSSetup.GetRecordOnce();
            PMSSetup.TestField("Property Nos.");
            "Property ID" := NoSeries.GetNextNo(PMSSetup."Property Nos.", WorkDate(), true);
        end;
    end;
}
