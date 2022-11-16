report 50106 "Current Stock Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Category Wise Stock Summary_50106';

    dataset
    {

        dataitem(Item; Item)
        {
            DataItemTableView = sorting("Item Category Code");
            RequestFilterFields = "Item Category Code", "No.";
            trigger OnAfterGetRecord()
            var
                IndentHeader: Record "Indent Header";
                Users: Record User;
                FixedAsset: Record "Fixed Asset";
                NewStartDate: Date;
                ItemLedgerEntry: Record "Item Ledger Entry";
                Openingstock: Decimal;
                InwardStock: Decimal;
                OutwardStock: Decimal;
                ClosingStock: Decimal;
            begin
                Clear(Openingstock);
                Clear(InwardStock);
                Clear(OutwardStock);
                Clear(ClosingStock);
                SNo += 1;

                NewStartDate := CALCDATE('-1D', StartDate);

                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Item No.", Item."No.");
                ItemLedgerEntry.SETFILTER("Posting Date", '..%1', NewStartDate);
                IF ItemLedgerEntry.FINDSET THEN begin
                    ItemLedgerEntry.CalcSums(Quantity);
                    Openingstock += ItemLedgerEntry.Quantity;
                end;

                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Item No.", Item."No.");
                ItemLedgerEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                ItemLedgerEntry.SetFilter("Document Type", '%1|%2|%3|%4|%5', ItemLedgerEntry."Document Type"::"Purchase Invoice",
                                                                             ItemLedgerEntry."Document Type"::"Purchase Receipt",
                                                                             ItemLedgerEntry."Document Type"::"Sales Credit Memo",
                                                                             ItemLedgerEntry."Document Type"::"Sales Return Receipt",
                                                                             ItemLedgerEntry."Document Type"::"Transfer Receipt");
                IF ItemLedgerEntry.FINDSET THEN begin
                    ItemLedgerEntry.CalcSums(Quantity);
                    InwardStock += ItemLedgerEntry.Quantity;
                end;

                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Item No.", Item."No.");
                ItemLedgerEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                ItemLedgerEntry.SetFilter("Entry Type", '%1|%2', ItemLedgerEntry."Entry Type"::"Positive Adjmt.",
                                                                 ItemLedgerEntry."Entry Type"::Output);
                IF ItemLedgerEntry.FINDSET THEN begin
                    ItemLedgerEntry.CalcSums(Quantity);
                    InwardStock += ItemLedgerEntry.Quantity;
                end;

                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Item No.", Item."No.");
                ItemLedgerEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                ItemLedgerEntry.SetFilter("Document Type", '%1|%2|%3|%4|%5', ItemLedgerEntry."Document Type"::"Sales Invoice",
                                                                             ItemLedgerEntry."Document Type"::"Sales Shipment",
                                                                             ItemLedgerEntry."Document Type"::"Purchase Return Shipment",
                                                                             ItemLedgerEntry."Document Type"::"Purchase Credit Memo",
                                                                             ItemLedgerEntry."Document Type"::"Transfer Shipment");
                IF ItemLedgerEntry.FINDSET THEN begin
                    repeat
                        OutwardStock += ABS(ItemLedgerEntry.Quantity);
                    until ItemLedgerEntry.Next() = 0;
                end;

                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Item No.", Item."No.");
                ItemLedgerEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                ItemLedgerEntry.SetFilter("Entry Type", '%1|%2', ItemLedgerEntry."Entry Type"::"Negative Adjmt.",
                                                                 ItemLedgerEntry."Entry Type"::Consumption);
                IF ItemLedgerEntry.FINDSET THEN begin
                    repeat
                        OutwardStock += ABS(ItemLedgerEntry.Quantity);
                    until ItemLedgerEntry.Next() = 0;
                end;

                ClosingStock := (Openingstock + InwardStock) - OutwardStock;


                WindPa.Update(1, Item."No.");
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(Item."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Item."No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Item.Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Item."Base Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(Item."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(Openingstock, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Item."Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Round(Openingstock * Item."Unit Cost", 0.01), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(InwardStock, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Item."Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Round(InwardStock * Item."Unit Cost", 0.01), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(OutwardStock, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Item."Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Round(OutwardStock * Item."Unit Cost", 0.01), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ClosingStock, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Item."Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Round(ClosingStock * Item."Unit Cost", 0.01), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

            end;

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
        TempExcelBuffer.CreateBookAndOpenExcel('', 'Category Wise Stock', '', COMPANYNAME, USERID);
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
        TempExcelBuffer.AddColumn('Category Wise Stock Summary', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        IF (StartDate <> 0D) or (EndDate <> 0D) THEN
            TempExcelBuffer.AddColumn('Stock Summary: ' + Format(StartDate) + ' to ' + Format(EndDate), FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Particulars', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Opening Stock', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Inwards', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Outwards', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Closing Stock', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('SNo.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ITEM CATEGORY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ITEM CODE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ITEM NAME', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('MAKE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('CATEGORY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('QUANTITY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UNIT RATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('STOCK VALUE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('QUANTITY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UNIT RATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('STOCK VALUE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('QUANTITY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UNIT RATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('STOCK VALUE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('QUANTITY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UNIT RATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('STOCK VALUE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

    end;
}