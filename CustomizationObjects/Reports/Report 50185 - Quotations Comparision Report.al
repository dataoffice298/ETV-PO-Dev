report 50185 "Comparitive Statement"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Comparitive Statement Report_50185';
    RDLCLayout = './Quotation Comparison 2.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number);
            PrintOnlyIfDetail = false;
            column(Number_Integer; Number)
            {
            }
            column(SNoCapLbl; SNoCapLbl)
            { }
            column(DescriptionCapLbl; DescriptionCapLbl)
            { }
            column(HSNCodeCapLbl; HSNCodeCapLbl)
            { }
            column(QtyCapLbl; QtyCapLbl)
            { }
            Column(UnitsCapLbl; UnitsCapLbl)
            { }
            column(ModelCapLbl; ModelCapLbl)
            { }
            column(MRPCapLbl; MRPCapLbl)
            { }
            column(GSTCapLbl; GSTCapLbl)
            { }
            column(RatesCapLbl; RatesCapLbl)
            { }
            column(TransportationCapLbl; TransportationCapLbl)
            { }
            column(DeliveryCapLbl; DeliveryCapLbl)
            { }
            column(PaymentCapLbl; PaymentCapLbl)
            { }
            column(WarrantyCapLbl; WarrantyCapLbl)
            { }
            column(ContactPersonCapLbl; ContactPersonCapLbl)
            { }
            column(PhoneNoCapLbl; PhoneNoCapLbl)
            { }
            column(QtnNoCapLbl; QtnNoCapLbl)
            { }



            dataitem(DataItem1102152028; "Quotation Comparison Test")
            {
                DataItemTableView = SORTING("RFQ No.", "Item No.", "Variant Code")
                                    ORDER(Ascending);
                PrintOnlyIfDetail = false;
                column(ComparitiveCapLbl; ComparitiveCapLbl)
                {

                }
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
                column(IndentNoCapLbl; IndentNoCapLbl)
                { }
                column(PurposeCapLbl; PurposeCapLbl)
                { }
                column(NameoftheIndentorCapLbl; NameoftheIndentorCapLbl)
                { }

                column(UnitRateCapLbl; UnitRateCapLbl)
                { }

                column(TermsConditionsCapLbl; TermsConditionsCapLbl)
                { }

                column(RsCapLbl; RsCapLbl)
                { }
                column(IndentNo; IndentNo)
                { }
                column(Document_Date; "Document Date")
                { }
                column(Indentor; Indentor)
                { }
                column(HSNCode; HSNCode)
                { }
                column(Indent_No_; "Indent No.")
                { }
                column(Quot_Comp_No_; "Quot Comp No.")
                { }
                column(GST; GST)
                { }
                column(CollectedCapLbl; CollectedCapLbl)
                { }
                column(Payment; Payment)
                { }
                column(warranty; warranty)
                { }
                column(Delivery; Delivery)
                { }
                column(Rate; Rate)
                { }
                column(Parent_Quote_No_; "Parent Quote No.")
                { }
                column(ContactPerson; ContactPerson)
                { }
                Column(PhoneNo; PhoneNo)
                { }



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



                    /* PurchLine.Reset();
                     PurchLine.setrange("Document No.", PurchHdr."No.");
                     If PurchLine.FindSet() then
                         repeat
                             HSNCode := PurchLine."HSN/SAC Code";
                             UOM := PurchLine."Unit of Measure Code";
                             GST := PurchLine."GST Group Code";
                         until PurchLine.Next() = 0;*/
                    Clear(HSNCode);
                    Clear(UOM);
                    PurchHdr.Reset();
                    PurchHdr.SetRange("Document Type", PurchHdr."Document Type"::Quote);
                    PurchHdr.SetRange("No.", "Parent Quote No.");
                    if PurchHdr.FindFirst() then begin
                        Payment := PurchHdr."Payment Terms Code";
                        warranty := PurchHdr.Warranty;

                        PurchLine.Reset();
                        PurchLine.SetRange("Document Type", PurchHdr."Document Type");
                        PurchLine.SetRange("Document No.", PurchHdr."No.");
                        if PurchLine.FindFirst() then begin
                            HSNCode := PurchLine."HSN/SAC Code";
                            UOM := PurchLine."Unit of Measure Code";
                            GST := PurchLine."GST Group Code";
                            if PurchHdr."Expected Receipt Date" <> 0D then
                                DeliveryDays := PurchHdr."Expected Receipt Date" - WorkDate();

                            GSTSetup.get();
                            GetGSTAmounts(TaxTransactionValue, PurchLine, GSTSetup);
                            Gstamt := CGSTAmt + SGSTAmt + IGSTAmt;
                            GSTPerc := CGSTPer + SGSTPer + IGSTPer;

                            IF Vend.get(PurchHdr."Buy-from Vendor No.") then begin
                                ContactPerson := Vend.Contact;
                                PhoneNo := Vend."Phone No.";
                            end;

                            //   IF Indentor1.get() then
                            //       Indentor := IndentHdr.Indentor;
                        end;
                    end;

                    IndentHdr.Reset();
                    IndentHdr.SetRange("No.", "Parent Quote No.");
                    Indentor := IndentHdr.Indentor;

                    QuoComp.Reset();
                    QuoComp.SetRange("Quot Comp No.", "Quot Comp No.");
                    If QuoComp.Findset() then
                        UnitPrice := QuoComp.Rate;
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

    local procedure GetGSTAmounts(TaxTransactionValue: Record "Tax Transaction Value";
   PurchaseLine: Record "Purchase Line";
   GSTSetup: Record "GST Setup")
    var
        ComponentName: Code[30];
    begin
        ComponentName := GetComponentName(PurchaseLine, GSTSetup);

        if (PurchaseLine.Type <> PurchaseLine.Type::" ") then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    case TaxTransactionValue."Value ID" of
                        6:
                            begin
                                SGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                SGSTPer := TaxTransactionValue.Percent;
                            end;
                        2:
                            begin
                                CGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                CGSTPer := TaxTransactionValue.Percent;
                            end;
                        3:
                            begin
                                IGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                IGSTPer := TaxTransactionValue.Percent;
                            end;
                    end;
                until TaxTransactionValue.Next() = 0;
        end;
    end;

    local procedure GetComponentName(PurchaseLine: Record "Purchase Line";
       GSTSetup: Record "GST Setup"): Code[30]
    var
        ComponentName: Code[30];
    begin
        if GSTSetup."GST Tax Type" = GSTLbl then
            if PurchaseLine."GST Jurisdiction Type" = PurchaseLine."GST Jurisdiction Type"::Interstate then
                ComponentName := IGSTLbl
            else
                ComponentName := CGSTLbl
        else
            if GSTSetup."Cess Tax Type" = GSTCESSLbl then
                ComponentName := CESSLbl;
        exit(ComponentName)
    end;

    procedure GetGSTRoundingPrecision(ComponentName: Code[30]): Decimal
    var
        TaxComponent: Record "Tax Component";
        GSTSetup: Record "GST Setup";
        GSTRoundingPrecision: Decimal;
    begin
        if not GSTSetup.Get() then
            exit;
        GSTSetup.TestField("GST Tax Type");

        TaxComponent.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxComponent.SetRange(Name, ComponentName);
        TaxComponent.FindFirst();
        if TaxComponent."Rounding Precision" <> 0 then
            GSTRoundingPrecision := TaxComponent."Rounding Precision"
        else
            GSTRoundingPrecision := 1;
        exit(GSTRoundingPrecision);
    end;

    var
        ComparitiveCapLbl: Label 'Comparitive Statement';
        PurchLine: Record "Purchase Line";
        PurchHdr: Record "Purchase Header";
        HSNCode: Code[20];
        QuoComp: Record "Quotation Comparison Test";
        QuoCompHdr: Record QuotCompHdr;
        UnitPrice: Decimal;
        IndentHdr: Record "Indent Header";
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
        IndentNo: Code[20];
        IndentNoCapLbl: Label 'Indent No.:';
        PurposeCapLbl: Label 'Purpose:';
        NameoftheIndentorCapLbl: Label 'Name of the Indentor:';
        SNoCapLbl: Label 'SNo.';
        DescriptionCapLbl: Label 'Description';
        HSNCodeCapLbl: Label 'HSN Code';
        QtyCapLbl: Label 'Qty.';
        UnitsCapLbl: Label 'Units';
        ModelCapLbl: Label 'Model No.:';
        MRPCapLbl: Label 'MRP';
        TermsConditionsCapLbl: Label 'Terms & Conditions';
        QtnNoCapLbl: Label 'Qtn No. & Dt.:';
        RatesCapLbl: Label 'Rates:';
        GSTCapLbl: Label 'GST:';
        TransportationCapLbl: Label 'Transportation:';
        DeliveryCapLbl: Label 'Delivery:';
        PaymentCapLbl: Label 'Payment:';
        WarrantyCapLbl: Label 'Warranty:';
        ContactPersonCapLbl: Label 'Contact Person:';
        PhoneNoCapLbl: Label 'Phone No.:';
        UnitRateCapLbl: Label 'Unit Rate';
        RsCapLbl: Label '(Rs.)';
        RsCapLbl1: Label '(Rs.)';
        Indentor: Text[50];
        Units: Integer;
        GST: Code[20];
        CollectedCapLbl: Label 'Collected by RFC';

        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTAmt: Decimal;
        CessAmt: Decimal;
        IGSTLbl: Label 'IGST';
        SGSTLbl: Label 'SGST';
        CGSTLbl: Label 'CGST';
        CESSLbl: Label 'CESS';
        GSTLbl: Label 'GST';
        GSTCESSLbl: Label 'GST CESS';
        SGSTPer: Decimal;
        IGSTPer: Decimal;
        CGSTPer: Decimal;
        GSTSetup: Record "GST Setup";
        TaxTransactionValue: Record "Tax Transaction Value";
        Payment: code[20];
        warranty: Code[20];
        DeliveryDays: Integer;
        Vend: Record Vendor;
        GSTPerc: Decimal;
        Gstamt: Decimal;
        ContactPerson: Text[100];
        PhoneNo: Text[30];
        Indentor1: Record "Indent Header";


    procedure SETRFQ(RFQNoL: Code[20]);
    begin
        RFQNOG := RFQNoL;
    end;
}

