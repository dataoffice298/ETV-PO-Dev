codeunit 50026 "PO Automation"
{
    // version PO1.0


    trigger OnRun();
    begin
    end;

    var
        Text001: Label 'Do you want to create Indent for Template %1?';
        Text002: Label 'Indent %1 Created';
        Item: Record 27;
        Text005: Label '"Rating of payment term code  ''%1'' Should not be zero "';
        Text006: Label 'Payment Term Code  should not be blank in Quotation No: %1';
        CreateIndents4: Record 50038;
        ItemUnitofMeasure: Record 5404;
        ConversionQty: Decimal;
        CreateIndents5: Record 50038;
        TEXT50050: Label 'Vendor No. must have Value in Lines.';

    procedure CreateIndents(TemplateName: Code[20]; "Jnl.BatchName": Code[20]);
    var
        IndentHeader: Record 50010;
        IndentLine: Record 50037;
        ReqLine: Record 246;
        PPSetup: Record 312;
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        IF NOT CONFIRM(Text001, FALSE, TemplateName) THEN
            EXIT;
        ReqLine.SETRANGE("Worksheet Template Name", TemplateName);
        ReqLine.SETRANGE("Journal Batch Name", "Jnl.BatchName");
        IF ReqLine.FIND('-') THEN BEGIN
            IndentHeader.INIT;
            PPSetup.GET;
            IndentHeader."No." := NoSeriesMgt.GetNextNo(PPSetup."Indent Nos.", WORKDATE, TRUE);
            IndentHeader."Due Date" := ReqLine."Due Date";
            IndentHeader."Document Date" := WORKDATE;
            IndentHeader."Delivery Location" := ReqLine."Location Code";
            IndentHeader."User Id" := USERID;
            IndentHeader."Indent Status" := IndentHeader."Indent Status"::Indent;
            IndentHeader.INSERT;
            REPEAT
                IndentLine.INIT;
                IndentLine."Line No." := IndentLine."Line No." + 10000;
                IndentLine."Document No." := IndentHeader."No.";
                IndentLine."No." := ReqLine."No.";
                IndentLine.VALIDATE("No.");
                IndentLine."Req.Quantity" := ReqLine.Quantity;
                IndentLine.VALIDATE("Req.Quantity");
                IndentLine."Due Date" := ReqLine."Due Date";
                IndentLine."Delivery Location" := ReqLine."Location Code";
                IndentLine."Indent Status" := IndentLine."Indent Status"::Indent;
                IndentLine.INSERT;
            UNTIL ReqLine.NEXT = 0;
        END;
        MESSAGE(Text002, IndentHeader."No.");
        ReqLine.DELETEALL;
    end;

    procedure GetIndentLines();
    var
        CreateIndents: Record 50038;
        IndentLine: Record 50037;
        Item2: Record 27;
        ItemUnitofMeasure: Record 5404;
        PPsetup: Record 312;
    begin
        CreateIndents.RESET;
        CreateIndents.DELETEALL;
        IndentLine.RESET;
        IndentLine.SETRANGE("Indent Status", IndentLine."Indent Status"::Indent);
        IndentLine.SETRANGE("Release Status", IndentLine."Release Status"::Released);
        IF IndentLine.FIND('-') THEN
            REPEAT
                PPsetup.GET;
                IF PPsetup."Cumulation of Indents" THEN BEGIN
                    CreateIndents.RESET;
                    CreateIndents.SETRANGE("Item No.", IndentLine."No.");
                    CreateIndents.SETRANGE("Location Code", IndentLine."Delivery Location");
                    CreateIndents.SETRANGE("Variant Code", IndentLine."Variant Code");
                    CreateIndents.SETRANGE("Due Date", IndentLine."Due Date");
                END ELSE BEGIN
                    CreateIndents.RESET;
                    CreateIndents.SETRANGE("Indent No.", IndentLine."Document No.");
                    CreateIndents.SETRANGE("Item No.", IndentLine."No.");
                    CreateIndents.SETRANGE("Location Code", IndentLine."Delivery Location");
                    CreateIndents.SETRANGE("Variant Code", IndentLine."Variant Code");
                    CreateIndents.SETRANGE("Due Date", IndentLine."Due Date");
                    CreateIndents.SETRANGE(Department, IndentLine.Department);
                END;
                IF CreateIndents.FIND('+') THEN BEGIN
                    Item2.RESET;
                    ItemUnitofMeasure.RESET;
                    Item2.GET(IndentLine."No.");
                    ItemUnitofMeasure.GET(IndentLine."No.", IndentLine."Unit of Measure");
                    IF Item2."Base Unit of Measure" <> IndentLine."Unit of Measure" THEN BEGIN
                        IF ItemUnitofMeasure."Qty. per Unit of Measure" <> 0 THEN
                            CreateIndents.Quantity += IndentLine."Req.Quantity" * ItemUnitofMeasure."Qty. per Unit of Measure";
                    END ELSE
                        CreateIndents.Quantity += IndentLine."Req.Quantity";
                    CreateIndents.MODIFY;
                END ELSE BEGIN
                    CreateIndents.INIT;
                    CreateIndents."Line Type" := IndentLine.Type; //ETVPO1.1
                    CreateIndents."Item No." := IndentLine."No.";
                    CreateIndents."Indent No." := IndentLine."Document No.";
                    CreateIndents."Indent Line No." := IndentLine."Line No.";
                    CreateIndents.Description := IndentLine.Description;
                    CreateIndents."Variant Code" := IndentLine."Variant Code";
                    CreateIndents."Indent Status" := IndentLine."Indent Status";
                    CreateIndents."Release Status" := IndentLine."Release Status";
                    CreateIndents."Due Date" := IndentLine."Due Date";
                    CreateIndents."Location Code" := IndentLine."Delivery Location";
                    Message('%1..%2', CreateIndents."Location Code", IndentLine."Delivery Location");
                    //CreateIndents."Location Code" := IndentLine.l
                    CreateIndents.Department := IndentLine.Department;
                    Item2.RESET;
                    ItemUnitofMeasure.RESET;
                    Item2.GET(CreateIndents."Item No.");
                    CreateIndents."Vendor No." := IndentLine."Vendor No.";
                    ItemUnitofMeasure.GET(IndentLine."No.", IndentLine."Unit of Measure");
                    IF Item2."Base Unit of Measure" = IndentLine."Unit of Measure" THEN BEGIN
                        CreateIndents."Unit of Measure" := IndentLine."Unit of Measure";
                        CreateIndents.Quantity := IndentLine."Req.Quantity";
                    END ELSE BEGIN
                        CreateIndents."Unit of Measure" := Item2."Base Unit of Measure";
                        IF ItemUnitofMeasure."Qty. per Unit of Measure" <> 0 THEN
                            CreateIndents.Quantity := (IndentLine."Req.Quantity" * ItemUnitofMeasure."Qty. per Unit of Measure");
                    END;
                    CreateIndents.INSERT;
                END;
            UNTIL IndentLine.NEXT = 0;
        CreateIndents.RESET;
    end;

    procedure InsertIndentItemvendor(var CreateIndentsLocal: Record 50038; var Vendor: Record 23);
    var
        IndentVendorItems: Record 50043;
        ItemVendor: Record 99;
        CreateIndents: Record 50038;
        Text000: Label 'Default Vendor is not Mentioned In the Vendor Item Catalog For  Item No ''%1''';
        Text001: Label 'First Select Vendor';
    begin
        IndentVendorItems.DELETEALL;
        CreateIndents.COPYFILTERS(CreateIndentsLocal);
        IF CreateIndents.FIND('-') THEN
            REPEAT
                IndentVendorItems.INIT;
                IndentVendorItems."Line Type" := CreateIndents."Line Type"; //ETVPO1.1
                IndentVendorItems."Item No." := CreateIndents."Item No.";
                IndentVendorItems.Quantity := CreateIndents.Quantity;
                IndentVendorItems."Variant Code" := CreateIndents."Variant Code";
                IndentVendorItems."Indent No." := CreateIndents."Indent No.";
                IndentVendorItems."Indent Line No." := CreateIndents."Indent Line No.";
                IndentVendorItems."Due Date" := CreateIndents."Due Date";
                IndentVendorItems.Check := FALSE;
                IndentVendorItems."Location Code" := CreateIndents."Location Code";
                IndentVendorItems."Unit Of Measure" := CreateIndents."Unit of Measure";
                IndentVendorItems.Department := CreateIndents.Department;
                IndentVendorItems."Indent Req No" := CreateIndents."Document No.";
                IndentVendorItems."Indent Req Line No" := CreateIndents."Line No.";
                IndentVendorItems."Shortcut Dimension 1 Code" := CreateIndents."Shortcut Dimension 1 Code"; //B2BPAV
                IndentVendorItems."Shortcut Dimension 2 Code" := CreateIndents."Shortcut Dimension 2 Code"; //B2BPAV
                //Message('Here is the code ? %1', CreateIndents."Shortcut Dimension 1 Code");
                IF NOT (Vendor.FIND('-')) THEN
                    ERROR(Text001, IndentVendorItems."Item No.")
                ELSE
                    REPEAT
                        IndentVendorItems."Vendor No." := Vendor."No.";
                        IndentVendorItems.INSERT;
                    UNTIL Vendor.NEXT = 0;
            UNTIL CreateIndents.NEXT = 0;
    end;

    procedure InsertOrderItemvendor(var CreateIndentsLocal: Record 50038);
    var
        IndentVendorItems: Record 50043;
        ItemVendor: Record 99;
        CreateIndents: Record 50038;
        Text000: Label 'Default Vendor is not Mentioned In the Vendor Item Catalog For  Item No ''%1''';
    begin
        IndentVendorItems.DELETEALL;
        CreateIndents.COPYFILTERS(CreateIndentsLocal);
        IF CreateIndents.FIND('-') THEN
            REPEAT
                IndentVendorItems.INIT;
                IndentVendorItems."Line Type" := CreateIndents."Line Type"; //ETVPO1.1
                IndentVendorItems."Item No." := CreateIndents."Item No.";
                IndentVendorItems.Quantity := CreateIndents.Quantity;
                IndentVendorItems."Variant Code" := CreateIndents."Variant Code";
                IndentVendorItems."Indent No." := CreateIndents."Indent No.";
                IndentVendorItems."Indent Line No." := CreateIndents."Indent Line No.";
                IndentVendorItems."Due Date" := CreateIndents."Due Date";
                IndentVendorItems.Check := FALSE;
                IndentVendorItems."Location Code" := CreateIndents."Location Code";
                IndentVendorItems."Unit Of Measure" := CreateIndents."Unit of Measure";
                IndentVendorItems."Vendor No." := CreateIndents."Vendor No.";
                IndentVendorItems.Department := CreateIndents.Department;
                IndentVendorItems."Indent Req No" := CreateIndents."Document No.";
                IndentVendorItems."Indent Req Line No" := CreateIndents."Line No.";
                IndentVendorItems."Shortcut Dimension 1 Code" := CreateIndents."Shortcut Dimension 1 Code";//B2BPAV
                IndentVendorItems."Shortcut Dimension 2 Code" := CreateIndents."Shortcut Dimension 2 Code";//B2BPAV
                IndentVendorItems.INSERT;
            UNTIL CreateIndents.NEXT = 0;
    end;

    procedure CreateEnquiries(var CreateIndentsEnquiry: Record 50038; var Vendor: Record 23; var Noseries: Code[20]);
    var
        IndentVendorItems: Record 50043;
        IndentVendorEnquiry: Record 50043;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        NoSeriesMgt: Codeunit 396;
        PPSetup: Record 312;
        CreateIndents2: Record 50038;
        IndentLine: Record 50037;
        Item2: Record 27;
        ItemUnitofMeasure: Record 5404;
        BaseUOMQtyMeasure: Decimal;
        PurchUOMQtyMeasure: Decimal;
    begin
        CreateIndents4.COPYFILTERS(CreateIndentsEnquiry);
        InsertIndentItemvendor(CreateIndents4, Vendor);
        IndentVendorItems.SETRANGE(Check, FALSE);
        IF IndentVendorItems.FIND('-') THEN
            REPEAT
                IndentVendorEnquiry.SETRANGE("Vendor No.", IndentVendorItems."Vendor No.");
                IndentVendorEnquiry.SETRANGE("Location Code", IndentVendorItems."Location Code");
                IF IndentVendorEnquiry.FIND('-') THEN BEGIN
                    PurchaseHeader.INIT;
                    PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Enquiry;
                    PPSetup.GET;
                    PurchaseHeader."No." := NoSeriesMgt.GetNextNo(Noseries, WORKDATE, TRUE);
                    PurchaseHeader.Insert(true);
                    PurchaseHeader."Buy-from Vendor No." := IndentVendorEnquiry."Vendor No.";
                    PurchaseHeader.VALIDATE(PurchaseHeader."Buy-from Vendor No.");
                    PurchaseHeader."Due Date" := IndentVendorEnquiry."Due Date";
                    PurchaseHeader."Expected Receipt Date" := IndentVendorEnquiry."Due Date";
                    PurchaseHeader.VALIDATE("Expected Receipt Date");
                    PurchaseHeader.VALIDATE("Due Date");
                    PurchaseHeader."Order Date" := WORKDATE;
                    PurchaseHeader."Document Date" := WORKDATE;
                    PurchaseHeader."Indent Requisition No" := IndentVendorEnquiry."Indent Req No";
                    ;
                    //PurchaseHeader.VALIDATE("Location Code", IndentVendorEnquiry."Location Code");//B2BESGOn19May2022
                    PurchaseHeader."Location Code" := IndentVendorEnquiry."Location Code";
                    PurchaseHeader.Validate("Shortcut Dimension 1 Code", IndentVendorEnquiry."Shortcut Dimension 1 Code");//B2BPAV
                    PurchaseHeader.Validate("Shortcut Dimension 2 Code", IndentVendorEnquiry."Shortcut Dimension 2 Code");//B2BPAV
                    PurchaseHeader.Modify(true);
                    REPEAT
                        PurchaseLine.INIT;
                        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Enquiry;
                        PurchaseLine."Document No." := PurchaseHeader."No.";
                        PurchaseLine."Line No." := PurchaseLine."Line No." + 10000;
                        PurchaseLine."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                        PurchaseLine.VALIDATE("Buy-from Vendor No.");
                        //ETVPO1.1 >>
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::Item then
                            PurchaseLine.Type := PurchaseLine.Type::Item;
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::"Fixed Assets" then
                            PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset";
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::"G/L Account" then
                            PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                        //ETVPO1.1 <<
                        PurchaseLine."No." := IndentVendorEnquiry."Item No.";

                        PurchaseLine.VALIDATE(PurchaseLine."No.");
                        PurchaseLine."Variant Code" := IndentVendorEnquiry."Variant Code";
                        IF Item2.GET(PurchaseLine."No.") THEN;
                        IF Item2."Purch. Unit of Measure" <> IndentVendorEnquiry."Unit Of Measure" THEN BEGIN
                            ItemUnitofMeasure.RESET;
                            IF ItemUnitofMeasure.GET(PurchaseLine."No.", Item2."Purch. Unit of Measure") THEN
                                PurchUOMQtyMeasure := ItemUnitofMeasure."Qty. per Unit of Measure";
                            ItemUnitofMeasure.RESET;
                            IF ItemUnitofMeasure.GET(PurchaseLine."No.", IndentVendorEnquiry."Unit Of Measure") THEN
                                BaseUOMQtyMeasure := ItemUnitofMeasure."Qty. per Unit of Measure";
                            if PurchUOMQtyMeasure <> 0 then
                                IndentVendorEnquiry.Quantity := IndentVendorEnquiry.Quantity / PurchUOMQtyMeasure;
                        END;
                        PurchaseLine.VALIDATE(Quantity, IndentVendorEnquiry.Quantity);
                        //PurchaseLine.VALIDATE("Order Quantity",IndentVendorEnquiry.Quantity);
                        PurchaseLine."Indent No." := IndentVendorEnquiry."Indent No.";
                        PurchaseLine."Indent Line No." := IndentVendorEnquiry."Indent Line No.";
                        //PurchaseLine."Indent No." := IndentVendorEnquiry."Indent Req No";
                        //PurchaseLine."Indent Line No." := IndentVendorEnquiry."Indent Req Line No";
                        PurchaseLine."Indent Req No" := IndentVendorEnquiry."Indent Req No"; //B2BMSOn21Sep2022
                        PurchaseLine."Indent Req Line No" := IndentVendorEnquiry."Indent Req Line No"; //B2BMSOn21Sep2022
                        PurchaseLine."Location Code" := IndentVendorEnquiry."Location Code";
                        //PurchaseLine.VALIDATE("Location Code");//B2BESGOn19May2022
                        // PurchaseLine."Shortcut Dimension 1 Code" := IndentVendorEnquiry."Project No.";
                        // PurchaseLine."Shortcut Dimension 2 Code" := IndentVendorEnquiry.Department;
                        PurchaseLine."Shortcut Dimension 1 Code" := IndentVendorEnquiry."Shortcut Dimension 1 Code";
                        PurchaseLine."Shortcut Dimension 2 Code" := IndentVendorEnquiry."Shortcut Dimension 2 Code";
                        CreateIndents4.RESET;
                        CreateIndents4.COPYFILTERS(CreateIndentsEnquiry);
                        IF CreateIndents4.FINDFIRST THEN
                            REPEAT
                                CreateIndents4."Document Type" := PurchaseLine."Document Type"::Enquiry.AsInteger();
                                CreateIndents4."Order No" := PurchaseLine."Document No.";
                                CreateIndents4.MODIFY;
                            UNTIL CreateIndents4.NEXT = 0;
                        PurchaseLine.INSERT;
                        IndentVendorEnquiry.Check := TRUE;
                        IndentVendorEnquiry.MODIFY;
                    UNTIL IndentVendorEnquiry.NEXT = 0;
                END;
            UNTIL IndentVendorItems.NEXT = 0;
    end;

    procedure CreateQuotes(var CreateIndentsQuotes: Record 50038; var Vendor: Record 23; var Noseries: Code[20]);
    var
        IndentVendorItems: Record 50043;
        IndentVendorEnquiry: Record 50043;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PPSetup: Record 312;
        CreateIndents2: Record 50038;
        IndentLine: Record 50037;
        Item2: Record 27;
        ItemUnitofMeasure: Record 5404;
        BaseUOMQtyMeasure: Decimal;
        PurchUOMQtyMeasure: Decimal;
    begin
        CreateIndents4.COPYFILTERS(CreateIndentsQuotes);
        InsertIndentItemvendor(CreateIndents4, Vendor);
        IndentVendorItems.RESET;
        IndentVendorItems.SETRANGE(Check, FALSE);
        IF IndentVendorItems.FIND('-') THEN
            REPEAT
                IndentVendorEnquiry.SETRANGE("Vendor No.", IndentVendorItems."Vendor No.");
                IndentVendorEnquiry.SETRANGE("Location Code", IndentVendorItems."Location Code");
                IF IndentVendorEnquiry.FIND('-') THEN BEGIN
                    PurchaseHeader.INIT;
                    PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Quote;
                    PPSetup.GET;
                    PurchaseHeader."No." := NoSeriesMgt.GetNextNo(Noseries, WORKDATE, TRUE);
                    PurchaseHeader.INSERT(true);
                    //MESSAGE('Purchaser Quote No %1 ', PurchaseHeader."No.");
                    PurchaseHeader."Buy-from Vendor No." := IndentVendorEnquiry."Vendor No.";
                    PurchaseHeader.VALIDATE(PurchaseHeader."Buy-from Vendor No.");
                    PurchaseHeader."Order Date" := WORKDATE;
                    PurchaseHeader."Document Date" := WORKDATE;
                    PurchaseHeader.VALIDATE("Location Code");
                    PurchaseHeader."Due Date" := IndentVendorEnquiry."Due Date";
                    PurchaseHeader."Expected Receipt Date" := IndentVendorEnquiry."Due Date";
                    PurchaseHeader."Indent Requisition No" := IndentVendorEnquiry."Indent Req No";
                    //Message('Indent Header %1', CreateIndentsQuotes."Shortcut Dimension 1 Code");
                    PurchaseHeader.Validate("Shortcut Dimension 1 Code", IndentVendorEnquiry."Shortcut Dimension 1 Code"); //B2BPAV
                    PurchaseHeader.Validate("Shortcut Dimension 2 Code", IndentVendorEnquiry."Shortcut Dimension 2 Code"); //B2BPAV
                    PurchaseHeader.VALIDATE("Expected Receipt Date");
                    PurchaseHeader.VALIDATE("Due Date");
                    PurchaseHeader.Modify(true);
                    REPEAT
                        PurchaseLine.INIT;
                        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Quote;
                        PurchaseLine."Document No." := PurchaseHeader."No.";
                        PurchaseLine."Line No." := PurchaseLine."Line No." + 10000;
                        PurchaseLine."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                        PurchaseLine.VALIDATE("Buy-from Vendor No.");

                        //ETVPO1.1 >>
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::Item then
                            PurchaseLine.Type := PurchaseLine.Type::Item;
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::"Fixed Assets" then
                            PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset";
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::"G/L Account" then
                            PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                        //ETVPO1.1 <<

                        PurchaseLine."No." := IndentVendorEnquiry."Item No.";
                        PurchaseLine.VALIDATE(PurchaseLine."No.");
                        PurchaseLine.VALIDATE("Variant Code", IndentVendorEnquiry."Variant Code");
                        IF Item2.GET(PurchaseLine."No.") THEN;
                        IF Item2."Purch. Unit of Measure" <> IndentVendorEnquiry."Unit Of Measure" THEN BEGIN
                            ItemUnitofMeasure.RESET;
                            IF ItemUnitofMeasure.GET(PurchaseLine."No.", Item2."Purch. Unit of Measure") THEN
                                PurchUOMQtyMeasure := ItemUnitofMeasure."Qty. per Unit of Measure";
                            ItemUnitofMeasure.RESET;
                            IF ItemUnitofMeasure.GET(PurchaseLine."No.", IndentVendorEnquiry."Unit Of Measure") THEN
                                BaseUOMQtyMeasure := ItemUnitofMeasure."Qty. per Unit of Measure";
                            IndentVendorEnquiry.Quantity := IndentVendorEnquiry.Quantity / PurchUOMQtyMeasure;
                        END;
                        PurchaseLine.VALIDATE(Quantity, IndentVendorEnquiry.Quantity);
                        PurchaseLine."Indent No." := IndentVendorEnquiry."Indent No.";
                        PurchaseLine."Indent Line No." := IndentVendorEnquiry."Indent Line No.";
                        //PurchaseLine."Indent No." := IndentVendorEnquiry."Indent Req No";
                        //PurchaseLine."Indent Line No." := IndentVendorEnquiry."Indent Req Line No";
                        PurchaseLine."Indent Req No" := IndentVendorEnquiry."Indent Req No"; //B2BMSOn21Sep2022
                        PurchaseLine."Indent Req Line No" := IndentVendorEnquiry."Indent Req Line No"; //B2BMSOn21Sep2022
                        //PurchaseLine."Shortcut Dimension 1 Code" := IndentVendorEnquiry."Project No.";
                        //PurchaseLine."Shortcut Dimension 2 Code" := IndentVendorEnquiry.Department;
                        PurchaseLine."Location Code" := IndentVendorEnquiry."Location Code";
                        PurchaseLine.VALIDATE("Location Code");
                        CreateIndents4.RESET;
                        CreateIndents4.COPYFILTERS(CreateIndentsQuotes);
                        IF CreateIndents4.FIND('-') THEN
                            REPEAT
                                CreateIndents4."Document Type" := PurchaseLine."Document Type"::Quote.AsInteger();
                                CreateIndents4."Order No" := PurchaseLine."Document No.";
                                CreateIndents4.MODIFY;
                            UNTIL CreateIndents4.NEXT = 0;
                        PurchaseLine.INSERT;
                        // Message('Indent Line %1', IndentVendorEnquiry."Shortcut Dimension 1 Code");
                        PurchaseLine.Validate("Shortcut Dimension 1 Code", IndentVendorEnquiry."Shortcut Dimension 1 Code");//B2BPAV
                        PurchaseLine.Validate("Shortcut Dimension 2 Code", IndentVendorEnquiry."Shortcut Dimension 2 Code");//B2BPAV
                        PurchaseLine.Modify();
                        IndentVendorEnquiry.Check := TRUE;
                        IndentVendorEnquiry.MODIFY;
                    UNTIL IndentVendorEnquiry.NEXT = 0;
                END;
            UNTIL IndentVendorItems.NEXT = 0;
    end;

    procedure CreateOrder(var CreateIndentsQuotes: Record 50038; var Vendor: Record 23; var Noseries: Code[20]);
    var
        IndentVendorItems: Record 50043;
        IndentVendorEnquiry: Record 50043;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PPSetup: Record 312;
        CreateIndents2: Record 50038;
        IndentLine: Record 50037;
        Item2: Record 27;
        ItemUnitofMeasure: Record 5404;
        BaseUOMQtyMeasure: Decimal;
        PurchUOMQtyMeasure: Decimal;
    begin
        CreateIndents4.COPYFILTERS(CreateIndentsQuotes);
        InsertIndentItemvendor(CreateIndents4, Vendor);
        IndentVendorItems.RESET;
        IndentVendorItems.SETRANGE(Check, FALSE);
        IF IndentVendorItems.FIND('-') THEN
            REPEAT
                IndentVendorEnquiry.SETRANGE("Vendor No.", IndentVendorItems."Vendor No.");
                IndentVendorEnquiry.SETRANGE("Location Code", IndentVendorItems."Location Code");
                IF IndentVendorEnquiry.FIND('-') THEN BEGIN
                    PurchaseHeader.INIT;
                    PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
                    PPSetup.GET;
                    PurchaseHeader."No." := NoSeriesMgt.GetNextNo(Noseries, WORKDATE, TRUE);
                    MESSAGE('Purchaser Order No %1 ', PurchaseHeader."No.");
                    PurchaseHeader."Buy-from Vendor No." := IndentVendorEnquiry."Vendor No.";
                    PurchaseHeader.VALIDATE(PurchaseHeader."Buy-from Vendor No.");
                    PurchaseHeader."Order Date" := WORKDATE;
                    PurchaseHeader."Document Date" := WORKDATE;
                    PurchaseHeader.VALIDATE("Location Code");
                    PurchaseHeader."Due Date" := IndentVendorEnquiry."Due Date";
                    PurchaseHeader."Expected Receipt Date" := IndentVendorEnquiry."Due Date";
                    PurchaseHeader.VALIDATE("Expected Receipt Date");
                    PurchaseHeader.VALIDATE("Due Date");
                    PurchaseHeader."Indent Requisition No" := IndentVendorEnquiry."Indent Req No";
                    PurchaseHeader.Validate("Shortcut Dimension 1 Code", IndentVendorEnquiry."Shortcut Dimension 1 Code");
                    PurchaseHeader.Validate("Shortcut Dimension 2 Code", IndentVendorEnquiry."Shortcut Dimension 2 Code");
                    PurchaseHeader.INSERT;
                    REPEAT
                        PurchaseLine.INIT;
                        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                        PurchaseLine."Document No." := PurchaseHeader."No.";
                        PurchaseLine."Line No." := PurchaseLine."Line No." + 10000;
                        PurchaseLine."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                        PurchaseLine.VALIDATE("Buy-from Vendor No.");

                        //ETVPO1.1 >>
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::Item then
                            PurchaseLine.Type := PurchaseLine.Type::Item;
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::"Fixed Assets" then
                            PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset";
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::"G/L Account" then
                            PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                        //ETVPO1.1 <<

                        PurchaseLine."No." := IndentVendorEnquiry."Item No.";
                        PurchaseLine.VALIDATE(PurchaseLine."No.");
                        PurchaseLine.VALIDATE("Variant Code", IndentVendorEnquiry."Variant Code");
                        IF Item2.GET(PurchaseLine."No.") THEN;
                        /*
                        IF Item2."Purch. Unit of Measure"<>IndentVendorEnquiry."Unit of Measure" THEN BEGIN
                          ItemUnitofMeasure.RESET;
                          IF ItemUnitofMeasure.GET(PurchaseLine."No.",Item2."Purch. Unit of Measure") THEN
                            PurchUOMQtyMeasure:=ItemUnitofMeasure."Qty. per Unit of Measure";
                          ItemUnitofMeasure.RESET;
                          IF ItemUnitofMeasure.GET(PurchaseLine."No.",IndentVendorEnquiry."Unit of Measure") THEN
                            BaseUOMQtyMeasure:=ItemUnitofMeasure."Qty. per Unit of Measure";
                            IndentVendorEnquiry.Quantity:=IndentVendorEnquiry.Quantity/PurchUOMQtyMeasure;
                        END;
                        */
                        //PurchaseLine.VALIDATE("Order Quantity",IndentVendorEnquiry.Quantity);
                        PurchaseLine.VALIDATE(Quantity, IndentVendorEnquiry.Quantity);
                        PurchaseLine."Indent No." := IndentVendorEnquiry."Indent No.";
                        PurchaseLine."Indent Line No." := IndentVendorEnquiry."Indent Line No.";
                        //PurchaseLine."Indent No." := IndentVendorEnquiry."Indent Req No";
                        //PurchaseLine."Indent Line No." := IndentVendorEnquiry."Indent Req Line No";
                        PurchaseLine."Indent Req No" := IndentVendorEnquiry."Indent Req No"; //B2BMSOn21Sep2022
                        PurchaseLine."Indent Req Line No" := IndentVendorEnquiry."Indent Req Line No"; //B2BMSOn21Sep2022
                        PurchaseHeader.Validate("Shortcut Dimension 1 Code", IndentVendorEnquiry."Shortcut Dimension 1 Code");
                        PurchaseHeader.Validate("Shortcut Dimension 2 Code", IndentVendorEnquiry."Shortcut Dimension 2 Code");
                        PurchaseLine."Location Code" := IndentVendorEnquiry."Location Code";
                        PurchaseLine.VALIDATE("Location Code");
                        CreateIndents4.RESET;
                        CreateIndents4.COPYFILTERS(CreateIndentsQuotes);
                        IF CreateIndents4.FIND('-') THEN
                            REPEAT
                                CreateIndents4."Document Type" := PurchaseLine."Document Type"::Order.AsInteger();
                                CreateIndents4."Order No" := PurchaseLine."Document No.";
                                CreateIndents4.MODIFY;
                            UNTIL CreateIndents4.NEXT = 0;
                        PurchaseLine.INSERT;
                        IndentVendorEnquiry.Check := TRUE;
                        IndentVendorEnquiry.MODIFY;
                    UNTIL IndentVendorEnquiry.NEXT = 0;
                END;
            UNTIL IndentVendorItems.NEXT = 0;

    end;

    procedure InsertQuotationLines(var RFQNumber: Code[20]);
    var
        PurchaseHeader: Record 38;
        QuoteCompare: Record 50041;
        PurchaseLine: Record 39;
        //Structure: Record 13795;
        Amount: Decimal;
        QuoteCompareAmount: Record 50041;
        PreviousItem: Code[20];
        LeastLineAmount: Decimal;
        QuoteCompare1: Record 50041;
        PurchaseSetup: Record 312;
        TotalWeightage: Decimal;
        PaymentTerms: Record 3;
        QuoteCompare2: Record 50041;
        MaxPayment: Decimal;
        Text0010: Label 'Item Price should  not be blank in Quotation No. %1';
        ColourCode: Code[20];
        Text0011: Label 'Quantity should  not be Zero in Quotation No. %1';
        PreviousItemSize: Code[20];
    begin
        QuoteCompare.DELETEALL;
        PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Quote);
        PurchaseHeader.SETRANGE("RFQ No.", RFQNumber);
        IF PurchaseHeader.FIND('-') THEN
            REPEAT
                QuoteCompare.INIT;
                QuoteCompare."RFQ No." := PurchaseHeader."RFQ No.";
                QuoteCompare."Quote No." := PurchaseHeader."No.";
                QuoteCompare."Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                QuoteCompare."Vendor Name" := PurchaseHeader."Buy-from Vendor Name";
                QuoteCompare."Item No." := '';
                QuoteCompare.Description := PurchaseHeader."Buy-from Vendor Name";
                QuoteCompare.Quantity := 0;
                QuoteCompare.Rate := 0;
                QuoteCompare.Amount := 0;
                QuoteCompare."Payment Term Code" := '';
                QuoteCompare."Parent Quote No." := '';
                QuoteCompare."Line Amount" := 0;
                QuoteCompare."Delivery Date" := 0D;
                QuoteCompare.Level := 0;
                QuoteCompare."Approval Status" := PurchaseHeader."Approval Status";
                QuoteCompare."Line No." := QuoteCompare."Line No." + 10000;
                //QuoteCompare.Structure := PurchaseHeader.Structure;//Balu
                QuoteCompare."Location Code" := PurchaseHeader."Location Code";

                QuoteCompare.INSERT;
                Amount := 0;
                PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseHeader."Document Type");
                PurchaseLine.SETRANGE(PurchaseLine."Document No.", PurchaseHeader."No.");
                //PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item); //ETVPO1.1
                IF PurchaseLine.FIND('-') THEN
                    REPEAT
                        QuoteCompare."RFQ No." := PurchaseHeader."RFQ No.";
                        QuoteCompare."Quote No." := '';
                        QuoteCompare."Vendor No." := '';
                        QuoteCompare."Vendor Name" := '';

                        QuoteCompare."Item No." := PurchaseLine."No.";
                        QuoteCompare.Description := PurchaseLine.Description;

                        IF PurchaseLine.Quantity = 0 THEN
                            ERROR(Text0011, PurchaseLine."Document No.");
                        QuoteCompare.Quantity := PurchaseLine.Quantity;
                        QuoteCompare.Rate := PurchaseLine."Direct Unit Cost";
                        IF PurchaseLine."Direct Unit Cost" = 0 THEN
                            ERROR(Text0010, PurchaseLine."Document No.");
                        QuoteCompare.Amount := PurchaseLine."Direct Unit Cost" * PurchaseLine.Quantity;
                        QuoteCompare."Payment Term Code" := PurchaseHeader."Payment Terms Code";
                        QuoteCompare."Delivery Date" := PurchaseHeader."Due Date";
                        QuoteCompare."Indent No." := PurchaseLine."Indent No.";
                        QuoteCompare."Indent Line No." := PurchaseLine."Indent Line No.";
                        QuoteCompare."Indent Req No" := PurchaseLine."Indent Req No";
                        QuoteCompare."Indent Req Line No" := PurchaseLine."Indent Req Line No";
                        QuoteCompare."Location Code" := PurchaseHeader."Location Code";
                        QuoteCompare."Line No." := QuoteCompare."Line No." + 10000;
                        QuoteCompare."Document Date" := PurchaseHeader."Document Date";
                        QuoteCompare."Due Date" := PurchaseHeader."Due Date";
                        QuoteCompare."Requested Receipt Date" := PurchaseHeader."Requested Receipt Date";
                        QuoteCompare."Parent Vendor" := PurchaseHeader."Buy-from Vendor No.";
                        PurchaseSetup.GET;

                        IF PurchaseSetup."Delivery Required" = TRUE THEN
                            QuoteCompare.Delivery
                             := CalculateDelivery(PurchaseLine."Buy-from Vendor No.", PurchaseLine."No.", PurchaseHeader."RFQ No.");
                        IF PurchaseSetup."Quality Required" = TRUE THEN
                            QuoteCompare.Quality := CalculateQuality(PurchaseLine."Buy-from Vendor No.", PurchaseLine."No.", PurchaseHeader."RFQ No.")
                  ;

                        QuoteCompare.Structure := '';
                        QuoteCompare."Line Amount" := 0;
                        QuoteCompare.Level := 1;
                        QuoteCompare."Parent Quote No." := PurchaseLine."Document No.";

                        IF PurchaseSetup."Payment Terms Required" = TRUE THEN BEGIN
                            IF QuoteCompare."Payment Term Code" = '' THEN
                                ERROR(Text006, QuoteCompare."Parent Quote No.");
                            IF PaymentTerms.GET(QuoteCompare."Payment Term Code") THEN BEGIN
                                PurchaseSetup.GET;
                                QuoteCompare.Rating := PaymentTerms.Rating;
                                IF QuoteCompare.Rating = 0 THEN
                                    ERROR(Text005, QuoteCompare."Payment Term Code");
                            END;
                        END;

                        QuoteCompare."Variant Code" := PurchaseLine."Variant Code";
                        //QuoteCompare."P & F" := PurchaseLine."Amount Added to Inventory";//Balu
                        Item.GET(PurchaseLine."No.");
                        /*IF Item."Excise Accounting Type" = Item."Excise Accounting Type"::"With CENVAT" THEN
                            QuoteCompare."Excise Duty" := 0
                        ELSE
                            QuoteCompare."Excise Duty" := PurchaseLine."Excise Amount";*///Balu
                        IF Item."Costing Method" = Item."Costing Method"::Standard THEN
                            QuoteCompare."Standard Price" := Item."Standard Cost";
                        QuoteCompare."Last Direct Cost" := Item."Last Direct Cost";
                        //QuoteCompare."Sales Tax" := PurchaseLine."Tax Amount";//Balu
                        QuoteCompare.Discount := (PurchaseLine."Line Discount Amount" + PurchaseLine."Inv. Discount Amount");
                        //QuoteCompare.Amount := (PurchaseLine.Quantity * PurchaseLine."Direct Unit Cost") + QuoteCompare."P & F" +
                        //PurchaseLine."Tax Amount" - QuoteCompare.Discount;//Balu
                        Amount := Amount + QuoteCompare.Amount;
                        QuoteCompareAmount.SETRANGE("RFQ No.", QuoteCompare."RFQ No.");
                        QuoteCompareAmount.SETRANGE("Quote No.", PurchaseLine."Document No.");
                        QuoteCompareAmount.SETRANGE(QuoteCompareAmount.Level, 0);
                        IF QuoteCompareAmount.FIND('-') THEN BEGIN
                            QuoteCompareAmount."Total Amount" := Amount;
                            QuoteCompareAmount.MODIFY;
                        END;
                        QuoteCompare.Department := PurchaseLine."Shortcut Dimension 2 Code";
                        QuoteCompare.INSERT;
                    UNTIL PurchaseLine.NEXT = 0;
            UNTIL PurchaseHeader.NEXT = 0;

        PurchaseSetup.GET;
        QuoteCompare.RESET;
        QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
        QuoteCompare.SETFILTER("Item No.", '<>%1', '');
        QuoteCompare.SETCURRENTKEY("Item No.");
        IF QuoteCompare.FIND('-') THEN
            REPEAT
                IF PreviousItem <> QuoteCompare."Item No." THEN BEGIN
                    LeastLineAmount := 0;
                    QuoteCompare1.RESET;
                    QuoteCompare1.SETRANGE("RFQ No.", RFQNumber);
                    QuoteCompare1.SETFILTER("Item No.", '<>%1', '');
                    QuoteCompare1.SETRANGE("Item No.", QuoteCompare."Item No.");
                    QuoteCompare1.SETRANGE("Variant Code", QuoteCompare."Variant Code");
                    IF QuoteCompare1.FIND('-') THEN BEGIN
                        LeastLineAmount := QuoteCompare1.Amount;
                        REPEAT
                            IF LeastLineAmount > QuoteCompare1.Amount THEN
                                LeastLineAmount := QuoteCompare1.Amount;
                        UNTIL QuoteCompare1.NEXT = 0;
                        IF QuoteCompare1.FIND('-') THEN
                            REPEAT
                                QuoteCompare1.Price := (LeastLineAmount / QuoteCompare1.Amount * 100) * PurchaseSetup."Price Weightage" / 100;
                                QuoteCompare1.MODIFY;
                            UNTIL QuoteCompare1.NEXT = 0;
                    END;
                END ELSE
                    PreviousItem := QuoteCompare."Item No.";
            UNTIL QuoteCompare.NEXT = 0;


        PurchaseSetup.GET;
        IF PurchaseSetup."Payment Terms Required" = TRUE THEN BEGIN
            QuoteCompare.RESET;
            QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
            QuoteCompare.SETFILTER("Item No.", '<>%1', '');
            QuoteCompare.SETCURRENTKEY("Item No.");
            IF QuoteCompare.FIND('-') THEN
                REPEAT
                    IF PreviousItem <> QuoteCompare."Item No." THEN BEGIN
                        LeastLineAmount := 0;
                        QuoteCompare1.RESET;
                        QuoteCompare1.SETRANGE("RFQ No.", RFQNumber);
                        QuoteCompare1.SETFILTER("Item No.", '<>%1', '');
                        QuoteCompare1.SETRANGE("Item No.", QuoteCompare."Item No.");
                        IF QuoteCompare1.FIND('-') THEN BEGIN
                            MaxPayment := QuoteCompare1.Rating;
                            REPEAT
                                IF MaxPayment < QuoteCompare1.Rating THEN
                                    MaxPayment := QuoteCompare1.Rating;
                            UNTIL QuoteCompare1.NEXT = 0;
                            IF QuoteCompare1.FIND('-') THEN
                                REPEAT

                                    QuoteCompare1."Payment Terms"
                                    := (QuoteCompare1.Rating / MaxPayment * 100) * PurchaseSetup."Payment Terms Weightage" / 100;
                                    QuoteCompare1.MODIFY;
                                UNTIL QuoteCompare1.NEXT = 0;
                        END;
                    END ELSE
                        PreviousItem := QuoteCompare."Item No.";
                UNTIL QuoteCompare.NEXT = 0;
        END;
        QuoteCompare.RESET;
        QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
        QuoteCompare.SETFILTER("Item No.", '<>%1', '');
        QuoteCompare.SETCURRENTKEY("Item No.");
        IF QuoteCompare.FIND('-') THEN
            REPEAT
                QuoteCompare."Total Weightage" := QuoteCompare.Price + QuoteCompare.Delivery + QuoteCompare.Quality +
                                                   QuoteCompare."Payment Terms";
                QuoteCompare.MODIFY;
            UNTIL QuoteCompare.NEXT = 0;


        //For Selecting the best vendor
        PreviousItem := '';
        QuoteCompare.RESET;
        QuoteCompare.SETCURRENTKEY("RFQ No.", "Item No.", "Variant Code");
        QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
        QuoteCompare.SETFILTER("Item No.", '<>%1', '');
        IF QuoteCompare.FIND('-') THEN
            REPEAT
                IF (PreviousItem <> QuoteCompare."Item No.") OR (ColourCode <> QuoteCompare."Variant Code")
               THEN BEGIN
                    PreviousItem := QuoteCompare."Item No.";
                    ColourCode := QuoteCompare."Variant Code";
                    QuoteCompare1.RESET;
                    QuoteCompare1.SETRANGE("RFQ No.", RFQNumber);
                    QuoteCompare1.SETRANGE("Item No.", QuoteCompare."Item No.");
                    QuoteCompare1.SETRANGE("Variant Code", QuoteCompare."Variant Code");
                    IF QuoteCompare1.FIND('-') THEN BEGIN
                        TotalWeightage := QuoteCompare1."Total Weightage";
                        REPEAT
                            IF TotalWeightage < QuoteCompare1."Total Weightage" THEN
                                TotalWeightage := QuoteCompare1."Total Weightage";
                        UNTIL QuoteCompare1.NEXT = 0;
                    END;
                    QuoteCompare2.RESET;
                    QuoteCompare2.SETRANGE("RFQ No.", RFQNumber);
                    QuoteCompare2.SETRANGE("Item No.", QuoteCompare."Item No.");
                    QuoteCompare2.SETRANGE("Variant Code", QuoteCompare."Variant Code");
                    QuoteCompare2.SETRANGE("Total Weightage", TotalWeightage);
                    IF QuoteCompare2.FIND('-') THEN BEGIN
                        QuoteCompare2."Carry Out Action" := TRUE;
                        QuoteCompare2.MODIFY;
                    END;
                END;
            UNTIL QuoteCompare.NEXT = 0;
    end;

    procedure InsertQuotationLinesNew(var RFQNumber: Code[20]; QuotComp: record QuotCompHdr);
    var
        QuoteCompare: Record "Quotation Comparison Test";
        PurchaseLine: Record "Purchase Line";
        QuoteCompare1: Record "Quotation Comparison Test";
        PurchaseSetup: Record 312;
        QuoteCompareAmount: Record "Quotation Comparison Test";
        PaymentTerms: Record 3;
        QuoteCompare2: Record "Quotation Comparison Test";
        PreviousItem: Code[20];
        LeastLineAmount: Decimal;
        TotalWeightage: Decimal;
        Amount: Decimal;
        MaxPayment: Decimal;
        Text0010Lbl: Label 'Item Price should  not be blank in Quotation No. %1';
        ColourCode: Code[20];
        Text0011Lbl: Label 'Quantity should  not be Zero in Quotation No. %1';

        Text005Lbl: Label '"Rating of payment term code  ''%1'' Should not be zero "';
        Text006Lbl: Label 'Payment Term Code  should not be blank in Quotation No: %1';
        Line: Integer;
        QuoComparsn: Record "Quotation Comparison Test";
        Lnum: integer;
        Linum: integer;
        Quocom: Record "Quotation Comparison Test";
        Vend: Record Vendor;
        PurchaseHeader: Record "Purchase Header";
    begin
        clear(TotalWeightage);
        PurchaseHeader.RESET();
        PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Quote);
        PurchaseHeader.SETRANGE("RFQ No.", RFQNumber);
        IF PurchaseHeader.FIND('-') THEN
            REPEAT
                //PKONJU14 Below Condition Added
                IF Vend.GET(PurchaseHeader."Buy-from Vendor No.") AND (Vend.Blocked = Vend.Blocked::" ") THEN BEGIN
                    QuoteCompare.Reset();
                    QuoteCompare.SetRange("RFQ No.", RFQNumber);
                    IF QuoteCompare.FINDLAST() then
                        Line := QuoteCompare."Line No."
                    else
                        Line := 10000;
                    QuoteCompare.INIT();
                    QuoteCompare."Quot Comp No." := QuotComp."No.";
                    QuoteCompare."RFQ No." := PurchaseHeader."RFQ No.";
                    QuoteCompare."Quote No." := PurchaseHeader."No.";
                    QuoteCompare."Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                    QuoteCompare."Vendor Name" := PurchaseHeader."Buy-from Vendor Name";
                    QuoteCompare."Item No." := '';
                    QuoteCompare.Description := PurchaseHeader."Buy-from Vendor Name";
                    QuoteCompare.Quantity := 0;
                    QuoteCompare.Rate := 0;
                    QuoteCompare.Amount := 0;
                    QuoteCompare."Payment Term Code" := '';
                    QuoteCompare."Parent Quote No." := '';
                    QuoteCompare."Line Amount" := 0;
                    QuoteCompare."Delivery Date" := 0D;
                    QuoteCompare.Level := 0;
                    QuoteCompare."RFQ No." := RFQNumber;
                    QuoteCompare."Line No." := Line + 10000;
                    QuoteCompare."Location Code" := PurchaseHeader."Location Code";
                    QuoteCompare."Parent Quote No." := PurchaseHeader."No.";
                    QuoteCompare.Status := QuoteCompare.Status::Open;
                    QuoteCompare.INSERT();
                    Amount := 0;
                    PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseHeader."Document Type");
                    PurchaseLine.SETRANGE(PurchaseLine."Document No.", PurchaseHeader."No.");
                    //PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);//TEST
                    IF PurchaseLine.FIND('-') THEN
                        REPEAT
                            QuoteCompare."RFQ No." := PurchaseHeader."RFQ No.";
                            QuoteCompare."Quot Comp No." := QuotComp."No.";
                            QuoteCompare."Quote No." := '';
                            QuoteCompare."Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                            QuoteCompare."Vendor Name" := PurchaseHeader."Buy-from Vendor Name";
                            IF PurchaseLine.Type = PurchaseLine.Type::Item then
                                QuoteCompare.Type := QuoteCompare.Type::Item;
                            If PurchaseLine.Type = PurchaseLine.Type::"Fixed Asset" then
                                QuoteCompare.Type := QuoteCompare.Type::"Fixed Assets";
                            If PurchaseLine.Type = PurchaseLine.Type::"G/L Account" then
                                QuoteCompare.Type := QuoteCompare.Type::"G/L Account";
                            QuoteCompare."Item No." := PurchaseLine."No.";
                            QuoteCompare.Description := PurchaseLine.Description;
                            QuoteCompare.Description2 := PurchaseLine."Description 2";
                            IF PurchaseLine.Quantity = 0 THEN
                                ERROR(Text0011Lbl, PurchaseLine."Document No.");
                            QuoteCompare.Quantity := PurchaseLine.Quantity;
                            QuoteCompare.Rate := PurchaseLine."Direct Unit Cost";
                            IF PurchaseLine."Direct Unit Cost" = 0 THEN
                                ERROR(Text0010Lbl, PurchaseLine."Document No.");
                            QuoteCompare."Payment Term Code" := PurchaseHeader."Payment Terms Code";
                            //QuoteCompare."Purc. Req No" := PurchaseLine."Sub Document No.";
                            //QuoteCompare."Purch. Req Line No" := PurchaseLine."Sub Document Line No.";
                            QuoteCompare."Location Code" := PurchaseHeader."Location Code";
                            //QuoteCompare."Material req No.s" := PurchaseLine."Material req No.s";//PK on 24.10.2020
                            QuoteCompare."Shortcut Dimension 1 Code" := PurchaseLine."Shortcut Dimension 1 Code";
                            QuoteCompare."Shortcut Dimension 2 Code" := PurchaseLine."Shortcut Dimension 2 Code";
                            QuoteCompare."Dimension Set ID" := PurchaseLine."Dimension Set ID";
                            QuoteCompare."Line No." := QuoteCompare."Line No." + 10000;
                            QuoteCompare."Document Date" := PurchaseHeader."Document Date";
                            QuoteCompare."Due Date" := PurchaseHeader."Due Date";
                            QuoteCompare."Requested Receipt Date" := PurchaseHeader."Requested Receipt Date";
                            QuoteCompare."Parent Vendor" := PurchaseHeader."Buy-from Vendor No.";
                            QuoteCompare."RFQ No." := RFQNumber;
                            QuoteCompare."Indent No." := PurchaseLine."Indent No.";
                            QuoteCompare."Indent Line No." := PurchaseLine."Indent Line No.";
                            //QuoteCompare."Purc. Req No" := PurchaseLine."Indent Req No";
                            //QuoteCompare."Purch. Req Line No" := PurchaseLine."Indent Req Line No";
                            QuoteCompare."Indent Req. No." := PurchaseLine."Indent Req No";
                            QuoteCompare."Indent Req. Line No." := PurchaseLine."Indent Req Line No";

                            //PhaniFeb102021 >>
                            QuoteCompare."VAT Bus. Posting Group" := PurchaseLine."VAT Bus. Posting Group";
                            QuoteCompare."VAT Prod. Posting Group" := PurchaseLine."VAT Prod. Posting Group";
                            //PhaniFeb102021 <<
                            //B2BMSOn06Oct21>>
                            QuoteCompare."Currency Code" := PurchaseLine."Currency Code";
                            //B2BMSOn06Oct21<<
                            PurchaseSetup.GET();

                            IF PurchaseSetup."Delivery Required" = TRUE THEN
                                QuoteCompare.Delivery
                                 := CalculateDelivery(PurchaseLine."Buy-from Vendor No.", PurchaseLine."No.", PurchaseHeader."RFQ No.");
                            IF PurchaseSetup."Quality Required" = TRUE THEN
                                QuoteCompare.Quality := CalculateQuality(PurchaseLine."Buy-from Vendor No.", PurchaseLine."No.", PurchaseHeader."RFQ No.");

                            QuoteCompare.Structure := '';
                            QuoteCompare."Line Amount" := 0;
                            QuoteCompare.Level := 1;
                            QuoteCompare."Parent Quote No." := PurchaseLine."Document No.";

                            IF PurchaseSetup."Payment Terms Required" = TRUE THEN BEGIN
                                IF QuoteCompare."Payment Term Code" = '' THEN
                                    ERROR(Text006Lbl, QuoteCompare."Parent Quote No.");
                                IF PaymentTerms.GET(QuoteCompare."Payment Term Code") THEN BEGIN
                                    QuoteCompare.Rating := PaymentTerms.Rating;
                                    IF QuoteCompare.Rating = 0 THEN
                                        ERROR(Text005Lbl, QuoteCompare."Payment Term Code");
                                END;
                            END;

                            QuoteCompare."Variant Code" := PurchaseLine."Variant Code";
                            QuoteCompare.Amount := (PurchaseLine.Quantity * PurchaseLine."Direct Unit Cost") - QuoteCompare.Discount;
                            Amount := Amount + QuoteCompare.Amount;

                            QuoteCompareAmount.SETRANGE("RFQ No.", QuoteCompare."RFQ No.");
                            QuoteCompareAmount.SETRANGE("Quote No.", PurchaseLine."Document No.");
                            QuoteCompareAmount.SETRANGE(QuoteCompareAmount.Level, 0);
                            IF QuoteCompareAmount.FIND('-') THEN BEGIN
                                QuoteCompareAmount."Total Amount" := Amount;
                                QuoteCompareAmount.MODIFY();
                            END;
                            QuoteCompare.Department := PurchaseLine."Shortcut Dimension 2 Code";

                            QuoteCompare.INSERT();
                        UNTIL PurchaseLine.NEXT() = 0;
                END;
            UNTIL PurchaseHeader.NEXT() = 0;

        PurchaseSetup.GET();
        QuoteCompare.RESET();
        QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
        QuoteCompare.SETFILTER("Item No.", '<>%1', '');
        QuoteCompare.SETCURRENTKEY("Item No.");
        IF QuoteCompare.FIND('-') THEN
            REPEAT
                IF PreviousItem <> QuoteCompare."Item No." THEN BEGIN
                    LeastLineAmount := 0;
                    QuoteCompare1.RESET();
                    QuoteCompare1.SETRANGE("RFQ No.", RFQNumber);
                    QuoteCompare1.SETFILTER("Item No.", '<>%1', '');
                    QuoteCompare1.SETRANGE("Item No.", QuoteCompare."Item No.");
                    QuoteCompare1.SETRANGE("Variant Code", QuoteCompare."Variant Code");
                    IF QuoteCompare1.FIND('-') THEN BEGIN
                        LeastLineAmount := QuoteCompare1.Amount;
                        REPEAT
                            IF LeastLineAmount > QuoteCompare1.Amount THEN
                                LeastLineAmount := QuoteCompare1.Amount;
                        UNTIL QuoteCompare1.NEXT() = 0;
                        IF QuoteCompare1.FIND('-') THEN
                            REPEAT
                                if QuoteCompare1.Amount <> 0 then begin //B2BMS
                                    QuoteCompare1.Price := (LeastLineAmount / QuoteCompare1.Amount * 100) * PurchaseSetup."Price Weightage" / 100;
                                    QuoteCompare1.MODIFY();
                                end; //B2BMS
                            UNTIL QuoteCompare1.NEXT() = 0;
                    END;
                END ELSE
                    PreviousItem := QuoteCompare."Item No.";
            UNTIL QuoteCompare.NEXT() = 0;


        PurchaseSetup.GET();
        IF PurchaseSetup."Payment Terms Required" = TRUE THEN BEGIN
            QuoteCompare.RESET();
            QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
            QuoteCompare.SETFILTER("Item No.", '<>%1', '');
            QuoteCompare.SETCURRENTKEY("Item No.");
            IF QuoteCompare.FIND('-') THEN
                REPEAT
                    IF PreviousItem <> QuoteCompare."Item No." THEN BEGIN
                        LeastLineAmount := 0;
                        QuoteCompare1.RESET();
                        QuoteCompare1.SETRANGE("RFQ No.", RFQNumber);
                        QuoteCompare1.SETFILTER("Item No.", '<>%1', '');
                        QuoteCompare1.SETRANGE("Item No.", QuoteCompare."Item No.");
                        IF QuoteCompare1.FIND('-') THEN BEGIN
                            MaxPayment := QuoteCompare1.Rating;
                            REPEAT
                                IF MaxPayment < QuoteCompare1.Rating THEN
                                    MaxPayment := QuoteCompare1.Rating;
                            UNTIL QuoteCompare1.NEXT() = 0;
                            IF QuoteCompare1.FIND('-') THEN
                                REPEAT
                                    if MaxPayment <> 0 then begin  //B2BMS
                                        QuoteCompare1."Payment Terms"
                                        := (QuoteCompare1.Rating / MaxPayment * 100) * PurchaseSetup."Payment Terms Weightage" / 100;
                                        QuoteCompare1.MODIFY();
                                    end; //B2BMS
                                UNTIL QuoteCompare1.NEXT() = 0;
                        END;
                    END ELSE
                        PreviousItem := QuoteCompare."Item No.";
                UNTIL QuoteCompare.NEXT() = 0;
        END;
        QuoteCompare.RESET();
        QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
        QuoteCompare.SETFILTER("Item No.", '<>%1', '');
        QuoteCompare.SETCURRENTKEY("Item No.");
        IF QuoteCompare.FIND('-') THEN
            REPEAT
                QuoteCompare."Total Weightage" := QuoteCompare.Price + QuoteCompare.Delivery + QuoteCompare.Quality +
                                                   QuoteCompare."Payment Terms";
                QuoteCompare.MODIFY();
            UNTIL QuoteCompare.NEXT() = 0;

        //For Selecting the best vendor
        PreviousItem := '';
        QuoteCompare.RESET();
        QuoteCompare.SETCURRENTKEY("RFQ No.", "Item No.", "Variant Code");
        QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
        QuoteCompare.SETFILTER("Item No.", '<>%1', '');
        IF QuoteCompare.FindSet() THEN
            REPEAT
                IF (PreviousItem <> QuoteCompare."Item No.") OR (ColourCode <> QuoteCompare."Variant Code")
               THEN BEGIN
                    PreviousItem := QuoteCompare."Item No.";
                    ColourCode := QuoteCompare."Variant Code";
                    QuoteCompare1.RESET();
                    QuoteCompare1.SETRANGE("RFQ No.", RFQNumber);
                    QuoteCompare1.SETRANGE("Item No.", QuoteCompare."Item No.");
                    QuoteCompare1.SETRANGE("Variant Code", QuoteCompare."Variant Code");
                    IF QuoteCompare1.FindFirst() THEN begin
                        TotalWeightage := QuoteCompare1."Total Weightage";
                        repeat
                            IF TotalWeightage < QuoteCompare1."Total Weightage" THEN
                                TotalWeightage := QuoteCompare1."Total Weightage";
                        until QuoteCompare1.Next() = 0;
                    END;

                    QuoteCompare2.RESET();
                    QuoteCompare2.SETRANGE("RFQ No.", RFQNumber);
                    QuoteCompare2.SETRANGE("Item No.", QuoteCompare."Item No.");
                    QuoteCompare2.SETRANGE("Variant Code", QuoteCompare."Variant Code");
                    QuoteCompare2.SETRANGE("Total Weightage", TotalWeightage);
                    IF QuoteCompare2.FindSet() THEN
                        //repeat
                        QuoteCompare2."Carry Out Action" := TRUE;
                    QuoteCompare2.MODIFY();
                    //until QuoteCompare2.next = 0;

                END;
            UNTIL QuoteCompare.NEXT() = 0;

        clear(Lnum);

        QuoComparsn.RESET;
        //QuoComparsn.SetCurrentKey("Purch. Req Line No");
        QuoComparsn.SetRange("RFQ No.", RFQNumber);
        QuoComparsn.SetFilter("Item No.", '<>%1', '');
        IF QuoComparsn.FindSet() then
            repeat
                IF (Lnum = 0) THEN BEGIN
                    clear(TotalWeightage);
                    clear(Linum);
                    QuoteCompare2.RESET();
                    QuoteCompare2.SETRANGE("RFQ No.", RFQNumber);
                    // QuoteCompare2.SETRANGE("Purch. Req Line No", QuoComparsn."Purch. Req Line No");
                    IF QuoteCompare2.FindSet() THEN
                        repeat
                            IF (TotalWeightage < QuoteCompare2."Total Weightage") then begin
                                TotalWeightage := QuoteCompare2."Total Weightage";
                                Linum := QuoteCompare2."Line No.";
                            end
                            else begin
                                TotalWeightage := TotalWeightage;
                                Linum := Linum;
                            end;
                        until QuoteCompare2.next = 0;

                    Quocom.RESET;
                    Quocom.SetRange("RFQ No.", RFQNumber);
                    Quocom.SetRange("Line No.", Linum);
                    IF Quocom.FindFirst() THEN begin
                        Quocom."Carry Out Action" := true;
                        Quocom.Modify();
                    end;
                end;
            // Lnum := QuoComparsn."Purch. Req Line No";
            until QuoComparsn.next = 0;
    end;


    procedure CalculateDelivery("VendorNo.": Code[20]; "ItemNo.": Code[20]; RFQNo: Code[20]) Delvery: Decimal;
    var
        PPSetup: Record 312;
        ItemVendor: Record 99;
        ItemVendor2: Record 99;
        MaxDeliveryPoints: Decimal;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        DeliverVal: Decimal; //B2BMSOn20Sep2022
    begin
        MaxDeliveryPoints := 0;
        ItemVendor2.RESET;
        PPSetup.GET;
        PurchaseHeader.RESET;
        PurchaseHeader.SETRANGE(PurchaseHeader."RFQ No.", RFQNo);
        IF PurchaseHeader.FIND('-') THEN
            REPEAT
                PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
                PurchaseLine.SETRANGE("No.", "ItemNo.");
                IF PurchaseLine.FIND('-') THEN
                    REPEAT
                        ItemVendor2.SETRANGE("Vendor No.", PurchaseLine."Buy-from Vendor No.");
                        ItemVendor2.SETRANGE("Item No.", "ItemNo.");
                        IF ItemVendor2.FIND('-') THEN BEGIN
                            REPEAT
                                ItemVendor2.CALCFIELDS("Total Qty. Supplied");
                                IF (ItemVendor2."Total Qty. Supplied" <> 0) AND (ItemVendor2."Qty. Supplied With in DueDate" <> 0) THEN BEGIN
                                    ItemVendor2."Avg. Delivery Rating" := ItemVendor2."Qty. Supplied With in DueDate" / ItemVendor2."Total Qty. Supplied";
                                    ItemVendor2.MODIFY;
                                    IF MaxDeliveryPoints < ItemVendor2."Avg. Delivery Rating" THEN
                                        MaxDeliveryPoints := ItemVendor2."Avg. Delivery Rating";
                                END ELSE BEGIN
                                    PPSetup.GET;
                                    IF PPSetup."Default Delivery Rating" > MaxDeliveryPoints THEN
                                        MaxDeliveryPoints := PPSetup."Default Delivery Rating";
                                END;
                            UNTIL ItemVendor2.NEXT = 0
                        END ELSE BEGIN
                            PPSetup.GET;
                            IF PPSetup."Default Delivery Rating" > MaxDeliveryPoints THEN
                                MaxDeliveryPoints := PPSetup."Default Delivery Rating";
                        END;
                    UNTIL PurchaseLine.NEXT = 0;
            UNTIL PurchaseHeader.NEXT = 0;


        ItemVendor.SETRANGE("Vendor No.", "VendorNo.");
        ItemVendor.SETRANGE("Item No.", "ItemNo.");
        IF ItemVendor.FIND('-') THEN BEGIN
            ItemVendor.CALCFIELDS("Total Qty. Supplied");
            IF ItemVendor."Qty. Supplied With in DueDate" = 0 THEN BEGIN
                if MaxDeliveryPoints <> 0 then
                    EXIT(((PPSetup."Default Delivery Rating" / MaxDeliveryPoints)) * PPSetup."Delivery Weightage")
            END ELSE
                IF (ItemVendor."Total Qty. Supplied" <> 0) AND (ItemVendor."Qty. Supplied With in DueDate" <> 0) THEN BEGIN
                    EXIT(((ItemVendor."Avg. Delivery Rating" / MaxDeliveryPoints)) * PPSetup."Delivery Weightage");
                END;
        END ELSE begin
            //EXIT((PPSetup."Default Delivery Rating" / MaxDeliveryPoints) * PPSetup."Delivery Weightage");
            if MaxDeliveryPoints <> 0 then
                DeliverVal := (PPSetup."Default Delivery Rating" / MaxDeliveryPoints) * PPSetup."Delivery Weightage";
            exit(DeliverVal);
        end;
    end;

    procedure CalculateQuality("VendorNo.": Code[20]; "ItemNo.": Code[20]; RFQNo: Code[20]) Quality: Decimal;
    var
        PPSetup: Record 312;
        ItemVendor: Record 99;
        ItemVendor2: Record 99;
        MaxQualityPoints: Decimal;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
    begin
        /*
        MaxQualityPoints := 0;
        ItemVendor2.RESET;
        PPSetup.GET;
        PurchaseHeader.RESET;
        PurchaseHeader.SETRANGE(PurchaseHeader."RFQ No.",RFQNo);
        IF PurchaseHeader.FIND('-') THEN
           REPEAT
              PurchaseLine.SETRANGE("Document No.",PurchaseHeader."No.");
              PurchaseLine.SETRANGE("No.","ItemNo.");
              IF PurchaseLine.FIND('-') THEN
                REPEAT
                 ItemVendor2.SETRANGE("Vendor No.",PurchaseLine."Buy-from Vendor No.");
                 ItemVendor2.SETRANGE("Item No.","ItemNo.");
                  IF ItemVendor2.FIND('-') THEN BEGIN
                    REPEAT
                      ItemVendor2.CALCFIELDS("Quality Rating","Total Qty. Supplied");
                      IF (ItemVendor2."Total Qty. Supplied" <> 0) AND (ItemVendor2."Quality Rating" <> 0)THEN BEGIN
                         ItemVendor2."Avg. Quality Rating" := (ItemVendor2."Quality Rating")/ItemVendor2."Total Qty. Supplied";
                         ItemVendor2.MODIFY;
                       IF MaxQualityPoints <  ItemVendor2."Avg. Quality Rating"  THEN
                        MaxQualityPoints :=  ItemVendor2."Avg. Quality Rating";
                      END ELSE BEGIN
                       PPSetup.GET;
                       IF PPSetup."Default Quality Rating" > MaxQualityPoints THEN
                        MaxQualityPoints := PPSetup."Default Quality Rating";
                      END;
                    UNTIL ItemVendor2.NEXT=0;
                  END ELSE BEGIN
                   PPSetup.GET;
                   IF PPSetup."Default Quality Rating" > MaxQualityPoints THEN
                     MaxQualityPoints := PPSetup."Default Quality Rating";
                 END;
                UNTIL PurchaseLine.NEXT=0;
           UNTIL PurchaseHeader.NEXT=0;
        
        
        ItemVendor.SETRANGE("Vendor No.","VendorNo.");
        ItemVendor.SETRANGE("Item No.","ItemNo.");
        IF ItemVendor.FIND('-') THEN BEGIN
          ItemVendor.CALCFIELDS("Total Qty. Supplied","Quality Rating");
          IF ItemVendor."Quality Rating" = 0 THEN
             EXIT(((PPSetup."Default Quality Rating" /MaxQualityPoints)) * PPSetup."Quality Weightage")
          ELSE
           IF (ItemVendor."Total Qty. Supplied" <> 0) AND (ItemVendor."Quality Rating" <> 0) THEN
             EXIT(((ItemVendor."Avg. Quality Rating" /MaxQualityPoints) * PPSetup."Quality Weightage"));
        END ELSE
           EXIT((PPSetup."Default Quality Rating"/MaxQualityPoints)*PPSetup."Quality Weightage");
        */

    end;

    procedure ConvertEnquirytoQuote(var Rec: Record 38);
    var
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        PurchaseSetup: Record 312;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurchaseLineQuote: Record 39;
        Text001: Label 'Enquiry %1 has been changed to Quote %2';
        IndentLine: Record 50037;
    begin
        PurchaseHeader.INIT;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Quote;
        PurchaseSetup.GET;
        PurchaseHeader."Buy-from Vendor No." := Rec."Buy-from Vendor No.";
        PurchaseHeader."Requested Receipt Date" := Rec."Requested Receipt Date";
        PurchaseHeader.VALIDATE("Buy-from Vendor No.");
        PurchaseHeader."No." := NoSeriesMgt.GetNextNo(PurchaseSetup."Quote Nos.", WORKDATE, TRUE);
        PurchaseHeader."Order Date" := WORKDATE;
        PurchaseHeader."Due Date" := Rec."Due Date";
        PurchaseHeader."Document Date" := WORKDATE;
        PurchaseHeader."Requested Receipt Date" := Rec."Requested Receipt Date";
        PurchaseHeader."Location Code" := Rec."Location Code";
        PurchaseHeader.VALIDATE("Location Code");
        PurchaseHeader."Indent Requisition No" := Rec."Indent Requisition No";
        PurchaseHeader.INSERT;
        //B2BMSOn14Sep2022>>
        PurchaseHeader.Validate("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
        PurchaseHeader.Validate("Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
        PurchaseHeader.Modify();
        //B2BMSOn14Sep2022<<
        PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Enquiry);
        PurchaseLine.SETRANGE("Document No.", Rec."No.");
        IF PurchaseLine.FIND('-') THEN
            REPEAT
                PurchaseLineQuote.INIT;
                PurchaseLineQuote."Document Type" := PurchaseLineQuote."Document Type"::Quote;
                PurchaseLineQuote."Document No." := PurchaseHeader."No.";
                PurchaseLineQuote."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                PurchaseLineQuote.VALIDATE("Buy-from Vendor No.");
                PurchaseLineQuote."Line No." := PurchaseLineQuote."Line No." + 10000;
                PurchaseLineQuote.INSERT(true);
                //   IF PurchaseLine.Type = PurchaseLine.Type::Item THEN BEGIN
                PurchaseLineQuote.Type := PurchaseLine.Type;
                PurchaseLineQuote."No." := PurchaseLine."No.";
                PurchaseLineQuote.VALIDATE("No.");
                PurchaseLineQuote.Quantity := PurchaseLine.Quantity;
                PurchaseLineQuote.VALIDATE(Quantity);
                PurchaseLineQuote."Indent No." := PurchaseLine."Indent No.";
                PurchaseLineQuote."Indent Line No." := PurchaseLine."Indent Line No.";
                //B2BMSOn14Sep2022>>
                PurchaseLineQuote."Indent Req No" := PurchaseLine."Indent Req No";
                PurchaseLineQuote."Indent Req Line No" := PurchaseLine."Indent Req Line No";
                //PurchaseLineQuote."Shortcut Dimension 1 Code" := PurchaseLine."Shortcut Dimension 1 Code";
                //PurchaseLineQuote."Shortcut Dimension 2 Code" := PurchaseLine."Shortcut Dimension 2 Code";
                PurchaseLineQuote.validate("Shortcut Dimension 1 Code", PurchaseLine."Shortcut Dimension 1 Code");
                PurchaseLineQuote.validate("Shortcut Dimension 2 Code", PurchaseLine."Shortcut Dimension 2 Code");
                //B2BMSOn14Sep2022<<
                PurchaseLineQuote.VALIDATE("Variant Code", PurchaseLine."Variant Code");
                PurchaseLineQuote.VALIDATE("Unit of Measure Code", PurchaseLine."Unit of Measure Code");
                // END ELSE BEGIN
                //PurchaseLineQuote.Type := PurchaseLineQuote.Type::" ";
                // PurchaseLineQuote.Description := PurchaseLine.Description;
                //  END;
                PurchaseLineQuote."Location Code" := PurchaseLine."Location Code";
                PurchaseLineQuote.VALIDATE("Location Code");
                PurchaseLineQuote."Variant Code" := PurchaseLine."Variant Code";
                PurchaseLineQuote.modify(true);

                IndentLine.RESET;
                IndentLine.SETRANGE("No.", PurchaseLine."No.");
                IndentLine.SETRANGE("Variant Code", PurchaseLine."Variant Code");
                IndentLine.SETRANGE("Document No.", PurchaseLine."Indent No.");
                IndentLine.SETRANGE(IndentLine."Line No.", PurchaseLine."Indent Line No.");
                IndentLine.SETRANGE("Indent Status", IndentLine."Indent Status"::Enquiry);
                IndentLine.SETRANGE("Release Status", IndentLine."Release Status"::Released);
                IF IndentLine.FIND('-') THEN BEGIN
                    IndentLine."Indent Status" := IndentLine."Indent Status"::Offer;
                    IndentLine.MODIFY;
                END;
            UNTIL PurchaseLine.NEXT = 0;
        MESSAGE(Text001, Rec."No.", PurchaseLineQuote."Document No.");
        Rec.DELETE;
    end;

    procedure GetReqLines(var IndreqHeader: Record 50045);
    var
        CreateIndents: Record 50038;
        IndentLine: Record 50037;
        Item2: Record 27;
        ItemUnitofMeasure: Record 5404;
        PPsetup: Record 312;
        Lineno: Integer;
    begin
        CreateIndents.RESET;
        CreateIndents.DELETEALL;
        IndentLine.RESET;
        IndentLine.SETRANGE("Indent Status", IndentLine."Indent Status"::Indent);
        IndentLine.SETRANGE("Release Status", IndentLine."Release Status"::Released);
        IF IndentLine.FIND('-') THEN
            REPEAT
                PPsetup.GET;
                IF PPsetup."Cumulation of Indents" THEN BEGIN
                    CreateIndents.RESET;
                    CreateIndents.SETRANGE("Item No.", IndentLine."No.");
                    CreateIndents.SETRANGE("Location Code", IndentLine."Delivery Location");
                    CreateIndents.SETRANGE("Variant Code", IndentLine."Variant Code");
                    CreateIndents.SETRANGE("Due Date", IndentLine."Due Date");
                END ELSE BEGIN
                    CreateIndents.RESET;
                    CreateIndents.SETRANGE("Indent No.", IndentLine."Document No.");
                    CreateIndents.SETRANGE("Item No.", IndentLine."No.");
                    CreateIndents.SETRANGE("Location Code", IndentLine."Delivery Location");
                    CreateIndents.SETRANGE("Variant Code", IndentLine."Variant Code");
                    CreateIndents.SETRANGE("Due Date", IndentLine."Due Date");
                    CreateIndents.SETRANGE(Department, IndentLine.Department);
                END;
                IF CreateIndents.FIND('+') THEN BEGIN
                    Item2.RESET;
                    ItemUnitofMeasure.RESET;
                    Item2.GET(IndentLine."No.");
                    ItemUnitofMeasure.GET(IndentLine."No.", IndentLine."Unit of Measure");
                    IF Item2."Base Unit of Measure" <> IndentLine."Unit of Measure" THEN BEGIN
                        IF ItemUnitofMeasure."Qty. per Unit of Measure" <> 0 THEN
                            CreateIndents.Quantity += IndentLine."Req.Quantity" * ItemUnitofMeasure."Qty. per Unit of Measure";
                    END ELSE
                        CreateIndents.Quantity += IndentLine."Req.Quantity";
                    CreateIndents.MODIFY;
                END ELSE BEGIN
                    CreateIndents.INIT;
                    CreateIndents."Document No." := IndreqHeader."No.";
                    CreateIndents."Line No." := Lineno;
                    CreateIndents."Item No." := IndentLine."No.";
                    CreateIndents."Indent No." := IndentLine."Document No.";
                    CreateIndents."Indent Line No." := IndentLine."Line No.";
                    CreateIndents.Description := IndentLine.Description;
                    CreateIndents."Variant Code" := IndentLine."Variant Code";
                    CreateIndents."Indent Status" := IndentLine."Indent Status";
                    CreateIndents."Release Status" := IndentLine."Release Status";
                    CreateIndents."Due Date" := IndentLine."Due Date";
                    CreateIndents."Location Code" := IndentLine."Delivery Location";
                    CreateIndents.Department := IndentLine.Department;
                    Item2.RESET;
                    ItemUnitofMeasure.RESET;
                    Item2.GET(CreateIndents."Item No.");
                    CreateIndents."Vendor No." := IndentLine."Vendor No.";
                    ItemUnitofMeasure.GET(IndentLine."No.", IndentLine."Unit of Measure");
                    IF Item2."Base Unit of Measure" = IndentLine."Unit of Measure" THEN BEGIN
                        CreateIndents."Unit of Measure" := IndentLine."Unit of Measure";
                        CreateIndents.Quantity := IndentLine."Req.Quantity";
                    END ELSE BEGIN
                        CreateIndents."Unit of Measure" := Item2."Base Unit of Measure";
                        IF ItemUnitofMeasure."Qty. per Unit of Measure" <> 0 THEN
                            CreateIndents.Quantity := (IndentLine."Req.Quantity" * ItemUnitofMeasure."Qty. per Unit of Measure");
                    END;
                    CreateIndents.INSERT;
                    Lineno += 10000;
                END;
            UNTIL IndentLine.NEXT = 0;
        CreateIndents.RESET;
    end;

    procedure "---B2B1.1---"();
    begin
    end;

    procedure CreateOrder2(var CreateIndentsQuotes: Record 50038; var Vendor: Record 23; var Noseries: Code[20]);
    var
        IndentVendorItems: Record 50043;
        IndentVendorEnquiry: Record 50043;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PPSetup: Record 312;
        CreateIndents2: Record 50038;
        IndentLine: Record 50037;
        Item2: Record 27;
        ItemUnitofMeasure: Record 5404;
        BaseUOMQtyMeasure: Decimal;
        PurchUOMQtyMeasure: Decimal;
    begin
        //B2B.1.3 S
        CreateIndents4.COPYFILTERS(CreateIndentsQuotes);
        InsertIndentItemvendor2(CreateIndents4, Vendor);
        IndentVendorItems.RESET;
        IndentVendorItems.SETRANGE(Check, FALSE);
        IF IndentVendorItems.FIND('-') THEN
            REPEAT
                //MESSAGE('1st FIND');
                // IndentVendorEnquiry.SETRANGE("Vendor No.", IndentVendorItems."Vendor No.");
                //PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
                IndentVendorEnquiry.SETRANGE("Location Code", IndentVendorItems."Location Code");
                IF IndentVendorEnquiry.FIND('-') THEN BEGIN
                    PurchaseHeader.INIT;
                    PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
                    PPSetup.GET;
                    PurchaseHeader."No." := NoSeriesMgt.GetNextNo(Noseries, WORKDATE, TRUE);
                    PurchaseHeader.Insert(true);
                    // MESSAGE('Purchaser Order No %1 ', PurchaseHeader."No.");
                    PurchaseHeader."Buy-from Vendor No." := IndentVendorEnquiry."Vendor No.";
                    PurchaseHeader.VALIDATE(PurchaseHeader."Buy-from Vendor No.");
                    PurchaseHeader."Order Date" := WORKDATE;
                    PurchaseHeader."Document Date" := WORKDATE;
                    PurchaseHeader.VALIDATE("Location Code");
                    PurchaseHeader."Due Date" := IndentVendorEnquiry."Due Date";
                    PurchaseHeader."Expected Receipt Date" := IndentVendorEnquiry."Due Date";
                    PurchaseHeader.VALIDATE("Expected Receipt Date");
                    PurchaseHeader.VALIDATE("Due Date");
                    PurchaseHeader."Indent Requisition No" := IndentVendorEnquiry."Indent Req No";
                    PurchaseHeader.VALIDATE("Location Code", IndentVendorItems."Location Code");
                    PurchaseHeader.validate("Shortcut Dimension 1 Code", IndentVendorEnquiry."Shortcut Dimension 1 Code");//B2BPAV
                    PurchaseHeader.validate("Shortcut Dimension 2 Code", IndentVendorEnquiry."Shortcut Dimension 2 Code");//B2BPAV
                    PurchaseHeader.Modify(true);
                    //PurchaseHeader.INSERT;
                    REPEAT
                        PurchaseLine.INIT;
                        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                        PurchaseLine."Document No." := PurchaseHeader."No.";
                        PurchaseLine."Line No." := PurchaseLine."Line No." + 10000;
                        PurchaseLine.Insert(true);
                        PurchaseLine."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                        PurchaseLine.VALIDATE("Buy-from Vendor No.");
                        PurchaseLine.Type := PurchaseLine.Type::Item;
                        PurchaseLine."No." := IndentVendorEnquiry."Item No.";
                        PurchaseLine.VALIDATE(PurchaseLine."No.");
                        // PurchaseLine."Description 2":=IndentVendorEnquiry.Description2;//iclean  B2B1.1
                        PurchaseLine.VALIDATE("Variant Code", IndentVendorEnquiry."Variant Code");
                        // *** BST 1.0 *** >>
                        /*
                        IF Item2.GET(PurchaseLine."No.") THEN;
                        IF Item2."Purch. Unit of Measure"<>IndentVendorEnquiry."Unit of Measure" THEN BEGIN
                          ItemUnitofMeasure.RESET;
                          IF ItemUnitofMeasure.GET(PurchaseLine."No.",Item2."Purch. Unit of Measure") THEN
                            PurchUOMQtyMeasure:=ItemUnitofMeasure."Qty. per Unit of Measure";
                          ItemUnitofMeasure.RESET;
                          IF ItemUnitofMeasure.GET(PurchaseLine."No.",IndentVendorEnquiry."Unit of Measure") THEN
                            BaseUOMQtyMeasure:=ItemUnitofMeasure."Qty. per Unit of Measure";
                            IndentVendorEnquiry.Quantity:=IndentVendorEnquiry.Quantity/PurchUOMQtyMeasure;
                        END;
                        */
                        // *** BST 1.0 *** <<
                        // PurchaseLine.VALIDATE("Order Quantity",IndentVendorEnquiry.Quantity);
                        PurchaseLine.VALIDATE(Quantity, IndentVendorEnquiry.Quantity);
                        PurchaseLine."Outstanding Quantity" := PurchaseLine.Quantity;
                        PurchaseLine."Outstanding Qty. (Base)" := PurchaseLine.Quantity;
                        PurchaseLine."Indent No." := IndentVendorEnquiry."Indent No.";
                        PurchaseLine."Indent Line No." := IndentVendorEnquiry."Indent Line No.";
                        PurchaseLine."Indent Req No" := IndentVendorEnquiry."Indent Req No";
                        PurchaseLine."Indent Req Line No" := IndentVendorEnquiry."Indent Req Line No";
                        PurchaseLine."Location Code" := IndentVendorEnquiry."Location Code";
                        //PurchaseLine."Shortcut Dimension 1 Code" := IndentVendorEnquiry."Project No.";
                        //PurchaseLine."Shortcut Dimension 2 Code" := IndentVendorEnquiry.Department;
                        PurchaseLine.Validate("Shortcut Dimension 1 Code", IndentVendorEnquiry."Shortcut Dimension 1 Code");//B2BPAV
                        PurchaseLine.Validate("Shortcut Dimension 2 Code", IndentVendorEnquiry."Shortcut Dimension 2 Code");//B2BPAV
                        PurchaseLine."Location Code" := IndentVendorEnquiry."Location Code";

                        CreateIndents5.RESET;
                        CreateIndents5.SETRANGE(CreateIndents5."Document No.", IndentVendorEnquiry."Indent Req No");
                        CreateIndents5.SETRANGE(CreateIndents5."Line No.", IndentVendorEnquiry."Indent Req Line No");
                        IF CreateIndents5.FINDFIRST THEN BEGIN
                            CreateIndents5."Document Type" := PurchaseLine."Document Type"::Order.AsInteger();
                            CreateIndents5."Order No" := PurchaseLine."Document No.";
                            PurchaseLine.VALIDATE("Direct Unit Cost", CreateIndents5."Unit Cost");//B2B.1.4
                            CreateIndents5.MODIFY;
                        END;
                        PurchaseLine.Modify(true);
                        //PurchaseLine.INSERT;
                        IndentVendorEnquiry.Check := TRUE;
                        IndentVendorEnquiry.MODIFY;
                    UNTIL IndentVendorEnquiry.NEXT = 0;
                END;
            UNTIL IndentVendorItems.NEXT = 0;
        //B2B.1.3 E

    end;

    procedure InsertIndentItemvendor2(var CreateIndentsLocal: Record 50038; var Vendor: Record 23);
    var
        IndentVendorItems: Record 50043;
        ItemVendor: Record 99;
        CreateIndents: Record 50038;
        Text000: Label 'Default Vendor is not Mentioned In the Vendor Item Catalog For  Item No ''%1''';
        Text001: Label 'First Select Vendor';
        VendorGrec: Record 23;
    begin
        //B2B.1.3 s
        IndentVendorItems.DELETEALL;
        CreateIndents.COPYFILTERS(CreateIndentsLocal);
        IF CreateIndents.FIND('-') THEN
            REPEAT
                IF CreateIndents."Remaining Quantity" <> 0 THEN BEGIN
                    IF CreateIndents."Manufacturer Code" = '' THEN
                        ERROR(TEXT50050);
                    IndentVendorItems.INIT;
                    IndentVendorItems."Item No." := CreateIndents."Item No.";
                    IndentVendorItems."Vendor No." := CreateIndents."Vendor No."; //B2BMSOn16Nov2022
                    IF CreateIndents."Qty. To Order" >= CreateIndents."Vendor Min.Ord.Qty" THEN BEGIN
                        IndentVendorItems.Quantity := CreateIndents."Qty. To Order";
                        CreateIndents."Remaining Quantity" -= CreateIndents."Qty. To Order";
                        CreateIndents.VALIDATE(CreateIndents."Remaining Quantity");
                        CreateIndents."Qty. Ordered" += IndentVendorItems.Quantity;
                        CreateIndents.MODIFY;
                    END ELSE BEGIN
                        IndentVendorItems.Quantity := CreateIndents."Vendor Min.Ord.Qty";
                        CreateIndents."Remaining Quantity" -= CreateIndents."Vendor Min.Ord.Qty";
                        IF CreateIndents."Remaining Quantity" < 0 THEN
                            CreateIndents."Remaining Quantity" := 0;
                        CreateIndents.VALIDATE(CreateIndents."Remaining Quantity");
                        CreateIndents."Qty. Ordered" += IndentVendorItems.Quantity;
                        CreateIndents.MODIFY;
                    END;
                    //IndentVendorItems.Quantity := CreateIndents."Indented Quantity";
                    IndentVendorItems."Variant Code" := CreateIndents."Variant Code";
                    IndentVendorItems."Indent No." := CreateIndents."Indent No.";
                    IndentVendorItems."Indent Line No." := CreateIndents."Indent Line No.";
                    IndentVendorItems."Due Date" := CreateIndents."Due Date";
                    IndentVendorItems."Indent Line No." := CreateIndents."Indent Line No.";
                    IndentVendorItems."Shortcut Dimension 1 Code" := CreateIndents."Shortcut Dimension 1 Code";//B2BPAV
                    IndentVendorItems."Shortcut Dimension 2 Code" := CreateIndents."Shortcut Dimension 2 Code";//B2BPAV
                    IndentVendorItems.Check := FALSE;
                    VendorGrec.RESET;
                    IF VendorGrec.GET(CreateIndents."Manufacturer Code") THEN
                        IndentVendorItems."Location Code" := VendorGrec."Location Code";

                    //IndentVendorItems."Location Code" := CreateIndents."Location Code";
                    IndentVendorItems."Unit Of Measure" := CreateIndents."Unit of Measure";
                    IndentVendorItems.Department := CreateIndents.Department;
                    //IndentVendorItems."Manufacturer Code" := CreateIndents."Manufacturer Code"; B2B1.1
                    //IndentVendorItems."Manufacturer Ref. No." := CreateIndents."Manufacturer Ref. No."; B2B1.1
                    IndentVendorItems."Indent Req No" := CreateIndents."Document No.";
                    IndentVendorItems."Indent Req Line No" := CreateIndents."Line No.";
                    //IndentVendorItems.Description2:=CreateIndents.Description2;//iclean  B2B1.1
                    IndentVendorItems."Vendor No." := CreateIndents."Manufacturer Code";
                    IndentVendorItems.INSERT;
                END;
            UNTIL CreateIndents.NEXT = 0;
        //B2B.1.3 E
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnBeforeUpdateLocationCode', '', false, false)]
    local procedure OnBeforeUpdateLocationCode(var PurchaseHeader: Record "Purchase Header"; LocationCode: Code[10]; var IsHandled: Boolean)
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Enquiry then
            IsHandled := true;
    end;

    //B2BMSOn02Nov2022>>
    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnInitFromPurchHeader', '', false, false)]
    local procedure OnInitFromPurchHeader(var PurchaseHeader: Record "Purchase Header"; SourcePurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader."Payment Terms Code" := SourcePurchaseHeader."Payment Terms Code";
        PurchaseHeader."Indent Requisition No" := SourcePurchaseHeader."Indent Requisition No";
    end;
    //B2BMSOn02Nov2022<<

    //B2BMSOn03Nov2022>>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostUpdateOrderLineOnPurchHeaderReceive', '', false, false)]
    local procedure OnPostUpdateOrderLineOnPurchHeaderReceive(var TempPurchLine: Record "Purchase Line"; PurchRcptHeader: Record "Purch. Rcpt. Header")
    var
        ItemLRec: Record Item;
    begin
        if (ItemLRec.Get(TempPurchLine."No.")) and (ItemLRec."QC Enabled B2B") then begin
            TempPurchLine."Quantity Accepted B2B" += TempPurchLine."Qty. to Accept B2B";
            TempPurchLine."Quantity Rejected B2B" += TempPurchLine."Qty. to Reject B2B";
            TempPurchLine."Qty. to Accept B2B" := 0;
            TempPurchLine."Qty. to Reject B2B" := 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnRunOnBeforePostPurchLine', '', false, false)]
    local procedure OnRunOnBeforePostPurchLine(var PurchLine: Record "Purchase Line")
    var
        ItemLRec: Record Item;
        Err0001: Label 'Either Qty. to Accept or Qty. to Reject must have a value as QC was enabled.';
    begin
        if (ItemLRec.Get(PurchLine."No.")) and (ItemLRec."QC Enabled B2B") then
            if (PurchLine."Qty. to Receive" <> 0)
                and ((PurchLine."Qty. to Accept B2B" = 0) and (PurchLine."Qty. to Reject B2B" = 0)) then
                Error(Err0001);
    end;
    //B2BMSOn03Nov2022<<
}

