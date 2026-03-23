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
        field(11; "Active Properties"; Integer)
        {
            Caption = 'Active Properties';
            FieldClass = FlowField;
            CalcFormula = count("PMS Property" where(Status = const(Active)));
        }
        field(12; "Vacant Properties"; Integer)
        {
            Caption = 'Vacant Properties';
            FieldClass = FlowField;
            CalcFormula = count("PMS Property" where(Status = const(Inactive)));
        }

        // ── Staff Houses ──────────────────────────────────────────────────────
        field(16; "Total Staff Houses"; Integer)
        {
            Caption = 'Total Staff Houses';
            FieldClass = FlowField;
            CalcFormula = count("PMS Property" where("Property Type Code" = const('STAFFHOUSE')));
        }
        field(17; "Active Staff Houses"; Integer)
        {
            Caption = 'Active Staff Houses';
            FieldClass = FlowField;
            CalcFormula = count("PMS Property" where("Property Type Code" = const('STAFFHOUSE'), Status = const(Active)));
        }
        field(18; "Vacant Staff Houses"; Integer)
        {
            Caption = 'Vacant Staff Houses';
            FieldClass = FlowField;
            CalcFormula = count("PMS Property" where("Property Type Code" = const('STAFFHOUSE'), Status = const(Inactive)));
        }

        // ── Units ────────────────────────────────────────────────────────────
        field(13; "Total Units"; Integer)
        {
            Caption = 'Total Units';
            FieldClass = FlowField;
            // TODO (Sam): Replace with count over the real Unit table
            CalcFormula = count("G/L Account");    // placeholder table - swap out
        }
        field(14; "Occupied Units"; Integer)
        {
            Caption = 'Occupied Units';
            FieldClass = FlowField;
            // TODO (Sam): Filter Unit table by Status = Occupied
            CalcFormula = count("G/L Account");    // placeholder table - swap out
        }
        field(15; "Available Units"; Integer)
        {
            Caption = 'Available Units';
            FieldClass = FlowField;
            // TODO (Sam): Filter Unit table by Status = Available
            CalcFormula = count("G/L Account");    // placeholder table - swap out
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
