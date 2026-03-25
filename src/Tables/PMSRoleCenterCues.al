table 80800 "PMS Role Center Cues"
{
    Caption = 'PMS Role Center Cues';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }

        // ── Properties ────────────────────────────────────────────────────────
        field(10; "Total Properties"; Integer)
        {
            Caption = 'Total Properties';
            FieldClass = FlowField;
            CalcFormula = count("PMS Property");
        }
        field(11; "Operational Properties"; Integer)
        {
            Caption = 'Operational Properties';
            FieldClass = FlowField;
            CalcFormula = count("PMS Property" where(Status = const(Operational)));
        }
        field(12; "Vacant Properties"; Integer)
        {
            Caption = 'Vacant Properties';
            FieldClass = FlowField;
            CalcFormula = count("PMS Property" where(Status = const(Vacant)));
        }

        // ── Staff Houses ──────────────────────────────────────────────────────
        field(16; "Total Staff Houses"; Integer)
        {
            Caption = 'Total Staff Houses';
            FieldClass = FlowField;
            CalcFormula = count("PMS Property" where("Property Type Code" = const('STAFFHOUSE')));
        }
        field(17; "Operational Staff Houses"; Integer)
        {
            Caption = 'Operational Staff Houses';
            FieldClass = FlowField;
            CalcFormula = count("PMS Property" where("Property Type Code" = const('STAFFHOUSE'), Status = const(Operational)));
        }
        field(18; "Vacant Staff Houses"; Integer)
        {
            Caption = 'Vacant Staff Houses';
            FieldClass = FlowField;
            CalcFormula = count("PMS Property" where("Property Type Code" = const('STAFFHOUSE'), Status = const(Vacant)));
        }

        // ── Units ────────────────────────────────────────────────────────────
        field(13; "Total Units"; Integer)
        {
            Caption = 'Total Units';
            FieldClass = FlowField;
            CalcFormula = count("PMS Unit");
        }

        field(15; "Available Units"; Integer)
        {
            Caption = 'Available Units';
            FieldClass = FlowField;
            CalcFormula = count("PMS Unit" where(Status = const(Vacant)));
        }
        field(19; "Tenancy Occupied Units"; Integer)
        {
            Caption = 'Tenancy Occupied Units';
            FieldClass = FlowField;
            CalcFormula = count("PMS Unit" where(Status = const("Tenancy Occupied")));
        }
        field(23; "Non Operational Units"; Integer)
        {
            Caption = 'Non Operational Units';
            FieldClass = FlowField;
            CalcFormula = count("PMS Unit" where(Status = const("Non Operational")));
        }
        field(24; "Operational Units"; Integer)
        {
            Caption = 'Operational Units';
            FieldClass = FlowField;
            CalcFormula = count("PMS Unit" where(Status = const(Operational)));
        }

        // ── Contracts ─────────────────────────────────────────────────────────
        field(20; "Active Contracts"; Integer)
        {
            Caption = 'Active Contracts';
            FieldClass = FlowField;
            CalcFormula = count("PMS Contract Header" where(Status = const(Active)));
        }
        field(22; "Open Contracts"; Integer)
        {
            Caption = 'Open Contracts';
            FieldClass = FlowField;
            CalcFormula = count("PMS Contract Header" where(Status = const(Open)));
        }
        field(25; "Closed Contracts"; Integer)
        {
            Caption = 'Closed Contracts';
            FieldClass = FlowField;
            CalcFormula = count("PMS Contract Header" where(Status = const(Closed)));
        }
        field(26; "Start in 30 Days"; Integer)
        {
            Caption = 'Start in 30 Days';
            DataClassification = CustomerContent;
        }
        field(27; "End in 30 Days"; Integer)
        {
            Caption = 'Ends in 30 Days';
            DataClassification = CustomerContent;
        }

        // ── Tenants ───────────────────────────────────────────────────────────
        field(30; "Total Tenants"; Integer)
        {
            Caption = 'Total Tenants';
            FieldClass = FlowField;
            CalcFormula = count("PMS Tenant");
        }
        field(31; "Active Tenants"; Integer)
        {
            Caption = 'Active Tenants';
            FieldClass = FlowField;
            CalcFormula = count("PMS Tenant" where(Status = const(Current)));
        }
        field(32; "Previous Tenants"; Integer)
        {
            Caption = 'Previous Tenants';
            FieldClass = FlowField;
            CalcFormula = count("PMS Tenant" where(Status = const(Previous)));
        }

        // ── Helpdesk ──────────────────────────────────────────────────────────
        field(40; "New Helpdesk Calls"; Integer)
        {
            Caption = 'New Helpdesk Calls';
            FieldClass = FlowField;
            CalcFormula = count("PMS Helpdesk Call" where(Status = const(New)));
        }
        field(41; "Critical Calls"; Integer)
        {
            Caption = 'Critical Calls';
            FieldClass = FlowField;
            CalcFormula = count("PMS Helpdesk Call" where(Priority = const(Critical)));
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
