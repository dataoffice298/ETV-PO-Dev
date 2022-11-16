report 50179 "Purchase Line Tracking Import"
{
    Caption = 'Purchase Line Tracking Import';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {


    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Selection")
                {
                    field(Options; Direction)
                    {

                    }
                }
                group("Select Field")
                {
                    field("Serial No."; SerialNo)
                    {
                        ApplicationArea = All;

                    }
                    field("Item No"; No)
                    {

                    }
                    field(Quantity; Quantity)
                    {

                    }

                }
            }
        }
        trigger OnQueryClosePage(CloseAction: Action): Boolean
        var
            Ext: Text;
            Text100: Label 'Purchase Lines Selection';
        begin
            if Direction = Direction::"Import Data" then begin
                if CloseAction = Action::OK then begin
                    ServerFileName := FileMgmt.UploadFile(Text100, Ext);
                    if ServerFileName = '' then
                        exit(false);
                    SheetName := ExcelBuffer1.SelectSheetsName(ServerFileName);
                    if SheetName = '' then
                        exit(false);
                end;
            end;
        end;
    }

    var
        SerialNo: Boolean;
        No: Boolean;
        Quantity: Boolean;
        Direction: Option "Export Template","Import Data";
        ExcelBuffer1: Record "Excel Buffer" temporary;
        PurchaseHeaderImport: Record "Purchase Header";
        ServerFileName: Text;
        SheetName: Text;
        FileMgmt: Codeunit "File Management";
        ExcelBuffer: Record "Excel Buffer";
        PurchaseLine: Record "Purchase Line";

    trigger OnInitReport()
    begin
        Direction := Direction::"Import Data"; //B2BMS
        SerialNo := true;
        No := true;
        Quantity := true;
    end;


    trigger OnPreReport()
    var
        Ext: Text;
        Text100: Label 'Purchase Lines Selection';
    begin
        ServerFileName := FileMgmt.UploadFile(Text100, Ext);
        if ServerFileName = '' then
            Error('File Name is empty.');
        SheetName := ExcelBuffer1.SelectSheetsName(ServerFileName);
        if SheetName = '' then
            Error('Sheet Name is empty.');
    end;

    trigger OnPostReport()
    begin
        if Direction = Direction::"Export Template" then
            GeneratePortTemplate()
        else
            ImportLines();
    end;

    procedure GetValues(PurchLine: Record "Purchase Line")
    begin
        PurchaseLine := PurchLine;
    end;

    procedure GeneratePortTemplate()
    begin
        MakeExcelDataHeader();
        CreateExcelbook();

    end;

    PROCEDURE MakeExcelDataHeader()
    var
        ReserExport: Record "Reservation Entry";
    BEGIN
        ExcelBuffer1.NewRow;
        if SerialNo then
            ExcelBuffer1.AddColumn(ReserExport.FIELDCAPTION("Serial No."), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        if No then
            ExcelBuffer1.AddColumn(ReserExport.FIELDCAPTION("Item No."), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        if Quantity then
            ExcelBuffer1.AddColumn(ReserExport.FIELDCAPTION(Quantity), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);


    END;

    PROCEDURE CreateExcelbook()
    VAR
        Text001: Label 'Purchase Lines';
    BEGIN
        ExcelBuffer1.CreateBookAndOpenExcel('', Text001, '', COMPANYNAME, USERID);
    END;

    PROCEDURE GetValueAtCell(RowNo: Integer; ColumnNo: Integer): Text;
    BEGIN
        IF ExcelBuffer1.GET(RowNo, ColumnNo) THEN
            EXIT(ExcelBuffer1."Cell Value as Text");
    END;

    procedure ImportLines()
    var
        I: Integer;
        FieldNo: Integer;
        InitPurchLine: Record "Purchase Line";
        LastPurchLine: Record "Purchase Line";
        ReservEntry: Record "Reservation Entry";
        ReservationEntry: Record "Reservation Entry";
        PrevItem: Text;
        FilterPurchLine: Record "Purchase Line";
        ReservationEntry1: Record "Reservation Entry";
        LastEntryNo: Integer;
    begin
        Clear(I);
        Clear(FieldNo);
        ReservationEntry1.Reset();
        if ReservationEntry1.FindLast() then;
        LastEntryNo := ReservationEntry1."Entry No." + 1;
        ExcelBuffer1.OpenBook(ServerFileName, SheetName);
        ExcelBuffer1.ReadSheet();
        ExcelBuffer1.SETRANGE("Column No.", 1);
        IF ExcelBuffer1.FINDSET THEN BEGIN
            FOR I := 1 TO ExcelBuffer1.Count() DO BEGIN
                Clear(FieldNo);
                if I <> 1 then begin

                    ReservEntry.Init();
                    ReservEntry."Entry No." := LastEntryNo;
                    if SerialNo then begin
                        FieldNo += 1;
                        if GetValueAtCell(i, FieldNo) <> '' then begin
                            Evaluate(ReservEntry."Serial No.", GetValueAtCell(I, FieldNo));
                            ReservEntry.Validate("Serial No.");
                        end;
                    end;
                    if No then begin
                        FieldNo += 1;
                        if GetValueAtCell(I, FieldNo) <> '' then begin
                            Evaluate(ReservEntry."Lot No.", GetValueAtCell(I, FieldNo));
                            ReservEntry.Validate("Lot No."); //B2BMS
                        end;
                    end;
                    if Quantity then begin
                        FieldNo += 1;
                        if GetValueAtCell(I, FieldNo) <> '' then begin
                            Evaluate(ReservEntry."Quantity (Base)", GetValueAtCell(I, FieldNo));
                            ReservEntry.Validate("Quantity (Base)");
                        end;
                    end;
                    ReservEntry.Validate("Item No.", PurchaseLine."No.");
                    ReservEntry.Validate("Reservation Status", ReservEntry."Reservation Status"::Surplus);
                    ReservEntry.Validate("Creation Date", WorkDate());
                    ReservEntry.Validate("Created By", UserId());
                    ReservEntry.Validate("Source Type", 39);
                    ReservEntry.Validate("Source Subtype", 1);
                    ReservEntry.Validate("Location Code", PurchaseLine."Location Code");
                    ReservEntry.Validate("Source ID", PurchaseLine."Document No.");
                    ReservEntry.Validate("Source Ref. No.", PurchaseLine."Line No.");
                    ReservEntry.Validate("Item Tracking", ReservEntry."Item Tracking"::"Serial No.");
                    ReservEntry.Validate(Positive, true);
                    ReservEntry.Insert(true);
                    LastEntryNo += 1;
                end;
            end;
        end;
        /*if ReservEntry.FindSet() then begin
            repeat
                LastPurchLine.Reset();
                LastPurchLine.SetRange("Document No.", PurchaseHeaderImport."No.");
                LastPurchLine.SetRange("Document Type", PurchaseHeaderImport."Document Type");
                if LastPurchLine.FindLast() then;
                FilterPurchLine.Reset();
                FilterPurchLine.SetRange("Document Type", PurchaseHeaderImport."Document Type");
                FilterPurchLine.SetRange("Document No.", PurchaseHeaderImport."No.");
                FilterPurchLine.SetRange(Type, FilterPurchLine.Type::Item);
                FilterPurchLine.SetRange("No.", ReservEntry."Item No.");
                if not FilterPurchLine.FindFirst() then begin
                    InitPurchLine.Init();
                    InitPurchLine.validate("Document Type", PurchaseHeaderImport."Document Type");
                    InitPurchLine.Validate("Document No.", PurchaseHeaderImport."No.");
                    InitPurchLine."Line No." := LastPurchLine."Line No." + 10000;
                    InitPurchLine.Validate(Type, InitPurchLine.Type::Item);
                    InitPurchLine.Validate("No.", ReservEntry."Item No.");
                    InitPurchLine.Validate(Quantity, ReservEntry.Quantity);
                    InitPurchLine.Insert(true);
                    ReservationEntry1.Reset();
                    if ReservationEntry1.FindLast() then;
                    ReservationEntry.Init();
                    ReservationEntry.TransferFields(ReservEntry);
                    ReservationEntry.Validate("Location Code", InitPurchLine."Location Code");
                    ReservationEntry.Validate("Source Subtype", 1);
                    ReservationEntry.Validate("Source Ref. No.", InitPurchLine."Line No.");
                    ReservationEntry.Insert(true);
                end else begin
                    FilterPurchLine.Validate(Quantity, FilterPurchLine.Quantity + ReservEntry.Quantity);
                    FilterPurchLine.Modify(true);
                    ReservationEntry1.Reset();
                    if ReservationEntry1.FindLast() then;
                    ReservationEntry.Init();
                    ReservationEntry.TransferFields(ReservEntry);
                    ReservationEntry.Validate("Location Code", InitPurchLine."Location Code");
                    ReservationEntry.Validate("Source Subtype", 1);
                    ReservationEntry.Validate("Source Ref. No.", FilterPurchLine."Line No.");
                    ReservationEntry.Insert(true);
                end;
            until ReservEntry.Next() = 0;
        end;*/
    end;

}