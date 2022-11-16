report 50166 "Inward Receipt Details"
{
    Caption = 'Inward Receipt_50166';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Posted Gate Entry Header_B2B"; "Posted Gate Entry Header_B2B")
        {
            dataitem("Posted Gate Entry Line_B2B"; "Posted Gate Entry Line_B2B")
            {
                DataItemLink = "Entry Type" = field("Entry Type"), "Gate Entry No." = field("No.");
                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                    Vendor: Record Vendor;
                    Users: Record User;
                    PurchInvLine: Record "Purch. Inv. Line";
                    PurchInvHdr: Record "Purch. Inv. Header";
                    PurchInvNo: Code[20];
                    PurchRcptLine: Record "Purch. Rcpt. Line";
                    PurchRcptHdr: Record "Purch. Rcpt. Header";
                    VATAmount: Decimal;
                    DocumentTotals: Codeunit "Document Totals";
                    DtldGSTLdgEntry: Record "Detailed GST Ledger Entry";
                    CGST: Decimal;
                    IGST: Decimal;
                    SGST: Decimal;
                    TotalGST: Decimal;
                    TDSEntry: Record "TDS Entry";
                    TDSAmt: Decimal;
                    LineAmount: Decimal;
                    TotAmt: Decimal;
                begin
                    Clear(CGST);
                    Clear(IGST);
                    Clear(SGST);
                    Clear(TDSAmt);
                    Clear(PurchRcptHdr);
                    Clear(PurchInvLine);
                    Clear(PurchInvHdr);
                    Clear(DtldGSTLdgEntry);
                    Clear(TDSEntry);
                    Clear(TotalGST);
                    Clear(LineAmount);

                    WindPa.Update(1, "Gate Entry No.");

                    PurchRcptLine.Reset();
                    PurchRcptLine.SetRange("Ref. Posted Gate Entry", "Gate Entry No.");
                    if PurchRcptLine.FindFirst() then begin
                        if PurchRcptHdr.Get(PurchRcptLine."Document No.") then;
                        PurchInvLine.Reset();
                        PurchInvLine.SetRange("Receipt No.", PurchRcptLine."Document No.");
                        PurchInvLine.SetRange("Receipt Line No.", PurchRcptLine."Line No.");
                        if PurchInvLine.FindSet() then begin
                            LineAmount := PurchInvLine."Line Amount";
                            if PurchInvHdr.Get(PurchInvLine."Document No.") then;
                            DocumentTotals.CalculatePostedPurchInvoiceTotals(PurchInvHdr, VATAmount, PurchInvLine);
                            DtldGSTLdgEntry.Reset();
                            DtldGSTLdgEntry.SetRange("Document No.", PurchInvLine."Document No.");
                            DtldGSTLdgEntry.SetRange("Document Line No.", PurchInvLine."Line No.");
                            if DtldGSTLdgEntry.FindSet() then
                                repeat
                                    if DtldGSTLdgEntry."GST Component Code" = 'CGST' then
                                        CGST += DtldGSTLdgEntry."GST Amount";
                                    if DtldGSTLdgEntry."GST Component Code" = 'SGST' then
                                        SGST += DtldGSTLdgEntry."GST Amount";
                                    if DtldGSTLdgEntry."GST Component Code" = 'IGST' then
                                        IGST += DtldGSTLdgEntry."GST Amount";
                                until DtldGSTLdgEntry.Next() = 0;
                            TotalGST := CGST + IGST + SGST;
                            TDSEntry.Reset();
                            TDSEntry.SetRange("Document No.", PurchInvLine."Document No.");
                            if TDSEntry.FindSet() then
                                TDSAmt := TDSEntry."TDS Amount";
                        end;
                    end;
                    TotAmt := LineAmount + CGST + SGST + IGST - TDSAmt;

                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn("Gate Entry No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Posted Gate Entry Header_B2B"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(PurchRcptHdr."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(PurchRcptHdr."Buy-from Vendor Name", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchInvLine."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchInvHdr."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(PurchInvLine."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchInvLine."No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchInvLine.Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchInvLine."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchInvLine.Quantity, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(PurchInvLine."Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(PurchInvLine."VAT %", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(VATAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(PurchInvLine."Line Discount Amount", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(CGST, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(SGST, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(IGST, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(TDSAmt, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(PurchInvLine."Line Amount", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(TotAmt, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchInvHdr."EPCG No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchRcptHdr."Order No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

                end;
            }
            trigger OnPreDataItem()
            begin
                Clear(SNo);
                MakeExcelHeaders();
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Date Filters")
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = all;
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }

    }

    trigger OnPreReport()
    begin
        TempExcelBuffer.DeleteAll();
    end;

    trigger OnPostReport()
    begin
        WindPa.CLOSE();
        TempExcelBuffer.CreateBookAndOpenExcel('', 'Inward Receipt', '', COMPANYNAME, USERID);
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        StartDate: Date;
        EndDate: Date;
        WindPa: Dialog;
        SNo: Integer;

    procedure MakeExcelHeaders()
    begin
        WindPa.OPEN('Processing #1###############');
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CompanyName, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Inward Receipt Details', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        IF (StartDate <> 0D) or (EndDate <> 0D) THEN
            TempExcelBuffer.AddColumn('Inward Receipt: ' + Format(StartDate) + ' to ' + Format(EndDate), FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('SNO', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INWARD NO.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INWARD DATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RECEIPT DATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SUPPLIER NAME', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INVOICE NO', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INVOICE DATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('CATEGORY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ITEM CODE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ITEM NAME', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('QTY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('VAT%', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('VAT AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('CST%', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('CST AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EXCISE%', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EXCISE AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('DISCOUNT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('CGST', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SGST', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('IGST', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('TDS', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('BASIC AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('TOTAL AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('NARRATION', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('IMPORT STATUS', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EPCG SHEME', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('REFERENCE NO', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;
}
