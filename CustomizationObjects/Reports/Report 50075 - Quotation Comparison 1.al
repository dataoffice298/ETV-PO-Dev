report 50075 "Quotation Comparison 1"
{
    // version B2B 1.0,PO

    DefaultLayout = RDLC;
    RDLCLayout = './Quotation Comparison 1.rdl';
    Caption = 'Quotation Comparison_50075';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number);
            PrintOnlyIfDetail = false;
            column(Number_Integer; Number)
            {
            }
            dataitem(DataItem1102152028; "Quotation Comparison Test")
            {
                DataItemTableView = SORTING("RFQ No.", "Item No.", "Variant Code")
                                    ORDER(Ascending);
                PrintOnlyIfDetail = false;
                column(CompanyInfoName; CompanyInfo.Name)
                {
                }
                column(QuotationComparisonStatementCaptionLbl; QuotationComparisonStatementCaptionLbl)
                {
                }
                column(REQNoCaptionLbl; REQNoCaptionLbl)
                {
                }
                column(VendorNoCaptionLbl; VendorNoCaptionLbl)
                {
                }
                column(VendorNameCaptionLbl; VendorNameCaptionLbl)
                {
                }
                column(QuoteNoCaptionLbl; QuoteNoCaptionLbl)
                {
                }
                column(ItemNoCaptionLbl; ItemNoCaptionLbl)
                {
                }
                column(DescriptionCaptionLbl; DescriptionCaptionLbl)
                {
                }
                column(UOMCaptionLbl; UOMCaptionLbl)
                {
                }
                column(QuantityCaptionLbl; QuantityCaptionLbl)
                {
                }
                column(RateCaptionLbl; RateCaptionLbl)
                {
                }
                column(AmountCaptionLbl; AmountCaptionLbl)
                {
                }
                column(TotalBasicValueCaptionLbl; TotalBasicValueCaptionLbl)
                {
                }
                column(ExiseDutyCaptionLbl; ExiseDutyCaptionLbl)
                {
                }
                column(SalesTaxCaptionLbl; SalesTaxCaptionLbl)
                {
                }
                column(VATCaptionLbl; VATCaptionLbl)
                {
                }
                column(OtherChargesCaptionLbl; OtherChargesCaptionLbl)
                {
                }
                column(TotalAmountCaptionLbl; TotalAmountCaptionLbl)
                {
                }
                column(PaymentTermCodeCaptionLbl; PaymentTermCodeCaptionLbl)
                {
                }
                column(RFQNo_QuotationComparison; "RFQ No.")
                {
                }
                column(ItemNo_QuotationComparison; "Item No.")
                {
                }
                column(VariantCode_QuotationComparison; "Variant Code")
                {
                }
                column(Description_QuotationComparison; Description)
                {
                }
                column(UOM; UOM)
                {
                }
                column(Vendor1; Vendor[Integer.Number])
                {
                }
                column(VendorName1; VendorName[Integer.Number])
                {
                }
                column(QuoteNo1; QuoteNo[Integer.Number])
                {
                }
                column(Qty1; Qty[Integer.Number])
                {
                }
                column(QRate1; QRate[Integer.Number])
                {
                }
                column(QAmount1; QAmount[Integer.Number])
                {
                }
                column(VendorAmount1; VendorAmount[Integer.Number])
                {
                }
                column(ExciseDuty1; ExciseDuty[Integer.Number])
                {
                }
                column(SalesTax1; SalesTax[Integer.Number])
                {
                }
                column(VAT11; VAT1[Integer.Number])
                {
                }
                column(Pf1; Pf[Integer.Number])
                {
                }
                column(TotalAmount1_1; "Total Amount1"[Integer.Number])
                {
                }
                column(PaymentTermCode1; PaymentTermCode[Integer.Number])
                {
                }

                trigger OnAfterGetRecord();
                begin
                    Qty[Integer.Number] := Quantity;
                    QRate[Integer.Number] := Rate;
                    QAmount[Integer.Number] := Quantity * Rate;
                    PaymentTermCode[Integer.Number] := "Payment Term Code";
                    VendorAmount[Integer.Number] += Quantity * Rate;
                    Pf[Integer.Number] += "P & F";
                    ExciseDuty[Integer.Number] += "Excise Duty";
                    VAT1[Integer.Number] += VAT;
                    Frieght[Integer.Number] += Freight;
                    Insurance1[Integer.Number] += Insurance;
                    "Total Amount1"[Integer.Number] += "Amt. including Tax";
                end;

                trigger OnPreDataItem();
                begin
                    SETRANGE("RFQ No.", RFQNOG);
                    SETRANGE("Parent Quote No.", QuoteNo[Integer.Number]);
                    SETRANGE("Parent Vendor", Vendor[Integer.Number]);
                end;
            }

            trigger OnPreDataItem();
            begin
                SETRANGE(Number, 1, NoofVendors);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Control")
                {
                    field("RFQ No."; RFQNOG)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        i := 1;
        //RFQNOG := '125';
        PurchHeader.RESET;
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Quote);
        PurchHeader.SETRANGE("RFQ No.", RFQNOG);
        IF PurchHeader.FINDSET THEN
            REPEAT
                Vendor[i] := PurchHeader."Buy-from Vendor No.";
                VendorName[i] := PurchHeader."Buy-from Vendor Name";
                QuoteNo[i] := PurchHeader."No.";
                i += 1;
            UNTIL PurchHeader.NEXT = 0;
        NoofVendors := i;
        CompanyInfo.GET;
    end;

    var
        Qty: array[10] of Decimal;
        QRate: array[10] of Decimal;
        QAmount: array[10] of Decimal;
        Vendor: array[10] of Code[20];
        VendorName: array[10] of Text[50];
        QuoteNo: array[10] of Code[20];
        //QuotationComparision2: Record 50018;
        //QuotationComparision3: Record 50018;
        //QuotationComparision4: Record 50018;
        //QuotationComparision5: Record 50018;
        VendorAmount: array[15] of Decimal;
        VendorDup: Code[20];
        Pf: array[10] of Decimal;
        ExciseDuty: array[10] of Decimal;
        SalesTax: array[10] of Decimal;
        VAT1: array[10] of Decimal;
        Frieght: array[10] of Decimal;
        Insurance1: array[10] of Decimal;
        "Total Amount1": array[10] of Decimal;
        i: Integer;
        j: Integer;
        k: Integer;
        l: Integer;
        Item: Record 27;
        UOM: Code[20];
        PaymentTermCode: array[10] of Code[20];
        QuotationComparisonStatementCaptionLbl: Label 'Quotation Comparison Statement';
        REQNoCaptionLbl: Label 'REQ No.';
        VendorNoCaptionLbl: Label 'Supplier No.';
        VendorNameCaptionLbl: Label 'Supplier Name';
        QuoteNoCaptionLbl: Label 'Quote No.';
        ItemNoCaptionLbl: Label 'Item No.';
        DescriptionCaptionLbl: Label 'Description';
        UOMCaptionLbl: Label 'UOM';
        QuantityCaptionLbl: Label 'Quantity';
        RateCaptionLbl: Label 'Rate';
        AmountCaptionLbl: Label 'Amount';
        TotalBasicValueCaptionLbl: Label 'Total Basic Value';
        ExiseDutyCaptionLbl: Label 'Exise Duty';
        SalesTaxCaptionLbl: Label 'Sales Tax';
        VATCaptionLbl: Label 'VAT';
        OtherChargesCaptionLbl: Label 'Other Charges';
        TotalAmountCaptionLbl: Label 'Total Amount';
        PaymentTermCodeCaptionLbl: Label 'Payment Term Code';
        CompanyInfo: Record 79;
        PurchHeader: Record 38;
        NoofVendors: Integer;
        RFQNOG: Code[20];

    procedure SETRFQ(RFQNoL: Code[20]);
    begin
        RFQNOG := RFQNoL;
    end;
}

