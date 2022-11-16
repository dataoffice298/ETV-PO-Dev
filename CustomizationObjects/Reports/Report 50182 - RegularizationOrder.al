report 50182 "Regularization Order"
{
    Caption = 'Regularization Order_50182';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './RegularizationOrder.rdl';


    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.")
            { }
            column(Picture_CompanyInfo; CompanyInfo.Picture)
            { }
            column(Name_CompanyInfo; CompanyInfo.Name)
            { }
            column(GSTNo_CompanyInfo; CompanyInfo."GST Registration No.")
            { }
            column(StateName_CompanyInfo; StateGRec.Description)
            { }
            column(StateCodeGST_CompanyInfo; StateGRec."State Code (GST Reg. No.)")
            { }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
            { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            { }
            column(Buy_from_Address; "Buy-from Address")
            { }
            column(Buy_from_Address_2; "Buy-from Address 2")
            { }
            column(Buy_from_City; "Buy-from City")
            { }
            column(Buy_from_Contact_No_; "Buy-from Contact No.")
            { }
            column(Buy_from_Email; VendorGRec."E-Mail")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(Dear_CaptionLbl; Dear_CaptionLbl)
            { }
            column(Quote_No_; "Quote No.")
            { }
            column(Subject; Subject)
            { }
            column(AmountText; AmountText[1])
            { }
            column(TotalOrderAmount; TotalOrderAmount)
            { }
            column(AckLbl; AckLbl)
            { }
            column(ThankYouLbl; ThankYouLbl)
            { }
            column(ETVLbl; ETVLbl)
            { }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                column(Document_No_; "Document No.")
                { }
                column(Line_No_; "Line No.")
                { }
                column(SNo; SNo)
                { }
                column(No_PurchLine; "No.")
                { }
                column(Description; Description)
                { }
                column(HSN_SAC_Code; "HSN/SAC Code")
                { }
                column(Quantity; Quantity)
                { }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                { }
                column(Unit_Cost; "Unit Cost")
                { }
                column(Line_Amount; "Line Amount")
                { }
                column(CGSTAmt; CGSTAmt)
                { }
                column(SGSTAmt; SGSTAmt)
                { }
                column(IGSSTAmt; IGSSTAmt)
                { }
                column(TotalGSTAmount; TotalGSTAmount)
                { }
                column(TotalLineAmount; TotalLineAmount)
                { }

                trigger OnPreDataItem()
                begin
                    SetFilter("No.", '<>%1', '');
                end;

                trigger OnAfterGetRecord()
                begin
                    SNo += 1;
                    Clear(CGSTAmt);
                    Clear(SGSTAmt);
                    Clear(IGSSTAmt);

                    TotalLineAmount += "Purchase Line"."Line Amount";

                    GetGSTAmounts("Purchase Line");
                    TotalGSTAmount += CGSTAmt + SGSTAmt + IGSSTAmt;
                end;

                trigger OnPostDataItem()
                begin
                    TotalOrderAmount := TotalLineAmount + TotalGSTAmount;
                    Clear(AmountText);
                    GateEntryPostYesNo.InitTextVariable;
                    GateEntryPostYesNo.FormatNoText(AmountText, Round(TotalOrderAmount, 1, '='), "Currency Code");
                end;
            }

            dataitem(GSTLoop; Integer)
            {
                DataItemTableView = sorting(Number);
                DataItemLinkReference = "Purchase Header";

                column(Number_GSTLoop; Number)
                { }
                column(GSTGroupCode_PurchLineGST; PurchLineGST."GST Group Code")
                { }
                column(GSTPerText; GSTPerText)
                { }
                column(GSTAmountLine; GSTAmountLine[I])
                { }

                trigger OnPreDataItem()
                begin
                    Clear(GSTGroupCode);
                    I := 1;
                    PurchLineGST.Reset();
                    PurchLineGST.SetCurrentKey("Line No.", "GST Group Code");
                    PurchLineGST.SetRange("Document No.", "Purchase Header"."No.");
                    PurchLineGST.SetFilter("GST Group Code", '<>%1', '');
                    PurchLineGST.SetFilter("No.", '<>%1', '');
                    if PurchLineGST.FindSet() then;

                    SetRange(Number, 1, PurchLineGST.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    Clear(GSTPerText);
                    Clear(GSTPercent);
                    if GSTGroupCode <> PurchLineGST."GST Group Code" then begin
                        GSTGroupCode := PurchLineGST."GST Group Code";
                        PurchLine.Reset();
                        PurchLine.SetCurrentKey("GST Group Code");
                        PurchLine.SetRange("Document No.", PurchLineGST."Document No.");
                        PurchLine.SetFilter("GST Group Code", PurchLineGST."GST Group Code");
                        if PurchLine.FindSet() then begin
                            GetGSTPercents(PurchLine);
                            if GSTPercent <> 0 then begin
                                I += 1;
                                GSTPerText := StrSubstNo(GSTText, GSTPercent);
                                repeat
                                    GetGSTAmounts(PurchLine);
                                    GSTAmountLine[I] += SGSTAmt + IGSSTAmt + CGSTAmt;
                                    LineSNo := DelChr(Format(PurchLine."Line No."), '>', '0');
                                    GSTPerText += LineSNo + ' & ';
                                until PurchLine.Next() = 0;
                                GSTPerText := DelChr(GSTPerText, '>', ' &');
                            end;
                        end;
                    end;
                    if PurchLineGST.Next() = 0 then
                        CurrReport.Break();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(SNo);
                Clear(TotalGSTAmount);
                Clear(TotalLineAmount);
                NextLoop := false;
                CompanyInfo.get;
                CompanyInfo.CalcFields(Picture);

                if StateGRec.Get(CompanyInfo."State Code") then;

                if VendorGRec.Get("Buy-from Vendor No.") then;

                if PurchaseHdr.Get(PurchaseHdr."Document Type"::Quote, "Quote No.") then;

                PurchLine.Reset();
                PurchLine.SetRange("Document No.", "No.");
                PurchLine.SetFilter("No.", '<>%1', '');
                if PurchLine.FindFirst() then
                    if IndentHdr.Get(PurchLine."Indent No.") then;

                Subject := StrSubstNo(Subject1, "Quote No.", "Purchase Header"."Document Date");
                Subject := Subject + StrSubstNo(Subject2, IndentHdr."No.", IndentHdr."Document Date");

                PurchLine.Reset();
                PurchLine.SetCurrentKey("GST Group Code");
                PurchLine.SetRange("Document No.", "No.");
                PurchLine.SetFilter("GST Group Code", '<>%1', '');
                if PurchLine.FindSet() then begin
                    GSTGroupCode := PurchLine."GST Group Code";
                    repeat
                        if GSTGroupCode <> PurchLine."GST Group Code" then
                            NextLoop := true;
                    until PurchLine.Next() = 0;
                end;
            end;
        }
    }


    var
        CompanyInfo: Record "Company Information";
        StateGRec: Record State;
        VendorGRec: Record Vendor;
        PurchaseHdr: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchLineGST: Record "Purchase Line";
        IndentHdr: Record "Indent Header";
        Dear_CaptionLbl: Label 'Dear Sir,';
        Subject: Text;
        Subject1: Label 'With reference to your Quotation No. %1/dt. %2 and subsequent discussion we had with you, ';
        Subject2: Label 'We would like to place order on you for the following lines against the Indent No. %1/dt. %2';
        IGSTLbl: Label 'IGST';
        SGSTLbl: Label 'SGST';
        CGSTLbl: Label 'CGST';
        GSTLbl: Label 'GST';
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSSTAmt: Decimal;
        SNo: Integer;
        TotalLineAmount: Decimal;
        TotalGSTAmount: Decimal;
        TotalOrderAmount: Decimal;
        GSTPercent: Decimal;
        GSTGroupCode: Code[10];
        NextLoop: Boolean;
        GSTText: Label 'GST @%1% on S.No. ';
        GSTPerText: Text;
        LineSNo: Text;
        AmountText: array[2] of Text;
        GateEntryPostYesNo: Codeunit "Gate Entry- Post Yes/No";
        AckLbl: Label 'Please acknowledge the receipt of the order and arrange the material at the earliest.';
        ThankYouLbl: Label 'Thanking you,';
        ETVLbl: Label 'For EENADU TELEVISION PVT. LIMITED';
        GSTAmountLine: array[10] of Decimal;
        I: Integer;

    //GST Starts>>
    local procedure GetGSTAmounts(PurchaseLine: Record "Purchase Line")
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
        ComponentName: Code[30];
    begin
        GSTSetup.Get();
        ComponentName := GetComponentName("Purchase Line", GSTSetup);

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
                            SGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                        2:
                            CGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                        3:
                            IGSSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
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
                ComponentName := CGSTLbl;
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

    local procedure GetGSTPercents(PurchaseLine: Record "Purchase Line")
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
        ComponentName: Code[30];
    begin
        GSTSetup.Get();
        ComponentName := GetComponentName("Purchase Line", GSTSetup);

        if (PurchaseLine.Type <> PurchaseLine.Type::" ") then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    GSTPercent += TaxTransactionValue.Percent;
                until TaxTransactionValue.Next() = 0;
        end;
    end;
    //GST Ends<<
}