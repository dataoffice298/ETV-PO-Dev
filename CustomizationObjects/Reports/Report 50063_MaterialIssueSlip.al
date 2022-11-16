report 50063 "Material Issue Slip"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Material Issue Slip_50063';
    RDLCLayout = './MaterialIssueSlip.rdl';
    DefaultLayout = RDLC;


    dataset
    {
        dataitem("Indent Header"; "Indent Header")
        {
            RequestFilterFields = "No.";
            column(Indentor1; Indentor)
            { }
            column(IndentNo1; "No.")
            { }

            column(IndentDate; "Document Date")
            { }
            column(CompanyInfoName; Companyinfo.Name)
            { }
            column(CompanyInfoAddress; CompanyInfo.Address)
            { }
            column(CompanyInfoAdress2; CompanyInfo."Address 2")
            { }
            column(TechnicalStoresCapLbl; TechnicalStoresCapLbl)
            { }
            column(MatIssueSlipCapLbl; MatIssueSlipCapLbl)
            { }
            column(IndentorCapLbl; IndentorCapLbl)
            { }
            column(DeptCapLbl; DeptCapLbl)
            { }
            column(LocationCapLbl; LocationCapLbl)
            { }
            column(ProgNamCapLbl; ProgNamCapLbl)
            { }
            column(IndentNoCapLbl; IndentNoCapLbl)
            { }
            column(IndentDateCapLbl; IndentDateCapLbl)
            { }
            column(ChannelCapLbl; ChannelCapLbl)
            { }
            column(IssNoCapLbl; IssNoCapLbl)
            { }
            column(IssDateCapLbl; IssDateCapLbl)
            { }
            column(SNoCapLbl; SNoCapLbl)
            { }
            column(DescofMatCapLbl; DescofMatCapLbl)
            { }
            column(CatNameCapLbl; CatNameCapLbl)
            { }
            column(MakeCapLbl; MakeCapLbl)
            { }
            column(PackCapLbl; PackCapLbl)
            { }
            column(UOMCapLbl; UOMCapLbl)
            { }
            column(ReqQtyCapLbl; ReqQtyCapLbl)
            { }
            column(IssQtyCapLbl; IssQtyCapLbl)
            { }
            column(PurposeCapLbl; PurposeCapLbl)
            { }
            column(StoresAssCapLbl; StoresAssCapLbl)
            { }
            column(ReceiversSigCapLbl; ReceiversSigCapLbl)
            { }
            column(RamojiFCCapLbl; RamojiFCCapLbl)
            { }
            column(Indentor; Indentor)
            { }
            column(Department; Department)
            { }
            column(No_; "No.")
            { }
            column(Document_Date; "Document Date")
            { }
            column(Delivery_Location; "Delivery Location")
            { }

            dataitem("Indent Line"; "Indent Line")
            {
                DataItemLink = "Document No." = field("No.");

                column(Req_Quantity; "Req.Quantity")
                { }
                column(Item_Category_Code; ItemCategoryCode)
                { }
                column(Qty_Issued; "Qty Issued")
                { }

                column(Unit_of_Measure_Code; "Unit of Measure")
                { }
                column(ISSNo1; ISSNo1)
                { }
                column(ISSDate1; ISSDate1)
                { }
                column(Location_Code; "delivery location")
                { }
                column(channel; ItemLedgerEntry."Global Dimension 1 Code")
                { }
                column(Dept; ItemLedgerEntry."Global Dimension 2 Code")
                { }
                column(Description; Description)
                { }
                column(SNo; SNo)
                { }
                column(DescriptionGrec; DescriptionGrec)
                { }
                column(UomGrec; UomGrec)
                { }
                column(ReqQty; ReqQty)
                { }
                column(QtyIssue; QtyIssue)
                { }

                trigger OnAfterGetRecord()
                begin
                    CalcFields("Qty Issued");
                    SNo += 1;
                    ItemLedgerEntry.Reset();
                    ItemLedgerEntry.SetRange("Indent No.", "Document No.");
                    ItemLedgerEntry.SetRange("Indent Line No.", "Line No.");
                    ItemLedgerEntry.SetFilter(Quantity, '<%1', 0);
                    if ItemLedgerEntry.FindFirst() then begin
                        ISSNo1 := ItemLedgerEntry."Document No.";
                        ISSDate1 := ItemLedgerEntry."Posting Date";
                        ItemCategoryCode := ItemLedgerEntry."Item Category Code";
                    end;
                end;

            }

            trigger OnPreDataItem();
            begin
                Clear(SNo);
                CompanyInfo.get;
                CompanyInfo.CALCFIELDS(Picture);
            end;
        }
    }

    var
        pa: Page "Purchase Invoice Statistics";
        ItemCategoryCode: Code[20];
        ISSNo1: Code[20];
        ISSDate1: Date;
        CompanyInfo: Record "Company Information";
        TechnicalStoresCapLbl: Label 'TECHNICAL STORES';
        MatIssueSlipCapLbl: Label 'MATERIAL ISSUE SLIP';
        IndentorCapLbl: Label 'Indentor';
        DeptCapLbl: Label 'Dept';
        LocationCapLbl: Label 'Location';
        ProgNamCapLbl: Label 'Programme Name';
        IndentNoCapLbl: Label 'Indent No';
        IndentDateCapLbl: Label 'Indent Date';
        ChannelCapLbl: Label 'Channel';
        IssNoCapLbl: Label 'ISS.NO';
        IssDateCapLbl: Label 'ISS.Date';
        SNoCapLbl: Label 'SNO.';
        DescofMatCapLbl: Label 'DESCRIPTION OF MATERIAL';
        CatNameCapLbl: Label 'CATERGORY NAME';
        MakeCapLbl: Label 'MAKE';
        PackCapLbl: Label 'PACK';
        UOMCapLbl: Label 'UOM';
        ReqQtyCapLbl: Label 'REQ QTY';
        IssQtyCapLbl: Label 'ISS QTY';
        PurposeCapLbl: Label 'PURPOSE';
        StoresAssCapLbl: Label 'Stores Assistant';
        ReceiversSigCapLbl: Label 'Receivers Signature';
        RamojiFCCapLbl: Label 'RAMOJI FILM CITY - HYDERBAD';
        DescriptionGrec: Text[50];
        UomGrec: Code[10];
        ReqQty: Decimal;
        QtyIssue: Decimal;
        SNo: Integer;
        ItemLedgerEntry: Record "Item Ledger Entry";
}