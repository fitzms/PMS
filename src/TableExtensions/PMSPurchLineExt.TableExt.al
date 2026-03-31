tableextension 80850 "PMS Purchase Line Ext." extends "Purchase Line"
{
    fields
    {
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
