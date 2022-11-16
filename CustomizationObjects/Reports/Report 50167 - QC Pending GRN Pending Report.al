report 50167 "QC Pending GRN Pending Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'QC Pending GRN Pending Report_50167';


    dataset
    {
        dataitem(IndentHeader; "Indent Header")
        {
            dataitem("Indent Line"; "Indent Line")
            {
                DataItemLink = "Document No." = field("No.");
                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                    Users: Record User;
                    PurchLine: Record "Purchase Line";
                    PurchHdr: Record "Purchase Header";
                    PostGateEntryHdr: Record "Posted Gate Entry Header_B2B";
                begin
                    Clear(PurchLine);
                    Clear(Item);
                    Clear(PurchHdr);

                    SNo += 1;

                    Users.Reset();
                    Users.SetRange("User Name", IndentHeader.Indentor);
                    if Users.FindFirst() then;

                    if Item.Get("No.") then;
                    Clear(PurchHdr);
                    PurchLine.Reset;
                    PurchLine.SetRange("Indent No.", "Indent Line"."Document No.");
                    PurchLine.SetRange("Indent Line No.", "Indent Line"."Line No.");
                    if PurchLine.FindFirst() then
                        if PurchHdr.get(PurchHdr."Document Type"::Order, PurchLine."Document No.") then;

                    PostGateEntryHdr.Reset();
                    PostGateEntryHdr.SetRange("No.", PurchLine."Ref. Posted Gate Entry");
                    if PostGateEntryHdr.FindFirst() then;

                    WindPa.Update(1, "Document No.");
                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn("Document No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(IndentHeader."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(PurchLine."Ref. Posted Gate Entry", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PostGateEntryHdr."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(PurchLine."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchHdr."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(PurchHdr."Buy-from Vendor Name", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchLine."Delivery Challan Posted", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchLine."Delivery Challan Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(Item."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item.Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Quantity (Base)", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn("Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(Amount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);


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
        TempExcelBuffer.CreateBookAndOpenExcel('', 'QC', '', COMPANYNAME, USERID);
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
        TempExcelBuffer.AddColumn('QC Pending GRN Details', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        IF (StartDate <> 0D) or (EndDate <> 0D) THEN
            TempExcelBuffer.AddColumn('QC Pending GRN: ' + Format(StartDate) + ' to ' + Format(EndDate), FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('SNo.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INDENT NO.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INDENT DATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INWARD NO', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INWARD DATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('PO NO', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('PO DATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SUPPLIER NAME', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('DC NO', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('DC DATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('CATEGORY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ITEM CODE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ITEM NAME', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('QTY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UNIT RATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('VALUE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;

}