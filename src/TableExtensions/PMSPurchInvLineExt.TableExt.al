tableextension 80853 "PMS Purch. Inv. Line Ext." extends "Purch. Inv. Line"
{
    fields
    {
        // Field IDs match PMSPurchLineExt so TransferFields copies them automatically during posting
        field(80800; "PMS Job No."; Code[20])
        {
            Caption = 'PMS Job No.';
            DataClassification = CustomerContent;
            TableRelation = "PMS Job";
        }
        field(80801; "PMS Property ID"; Code[20])
        {
            Caption = 'PMS Property ID';
            DataClassification = CustomerContent;
            TableRelation = "PMS Property";
        }
    }
}
