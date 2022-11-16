table 50055 "LC Orders"
{
    Caption = 'LC Orders';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "LC No."; Code[20])
        {
            Caption = 'LC No.';
            DataClassification = CustomerContent;
        }
        field(2; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            OptionMembers = Purchase,Sale;
            DataClassification = CustomerContent;
        }
        field(3; "Issued To/Received From"; Code[20])
        {
            Caption = 'Issued To/Received From';
            DataClassification = CustomerContent;
        }
        field(4; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            DataClassification = CustomerContent;
        }
        field(5; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
            DataClassification = CustomerContent;
        }
        field(6; "Order Value"; Decimal)
        {
            Caption = 'Order Value';
            DataClassification = CustomerContent;
        }
        field(7; Renewed; Boolean)
        {
            Caption = 'Renewed';
            DataClassification = CustomerContent;
        }
        field(8; "Received Bank Receipt No."; Boolean)
        {
            Caption = 'Received Bank Receipt No.';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "LC No.", "Order No.")
        {
            Clustered = true;
        }
    }
}
