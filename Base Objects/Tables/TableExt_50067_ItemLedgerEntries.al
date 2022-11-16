tableextension 50067 ItemLedgerEntries extends "Item Ledger Entry"
{
    fields
    {
        field(50150; "Indent No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50151; "Indent Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

}