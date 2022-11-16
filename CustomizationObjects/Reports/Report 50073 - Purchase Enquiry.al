report 50073 "Purchase Enquiry B2B"
{
    // version B2BLIFT1.00.00

    DefaultLayout = RDLC;
    RDLCLayout = 'CustomizationObjects\Reports\Layouts\Purchase Enquiry.rdl';
    Caption = 'Purchase Enquiry';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") ORDER(Ascending) WHERE("Document Type" = CONST(Enquiry));
            RequestFilterFields = "No.";
            column(CompanyInfo_Picture; CompInfo.Picture)
            {
            }
            column(Excise_1_; "Excise1%")
            {
            }
            column(Vat_Cst_; "Vat/Cst%")
            {
            }
            column(CompanyAddr_1_; CompanyAddr[1])
            {
            }
            column(CompanyAddr_2_; CompanyAddr[2])
            {
            }
            column(CompanyAddr_3_; CompanyAddr[3])
            {
            }
            column(CompanyAddr_4_; CompanyAddr[4])
            {
            }
            column(CompanyAddr_5_; CompanyAddr[5])
            {
            }
            column(CompanyAddr_6_; CompanyAddr[6])
            {
            }
            column(CompanyInfo_Phone_No; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfo_Fax_No; CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfo_EMail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfo_Bank_Name_; CompanyInfo."Bank Name")
            {
            }
            column(CompanyInfo_Bank_Account_No_; CompanyInfo."Bank Account No.")
            {
            }
            column(CompanyInfo_Bank_Branch_No_; CompanyInfo."Bank Branch No.")
            {
            }
            column(CompanyInfo__DL_20B_; CompanyInfo__DL_20B_)
            {

            }
            column(CompanyInfo__DL_21B_; CompanyInfo__DL_21B_)
            {

            }

            column(BuyFromAddr_1_; BuyFromAddr[1])
            {
            }
            column(BuyFromAddr_2_; BuyFromAddr[2])
            {
            }
            column(BuyFromAddr_3_; BuyFromAddr[3])
            {
            }
            column(BuyFromAddr_4_; BuyFromAddr[4])
            {
            }
            column(BuyFromAddr_5_; BuyFromAddr[5])
            {
            }
            column(BuyFromAddr_6_; BuyFromAddr[6])
            {
            }
            column(No_PurchaseHeader; "Purchase Header"."No.")
            {
            }
            column(DocumentDate_PurchaseHeader; "Purchase Header"."Document Date")
            {
            }
            column(VendorOrderNo_PurchaseHeader; "Purchase Header"."Vendor Order No.")
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                //DataItemLinkReference = "Purchase Header";
                column(No_PurchaseLine; "Purchase Line"."No.")
                {
                }
                column(Description_PurchaseLine; "Purchase Line".Description)
                {
                }
                column(PlannedReceiptDate_PurchaseLine; "Purchase Line"."Planned Receipt Date")
                {
                }

                column(UnitofMeasure_PurchaseLine; "Purchase Line"."Unit of Measure")
                {
                }
                column(Quantity_PurchaseLine; "Purchase Line".Quantity)
                {
                }
                column(DirectUnitCost_PurchaseLine; "Purchase Line"."Direct Unit Cost")
                {
                }
                column(LineAmount_PurchaseLine; "Purchase Line"."Line Amount")
                {
                }
                column(ExciseAmount; ExciseAmount)
                {
                }
                column(TaxVatAmount; TaxVatAmount)
                {
                }
                column(Packing; Packing)
                {
                }
                column(TotAmount; TotAmount)
                {
                }
                column(Freight; Freight)
                {
                }
                column(Insurance; Insurance)
                {
                }
                column(PaymentTerms_Description; PaymentTerms.Description)
                {
                }
                column(Documents; Documents)
                {
                }
                column(SpecialInstructions; SpecialInstructions)
                {
                }
                column(Text001; Text001Lbl)
                {
                }
                column(Text002; Text002Lbl)
                {
                }
                column(Text003; Text003Lbl)
                {
                }
                column(Text004; Text004Lbl)
                {
                }
                column(Text005; Text005Lbl)
                {
                }
                column(Text006; Text006Lbl)
                {
                }
                column(Text007; Text007Lbl)
                {
                }
                column(Text008; Text008Lbl)
                {
                }
                column(Text009; Text009Lbl)
                {
                }
                column(Text010; Text010Lbl)
                {
                }
                column(Text011Lbl; Text011Lbl + Text0111Lbl)
                {
                }
                column(Text012; Text012Lbl)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                //CurrReport.LANGUAGE := Language.GetLanguageID("Language Code"); //CHeckB2B

                CompanyInfo.GET();

                if RespCenter.GET("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                if PaymentTerms.GET("Payment Terms Code") then;
                FormatAddr.PurchHeaderBuyFrom(BuyFromAddr, "Purchase Header");
                if ("Purchase Header"."Buy-from Vendor No." <> "Purchase Header"."Pay-to Vendor No.") then
                    FormatAddr.PurchHeaderPayTo(VendAddr, "Purchase Header");
            end;

            trigger OnPreDataItem();
            begin
                CompanyInfo.GET();
                CompanyInfo.CALCFIELDS(Picture);

                CompInfo.GET();
                CompInfo.CALCFIELDS(Picture);
            end;
        }
    }

    requestpage
    {
        Caption = 'Purchase Enquiry';

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

    trigger OnInitReport();
    begin
        GLSetup.GET();
    end;

    var
        CompInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        PaymentTerms: Record "Payment Terms";
        RespCenter: Record "Responsibility Center";
        Language: Codeunit Language;
        FormatAddr: Codeunit "Format Address";
        VendAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        BuyFromAddr: array[8] of Text[50];
        ExciseAmount: Decimal;
        TaxVatAmount: Decimal;
        CompanyInfo__DL_20B_: Text[30];
        CompanyInfo__DL_21B_: Text[30];
        Packing: Decimal;
        Freight: Decimal;
        Insurance: Decimal;
        SpecialInstructions: Text[50];
        TotAmount: Decimal;
        Documents: Text[50];
        "Vat/Cst%": Decimal;
        "Excise1%": Decimal;
        Text001Lbl: Label '1.  Central Excise Invoice( Original & Duplicate for Transporter Copies), wherever applicable,should accompany the material .';
        Text002Lbl: Label '2.  Only one item should be billed in one invoice, against single Purchase Order.';
        Text003Lbl: Label '3.  Material acceptance is subject to approval by our Quality Control Department.';
        Text004Lbl: Label '4.  Cost of transporting the reject materials is to be borne by you';
        Text005Lbl: Label '5.  In the event of Excise Authorities refusing to allow Central credit for improper endorsement or other defects in the Invoice, the amount will be debited to your account .';
        Text006Lbl: Label '6.  Sales Tax is payable only if S.T. Regn. No. is mentioned in the invoice . In case of CST sales, only 4% will be paid along with ''C'' form.';
        Text007Lbl: Label '7.  Delivery Schedule given should be strictly followed.';
        Text008Lbl: Label '8.  In case, the goods are held by Sales Tax / Excise Authorities for improper documentation from your side, the penalty or other costs levied will be debited to your account.';
        Text009Lbl: Label '9.  Invoice in duplicate bearing the relevant order number & date must be sent to our factory within a week''s time';
        Text010Lbl: Label '10. Any loss due to breakage, damage, leakage, pilferage etc., due to faulty packaging will be borne by you.';
        Text011Lbl: Label '11. Any demurage, penalties, interest and other charges, which we may have to pay on account for your not booking  the goods in accordance';
        Text0111Lbl: Label 'with  the order, or delay in delivering the bill of carrier to us, either by you or banker, will be debited to your account.';
        Text012Lbl: Label '12. The Company reserves the right to cancel the order either in whole or in part of suspending of the same without assigning any reason whatsoever.';

}

