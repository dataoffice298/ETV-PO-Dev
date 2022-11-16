table 50060 "Gate Entry Line_B2B"
{
    // version NAVIN7.00

    DataClassification = CustomerContent;
    LookupPageId = "Inward Gate Entry SubFrm-NRGP";
    DrillDownPageId = "Inward Gate Entry SubFrm-NRGP";

    fields
    {
        field(1; "Entry Type"; Enum GateEntryInOutWard)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Gate Entry No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gate Entry Header_B2B"."No." WHERE("Entry Type" = FIELD("Entry Type"));
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Source Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Sales Shipment","Sales Return Order","Purchase Order","Purchase Return Shipment","Transfer Receipt","Transfer Shipment","Item","Fixed Asset",Others;


            trigger OnValidate();
            begin
                if "Source Type" <> xRec."Source Type" then begin
                    "Source No." := '';
                    "Source Name" := '';
                end;
            end;
        }
        field(5; "Source No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Source Name"; Text[200])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,Close;
        }
        field(8; Description; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Challan No."; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(10; "Challan Date"; Date)
        {
            DataClassification = CustomerContent;
        }

        field(12; "Source Line No."; integer)
        {
            Editable = false;
        }
        field(23; "Type"; Enum GateEntryType)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Posted RGP OUT NO."; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(26; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(27; "Unit of Measure"; code[20])
        {
            DataClassification = CustomerContent;

            TableRelation = IF ("Source Type" = CONST(Item)) "Item Unit of Measure".Code ELSE
            IF ("Source Type" = CONST("Fixed Asset")) "Unit of Measure".Code;
        }
        field(29; "Posted RGP OUT NO. Line"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Expected Receipt Date"; Date)
        {
            DataClassification = CustomerContent;//Pk-N on 14.05.2021
        }
        //BaluonNov82022>>
        field(31; Variant; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(32; ModelNo; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Model No';
        }
        field(33; SerialNo; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Serial No';
        }

        //BaluonNov82022<<

    }

    keys
    {
        key(Key1; "Entry Type", "Type", "Gate Entry No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
    trigger OnDelete()
    var

        PostedLnesCount: integer;
        GateEntLRec: Record "Gate Entry Line_B2B";
        GateLocSetup: Record "Gate Entry Location Setup_B2B";
        GateENtHdrLRec: Record "Gate Entry Header_B2B";
    BEGIN
        /*
        IF GateENtHdrLRec.get("Entry Type", "type", "Gate Entry No.") then;
        GateLocSetup.RESET;
        IF "Entry Type" = "Entry Type"::Inward then
            GateLocSetup.SetRange("Entry Type", GateLocSetup."Entry Type"::Inward)
        else
            GateLocSetup.SetRange("Entry Type", GateLocSetup."Entry Type"::Outward);
        IF GateENtHdrLRec."Location Code" <> '' then
            GateLocSetup.SetRange("Location Code", GateENtHdrLRec."Location Code");
        IF GateLocSetup.findfirst then;
        PostdLneLRec.reset;
        PostdLneLRec.SetRange("Document No.", "Source No.");
        IF PostdLneLRec.findset then;
        PostedLnesCount := PostdLneLRec.Count;
        IF (PostedLnesCount > 1) AND (NOT GateLocSetup."Allow GateEntry Lines Delete") then BEGIN
            IF Confirm('If you delete record corresponding Gate Entry Lines with Source No. will be deleted do you want to continue?', true, false) then begin
                GateEntLRec.Reset();
                GateEntLRec.SetRange("Gate Entry No.", "Gate Entry No.");
                GateEntLRec.SetRange("Source No.", "Source No.");
                IF gateEntLRec.findset then
                    GateEntLRec.DeleteAll();
            end;
        error('You cannot delete Gate entry Lines.');
    end else begin
            */
    END;

    trigger OnInsert()
    begin
        //"Source Line No." := "Line No.";
    end;

    var
        PurchHeader: Record "Purchase Header";
        SalesShipHeader: Record "Sales Shipment Header";
        TransHeader: Record "Transfer Header";
        SalesHeader: Record "Sales Header";
        ReturnShipHeader: Record "Return Shipment Header";
        TransShptHeader: Record "Transfer Shipment Header";
        GateEntryHeader: Record "Gate Entry Header_B2B";
        Text16500: Label 'Source Type must not be blank in %1 %2.';
}

