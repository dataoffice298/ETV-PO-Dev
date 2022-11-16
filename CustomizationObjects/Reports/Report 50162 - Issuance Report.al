report 50162 "Issuance Report"
{
    Caption = 'Issuance Report(Consumption)_50162';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Indent Header"; "Indent Header")
        {
            dataitem("Indent Line"; "Indent Line")
            {
                DataItemLink = "Document No." = field("No.");
                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                    ILE: Record "Item Ledger Entry";
                    Users: Record User;
                    PurchLine: Record "Purchase Line";
                    PostGateEntryLine: Record "Posted Gate Entry Line_B2B";
                begin
                    SNo += 1;

                    Users.Reset();
                    Users.SetRange("User Name", "Indent Header".Indentor);
                    if Users.FindFirst() then;
                    ;
                    if Item.Get("No.") then;
                    CalcFields("Qty Issued");

                    ILE.Reset();
                    ILE.SetRange("Indent No.", "Document No.");
                    ILE.SetRange("Indent Line No.", "Line No.");
                    if ILE.FindFirst() then;

                    PurchLine.Reset();
                    PurchLine.SetRange("Indent No.", "Document No.");
                    PurchLine.SetRange("Indent Line No.", "Line No.");
                    if PurchLine.FindFirst() then begin
                        PostGateEntryLine.Reset();
                        PostGateEntryLine.SetRange("Source No.", PurchLine."Document No.");
                        if PostGateEntryLine.FindFirst() then;
                    end;

                    WindPa.Update(1, "Document No.");
                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn("Indent Header"."Shortcut Dimension 2 Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Indent Header"."Delivery Location", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Indent Header"."Shortcut Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Users."Full Name", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Document No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Indent Header"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(ILE."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(ILE."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Quantity (Base)", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn("Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Qty Issued", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(Amount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(PostGateEntryLine."Gate Entry No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
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
        TempExcelBuffer.CreateBookAndOpenExcel('', 'Consumption Details', '', COMPANYNAME, USERID);
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
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CompanyName, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Consumption Report Details', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        IF (StartDate <> 0D) or (EndDate <> 0D) THEN
            TempExcelBuffer.AddColumn('Consumption Deatils: ' + Format(StartDate) + ' to ' + Format(EndDate), FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('S. No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Dept. Name', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Location', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Channel', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Programme', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Item Category', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('User Name', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Indent No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Indent Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Issue No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Issue Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Item Name', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Order Qty', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Issue Qty', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Issue Rate', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Total Amount', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Inward Ref.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;
}