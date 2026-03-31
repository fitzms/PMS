page 80832 "PMS Tenant Movement"
{
    Caption = 'Tenant Movement';
    PageType = Card;
    SourceTable = "PMS Tenant Movement";
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the entry number.';
                    Visible = false;
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = IsTenantEditable;
                    ToolTip = 'Specifies the tenant.';

                    trigger OnValidate()
                    begin
                        UpdatePageVars();
                        CurrPage.Update(true);
                    end;
                }
                field(TenantName; TenantName)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the tenant.';
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the status of the tenant for this movement.';
                }

                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the property associated with this movement.';

                    trigger OnValidate()
                    begin
                        UpdatePageVars();
                        CurrPage.Update(true);
                    end;
                }
                field(PropertyKnownAs; PropertyKnownAs)
                {
                    ApplicationArea = All;
                    Caption = 'Known As';
                    Editable = false;
                    ToolTip = 'Specifies the known-as name of the property.';
                }
                field("Unit ID"; Rec."Unit ID")
                {
                    ApplicationArea = All;
                    Editable = not IsSingleUnit;
                    ToolTip = 'Specifies the unit associated with this movement.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the start date of the tenancy.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the end date of the tenancy.';
                }
            }
            group(Details)
            {
                Caption = 'Details';

                field("Notes"; Rec."Notes")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies additional notes for this movement entry.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who created this entry.';
                }
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the movement entry.';
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Tenant ID" := Rec.GetFilter("Tenant ID");
        Rec."Date" := WorkDate();
        Rec."User ID" := CopyStr(UserId(), 1, MaxStrLen(Rec."User ID"));
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        CurrPage.SaveRecord();
        exit(true);
    end;

    trigger OnAfterGetRecord()
    begin
        UpdatePageVars();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdatePageVars();
    end;

    local procedure UpdatePageVars()
    var
        PropertyRec: Record "PMS Property";
        TenantRec: Record "PMS Tenant";
    begin
        IsSingleUnit := false;
        if Rec."Property ID" <> '' then
            if PropertyRec.Get(Rec."Property ID") then begin
                IsSingleUnit := PropertyRec."Single Unit";
                PropertyKnownAs := PropertyRec."Known As";
            end else
                PropertyKnownAs := ''
        else
            PropertyKnownAs := '';

        TenantName := '';
        if Rec."Tenant ID" <> '' then begin
            IsTenantEditable := false;
            if TenantRec.Get(Rec."Tenant ID") then
                TenantName := TenantRec.Name;
        end else
            IsTenantEditable := true;
    end;

    var
        IsSingleUnit: Boolean;
        IsTenantEditable: Boolean;
        TenantName: Text[100];
        PropertyKnownAs: Text[100];
}
