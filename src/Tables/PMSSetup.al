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
        field(20; "Default Job Type"; Option)
        {
            Caption = 'Default Job Type';
            OptionCaption = ' ,Planned Maintenance,Reactive Maintenance,Internal';
            OptionMembers = " ","Planned Maintenance","Reactive Maintenance",Internal;
        }
        field(30; "Job Frequency"; Option)
        {
            Caption = 'Job Frequency';
            OptionCaption = ' ,Weekly,Fortnightly,Monthly,Quarterly,Half Yearly,Yearly,Single Charge';
            OptionMembers = " ",Weekly,Fortnightly,Monthly,Quarterly,"Half Yearly",Yearly,"Single Charge";
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
            Insert();
        end;
    end;
}
