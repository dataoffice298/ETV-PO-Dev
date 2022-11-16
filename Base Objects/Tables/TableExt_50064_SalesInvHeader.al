tableextension 50064 SalesInvHeaderExt extends "Sales Invoice Header"
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