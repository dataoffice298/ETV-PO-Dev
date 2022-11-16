page 50130 "Fixed Asset QR Code"
{
    Caption = 'Fixed Asset QR Code';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = "Fixed Asset";

    layout
    {
        area(content)
        {
            field("Qr Code"; Rec."Qr Code")
            {
                ApplicationArea = FixedAssets;
                ShowCaption = false;
                ToolTip = 'Specifies the QR Code that has been show for the fixed asset.';
            }
        }
    }

    actions
    {

    }

    var
        myInt: Integer;
}