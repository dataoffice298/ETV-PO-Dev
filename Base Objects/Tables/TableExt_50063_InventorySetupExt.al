tableextension 50063 InventorysetupExtPOAut extends "Inventory Setup"
{
    fields
    {
        field(50100; "Inward RGP No. Series_B2B"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            Caption = 'Inward RGP No. Series';

        }
        field(50101; "Inward NRGP No. Series_B2B"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            Caption = 'Inward NRGP No. Series';
        }
        field(50102; "Outward RGP No. Series_B2B"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            Caption = 'Outward RGP No. Series';
        }
        field(50103; "Inward Gate Entry Nos.-RGP_B2B"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            Caption = 'Inward Gate Entry Nos.-RGP';
        }
        field(50104; "Inward Gate Entry Nos.NRGP_B2B"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            Caption = 'Inward Gate Entry Nos.NRGP';
        }
        field(50105; "Outward Gate Entry Nos.RGP_B2B"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            Caption = 'Outward Gate Entry Nos.RGP';
        }
        field(50106; "Outward Gate EntryNos.NRGP_B2B"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            Caption = 'Outward Gate EntryNos.NRGP';
        }
        field(50107; "Outward NRGP No. Series_B2B"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            Caption = 'Outward NRGP No. Series';
        }
    }

    var
        myInt: Integer;
}