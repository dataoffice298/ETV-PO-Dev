table 50041 "Quotation Comparison"
{
    // version PH1.0,PO1.0

    // Resource : SM-SivaMohan
    // 
    // SM  1.0  04/06/08   "Indent Req No","Indent Req Line No" Fields Added


    fields
    {
        field(1; "RFQ No."; Code[20])
        {
        }
        field(2; "Quote No."; Code[20])
        {
            Editable = false;
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FILTER(Quote));
        }
        field(3; "Vendor No."; Code[20])
        {
            Editable = false;
            TableRelation = Vendor."No.";
        }
        field(4; "Vendor Name"; Text[50])
        {
        }
        field(5; "Total Amount"; Decimal)
        {
            BlankZero = true;
            Editable = false;
        }
        field(6; "Item No."; Code[20])
        {
            Editable = true;
            TableRelation = Item."No.";
        }
        field(7; Description; Text[50])
        {
            Editable = false;
        }
        field(8; Quantity; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 0 : 5;
        }
        field(9; Rate; Decimal)
        {
            BlankZero = true;
            Editable = false;
        }
        field(10; Amount; Decimal)
        {
            BlankZero = true;
            Editable = false;
        }
        field(11; "P & F"; Decimal)
        {
            BlankZero = true;
            Editable = false;
        }
        field(12; "Excise Duty"; Decimal)
        {
            BlankZero = true;
            Editable = false;
        }
        field(13; "Sales Tax"; Decimal)
        {
            BlankZero = true;
            Editable = false;
        }
        field(14; Freight; Decimal)
        {
            BlankZero = true;
            Editable = false;
        }
        field(15; Insurance; Decimal)
        {
            BlankZero = true;
            Editable = false;
        }
        field(16; Discount; Decimal)
        {
            BlankZero = true;
            Editable = false;
        }
        field(17; VAT; Decimal)
        {
            BlankZero = true;
            Editable = false;
        }
        field(18; "Payment Term Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Payment Terms".Code;
        }
        field(19; "Delivery Date"; Date)
        {
        }
        field(20; "Line No."; Integer)
        {
        }
        field(21; "Carry Out Action"; Boolean)
        {
        }
        field(22; Level; Integer)
        {
        }
        field(23; "Parent Quote No."; Code[20])
        {
        }
        field(24; "Indent No."; Code[20])
        {
        }
        field(25; "Indent Line No."; Integer)
        {
        }
        field(26; "Document Date"; Date)
        {
        }
        field(27; "Due Date"; Date)
        {
        }
        field(28; "Requested Receipt Date"; Date)
        {
            Caption = 'Requested Receipt Date';
        }
        field(30; "Parent Vendor"; Code[20])
        {
        }
        field(32; "Standard Price"; Decimal)
        {
        }
        field(33; Structure; Code[10])
        {
        }
        field(34; Price; Decimal)
        {
        }
        field(35; "Line Amount"; Decimal)
        {
        }
        field(36; Delivery; Decimal)
        {
        }
        field(37; "Payment Terms"; Decimal)
        {
        }
        field(38; "Total Weightage"; Decimal)
        {
        }
        field(39; "Location Code"; Code[10])
        {
        }
        field(40; "Amt. including Tax"; Decimal)
        {
        }
        field(41; Rating; Decimal)
        {
        }
        field(42; "Variant Code"; Code[10])
        {
        }
        field(43; "Last Direct Cost"; Decimal)
        {
            Editable = false;
        }
        field(44; "Currency Factor"; Decimal)
        {
        }
        field(45; Remarks; Text[100])
        {
        }
        field(46; Department; Code[20])
        {
        }
        field(49; Quality; Decimal)
        {
        }
        field(54; "Indent Req No"; Code[20])
        {
            Description = 'PO1.0';
            //TableRelation = Table50067;//Balu
        }
        field(55; "Indent Req Line No"; Integer)
        {
            Description = 'PO1.0';
        }
        field(50000; "Terms & Conditions"; Option)
        {
            OptionCaption = '" ,payment terms,delivery,freight,VAT,shipment mode,packing,mode of payment"';
            OptionMembers = " ","payment terms",delivery,freight,VAT,"shipment mode",packing,"mode of payment";
        }
        field(50001; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Open,"Pending Approval",Released;
            OptionCaption = ' ,Open,Pending Approval,Released';
        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
        }
        key(Key2; "Item No.")
        {
        }
        key(Key3; "RFQ No.", "Item No.", "Variant Code")
        {
        }
        key(Key4; "Parent Vendor")
        {
        }
    }

    fieldgroups
    {
    }
}

