table 50037 "Indent Line"
{
    // version PH1.0,PO1.0

    // Resource : SM -SivaMohan Y
    // 
    // SM  PO1.0  05/06/08  "Indent Req No" and "Indent Req Line No" fields added and Changed option values of Type field
    //                      and code in "No." field OnValidate

    LookupPageID = "Indent Line";
    DrillDownPageId = "Indent Line";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            TableRelation = "Indent Header"."No.";
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "No."; Code[20])
        {
            Description = 'PO1.0';
            TableRelation = IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST("Fixed Assets")) "Fixed Asset"
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account";

            trigger OnValidate();
            var
                ItemUnitofMeasure: Record 5404;
            begin
                TestStatusOpen;
                CASE Type OF
                    Type::Item:
                        IF Item.GET("No.") THEN BEGIN
                            Item.TESTFIELD(Blocked, FALSE);
                            Description := Item.Description;
                            "Description 2" := Item."Description 2";
                            "Due Date" := CALCDATE(Item."Lead Time Calculation", WORKDATE);
                            "Unit of Measure" := Item."Base Unit of Measure";
                            VALIDATE("Unit Cost", Item."Last Direct Cost");//PO1.0
                            "Vendor No." := Item."Vendor No.";
                        END;
                    //<<PO1.0
                    Type::"Fixed Assets":
                        IF Fixedasset.GET("No.") THEN BEGIN
                            Fixedasset.TESTFIELD(Blocked, FALSE);
                            Description := Fixedasset.Description;
                            "Description 2" := Fixedasset."Description 2";
                        END;
                    Type::"G/L Account":
                        IF GLAccount.GET("No.") THEN BEGIN
                            GLAccount.TESTFIELD(Blocked, FALSE);
                            Description := GLAccount.Name;
                        END;
                //PO1.0>>
                END;
                IF IndentHeader.GET("Document No.") THEN;
                "Delivery Location" := IndentHeader."Delivery Location";
                IndentHeader.MODIFY;//PO1.0
                "Avail.Qty" := 0;
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Item No.", "No.");
                ItemLedgerEntry.SETRANGE("Variant Code", "Variant Code");
                ItemLedgerEntry.SETRANGE("Location Code", "Delivery Location");
                IF ItemLedgerEntry.FINDFIRST THEN
                    REPEAT
                        "Avail.Qty" += ItemLedgerEntry."Remaining Quantity";
                    UNTIL ItemLedgerEntry.NEXT = 0;
            end;
        }
        field(4; Description; Text[50])
        {

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(5; "Req.Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate();
            begin
                //TestStatusOpen;
                Amount := "Req.Quantity" * "Unit Cost";
                UpdateIndentQtyBase; // Nov042016
                //B2BMSOn13Sep2022>>
                if (IndentHeader.Get("Document No.")) and (IndentHeader."Released Status" = IndentHeader."Released Status"::"Pending Approval") then begin
                    IndentHeader.TestField("Ammendent Comments");
                    if (xRec."Req.Quantity" <> 0) AND ("Prev Quantity" = 0) AND (xRec."Req.Quantity" <> Rec."Req.Quantity") then
                        "Prev Quantity" := xRec."Req.Quantity";
                end;
                //B2BMSOn13Sep2022<<
            end;
        }
        field(6; "Available Stock"; Decimal)
        {

        }
        field(10; "Due Date"; Date)
        {

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(11; "Delivery Location"; Code[20])
        {
            TableRelation = Location;

            trigger OnValidate();
            begin
                TestStatusOpen;

                "Avail.Qty" := 0;
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Item No.", "No.");
                ItemLedgerEntry.SETRANGE("Variant Code", "Variant Code");
                ItemLedgerEntry.SETRANGE("Location Code", "Delivery Location");
                IF ItemLedgerEntry.FINDFIRST THEN
                    REPEAT
                        "Avail.Qty" += ItemLedgerEntry."Remaining Quantity";
                    UNTIL ItemLedgerEntry.NEXT = 0;
            end;
        }
        field(12; "Unit of Measure"; Code[10])
        {
            Description = 'PO1.0';
            //TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(17; "Indent Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Indent,Enquiry,Offer,Order,Cancel,Closed';
            OptionMembers = Indent,Enquiry,Offer,"Order",Cancel,Closed;
        }
        field(18; "Avail.Qty"; Decimal)
        {
            Editable = false;

        }
        field(20; Department; Code[20])
        {

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(22; "Indent Req No"; Code[20])
        {
            Editable = false;
            TableRelation = "Indent Req Header";
        }
        field(23; "Indent Req Line No"; Integer)
        {
        }
        field(30; Type; Option)
        {
            Description = 'PO1.0';
            OptionMembers = Item,"Fixed Assets",Description,"G/L Account";

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(32; "Unit Cost"; Decimal)
        {

            trigger OnValidate();
            begin
                TestStatusOpen;
                Amount := "Req.Quantity" * "Unit Cost";
            end;
        }
        field(33; Amount; Decimal)
        {

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(36; "Release Status"; Option)
        {
            //B2BMSOn12Sep2022>>
            //OptionCaption = 'Open,Released,Cancel,Closed';
            //OptionMembers = Open,Released,Cancel,Closed;
            OptionCaption = 'Open,Released,Cancel,Closed,Pending Approval';
            OptionMembers = Open,Released,Cancel,Closed,"Pending Approval";
            //B2BMSOn12Sep2022<<
        }
        field(37; "Description 2"; Text[50])
        {
        }
        field(38; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("No."));

            trigger OnValidate();
            begin
                TestStatusOpen;
                TESTFIELD(Type, Type::Item);
                IF "Variant Code" = '' THEN
                    IF Type = Type::Item THEN BEGIN
                        Item.GET("No.");
                        Description := Item.Description;
                        "Description 2" := Item."Description 2";
                    END;

                ItemVariant.GET("No.", "Variant Code");
                Description := ItemVariant.Description;
                "Description 2" := ItemVariant."Description 2";

                "Avail.Qty" := 0;
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Item No.", "No.");
                ItemLedgerEntry.SETRANGE("Variant Code", "Variant Code");
                ItemLedgerEntry.SETRANGE("Location Code", "Delivery Location");
                IF ItemLedgerEntry.FINDFIRST THEN
                    REPEAT
                        "Avail.Qty" += ItemLedgerEntry."Remaining Quantity";
                    UNTIL ItemLedgerEntry.NEXT = 0;
            end;
        }
        field(39; Remarks; Text[30])
        {
        }
        field(41; "Vendor No."; Code[20])
        {
            TableRelation = "Item Vendor" WHERE("Item No." = FIELD("No."));

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(50000; "Quantity (Base)"; Decimal)
        {
        }
        field(50001; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
            Blocked = CONST(false));
        }

        field(50002; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
            Blocked = CONST(false));
        }
        //B2BMSOn13Sep2022>>
        field(50003; "Prev Quantity"; Decimal)
        {
        }
        field(50004; "Transfer Order No."; Code[20])
        {
        }
        //B2BMSOn13Sep2022<<

        field(50005; "Qty To Issue"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CalcFields("Qty issued");
                if "Qty To Issue" > "Avail.Qty" then
                    Error('Qty Should not be greater than Available Qty');

                if "Qty To Issue" > (Rec."Req.Quantity" - abs(Rec."Qty Issued")) then
                    Error('Qty to return should not be greater than %1', (Rec."Req.Quantity" - abs(Rec."Qty Issued")));

                if "Qty To Return" > (Rec."Req.Quantity" - Abs(Rec."Qty Returned")) then
                    Error('Qty to return should not be greater than %1', (Rec."Req.Quantity" - Abs(Rec."Qty Returned")));
            end;
        }
        field(50006; "Qty To Return"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CalcFields("Qty Returned");
                if "Qty To Return" > "Avail.Qty" then
                    Error('Qty Should not be greater than Available Qty');

                if "Qty To Return" > (Rec."Req.Quantity" - Abs(Rec."Qty Returned")) then
                    Error('Qty to return should not be greater than %1', (Rec."Req.Quantity" - Abs(Rec."Qty Returned")));
            end;
        }
        field(50007; "Qty Issued"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Indent No." = field("Document No."), "Indent Line No." = field("Line No."), Quantity = filter(< 0)));
        }
        field(50008; "Qty Returned"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Indent No." = field("Document No."), "Indent Line No." = field("Line No."), Quantity = filter(> 0)));
        }
        field(50009; "Archived Version"; Integer)
        {
        }
        field(50010; "Archived By"; Code[30])
        {
        }
        //BaluOn19Oct2022<<
        field(50012; "Indent Transfer"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50013; "Issue Location"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
        field(50014; "Issue Sub Location"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
        //BaluOn19Oct2022>>
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
        TESTFIELD("Indent Status", "Indent Status"::Indent);
        TESTFIELD("Release Status", "Release Status"::Open);
    end;

    trigger OnInsert();
    var
        IndHdr: Record "Indent Header";
    begin
        Compsetup.GET;
        "Delivery Location" := Compsetup."Location Code";
        If IndHdr.GET("Document No.") then begin
            Validate("Shortcut Dimension 1 Code", IndHdr."Shortcut Dimension 1 Code");
            Validate("Shortcut Dimension 2 Code", IndHdr."Shortcut Dimension 2 Code");
        End;
    end;

    trigger OnModify();
    begin
        //TestStatusOpen;
    end;

    var
        IndentHeader: Record 50010;
        Item: Record 27;
        ItemVariant: Record 5401;
        cust: Record 18;
        loc: Record 14;
        ProdOrderRoutingLine: Record 5409;
        changeIndentLine: Boolean;
        SalesPurchase: Record 13;
        Text000: Label 'Item dont have unit of measure %1';
        ItemLedgerEntry: Record 32;
        Compsetup: Record 79;
        Fixedasset: Record 5600;
        GLAccount: Record 15;
        NoStatusCheck: Boolean;

    procedure NoHeadStatusCheck(StatusCheck: Boolean)
    begin
        NoStatusCheck := StatusCheck;
    end;

    local procedure TestStatusOpen();
    begin
        if not NoStatusCheck then begin
            IF (IndentHeader.GET("Document No.")) THEN;
            if IndentHeader."Released Status" <> IndentHeader."Released Status"::"Pending Approval" then
                IndentHeader.TESTFIELD("Released Status", IndentHeader."Released Status"::Open);
            IndentHeader.MODIFY;
        end;
    end;

    procedure ChangePurchaser();
    begin
        changeIndentLine := TRUE;
        MESSAGE('fun %1', changeIndentLine);
    end;

    procedure UpdateIndentQtyBase();
    var
        Item2: Record 27;
        ItemUnitofMeasure: Record 5404;
    begin
        IF Type = Type::Item THEN BEGIN
            Item2.GET("No.");
            ItemUnitofMeasure.GET("No.", "Unit of Measure");
            IF Item2."Base Unit of Measure" = "Unit of Measure" THEN
                "Quantity (Base)" := "Req.Quantity"
            ELSE
                "Quantity (Base)" := "Req.Quantity" * ItemUnitofMeasure."Qty. per Unit of Measure";
        END else begin
            "Quantity (Base)" := "Req.Quantity";
        end;
    end;
}

