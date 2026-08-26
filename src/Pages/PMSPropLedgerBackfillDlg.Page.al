page 80851 "PMS Prop Ledger Backfill Dlg"
{
    PageType = ConfirmationDialog;
    Caption = 'Backfill Property Ledger Entries';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field(PropertyIDField; PropertyID)
            {
                ApplicationArea = All;
                Caption = 'Property ID';
                TableRelation = "PMS Property";
                ToolTip = 'Specifies the property to backfill. Leave blank to backfill all properties.';
            }
        }
    }

    var
        PropertyID: Code[20];
        Confirmed: Boolean;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Confirmed := CloseAction = ACTION::Yes;
        exit(true);
    end;

    procedure WasConfirmed(): Boolean
    begin
        exit(Confirmed);
    end;

    procedure GetPropertyID(): Code[20]
    begin
        exit(PropertyID);
    end;

    procedure SetPropertyID(DefaultPropertyID: Code[20])
    begin
        PropertyID := DefaultPropertyID;
    end;
}
