report 50099 "Purchase Order Creation"
{
    // version B2B1.1,PO

    // PROJECT : WindlassHealthCare
    // *********************************************************************************************************************************************************
    // SIGN
    // *********************************************************************************************************************************************************
    // B2B : B2B Software Technologies
    // *********************************************************************************************************************************************************
    // VER       SIGN       USERID          DATE         DESCRIPTION
    // *********************************************************************************************************************************************************
    // 1.1       B2B        Srikar        13-May-15 -->  Added Code In Quotation Comparison OnAfterGetRecord,OnPosteDataItem.

    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Quotation Comparison"; "Quotation Comparison")
        {
            DataItemTableView = SORTING("Line No.")
                                WHERE("Carry Out Action" = FILTER(true),
                                      Level = FILTER(1));

            trigger OnAfterGetRecord();
            begin
                //PurchaseHeaderOrder.SETRANGE("Document Type",PurchaseHeaderOrder."Document Type"::Order);
                PurchaseHeaderOrder.SETRANGE("Quotation No.", "Quotation Comparison"."Parent Quote No.");
                IF PurchaseHeaderOrder.FIND('-') THEN BEGIN
                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Quote);
                    PurchaseHeader.SETRANGE("No.", "Parent Quote No.");
                    IF PurchaseHeader.FIND('-') THEN BEGIN
                        PurchaseHeaderOrder."Document Type" := PurchaseHeaderOrder."Document Type"::Order;
                        PPSetup.GET;
                        PurchaseHeaderOrder."No." := NoSeriesMgt.GetNextNo(Noseries2, WORKDATE, TRUE);
                        MESSAGE('%1', PurchaseHeaderOrder."No.");
                        IF PurchaseLineOrder2.GET(PurchaseHeaderOrder."Document Type"::Order, PurchaseHeaderOrder."No.") THEN
                            ERROR('Record already Existed.');
                        PurchaseHeaderOrder."Posting Date" := WORKDATE;
                        PurchaseHeaderOrder."Document Date" := WORKDATE;
                        PurchaseHeaderOrder.VALIDATE("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                        //PurchaseHeaderOrder.VALIDATE("Buy-from Vendor No.");
                        PurchaseHeaderOrder."Quotation No." := "Parent Quote No.";
                        //AS <<
                        //    PurchaseHeaderOrder."RFQ No." := RFQNumbers."RFQ No.";//AS
                        PurchaseHeaderOrder."RFQ No." := "Quotation Comparison"."RFQ No.";//AS
                                                                                          //AS >>
                                                                                          //PurchaseHeaderOrder.Structure := Structure;//Balu
                                                                                          //PurchaseHeaderOrder.VALIDATE(Structure);//Balu
                        PurchaseHeaderOrder."Expected Receipt Date" := "Quotation Comparison"."Due Date";
                        PurchaseHeaderOrder."Indent Requisition No" := "Quotation Comparison"."Indent Req No";
                        PurchaseHeaderOrder.INSERT;
                        PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                        PurchaseLine.SETRANGE("Document No.", PurchaseHeaderOrder."No.");
                        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
                        PurchaseLine.SETRANGE("No.", "Item No.");
                        IF PurchaseLine.FINDLAST THEN
                            LineNo := PurchaseLine."Line No." + 10000
                        ELSE
                            LineNo := 10000;
                        CLEAR(PurchaseLine);
                        PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Quote);
                        PurchaseLine.SETRANGE("Document No.", "Parent Quote No.");
                        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
                        PurchaseLine.SETRANGE("No.", "Item No.");
                        IF PurchaseLine.FINDSET THEN BEGIN
                            REPEAT
                                PurchaseLineOrder.INIT;
                                PurchaseLineOrder.RESET;
                                PurchaseLineOrder."Document Type" := PurchaseHeaderOrder."Document Type";
                                PurchaseLineOrder."Document No." := PurchaseHeaderOrder."No.";
                                PurchaseLineOrder."Line No." := LineNo;
                                PurchaseLineOrder."Buy-from Vendor No." := PurchaseHeaderOrder."Buy-from Vendor No.";
                                PurchaseLineOrder.VALIDATE("Buy-from Vendor No.");
                                PurchaseLineOrder.Type := PurchaseLineOrder.Type::Item;
                                PurchaseLineOrder.VALIDATE("No.", "Item No.");
                                //PurchaseLineOrder."Description 2":="Quotation Comparison".Description2;B2B1.1
                                PurchaseLineOrder.VALIDATE(Quantity, "Quotation Comparison".Quantity);
                                PurchaseLineOrder."Direct Unit Cost" := "Quotation Comparison".Rate;
                                PurchaseLineOrder.VALIDATE("Direct Unit Cost");
                                PurchaseLineOrder."Indent No." := "Quotation Comparison"."Indent Req No";
                                PurchaseLineOrder."Indent Line No." := "Quotation Comparison"."Indent Req Line No";
                                PurchaseLineOrder.VALIDATE("Variant Code", "Quotation Comparison"."Variant Code");
                                PurchaseLineOrder."Location Code" := "Quotation Comparison"."Location Code";
                                PurchaseLineOrder.INSERT;
                                LineNo += 10000;
                            UNTIL PurchaseLine.NEXT = 0;

                            IndentReq.RESET;
                            IndentReq.SETRANGE(IndentReq."Document No.", "Quotation Comparison"."Indent Req No");
                            IF IndentReq.FINDFIRST THEN
                                REPEAT
                                    IndentReq."Document Type" := IndentReq."Document Type"::Order;
                                    IndentReq."Order No" := PurchaseLineOrder."Document No.";
                                    IndentReq.MODIFY;
                                UNTIL IndentReq.NEXT = 0;
                        END;
                    END;

                END ELSE BEGIN
                    /*
                   //Noseries2:=
                     PPSetup.GET;
                     NoSeries.SETRANGE(Code,PPSetup."Order Nos.");
                     IF NoSeries.FINDFIRST THEN
                       Noseries2:=NoSeries."Series Code";
                   */
                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Quote);
                    PurchaseHeader.SETRANGE("No.", "Parent Quote No.");
                    IF PurchaseHeader.FIND('-') THEN BEGIN
                        PurchaseHeaderOrder."Document Type" := PurchaseHeaderOrder."Document Type"::Order;
                        PPSetup.GET;
                        PurchaseHeaderOrder."No." := NoSeriesMgt.GetNextNo(Noseries2, WORKDATE, TRUE);
                        MESSAGE('%1', PurchaseHeaderOrder."No.");
                        IF PurchaseLineOrder2.GET(PurchaseHeaderOrder."Document Type"::Order, PurchaseHeaderOrder."No.") THEN
                            ERROR('Record already Existed.');
                        PurchaseHeaderOrder."Posting Date" := WORKDATE;
                        PurchaseHeaderOrder."Document Date" := WORKDATE;
                        PurchaseHeaderOrder.VALIDATE("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                        //PurchaseHeaderOrder.VALIDATE("Buy-from Vendor No.");
                        PurchaseHeaderOrder."Quotation No." := "Parent Quote No.";
                        //AS <<
                        //    PurchaseHeaderOrder."RFQ No." := RFQNumbers."RFQ No.";//AS
                        PurchaseHeaderOrder."RFQ No." := "Quotation Comparison"."RFQ No.";//AS
                                                                                          //AS >>
                                                                                          //PurchaseHeaderOrder.Structure := Structure;//Balu
                                                                                          //PurchaseHeaderOrder.VALIDATE(Structure);//Balu
                        PurchaseHeaderOrder."Expected Receipt Date" := "Quotation Comparison"."Due Date";
                        PurchaseHeaderOrder."Indent Requisition No" := "Quotation Comparison"."Indent Req No";
                        PurchaseHeaderOrder.INSERT;
                        PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Quote);
                        PurchaseLine.SETRANGE("Document No.", "Parent Quote No.");
                        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
                        PurchaseLine.SETRANGE("No.", "Item No.");
                        IF PurchaseLine.FIND('-') THEN BEGIN
                            PurchaseLineOrder.INIT;
                            PurchaseLineOrder.RESET;
                            PurchaseLineOrder."Document Type" := PurchaseHeaderOrder."Document Type";
                            PurchaseLineOrder."Document No." := PurchaseHeaderOrder."No.";
                            PurchaseLineOrder."Line No." := PurchaseLine."Line No." + 10000;
                            PurchaseLineOrder."Buy-from Vendor No." := PurchaseHeaderOrder."Buy-from Vendor No.";
                            PurchaseLineOrder.VALIDATE("Buy-from Vendor No.");
                            PurchaseLineOrder.Type := PurchaseLineOrder.Type::Item;
                            PurchaseLineOrder.VALIDATE("No.", "Item No.");
                            //PurchaseLineOrder."Description 2":="Quotation Comparison".Description2;B2B1.1
                            PurchaseLineOrder.VALIDATE(Quantity, "Quotation Comparison".Quantity);
                            PurchaseLineOrder."Direct Unit Cost" := "Quotation Comparison".Rate;
                            PurchaseLineOrder.VALIDATE("Direct Unit Cost");
                            PurchaseLineOrder."Indent No." := "Quotation Comparison"."Indent Req No";
                            PurchaseLineOrder."Indent Line No." := "Quotation Comparison"."Indent Req Line No";
                            PurchaseLineOrder.VALIDATE("Variant Code", "Quotation Comparison"."Variant Code");
                            PurchaseLineOrder."Location Code" := "Quotation Comparison"."Location Code";
                            PurchaseLineOrder.INSERT;
                            IndentReq.RESET;
                            IndentReq.SETRANGE(IndentReq."Document No.", "Quotation Comparison"."Indent Req No");
                            IF IndentReq.FINDFIRST THEN
                                REPEAT
                                    IndentReq."Document Type" := IndentReq."Document Type"::Order;
                                    IndentReq."Order No" := PurchaseLineOrder."Document No.";
                                    IndentReq.MODIFY;
                                UNTIL IndentReq.NEXT = 0;
                        END;
                    END;
                END;

            end;

            trigger OnPostDataItem();
            begin

                MESSAGE('Orders Created');
                RFQNumbers.SETRANGE("RFQ No.", "RFQ No.");
                IF RFQNumbers.FIND('-') THEN BEGIN
                    RFQNumbers.Completed := TRUE;//B2B1.1
                    RFQNumbers.MODIFY;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        PurchaseHeaderOrder: Record 38;
        PurchaseLineOrder: Record 39;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PPSetup: Record 312;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        RFQNumbers: Record 50039;
        IndentLine: Record 50037;
        PurchaseLineOrder2: Record 38;
        Noseries2: Code[20];
        IndentReq: Record 50038;
        NoSeries: Record 310;
        LineNo: Integer;

    procedure GetValues(Noseries: Code[20]);
    begin
        Noseries2 := Noseries;
    end;
}

