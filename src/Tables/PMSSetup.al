table 80807 "PMS Setup"
{
    Caption = 'Property Management Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Contract Nos."; Code[20])
        {
            Caption = 'Contract Nos.';
            TableRelation = "No. Series";
        }
        field(11; "Property Nos."; Code[20])
        {
            Caption = 'Property Nos.';
            TableRelation = "No. Series";
        }
        field(12; "Unit Nos."; Code[20])
        {
            Caption = 'Unit Nos.';
            TableRelation = "No. Series";
        }
        field(13; "Tenant Nos."; Code[20])
        {
            Caption = 'Tenant Nos.';
            TableRelation = "No. Series";
        }
        field(14; "Helpdesk Nos."; Code[20])
        {
            Caption = 'Helpdesk Nos.';
            TableRelation = "No. Series";
        }
        field(16; "Job Nos."; Code[20])
        {
            Caption = 'Job Nos.';
            TableRelation = "No. Series";
        }
        field(20; "Default Job Type"; Option)
        {
            Caption = 'Default Job Type';
            OptionCaption = ' ,Planned Maintenance,Reactive Maintenance,Internal';
            OptionMembers = " ","Planned Maintenance","Reactive Maintenance",Internal;
        }
        field(30; "Job Frequency"; Enum "PMS Job Frequency")
        {
            Caption = 'Job Frequency';
        }
        field(40; "Property Dimension Code"; Code[20])
        {
            Caption = 'Property Dimension Code';
            TableRelation = Dimension;
        }
        field(41; "Employee Dimension Code"; Code[20])
        {
            Caption = 'Employee Dimension Code';
            TableRelation = Dimension;
        }
        field(42; "Cost Centre Dimension Code"; Code[20])
        {
            Caption = 'Cost Centre Dimension Code';
            TableRelation = Dimension;
        }
        field(50; "SP Tenant ID"; Text[100])
        {
            Caption = 'Azure AD Tenant ID';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(51; "SP Client ID"; Text[100])
        {
            Caption = 'App Client ID';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(52; "SP Site Host"; Text[100])
        {
            Caption = 'SharePoint Host';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(53; "SP Site Path"; Text[200])
        {
            Caption = 'SharePoint Site Path';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(54; "SP Document Library"; Text[100])
        {
            Caption = 'Document Library';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(55; "SP Graph Site ID"; Text[300])
        {
            Caption = 'Graph Site ID';
            Editable = false;
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(56; "SP Graph Drive ID"; Text[300])
        {
            Caption = 'Graph Drive ID';
            Editable = false;
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(57; "SP Has Client Secret"; Boolean)
        {
            Caption = 'Client Secret Configured';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(60; "Web Client Base URL"; Text[250])
        {
            Caption = 'Web Client Base URL';
            DataClassification = OrganizationIdentifiableInformation;
        }

    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure GetRecordOnce()
    begin
        if not Get() then begin
            Init();
            "SP Document Library" := 'Documents';
            Insert();
        end;
    end;
}
