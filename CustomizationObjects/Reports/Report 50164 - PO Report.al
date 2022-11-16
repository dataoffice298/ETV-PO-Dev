
report 50164 "Po Report"//>>CH15SEP2022
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Po Report_50164';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        layout
        {
            area(Content)
            {

            }
        }

    }

    var

        ExcelBuffer1: Record "Excel Buffer" temporary;
        SNo: integer;
        StartDate: Date;
        EndDate: Date;

    trigger OnPostReport()
    begin
        PurchaseOrderExport();

    end;



    procedure PurchaseOrderExport()
    begin
        ExcelBuffer1.DeleteAll();
        MakeOrderExcelDataHeader();

        MakeOrderExcelDataBody();
        CreateExcelbook();

    end;

    PROCEDURE MakeOrderExcelDataHeader()
    BEGIN
        ExcelBuffer1.NewRow();
        ExcelBuffer1.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn(CompanyName, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.NewRow();
        ExcelBuffer1.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('Open PO Report', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.NewRow();
        ExcelBuffer1.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        IF (StartDate <> 0D) or (EndDate <> 0D) THEN
            ExcelBuffer1.AddColumn('Open PO: ' + Format(StartDate) + ' to ' + Format(EndDate), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.NewRow;
        ExcelBuffer1.AddColumn('SL NO.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('INDENT NUMBER', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('INDENT DATE', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('PO NUMBER', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('PO DATE', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('SUPPLIER NAME', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('ITEM CODE', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('ITEM NAME', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('UOM', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('QTY', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('UNIT RATE', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('AMOUNT', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
    END;

    PROCEDURE MakeOrderExcelDataBody()
    var
        IndentRequsition: Record "Indent Req Header";
        PurchaseHeader: Record "Purchase Header";
        PurchaseOrderLine: Record "Purchase Line";
    BEGIN
        clear(SNo);
        PurchaseOrderLine.Reset();
        PurchaseOrderLine.SetFilter(Quantity, '<>%1', 0);
        PurchaseOrderLine.SetRange("Document Type", PurchaseOrderLine."Document Type"::Order);
        if PurchaseOrderLine.FindSet() then
            repeat

                PurchaseHeader.get(PurchaseOrderLine."Document Type", PurchaseOrderLine."Document No.");
                IndentRequsition.Reset();
                IndentRequsition.SetRange("No.", PurchaseHeader."Indent Requisition No");
                if IndentRequsition.FindFirst() then begin
                    SNo += 1;
                    ExcelBuffer1.NewRow;
                    ExcelBuffer1.AddColumn(SNo, FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn(PurchaseHeader."Indent Requisition No", FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn(IndentRequsition."Document Date", FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn(PurchaseOrderLine."Document No.", FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn(PurchaseHeader."Posting Date", FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn(PurchaseHeader."Buy-from Vendor Name", FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn(PurchaseOrderLine."No.", FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn(PurchaseOrderLine.Description, FALSE, '', false, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn(PurchaseOrderLine."Unit of Measure", FALSE, '', false, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn(PurchaseOrderLine.Quantity, FALSE, '', false, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn(PurchaseOrderLine."Unit Cost", FALSE, '', false, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn(PurchaseOrderLine."Unit Cost" * PurchaseOrderLine.Quantity, FALSE, '', false, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                end
            until PurchaseOrderLine.Next() = 0;
    END;


    PROCEDURE CreateExcelbook()
    BEGIN
        ExcelBuffer1.CreateBookAndOpenExcel('', 'Open Po', '', COMPANYNAME, USERID);

    END;



}