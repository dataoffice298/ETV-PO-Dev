tableextension 50061 FixedAssetExtPOAuto extends "Fixed Asset"
{
    fields
    {
        field(50050; "Qr Code"; Blob)
        {
            Subtype = Bitmap;
            Caption = 'QR Code';
            DataClassification = CustomerContent;
        }
        field(50051; "Model No."; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }

    var
        myInt: Integer;
}