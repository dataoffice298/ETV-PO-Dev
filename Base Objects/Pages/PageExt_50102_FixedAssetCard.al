pageextension 50102 FixedAssetCard extends "Fixed Asset Card"
{
    layout
    {
        addbefore("Serial No.")
        {
            field("Model No."; Rec."Model No.")
            {

            }
        }
        addafter(FixedAssetPicture)
        {
            part("Fixed Asset QR Code"; "Fixed Asset QR Code")
            {
                ApplicationArea = FixedAssets;
                Caption = 'Fixed Asset QR Code';
                SubPageLink = "No." = FIELD("No.");
            }
        }
    }

    actions
    {
        addafter(Attachments)
        {
            action("Generate QR Code")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    QRGenerator: Codeunit "QR Generator";
                    TempBlob: Codeunit "Temp Blob";
                    FixedAsset: Record "Fixed Asset";
                    FieldRef: FieldRef;
                    RecRef: RecordRef;
                    CF: Char;
                    LF: Char;
                    QRText: Text;
                begin
                    if FixedAsset.Get(Rec."No.") then begin
                        RecRef.GetTable(FixedAsset);
                        CF := 15;
                        LF := 20;
                        QRText := 'Description : ' + FixedAsset.Description + ' ' + FixedAsset."Description 2" + 'Model No. : ' + FixedAsset."Model No."
                                     + 'Serial No. : ' + FixedAsset."Serial No.";
                        QRGenerator.GenerateQRCodeImage(QRText, TempBlob);
                        FieldRef := RecRef.Field(FixedAsset.FieldNo("QR Code"));
                        TempBlob.ToRecordRef(RecRef, FixedAsset.FieldNo("QR Code"));
                        RecRef.Modify();
                    end;
                end;
            }
        }
        addafter("Ledger E&ntries")
        {
            action(OpenFAMovementEntries)
            {
                ApplicationArea = ALL;
                Caption = 'FA Movement Entries';
                Image = Entries;
                trigger onaction()
                var
                    FAMovement: Record "Fixed Asset Movements";
                BEGIN
                    FAMovement.Reset();
                    FAMovement.SetRange("FA No.", Rec."No.");
                    if FAMovement.FindSet() then
                        Page.Run(0, FAMovement);
                END;
            }
        }
    }

    var
        myInt: Integer;
}