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
            OptionCaption = ' ,Active,Inactive,Sold,Under Development';
            OptionMembers = " ",Active,Inactive,Sold,"Under Development";
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
    }

    keys
    {
        key(PK; "Property ID")
        {
            Clustered = true;
        }
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
