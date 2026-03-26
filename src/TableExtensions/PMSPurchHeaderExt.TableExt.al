tableextension 80851 "PMS Purchase Header Ext." extends "Purchase Header"
{
    fields
    {
        field(80801; "PMS Contract ID"; Code[20])
        {
            Caption = 'PMS Contract ID';
            DataClassification = CustomerContent;
            TableRelation = "PMS Contract Header";
        }
    }
}
