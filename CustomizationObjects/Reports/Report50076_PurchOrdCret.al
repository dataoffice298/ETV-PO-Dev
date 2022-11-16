report 50076 "Purchase Order Creation New"
{
    ProcessingOnly = true;
    UseRequestPage = false;
    ApplicationArea = all;
    UsageCategory = Lists;
    Caption = 'Purchase Order Creation_50005';

    dataset
    {
        dataitem("Quotation Comparison1"; "Quotation Comparison Test")
        {
            DataItemTableView = SORTING("Line No.")
                                WHERE("Carry Out Action" = FILTER(true),
                                      Level = FILTER(1));


            trigger OnPreDataItem();
            begin
                SetRange("RFQ No.", RFQNum);
            end;

            trigger OnAfterGetRecord();
            var

                PurchaseHeaderOrder: Record "Purchase Header";
                PurchaseLineOrder: Record "Purchase Line";
                PPSetup: Record "Purchases & Payables Setup";
                PurchaseHeader: Record "Purchase Header";
                PurchaseLine: Record "Purchase Line";
                PurchaseHeader1: Record "Purchase Header";
                PurchaseLine1: Record "Purchase Line";
                PurchaseLineOrder2: Record "Purchase Line";
                VendorL: Record Vendor;
                NoSeriesMgt: Codeunit NoSeriesManagement;
                LineNo: Integer;
                FixeAss: Record "Fixed Asset";
                FixedAssBool: Boolean;
                FixedAset: Record "Fixed Asset";
                FxdAset: Record "Fixed Asset";
                LneLVar: Integer;
                GLAcc: Record "G/L Account";
                GLAccBool: Boolean;
                FADepBook: Record "FA Depreciation Book";
                QuotCompHdr: Record QuotCompHdr; //B2BMSOn18Oct2022
            begin

                PurchaseHeader.RESET;
                PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Quote);
                PurchaseHeader.SETRANGE("No.", "Parent Quote No.");
                PurchaseHeader.SetRange("Buy-from Vendor No.", "Vendor No.");
                IF PurchaseHeader.FindFirst() THEN BEGIN
                    //B2BMSOn18Oct2022>>
                    PurchaseHeader1.Reset();
                    PurchaseHeader1.SetRange("Document Type", PurchaseHeader1."Document Type"::Order);
                    PurchaseHeader1.SetRange("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                    PurchaseHeader1.SetRange("No.", OrderNo);
                    if not PurchaseHeader1.FindFirst() then begin
                        //B2BMSOn18Oct2022<<
                        PurchaseHeaderOrder."Document Type" := PurchaseHeaderOrder."Document Type"::Order;
                        PPSetup.GET;
                        PurchaseHeaderOrder."No." := '';
                        VendorL.GET(PurchaseHeader."Buy-from Vendor No.");
                        IF PurchaseLineOrder2.GET(PurchaseHeaderOrder."Document Type"::Order, PurchaseHeaderOrder."No.") THEN
                            ERROR('Record already Existed.');
                        //PurchaseHeaderOrder."Posting Date" := WORKDATE();
                        PurchaseHeaderOrder.INSERT(true);
                        OrderNo := PurchaseHeaderOrder."No."; //B2BMSOn18Oct2022
                        PurchaseHeaderOrder."Posting Date" := Today;
                        PurchaseHeaderOrder."Document Date" := WORKDATE();
                        PurchaseHeaderOrder.Validate("Order Date", WorkDate());
                        PurchaseHeaderOrder.VALIDATE("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                        PurchaseHeaderOrder."Quotation No." := "Quot Comp No.";
                        PurchaseHeaderOrder."Quote No." := "Parent Quote No.";
                        PurchaseHeaderOrder."Expected Receipt Date" := "Quotation Comparison1"."Due Date";
                        PurchaseHeaderOrder."Currency Code" := "Quotation Comparison1"."Currency Code";
                        PurchaseHeaderOrder.Validate("Shortcut Dimension 1 Code", "Quotation Comparison1"."Shortcut Dimension 1 Code");//B2BPAV
                        PurchaseHeaderOrder.Validate("Shortcut Dimension 2 Code", "Quotation Comparison1"."Shortcut Dimension 2 Code");//B2BPAV
                        PurchaseHeaderOrder.Validate("Payment Terms Code", "Quotation Comparison1"."Payment Term Code");
                        //B2BMSOn18Oct2022>>
                        if QuotCompHdr.Get("Quotation Comparison1"."Quot Comp No.") then
                            PurchaseHeaderOrder.Regularization := QuotCompHdr.Regularization;
                        PurchaseHeaderOrder."Indent Requisition No" := "Quotation Comparison1"."Indent Req. No.";
                        //B2BMSOn18Oct2022<<
                        PurchaseHeaderOrder.Modify();
                    end; //B2BMSOn18Oct2022
                    PurchaseLine.Reset();
                    PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Quote);
                    PurchaseLine.SETRANGE("Document No.", "Parent Quote No.");
                    PurchaseLine.SETRANGE("Buy-from Vendor No.", "Vendor No.");
                    PurchaseLine.SetRange("No.", "Item No.");
                    IF PurchaseLine.FindFirst() THEN BEGIN
                        LneLVar := PurchaseLine."Line No."; //B2BMSOn18Oct2022
                        repeat
                            //B2BMSOn18Oct2022>>
                            //clear(LneLVar);
                            //LneLVar := PurchaseLine."Line No." + 10000;
                            PurchaseLine1.Reset();
                            PurchaseLine1.SetRange("Document No.", PurchaseHeaderOrder."No.");
                            PurchaseLine1.SetRange("Line No.", LneLVar);
                            if not PurchaseLine1.FindFirst() then begin
                                //B2BMSOn18Oct2022<<
                                PurchaseLineOrder.INIT();
                                //B2BMSOn18Oct2022>>
                                //PurchaseLineOrder.RESET();
                                //PurchaseLineOrder."Document No." := PurchaseHeaderOrder."No.";
                                PurchaseLineOrder."Document No." := OrderNo;
                                //B2BMSOn18Oct2022<<
                                PurchaseLineOrder."Document Type" := PurchaseLineOrder."Document Type"::Order;
                                PurchaseLineOrder."Line No." := LneLVar;
                                PurchaseLineOrder."Buy-from Vendor No." := PurchaseHeaderOrder."Buy-from Vendor No.";
                                PurchaseLineOrder.VALIDATE("Buy-from Vendor No.");
                                PurchaseLineOrder.Type := PurchaseLine.type;
                                PurchaseLineOrder.VALIDATE("No.", "Item No.");
                                PurchaseLineOrder."Description 2" := "Quotation Comparison1".Description2;
                                PurchaseLineOrder.VALIDATE(Quantity, "Quotation Comparison1".Quantity);
                                PurchaseLineOrder."Direct Unit Cost" := "Quotation Comparison1".Rate;
                                PurchaseLineOrder.VALIDATE("Direct Unit Cost");
                                PurchaseLineOrder.VALIDATE("Variant Code", "Quotation Comparison1"."Variant Code");
                                PurchaseLineOrder."Location Code" := "Quotation Comparison1"."Location Code";
                                PurchaseLineOrder."Shortcut Dimension 1 Code" := "Quotation Comparison1"."Shortcut Dimension 1 Code";//B2BPAV
                                PurchaseLineOrder."Shortcut Dimension 2 Code" := "Quotation Comparison1"."Shortcut Dimension 2 Code";//B2BPAV
                                PurchaseLineOrder."Dimension Set ID" := "Quotation Comparison1"."Dimension Set ID";
                                PurchaseLineOrder."Shortcut Dimension 1 Code" := "Quotation Comparison1"."Shortcut Dimension 1 Code";
                                PurchaseLineOrder."Shortcut Dimension 2 Code" := "Quotation Comparison1"."Shortcut Dimension 2 Code";
                                PurchaseLineOrder."Dimension Set ID" := "Quotation Comparison1"."Dimension Set ID";
                                PurchaseLineOrder."Currency Code" := "Quotation Comparison1"."Currency Code";
                                PurchaseLineOrder.INSERT();
                                PurchaseLineOrder.Validate("Shortcut Dimension 1 Code");
                                PurchaseLineOrder.validate("Shortcut Dimension 2 Code");
                                PurchaseLineOrder.Validate("Dimension Set ID");
                                //B2BMSOn21Sep2022>>
                                PurchaseLineOrder."Indent No." := "Quotation Comparison1"."Indent No.";
                                PurchaseLineOrder."Indent Line No." := "Quotation Comparison1"."Indent Line No.";
                                PurchaseLineOrder."Indent Req No" := "Quotation Comparison1"."Indent Req. No.";
                                PurchaseLineOrder."Indent Req Line No" := "Quotation Comparison1"."Indent Req. Line No.";
                                //B2BMSOn21Sep2022<<
                                PurchaseLineOrder.Modify();
                                LneLVar += 10000;
                            end;
                        until PurchaseLine.Next() = 0;
                    END;
                end;

                QutComLine.RESET;
                QutComLine.SetRange("Quot Comp No.", "Quot Comp No.");
                QutComLine.SetRange("Line No.", "Line No.");
                IF QutComLine.findfirst THEN BEGIN
                    QutComLine."Po No." := OrderNo;
                    QutComLine.modify;
                END;
                Message('Order Created %1', PurchaseHeaderOrder."No.");

            END;

            trigger OnPostDataItem();
            var
                RFQNumbers: Record "RFQ Numbers";
            begin

                RFQNumbers.RESET;
                RFQNumbers.SETRANGE("RFQ No.", RFQNum);
                IF RFQNumbers.FIND('-') THEN BEGIN
                    RFQNumbers.Completed := TRUE;
                    RFQNumbers.MODIFY();
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
        Noseries2: Code[20];
        RFQNum: Code[20];
        OrderNo: Code[20];
        QutComLine: Record "Quotation Comparison Test";
        invposset: Record "Inventory Posting Setup";
        itemgv: Record Item;


    procedure GetValues(RFQNUmbr: code[20]);
    begin
        RFQNum := RFQNUmbr;
    end;
}

