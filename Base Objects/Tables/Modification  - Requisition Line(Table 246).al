tableextension 50059 tableextension70000008 extends "Requisition Line"
{
    // version NAVW19.00.00.45778,PO

    fields
    {
        field(33002900; "Vendor Evaluated"; Boolean)
        {
            Description = 'PO 1.0';
        }
        field(33002901; "Enquiry Created"; Boolean)
        {
            Description = 'PO 1.0';
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.


    var
        "---PH1.0---": Integer;
        IndentHeader: Record "Indent Header";
        IndentLine: Record "Indent Line";
        "P&PSetup": Record "Purchases & Payables Setup";
        IndentNo: Code[20];
        LineNo: Integer;
        IndentLine1: Record "Indent Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

