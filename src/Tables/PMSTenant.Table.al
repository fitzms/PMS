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
            Editable = false;
        }
        field(7; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(10; "Employee Dimension Value"; Code[20])
        {
            Caption = 'Employee Dimension';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Employee Dimension Filter"), Blocked = const(false));

            trigger OnValidate()
            begin
                UpdateDefaultDimension();
            end;
        }
        field(11; "Employee Dimension Filter"; Code[20])
        {
            Caption = 'Employee Dimension Filter';
            FieldClass = FlowFilter;
        }
        field(12; "Billing Code"; Code[10])
        {
            Caption = 'Billing Code';
            TableRelation = "Service Shelf";
        }
        field(13; "Cost Centre Code"; Code[20])
        {
            Caption = 'Cost Centre';
            Editable = false;
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
        Status := Status::Inactive;
        if "Tenant ID" = '' then begin
            PMSSetup.GetRecordOnce();
            PMSSetup.TestField("Tenant Nos.");
            "No. Series" := PMSSetup."Tenant Nos.";
            "Tenant ID" := NoSeries.GetNextNo(PMSSetup."Tenant Nos.", WorkDate(), true);
        end;
    end;

    local procedure UpdateDefaultDimension()
    var
        DefaultDim: Record "Default Dimension";
        DimValue: Record "Dimension Value";
        CostCentreCode: Code[20];
    begin
        PMSSetup.GetRecordOnce();
        if PMSSetup."Employee Dimension Code" = '' then
            exit;

        // Handle Employee Dimension
        if "Employee Dimension Value" = '' then begin
            if DefaultDim.Get(Database::"PMS Tenant", "Tenant ID", PMSSetup."Employee Dimension Code") then
                DefaultDim.Delete(true);
        end else begin
            if DefaultDim.Get(Database::"PMS Tenant", "Tenant ID", PMSSetup."Employee Dimension Code") then begin
                DefaultDim.Validate("Dimension Value Code", "Employee Dimension Value");
                DefaultDim.Modify(true);
            end else begin
                DefaultDim.Init();
                DefaultDim."Table ID" := Database::"PMS Tenant";
                DefaultDim."No." := "Tenant ID";
                DefaultDim.Validate("Dimension Code", PMSSetup."Employee Dimension Code");
                DefaultDim.Validate("Dimension Value Code", "Employee Dimension Value");
                DefaultDim.Insert(true);
            end;

            // Get Cost Centre from CRE Dimension Value field
            if DimValue.Get(PMSSetup."Employee Dimension Code", "Employee Dimension Value") then
                CostCentreCode := DimValue."Def. Cost Cent Dim. Value CRE";
        end;

        // Handle Cost Centre Dimension
        "Cost Centre Code" := CostCentreCode;
        if CostCentreCode = '' then begin
            if DefaultDim.Get(Database::"PMS Tenant", "Tenant ID", 'COSTCENTRE') then
                DefaultDim.Delete(true);
        end else begin
            if DefaultDim.Get(Database::"PMS Tenant", "Tenant ID", 'COSTCENTRE') then begin
                DefaultDim.Validate("Dimension Value Code", CostCentreCode);
                DefaultDim.Modify(true);
            end else begin
                DefaultDim.Init();
                DefaultDim."Table ID" := Database::"PMS Tenant";
                DefaultDim."No." := "Tenant ID";
                DefaultDim.Validate("Dimension Code", 'COSTCENTRE');
                DefaultDim.Validate("Dimension Value Code", CostCentreCode);
                DefaultDim.Insert(true);
            end;
        end;
    end;

    procedure CalcStatusFromMovements()
    var
        TenantMovement: Record "PMS Tenant Movement";
    begin
        TenantMovement.SetRange("Tenant ID", "Tenant ID");
        TenantMovement.SetCurrentKey("Tenant ID", "Date");
        if TenantMovement.FindLast() then begin
            if TenantMovement.Status = TenantMovement.Status::Current then
                Status := Status::Current
            else
                Status := Status::Inactive;
        end else
            Status := Status::Inactive;
        Modify();
    end;
}
