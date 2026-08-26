tableextension 80854 "PMS Purch. Inv. Header Ext." extends "Purch. Inv. Header"
{
    fields
    {
        // Field ID matches PMSPurchHeaderExt so TransferFields copies it automatically during posting
        field(80801; "PMS Contract ID"; Code[20])
        {
            Caption = 'PMS Contract ID';
            DataClassification = CustomerContent;
            TableRelation = "PMS Contract Header";
        }
    }
}
