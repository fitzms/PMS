table 80820 "PMS Tenant"
{
    Caption = 'Tenant';
    DataClassification = CustomerContent;
    LookupPageId = "PMS Tenant List";
    DrillDownPageId = "PMS Tenant List";

    fields
    {
        field(1; "Tenant ID"; Code[20])
        {
            Caption = 'Tenant ID';
            NotBlank = true;

            trigger OnValidate()
            begin
                if "Tenant ID" <> xRec."Tenant ID" then begin
                    PMSSetup.GetRecordOnce();
                    NoSeries.TestManual(PMSSetup."Tenant Nos.");
                end;
            end;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(3; Status; Enum "PMS Tenant Status")
        {
            Caption = 'Status';

            trigger OnValidate()
            begin
                SyncUnitStatus("Unit ID");
            end;
        }
        field(4; "Unit ID"; Code[20])
        {
            Caption = 'Unit ID';
            TableRelation = "PMS Unit";

            trigger OnValidate()
            var
                Unit: Record "PMS Unit";
            begin
                // Revert the old unit before moving to the new one
                if xRec."Unit ID" <> "Unit ID" then
                    SyncUnitStatus(xRec."Unit ID");

                if "Unit ID" = '' then
                    "Property ID" := ''
                else
                    if Unit.Get("Unit ID") then
                        "Property ID" := Unit."Property ID";

                SyncUnitStatus("Unit ID");
            end;
        }
        field(8; "Property ID"; Code[20])
        {
            Caption = 'Property ID';
            TableRelation = "PMS Property";
            Editable = false;
        }
        field(9; "Property Known As"; Text[100])
        {
            Caption = 'Known As';
            FieldClass = FlowField;
            CalcFormula = lookup("PMS Property"."Known As" where("Property ID" = field("Property ID")));
            Editable = false;
        }
        field(5; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(6; "End Date"; Date)
        {
            Caption = 'End Date';

            trigger OnValidate()
            begin
                if "End Date" <> 0D then
                    Status := Status::Previous
                else
                    if Status = Status::Previous then
                        Status := Status::Current;
                SyncUnitStatus("Unit ID");
            end;
        }
        field(7; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "Tenant ID")
        {
            Clustered = true;
        }
    }

    var
        PMSSetup: Record "PMS Setup";
        NoSeries: Codeunit "No. Series";

    trigger OnInsert()
    begin
        if "Tenant ID" = '' then begin
            PMSSetup.GetRecordOnce();
            PMSSetup.TestField("Tenant Nos.");
            "No. Series" := PMSSetup."Tenant Nos.";
            "Tenant ID" := NoSeries.GetNextNo(PMSSetup."Tenant Nos.", WorkDate(), true);
        end;
    end;

    local procedure SyncUnitStatus(UnitID: Code[20])
    var
        Unit: Record "PMS Unit";
        OtherTenant: Record "PMS Tenant";
        HasCurrentTenant: Boolean;
    begin
        if UnitID = '' then
            exit;
        if not Unit.Get(UnitID) then
            exit;

        // Exclude the current record from the DB query — its fields may be changed
        // in memory but not yet written to the database, so the DB value is stale.
        OtherTenant.SetRange("Unit ID", UnitID);
        OtherTenant.SetRange(Status, OtherTenant.Status::Current);
        if "Tenant ID" <> '' then
            OtherTenant.SetFilter("Tenant ID", '<>%1', "Tenant ID");
        HasCurrentTenant := not OtherTenant.IsEmpty();

        // Now account for the current record using its in-memory values.
        // If its in-memory Unit ID matches and Status is Current, count it.
        if (not HasCurrentTenant) and ("Unit ID" = UnitID) and (Status = Status::Current) then
            HasCurrentTenant := true;

        if HasCurrentTenant then begin
            if Unit.Status <> Unit.Status::"Tenancy Occupied" then begin
                Unit.Status := Unit.Status::"Tenancy Occupied";
                Unit.Modify(true);
            end;
        end else begin
            if Unit.Status = Unit.Status::"Tenancy Occupied" then begin
                Unit.Status := Unit.Status::Operational;
                Unit.Modify(true);
            end;
        end;
    end;
}
