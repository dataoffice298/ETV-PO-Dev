page 50170 "LC Order Details"
{
    Caption = 'LC Order Details';
    PageType = List;
    SourceTable = "LC Orders";
    UsageCategory = Lists;
    ApplicationArea = all;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("LC No."; Rec."LC No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the LC No. field.';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order No. field.';
                }
                field("Order Value"; Rec."Order Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order Value field.';
                }
                field("Issued To/Received From"; Rec."Issued To/Received From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Issued To/Received From field.';
                }
                field("Received Bank Receipt No."; Rec."Received Bank Receipt No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Received Bank Receipt No. field.';
                }
                field(Renewed; Rec.Renewed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Renewed field.';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shipment Date field.';
                }

            }
        }
    }
}
