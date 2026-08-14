codeunit 80811 "PMS Run Vend Inv Import CRE"
{
    trigger OnRun()
    begin
        XMLPORT.RUN(XMLPORT::"PMS Vendor Invoice Import CRE");
    end;
}
