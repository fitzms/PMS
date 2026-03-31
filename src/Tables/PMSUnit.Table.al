table 80816 "PMS Unit"
{
    Caption = 'Unit';
    DataClassification = CustomerContent;
    LookupPageId = "PMS Unit List";
    DrillDownPageId = "PMS Unit List";

    fields
    {
        field(1; "Unit ID"; Code[20])
        {
            Caption = 'Unit ID';
            NotBlank = true;

            trigger OnValidate()
            begin
                if "Unit ID" <> xRec."Unit ID" then begin
                    PMSSetup.GetRecordOnce();
                    NoSeries.TestManual(PMSSetup."Unit Nos.");
                end;
            end;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Unit Type Code"; Code[20])
        {
            Caption = 'Unit Type';
            TableRelation = "PMS Property Type";
        }
        field(4; Tenure; Option)
        {
            Caption = 'Tenure';
            OptionCaption = ' ,Freehold,Leasehold';
            OptionMembers = " ",Freehold,Leasehold;
        }
        field(5; Status; Enum "PMS Property Status")
        {
            Caption = 'Status';
        }
        field(6; "Property ID"; Code[20])
        {
            Caption = 'Property ID';
            TableRelation = "PMS Property";
        }
        field(7; "Current Tenant ID"; Code[20])
        {
            Caption = 'Current Tenant ID';
            FieldClass = FlowField;
            CalcFormula = lookup("PMS Tenant Movement"."Tenant ID" where("Unit ID" = field("Unit ID"), Status = const(Current)));
            Editable = false;
        }
        field(8; "Single Unit"; Boolean)
        {
            Caption = 'Single Unit';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Unit ID")
        {
            Clustered = true;
        }
    }

    var
        PMSSetup: Record "PMS Setup";
        NoSeries: Codeunit "No. Series";

    trigger OnInsert()
    begin
        if "Unit ID" = '' then begin
            PMSSetup.GetRecordOnce();
            PMSSetup.TestField("Unit Nos.");
            "Unit ID" := NoSeries.GetNextNo(PMSSetup."Unit Nos.", WorkDate(), true);
        end;
    end;
}
