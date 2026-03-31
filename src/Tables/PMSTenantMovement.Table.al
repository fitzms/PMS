table 80825 "PMS Tenant Movement"
{
    Caption = 'Tenant Movement';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Tenant ID"; Code[20])
        {
            Caption = 'Tenant ID';
            TableRelation = "PMS Tenant";
        }
        field(3; "Date"; Date)
        {
            Caption = 'Date';
        }

        field(5; "Unit ID"; Code[20])
        {
            Caption = 'Unit ID';
            TableRelation = "PMS Unit"."Unit ID" where("Property ID" = field("Property ID"));

            trigger OnValidate()
            var
                UnitRec: Record "PMS Unit";
            begin
                if "Unit ID" = '' then
                    exit;
                if UnitRec.Get("Unit ID") then
                    "Property ID" := UnitRec."Property ID";
            end;
        }
        field(6; "Property ID"; Code[20])
        {
            Caption = 'Property ID';
            TableRelation = "PMS Property";

            trigger OnValidate()
            var
                PropertyRec: Record "PMS Property";
            begin
                if "Property ID" = '' then begin
                    "Unit ID" := '';
                    exit;
                end;
                if PropertyRec.Get("Property ID") then
                    if PropertyRec."Single Unit" then
                        "Unit ID" := "Property ID"
                    else
                        if ("Unit ID" <> '') then begin
                            // Clear unit if it doesn't belong to the new property
                            if "Unit ID" <> xRec."Unit ID" then
                                "Unit ID" := '';
                        end;
            end;
        }
        field(7; "Status"; Enum "PMS Tenant Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(12; "Property Known As"; Text[100])
        {
            Caption = 'Property Known As';
            FieldClass = FlowField;
            CalcFormula = lookup("PMS Property"."Known As" where("Property ID" = field("Property ID")));
            Editable = false;
        }
        field(8; "Start Date"; Date)
        {
            Caption = 'Start Date';

            trigger OnValidate()
            begin
                CalcStatus();
            end;
        }
        field(11; "End Date"; Date)
        {
            Caption = 'End Date';

            trigger OnValidate()
            begin
                CalcStatus();
            end;
        }
        field(9; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(10; "Notes"; Text[500])
        {
            Caption = 'Notes';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(TenantDate; "Tenant ID", "Date")
        {
        }
    }

    trigger OnInsert()
    begin
        CalcStatus();
    end;

    trigger OnModify()
    begin
        CalcStatus();
    end;

    local procedure CalcStatus()
    begin
        if ("Start Date" <> 0D) and ("Start Date" <= Today) and
           (("End Date" = 0D) or ("End Date" >= Today)) then
            Status := Status::Current
        else
            if "Start Date" <> 0D then
                Status := Status::Previous
            else
                Status := Status::" ";
    end;

    procedure UpdateTenantStatus()
    var
        Tenant: Record "PMS Tenant";
    begin
        if "Tenant ID" = '' then
            exit;
        if Tenant.Get("Tenant ID") then
            Tenant.CalcStatusFromMovements();
    end;
}
