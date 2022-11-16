table 50046 "Quotation Comparison Test"
{
    fields
    {
        field(1; "RFQ No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Quote No."; Code[20])
        {
            Editable = false;
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FILTER(Quote));
            DataClassification = CustomerContent;
        }
        field(3; "Vendor No."; Code[20])
        {
            //Editable = false;
            TableRelation = Vendor."No.";
            DataClassification = CustomerContent;
        }
        field(4; "Vendor Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Total Amount"; Decimal)
        {
            BlankZero = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(6; "Item No."; Code[20])
        {
            Editable = true;
            TableRelation = Item."No.";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                IF Item.GET("Item No.") THEN;
                Item.TESTFIELD(Blocked, FALSE);
            end;
        }
        field(7; Description; Text[100])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(8; Quantity; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
            //B2BMSOn14Oct2022>>
            trigger OnValidate()
            var
                QuoCompLine: Record "Quotation Comparison Test";
                QuoCompLine1: Record "Quotation Comparison Test";
            begin
                Rec.Amount := Rec.Quantity * Rec.Rate;
                Rec.Modify();
                QuoCompLine.Reset();
                QuoCompLine.SetRange("Vendor No.", Rec."Vendor No.");
                QuoCompLine.SetFilter("Item No.", '<>%1', '');
                if QuoCompLine.FindSet() then begin
                    QuoCompLine.CalcSums(Amount);
                    QuoCompLine1.Reset();
                    QuoCompLine1.SetRange("Vendor No.", "Vendor No.");
                    QuoCompLine1.SetFilter("Item No.", '');
                    if QuoCompLine1.FindFirst() then begin
                        QuoCompLine1."Total Amount" := QuoCompLine.Amount;
                        QuoCompLine1.Modify();
                    end;
                end;
            end;
            //B2BMSOn14Oct2022<<
        }
        field(9; Rate; Decimal)
        {
            BlankZero = true;
            //Editable = false;
            DataClassification = CustomerContent;
            //B2BMSOn14Oct2022>>
            trigger OnValidate()
            var
                QuoCompLine: Record "Quotation Comparison Test";
                QuoCompLine1: Record "Quotation Comparison Test";
            begin
                Rec.Amount := Rec.Quantity * Rec.Rate;
                Rec.Modify();
                QuoCompLine.Reset();
                QuoCompLine.SetRange("Vendor No.", Rec."Vendor No.");
                QuoCompLine.SetFilter("Item No.", '<>%1', '');
                if QuoCompLine.FindSet() then begin
                    QuoCompLine.CalcSums(Amount);
                    QuoCompLine1.Reset();
                    QuoCompLine1.SetRange("Vendor No.", "Vendor No.");
                    QuoCompLine1.SetFilter("Item No.", '');
                    if QuoCompLine1.FindFirst() then begin
                        QuoCompLine1."Total Amount" := QuoCompLine.Amount;
                        QuoCompLine1.Modify();
                    end;
                end;
            end;
            //B2BMSOn14Oct2022<<
        }
        field(10; Amount; Decimal)
        {
            BlankZero = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11; "P & F"; Decimal)
        {
            BlankZero = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(12; "Excise Duty"; Decimal)
        {
            BlankZero = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(13; "Sales Tax"; Decimal)
        {
            BlankZero = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14; Freight; Decimal)
        {
            BlankZero = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(15; Insurance; Decimal)
        {
            BlankZero = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(16; Discount; Decimal)
        {
            BlankZero = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(17; VAT; Decimal)
        {
            BlankZero = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(18; "Payment Term Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Payment Terms".Code;
            DataClassification = CustomerContent;
        }
        field(19; "Delivery Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(21; "Carry Out Action"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(22; Level; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(23; "Parent Quote No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(24; "Indent No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(25; "Indent Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(26; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(27; "Due Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(28; "Requested Receipt Date"; Date)
        {
            Caption = 'Requested Receipt Date';
            DataClassification = CustomerContent;
        }
        field(29; Description2; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(30; "Parent Vendor"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(32; "Standard Price"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(33; Structure; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(34; Price; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(35; "Line Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(36; Delivery; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(37; "Payment Terms"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(38; "Total Weightage"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(39; "Location Code"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(40; "Amt. including Tax"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(41; Rating; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(42; "Variant Code"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(43; "Last Direct Cost"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(44; "Currency Factor"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(45; Remarks; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(46; Department; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(49; Quality; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(52; "Manufacturer Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(53; "Manufacturer Ref. No."; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(54; "Purc. Req No"; Code[20])
        {
            //TableRelation = "Purch. Req Header";//B2BESGOn05Jun2022
            DataClassification = CustomerContent;
        }
        field(55; "Purch. Req Line No"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(61; "Parent Quote Line No"; Integer)
        {
            Description = 'RIM';
            DataClassification = CustomerContent;
        }
        field(62; "Line Type"; Option)
        {
            Description = 'RIM';
            OptionCaption = '" ,Item,Narration,Scope of Work,Material,Service,Capex"';
            OptionMembers = " ",Item,Narration,"Scope of Work",Material,Service,Capex;
            DataClassification = CustomerContent;
        }
        field(63; "Is Leaf"; Boolean)
        {

            DataClassification = CustomerContent;
        }
        field(64; Status; Option)
        {

            DataClassification = ToBeClassified;
            OptionMembers = " ",Open,"Pending Approval",Released;
            OptionCaption = ' ,Open,Pending Approval,Released';
            trigger OnValidate();
            begin
            end;
        }
        field(65; "Quot Comp No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(70; "Capex No."; code[20])
        {
            DataClassification = CustomerContent;
            //TableRelation = "Budget Header"."No.";
            Editable = false;
        }
        field(71; "Capex Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80; "Budget Name"; code[20])
        {
            DataClassification = CustomerContent;
        }
        field(81; "FA Posting Group"; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "FA Posting Group";
            Editable = false;
            Description = 'FA Posting Group';
        }
        field(85; "PO No."; code[20])
        {
            DataClassification = CustomerContent;
            Editable = FALSE;
        }
        field(89; "Material req No.s"; Code[250])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(93; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;

        }
        field(94; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;

        }
        field(95; "Dimension Set ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        //PhaniFeb102021 >>
        field(98; "VAT Bus. Posting Group"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group";
        }
        field(99; "VAT Prod. Posting Group"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "VAT Product Posting Group";

        }
        //PhaniFeb102021 <<
        //PhaniFeb112021 <<
        field(100; "CWIP No."; Code[10])
        {
            DataClassification = CustomerContent;
            //TableRelation = "CWIP Masters";

        }
        //PhaniFeb112021 >>
        //Service08Jul2021>>
        field(101; "Service Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }

        //Service08Jul2021<<
        //B2BMSOn06Oct21>>
        field(110; "Currency Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        //B2BMSOn06Oct21<<
        field(111; "Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Item,"Fixed Assets",Description,"G/L Account";
        }
        //Do not use 112 Field id
        //B2BMSOn08Nov2022>>
        field(120; "Indent Req. No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(121; "Indent Req. Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        //B2BMSOn08Nov2022<<

    }

    keys
    {
        key(Key1; "Quot Comp No.", "Line No.")
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

    var
        Item: Record Item;

    procedure "--RIM--"();
    begin
    end;

    procedure CheckCOAction();
    var
        QuotationComparison: Record "Quotation Comparison";
    begin
        QuotationComparison.SETRANGE("RFQ No.", "RFQ No.");
        QuotationComparison.SETRANGE("Carry Out Action", TRUE);
        QuotationComparison.SETFILTER("Line No.", '<>%1', "Line No.");
        IF NOT QuotationComparison.IsEmpty() THEN
            ERROR('Already carry Out Action is selected.');
    end;
}

