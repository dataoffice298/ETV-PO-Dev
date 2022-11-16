report 50186 "Return Receipt Gatepass"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Return Receipt Gatepass-F6';

    dataset
    {
        dataitem("Posted Gate Entry Header_B2B"; "Posted Gate Entry Header_B2B")
        {
            DataItemTableView = where(Type = const(RGP));
            dataitem("Posted Gate Entry Line_B2B"; "Posted Gate Entry Line_B2B")
            {
                DataItemLink = "Entry Type" = field("Entry Type"), "Gate Entry No." = field("No."), Type = field(Type);


                trigger OnAfterGetRecord()
                var
                begin

                    SNo += 1;
                    ExcelBuffer.NewRow();
                    ExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Posted Gate Entry Header_B2B"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Posted Gate Entry Header_B2B"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn("Posted Gate Entry Line_B2B"."Source No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Posted Gate Entry Line_B2B"."Source Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Posted Gate Entry Line_B2B"."Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Posted Gate Entry Line_B2B".Variant, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Posted Gate Entry Line_B2B".ModelNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Posted Gate Entry Line_B2B".SerialNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Posted Gate Entry Line_B2B".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Posted Gate Entry Header_B2B"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn("Posted Gate Entry Header_B2B"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);


                end;
            }
            trigger OnPreDataItem()
            begin
                SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                clear(SNo);
                MakeInTransitHeader();
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
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

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnPostReport()
    begin
        CreateExcelbook();
    end;


    var
        SNo: Integer;
        StartDate: Date;
        EndDate: Date;
        ExcelBuffer: Record "Excel Buffer" temporary;


    PROCEDURE MakeInTransitHeader()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('EENADU TELEVISION PVT LTD.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('RETURN RECEIPT GATEPASS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        IF (StartDate <> 0D) or (EndDate <> 0D) THEN
            ExcelBuffer.AddColumn('REPORT From: ' + Format(StartDate) + ' to ' + Format(EndDate), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('SNO.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('RGP NO', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('RGP DATE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('ITEM CODE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('ITEM NAME', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MAKE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MODEL NO', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SERIAL NO', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('QTY', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('RETURN DATE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('LOCATION', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('RECEIPT NO', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('RECEIPT DATE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    PROCEDURE CreateExcelbook()
    BEGIN
        ExcelBuffer.CreateBookAndOpenExcel('', 'Stock Summary', '', COMPANYNAME, USERID);

    END;
}