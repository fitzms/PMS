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
            // TODO (Sam): Add filter where contract is active (e.g. Start Date <= Today <= End Date)
            CalcFormula = count("PMS Contract");
        }
        field(21; "Expiring This Month"; Integer)
        {
            Caption = 'Expiring This Month';
            FieldClass = FlowField;
            // TODO (Sam): Add filter where End Date is within current month
            CalcFormula = count("PMS Contract");
        }
        field(22; "Contracts Pending Approval"; Integer)
        {
            Caption = 'Pending Approval';
            FieldClass = FlowField;
            // TODO (Sam): Add filter by approval status field once added to the Contract table
            CalcFormula = count("PMS Contract");
        }

        // ── Tenants ───────────────────────────────────────────────────────────
        field(30; "Total Tenants"; Integer)
        {
            Caption = 'Total Tenants';
            FieldClass = FlowField;
            // TODO (Sam): Replace with count over the real Tenant table
            CalcFormula = count("G/L Account");    // placeholder table - swap out
        }
        field(31; "New Tenants This Month"; Integer)
        {
            Caption = 'New This Month';
            FieldClass = FlowField;
            // TODO (Sam): Filter Tenant table where Created Date is within current month
            CalcFormula = count("G/L Account");    // placeholder table - swap out
        }
        field(32; "Overdue Rent"; Integer)
        {
            Caption = 'Overdue Rent';
            FieldClass = FlowField;
            // TODO (Sam): Derive from ledger entries or outstanding rent records
            CalcFormula = count("G/L Account");    // placeholder table - swap out
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
