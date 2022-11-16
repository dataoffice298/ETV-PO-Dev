table 50038 "Indent Requisitions"
{
    // version PH1.0,PO1.0

    // Resource : SM - SivaMohan Y
    // 
    // SM 1.0  04/06/08  "Document No.","Line No.","Received Quantity","Document Type" and "Order No" Fields are added


    fields
    {
        field(1; "Item No."; Code[20])
        {

            TableRelation = IF ("Line Type" = CONST(Item)) Item
            ELSE
            IF ("Line Type" = CONST("Fixed Assets")) "Fixed Asset"
            ELSE
            IF ("Line Type" = CONST("G/L Account")) "G/L Account";
            Caption = 'No.';
        }
        field(2; Description; Text[50])
        {

        }
        field(3; Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
            //B2BESGOn23May2022++
            trigger OnValidate();
            begin
                Amount := "Unit Cost" * Quantity
            end;
            //B2BESGOn23May2022--
        }
        field(4; "Indent No."; Code[20])
        {

            TableRelation = "Indent Header";
        }
        field(5; "Indent Line No."; Integer)
        {
            Editable = false;
        }
        field(6; "Indent Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Indent,Enquiry,Offer,Order,Cancel,Closed';
            OptionMembers = Indent,Enquiry,Offer,"Order",Cancel,Closed;
        }
        field(7; "Accept Action Message"; Boolean)
        {
        }
        field(8; "Release Status"; Option)
        {
            Editable = false;
            OptionMembers = Open,Released,Cancel,Closed;
        }
        field(9; "Due Date"; Date)
        {
            Editable = false;
        }
        field(10; "Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(12; "Variant Code"; Code[20])
        {
        }
        field(13; "Unit of Measure"; Code[20])
        {
        }
        field(14; "Vendor No."; Code[20])
        {
            TableRelation = "Item Vendor"."Vendor No." WHERE("Item No." = FIELD("Item No."));
        }
        field(15; Department; Code[20])
        {
            Editable = false;
        }
        field(17; "Carry out Action"; Boolean)
        {
        }
        field(19; "No.Series"; Code[20])
        {

            trigger OnLookup();
            begin
                PPSetup.GET;
                Noseries.SETRANGE(Code, PPSetup."Order Nos.");
                IF PAGE.RUNMODAL(458, Noseries) = ACTION::LookupOK THEN
                    "No.Series" := Noseries."Series Code";
            end;
        }
        field(20; Type; Option)
        {
            OptionCaption = 'Enquiry,Quote,Order';
            OptionMembers = Enquiry,Quote,"Order";
        }
        field(24; "Document No."; Code[20])
        {
        }
        field(25; "Line No."; Integer)
        {

        }

        field(26; "Received Quantity"; Decimal)
        {
            CalcFormula = Sum("Purch. Rcpt. Line".Quantity WHERE("Indent Req No" = FIELD("Document No."),
                                                                  "Indent Req Line No" = FIELD("Line No.")));

            FieldClass = FlowField;
        }
        field(27; "Document Type"; Option)
        {
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Enquiry;
        }
        field(28; "Order No"; Code[20])
        {
        }
        field(50000; "Indent Quantity"; Decimal)
        {
        }
        field(50001; "Manufacturer Code"; Code[20])
        {

            trigger OnValidate();
            var
                VendorItemrec: Record 99;
            begin
                TestStatusOpen;
                Vendor.RESET;
                IF Vendor.GET("Manufacturer Code") THEN BEGIN
                    "Vendor Name" := Vendor.Name;
                    "Payment Method Code" := Vendor."Payment Method Code";
                    /*
                    VendorItemrec.RESET;
                    VendorItemrec.SETRANGE("Vendor No.","Manufacturer Code");
                    VendorItemrec.SETRANGE("Item No.","Item No.");
                    IF VendorItemrec.FINDFIRST THEN
                     "Vendor Min.Ord.Qty" := VendorItemrec."Vendor Min.Ord.Qty" ;
                 */
                END;

            end;
        }
        field(50002; "Manufacturer Ref. No."; Text[50])
        {
        }
        field(50003; "Remaining Quantity"; Decimal)
        {


            trigger OnValidate();
            begin
                "Qty. To Order" := "Remaining Quantity";
            end;
        }
        field(50004; "Qty. To Order"; Decimal)
        {
        }
        field(50005; "Qty. Ordered"; Decimal)
        {
            Editable = false;
        }
        field(50006; "Vendor Min.Ord.Qty"; Decimal)
        {
            Caption = 'Vendor Min.Ord.Qty';
            Description = 'B2B1.3';
            /*TableRelation = "Item Vendor".Field18043048 WHERE ("Vendor No."=FIELD("Manufacturer Code"),
                                                               "Item No."=FIELD("Item No."));*///Balu
        }
        field(50007; "Vendor Name"; Text[30])
        {
            Caption = 'Vendor Name';
            Description = 'B2B1.3.1';
        }
        field(50008; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            Description = 'B2B1.3.1';
            //B2BESGOn23May2022++
            trigger OnValidate();
            begin
                Amount := "Unit Cost" * Quantity
            end;
            //B2BESGOn23May2022--

        }
        field(50009; Amount; Decimal)
        {
            Caption = 'Amount';
            Description = 'B2B1.3.1';

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(50010; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Meathod Code';
            Description = 'B2B1.3.1';
            TableRelation = Vendor."Payment Method Code" WHERE("No." = FIELD("Manufacturer Code"));
        }
        field(50011; Description2; Text[50])
        {
            Description = 'PO 1.0';

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(50012; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
            Blocked = CONST(false));
        }
        field(50013; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
            Blocked = CONST(false));
        }
        field(50014; "Line Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Item,"Fixed Assets",Description,"G/L Account";
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        IndentLine.RESET;
        IndentLine.SETRANGE("Indent Req No", "Document No.");
        IndentLine.SETRANGE("Indent Req Line No", "Line No.");
        IF IndentLine.FINDFIRST THEN
            REPEAT
                IndentLine."Indent Req No" := '';
                IndentLine."Indent Req Line No" := 0;
                IndentLine.MODIFY;
            UNTIL IndentLine.NEXT = 0;
    end;

    var
        PPSetup: Record 312;
        Noseries: Record 310;
        IndentLine: Record "Indent Line";
        IndentReqHeader: Record "Indent Req Header";
        Vendor: Record 23;

    procedure TestStatusOpen();
    begin
        IF IndentReqHeader.GET("Document No.") THEN;
        IndentReqHeader.TESTFIELD(Status, IndentReqHeader.Status::Open);
        IndentReqHeader.MODIFY;
    end;
}

