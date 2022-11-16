tableextension 50065 SalesShipHeaderExt extends "Sales Shipment Header"
{
    fields
    {
        field(50100; "LC No."; Code[20])
        {
            Caption = 'LC No.';

        }
    }

    var
        myInt: Integer;
}