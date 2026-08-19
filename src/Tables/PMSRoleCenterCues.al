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
            Caption = 'Staff Houses';
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
            CalcFormula = count("PMS Unit" where("Single Unit" = const(false)));
        }

        field(15; "Available Units"; Integer)
        {
            Caption = 'Available Units';
            FieldClass = FlowField;
            CalcFormula = count("PMS Unit" where(Status = const(Vacant), "Single Unit" = const(false)));
        }
        field(19; "Tenancy Occupied Units"; Integer)
        {
            Caption = 'Tenancy Occupied Units';
            FieldClass = FlowField;
            CalcFormula = count("PMS Unit" where(Status = const("Tenancy Occupied"), "Single Unit" = const(false)));
        }
        field(23; "Non Operational Units"; Integer)
        {
            Caption = 'Non Operational Units';
            FieldClass = FlowField;
            CalcFormula = count("PMS Unit" where(Status = const("Non Operational"), "Single Unit" = const(false)));
        }
        field(24; "Operational Units"; Integer)
        {
            Caption = 'Operational Units';
            FieldClass = FlowField;
            CalcFormula = count("PMS Unit" where(Status = const(Operational), "Single Unit" = const(false)));
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
        field(44; "Open Calls"; Integer)
        {
            Caption = 'Open Calls';
            FieldClass = FlowField;
            CalcFormula = count("PMS Helpdesk Call" where(Status = filter(<> Closed)));
        }
        field(40; "New Helpdesk Calls"; Integer)
        {
            Caption = 'New Helpdesk Calls';
            FieldClass = FlowField;
            CalcFormula = count("PMS Helpdesk Call" where(Status = const(Open)));
        }
        field(41; "Critical Calls"; Integer)
        {
            Caption = 'Critical Calls';
            FieldClass = FlowField;
            CalcFormula = count("PMS Helpdesk Call" where(Priority = const(Critical)));
        }
        field(42; "My Calls"; Integer)
        {
            Caption = 'My Calls';
            FieldClass = FlowField;
            CalcFormula = count("PMS Helpdesk Call" where("Call Type" = const(Internal), "Employee No." = field("Employee No. Filter"), Status = filter(<> Closed)));
        }
        field(43; "Employee No. Filter"; Code[50])
        {
            Caption = 'Employee No. Filter';
            FieldClass = FlowFilter;
        }
        field(45; "My New Calls"; Integer)
        {
            Caption = 'My New Calls';
            FieldClass = FlowField;
            CalcFormula = count("PMS Helpdesk Call" where(Status = const(Open), "Employee No." = field("Employee No. Filter")));
        }

        // ── Jobs ──────────────────────────────────────────────────────────────
        field(50; "Open Jobs"; Integer)
        {
            Caption = 'Open Jobs';
            FieldClass = FlowField;
            CalcFormula = count("PMS Job" where(Status = const(Open)));
        }
        field(51; "Jobs In Progress"; Integer)
        {
            Caption = 'Jobs In Progress';
            FieldClass = FlowField;
            CalcFormula = count("PMS Job" where(Status = const("In Progress")));
        }
        field(52; "Jobs Due Today"; Integer)
        {
            Caption = 'Jobs Due Today';
            FieldClass = FlowField;
            CalcFormula = count("PMS Job" where("Scheduled Date" = field("Date Filter"), Status = filter(< Completed)));
        }
        field(53; "Overdue Jobs"; Integer)
        {
            Caption = 'Overdue Jobs';
            FieldClass = FlowField;
            CalcFormula = count("PMS Job" where("Scheduled Date" = field("Date Filter"), Status = filter(< Completed)));
        }
        field(54; "My Open Jobs"; Integer)
        {
            Caption = 'My Open Jobs';
            FieldClass = FlowField;
            CalcFormula = count("PMS Job" where("Job Type" = const(Internal), "Employee No." = field("Employee No. Filter"), Status = const(Open)));
        }
        field(58; "My Scheduled Jobs"; Integer)
        {
            Caption = 'My Scheduled Jobs';
            FieldClass = FlowField;
            CalcFormula = count("PMS Job" where("Job Type" = const(Internal), "Employee No." = field("Employee No. Filter"), Status = const(Scheduled)));
        }
        field(59; "My In Progress Jobs"; Integer)
        {
            Caption = 'My In Progress Jobs';
            FieldClass = FlowField;
            CalcFormula = count("PMS Job" where("Job Type" = const(Internal), "Employee No." = field("Employee No. Filter"), Status = const("In Progress")));
        }
        field(55; "External Jobs Awaiting PO"; Integer)
        {
            Caption = 'External Jobs Awaiting PO';
            FieldClass = FlowField;
            CalcFormula = count("PMS Job" where("Job Type" = const(External), "Purchase Order No." = const(''), Status = filter(< Completed)));
        }
        field(56; "Resource No. Filter"; Code[20])
        {
            Caption = 'Resource No. Filter';
            FieldClass = FlowFilter;
            TableRelation = Resource;
        }
        field(57; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
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
