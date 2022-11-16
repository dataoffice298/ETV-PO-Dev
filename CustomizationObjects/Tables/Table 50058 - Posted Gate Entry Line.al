table 50058 "Posted Gate Entry Line_B2B"
{
    // version NAVIN7.00

    DataClassification = CustomerContent;
    LookupPageID = "Posted Gate Entry Line List";

    fields
    {
        field(1; "Entry Type"; Enum GateEntryInOutWard)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Gate Entry No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Posted Gate Entry Header_B2B"."No." WHERE("Entry Type" = FIELD("Entry Type"));
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Source Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Sales Shipment","Sales Return Order","Purchase Order","Purchase Return Shipment","Transfer Receipt","Transfer Shipment","Item","Fixed Asset",Others;
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
        field(7; Status; enum VehicleStatus)
        {
            DataClassification = CustomerContent;
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
        field(11; Mark; Boolean)
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
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Source No."));
        }

        field(28; "Quantity Received"; Decimal)
        {

            FieldClass = FlowField;
            CalcFormula = sum("Posted Gate Entry Line_B2B".Quantity where("Posted RGP OUT NO." = field("Gate Entry No."), "Posted RGP OUT NO. Line" = field("Line No.")));

        }
        field(29; "Posted RGP OUT NO. Line"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Expected Receipt Date"; Date)
        {
            DataClassification = CustomerContent;//Pk-N on 14.05.2021
        }
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
    }

    keys
    {
        key(Key1; "Entry Type", "Type", "Gate Entry No.", "Line No.")
        {
        }
        key(Key2; "Entry Type", "Source Type", "Source No.", Status)
        {
        }
    }

    fieldgroups
    {
    }
}

