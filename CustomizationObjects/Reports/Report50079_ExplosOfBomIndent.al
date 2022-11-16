report 50180 "Quant Explo of BOM In Indent"
{
    //ApplicationArea = Manufacturing;
    //UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Search Description", "Inventory Posting Group";
            column(AsOfCalcDate; Text000 + Format(CalculateDate))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(ItemTableCaptionFilter; TableCaption + ': ' + ItemFilter)
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(No_Item; "No.")
            {
            }
            column(Desc_Item; Description)
            {
            }
            column(QtyExplosionofBOMCapt; QtyExplosionofBOMCaptLbl)
            {
            }
            column(CurrReportPageNoCapt; CurrReportPageNoCaptLbl)
            {
            }
            column(BOMQtyCaption; BOMQtyCaptionLbl)
            {
            }
            column(BomCompLevelQtyCapt; BomCompLevelQtyCaptLbl)
            {
            }
            column(BomCompLevelDescCapt; BomCompLevelDescCaptLbl)
            {
            }
            column(BomCompLevelNoCapt; BomCompLevelNoCaptLbl)
            {
            }
            column(LevelCapt; LevelCaptLbl)
            {
            }
            column(BomCompLevelUOMCodeCapt; BomCompLevelUOMCodeCaptLbl)
            {
            }
            dataitem(BOMLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 1;
                    column(BomCompLevelNo; BomComponent[Level]."No.")
                    {
                    }
                    column(BomCompLevelDesc; BomComponent[Level].Description)
                    {
                    }
                    column(BOMQty; BOMQty)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(FormatLevel; PadStr('', Level, ' ') + Format(Level))
                    {
                    }
                    column(BomCompLevelQty; BomComponent[Level].Quantity)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(BomCompLevelUOMCode; BomComponent[Level]."Unit of Measure Code")
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        IndentLines: Record "Indent Line";
                    begin
                        BOMQty := Quantity[Level] * QtyPerUnitOfMeasure * BomComponent[Level].Quantity;


                        Lineno += 10000;
                        IndentLines.Init();
                        IndentLines."Document No." := IndentNo;
                        IndentLines."Line No." := Lineno;
                        IndentLines.Insert();
                        IndentLines.Validate("No.", BomComponent[Level]."No.");
                        IndentLines.Validate("Req.Quantity", BOMQty);
                        IndentLines.Modify();
                    end;

                    trigger OnPostDataItem()
                    begin
                        Level := NextLevel;
                    end;


                }

                trigger OnAfterGetRecord()
                var
                    BomItem: Record Item;
                begin
                    while BomComponent[Level].Next() = 0 do begin
                        Level := Level - 1;
                        if Level < 1 then
                            CurrReport.Break();

                    end;

                    NextLevel := Level;
                    Clear(CompItem);
                    QtyPerUnitOfMeasure := 1;
                    case BomComponent[Level].Type of
                        BomComponent[Level].Type::Item:
                            begin
                                CompItem.Get(BomComponent[Level]."No.");
                                if CompItem."Production BOM No." <> '' then begin
                                    ProdBOM.Get(CompItem."Production BOM No.");
                                    if ProdBOM.Status = ProdBOM.Status::Closed then
                                        CurrReport.Skip();
                                    NextLevel := Level + 1;
                                    if Level > 1 then
                                        if (NextLevel > 50) or (BomComponent[Level]."No." = NoList[Level - 1]) then
                                            Error(ProdBomErr, 50, Item."No.", NoList[Level], Level);
                                    Clear(BomComponent[NextLevel]);
                                    NoListType[NextLevel] := NoListType[NextLevel] ::Item;
                                    NoList[NextLevel] := CompItem."No.";
                                    VersionCode[NextLevel] :=
                                      VersionMgt.GetBOMVersion(CompItem."Production BOM No.", CalculateDate, true);
                                    BomComponent[NextLevel].SetRange("Production BOM No.", CompItem."Production BOM No.");
                                    BomComponent[NextLevel].SetRange("Version Code", VersionCode[NextLevel]);
                                    BomComponent[NextLevel].SetFilter("Starting Date", '%1|..%2', 0D, CalculateDate);
                                    BomComponent[NextLevel].SetFilter("Ending Date", '%1|%2..', 0D, CalculateDate);
                                end;
                                if Level > 1 then
                                    if BomComponent[Level - 1].Type = BomComponent[Level - 1].Type::Item then
                                        if BomItem.Get(BomComponent[Level - 1]."No.") then
                                            QtyPerUnitOfMeasure :=
                                              UOMMgt.GetQtyPerUnitOfMeasure(BomItem, BomComponent[Level - 1]."Unit of Measure Code") /
                                              UOMMgt.GetQtyPerUnitOfMeasure(
                                                BomItem, VersionMgt.GetBOMUnitOfMeasure(BomItem."Production BOM No.", VersionCode[Level]));
                            end;
                        BomComponent[Level].Type::"Production BOM":
                            begin
                                ProdBOM.Get(BomComponent[Level]."No.");
                                if ProdBOM.Status = ProdBOM.Status::Closed then
                                    CurrReport.Skip();
                                NextLevel := Level + 1;
                                if Level > 1 then
                                    if (NextLevel > 50) or (BomComponent[Level]."No." = NoList[Level - 1]) then
                                        Error(ProdBomErr, 50, Item."No.", NoList[Level], Level);
                                Clear(BomComponent[NextLevel]);
                                NoListType[NextLevel] := NoListType[NextLevel] ::"Production BOM";
                                NoList[NextLevel] := ProdBOM."No.";
                                VersionCode[NextLevel] := VersionMgt.GetBOMVersion(ProdBOM."No.", CalculateDate, true);
                                BomComponent[NextLevel].SetRange("Production BOM No.", NoList[NextLevel]);
                                BomComponent[NextLevel].SetRange("Version Code", VersionCode[NextLevel]);
                                BomComponent[NextLevel].SetFilter("Starting Date", '%1|..%2', 0D, CalculateDate);
                                BomComponent[NextLevel].SetFilter("Ending Date", '%1|%2..', 0D, CalculateDate);
                            end;
                    end;

                    if NextLevel <> Level then
                        Quantity[NextLevel] := BomComponent[NextLevel - 1].Quantity * QtyPerUnitOfMeasure * Quantity[Level];
                end;

                trigger OnPreDataItem()
                var
                    IndentLines: Record "Indent Line";
                begin
                    If Item.GetFilter("No.") = '' then
                        Error('Please select Item No.');
                    IndentLines.Reset();
                    IndentLines.SetRange("Document No.", IndentNo);
                    IF IndentLines.FindSet() then BEGIN
                        If confirm('Existing lines will delete and insert. Do you want to continue ?') then
                            IndentLines.DeleteAll();
                    end else
                        If Not confirm('Existing lines will delete and insert. Do you want to continue ?') then
                            exit;
                    Level := 1;

                    ProdBOM.Get(Item."Production BOM No.");

                    VersionCode[Level] := VersionMgt.GetBOMVersion(Item."Production BOM No.", CalculateDate, true);
                    Clear(BomComponent);
                    BomComponent[Level]."Production BOM No." := Item."Production BOM No.";
                    BomComponent[Level].SetRange("Production BOM No.", Item."Production BOM No.");
                    BomComponent[Level].SetRange("Version Code", VersionCode[Level]);
                    BomComponent[Level].SetFilter("Starting Date", '%1|..%2', 0D, CalculateDate);
                    BomComponent[Level].SetFilter("Ending Date", '%1|%2..', 0D, CalculateDate);
                    NoListType[Level] := NoListType[Level] ::Item;
                    NoList[Level] := Item."No.";
                    Quantity[Level] :=
                      UOMMgt.GetQtyPerUnitOfMeasure(Item, Item."Base Unit of Measure") /
                      UOMMgt.GetQtyPerUnitOfMeasure(
                        Item,
                        VersionMgt.GetBOMUnitOfMeasure(
                          Item."Production BOM No.", VersionCode[Level]));
                end;
            }

            trigger OnPreDataItem()
            begin

                ItemFilter := GetFilters;
                Lineno := 0;
                SetFilter("Production BOM No.", '<>%1', '');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(IndentNo; IndentNo)
                    {
                        ApplicationArea = all;
                        Caption = 'Indent No.';
                        Editable = false;
                    }
                    field(CalculateDate; CalculateDate)
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Calculation Date';
                        ToolTip = 'Specifies the date you want the program to calculate the quantity of the BOM lines.';
                    }

                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            CalculateDate := WorkDate;
        end;
    }

    labels
    {
    }

    var
        Text000: Label 'As of ';
        ProdBOM: Record "Production BOM Header";
        BomComponent: array[99] of Record "Production BOM Line";
        CompItem: Record Item;
        UOMMgt: Codeunit "Unit of Measure Management";
        VersionMgt: Codeunit VersionManagement;
        ItemFilter: Text;
        CalculateDate: Date;
        NoList: array[99] of Code[20];
        VersionCode: array[99] of Code[20];
        Quantity: array[99] of Decimal;
        QtyPerUnitOfMeasure: Decimal;
        Level: Integer;
        NextLevel: Integer;
        BOMQty: Decimal;
        QtyExplosionofBOMCaptLbl: Label 'Quantity Explosion of BOM';
        CurrReportPageNoCaptLbl: Label 'Page';
        BOMQtyCaptionLbl: Label 'Total Quantity';
        BomCompLevelQtyCaptLbl: Label 'BOM Quantity';
        BomCompLevelDescCaptLbl: Label 'Description';
        BomCompLevelNoCaptLbl: Label 'No.';
        LevelCaptLbl: Label 'Level';
        BomCompLevelUOMCodeCaptLbl: Label 'Unit of Measure Code';
        NoListType: array[99] of Option " ",Item,"Production BOM";
        ProdBomErr: Label 'The maximum number of BOM levels, %1, was exceeded. The process stopped at item number %2, BOM header number %3, BOM level %4.';
        IndentNo: code[20];
        Lineno: Integer;

    procedure GetInden(Ind: code[20])
    Begin
        IndentNo := Ind;
    End;
}

