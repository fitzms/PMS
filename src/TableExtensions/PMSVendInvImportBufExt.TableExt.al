tableextension 80852 "PMS Vend Inv Import Buf. Ext." extends "Vendor Invoice Import Buffer"
{
    fields
    {
        field(80800; "Direct Unit Cost"; Decimal)
        {
            Caption = 'Direct Unit Cost';
            DataClassification = CustomerContent;
        }
    }
}
