page 50158 "Outward Gate Entry SubFrm-RGP"
{
    Caption = 'RGP-OUTWARD Subform';
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Gate Entry Line_B2B";

    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                field("Challan No."; Rec."Challan No.")
                {
                    ApplicationArea = ALL;
                }
                field("Challan Date"; Rec."Challan Date")
                {
                    ApplicationArea = ALL;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = ALL;
                    OptionCaption = ' ,Sales Shipment,Sales Return Order,Purchase Order,Purchase Return Shipment,Transfer Receipt,Transfer Shipment,Item,Fixed Asset,Others';

                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = ALL;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FA: record "Fixed Asset";
                        ItemLRec: record Item;
                        Text16500: Label 'Source Type must not be blank in %1 %2.';
                        TransShptHeader: Record "Transfer Shipment Header";
                        GateEntryHeader: Record "Gate Entry Header_B2B";
                    begin
                        if GateEntryHeader.GET(Rec."Entry Type", Rec."Type", Rec."Gate Entry No.") then;
                        case Rec."Source Type" of
                            Rec."Source Type"::"Fixed Asset":
                                begin
                                    FA.Reset();
                                    FA.SetRange(Blocked, false);
                                    FA.FilterGroup(0);
                                    if PAGE.RUNMODAL(0, FA) = ACTION::LookupOK then begin
                                        Rec."Source No." := FA."No.";
                                        Rec."Source Name" := FA.Description;
                                        Rec.Description := FA.Description;
                                    end;
                                end;
                            Rec."Source Type"::Item:
                                begin
                                    ItemLRec.Reset();
                                    ItemLRec.SetRange(Blocked, false);
                                    ItemLRec.FilterGroup(0);
                                    if PAGE.RUNMODAL(0, ItemLRec) = ACTION::LookupOK then begin
                                        Rec."Source No." := ItemLRec."No.";
                                        Rec."Source Name" := ItemLRec.Description;
                                        Rec.Description := ItemLRec.Description;
                                        Rec."Unit of Measure" := ItemLRec."Base Unit of Measure";
                                    end;
                                end;
                            Rec."Source Type"::"Transfer Shipment":
                                begin
                                    TransShptHeader.RESET;
                                    TransShptHeader.FILTERGROUP(2);
                                    TransShptHeader.SETRANGE("Transfer-from Code", GateEntryHeader."Location Code");
                                    TransShptHeader.FILTERGROUP(0);
                                    if PAGE.RUNMODAL(0, TransShptHeader) = ACTION::LookupOK then begin
                                        Rec."Source No." := TransShptHeader."No.";
                                        Rec."Source Name" := TransShptHeader."Transfer-to Name";
                                    end;
                                end;
                        end;
                    end;

                    trigger OnValidate()
                    var
                        SalesShipHeader: Record "Sales Shipment Header";
                        SalesHeader: Record "Sales Header";
                        PurchHeader: Record "Purchase Header";
                        ReturnShipHeader: Record "Return Shipment Header";
                        TransHeader: Record "Transfer Header";
                        TransShptHeader: Record "Transfer Shipment Header";
                        Text16500: Label 'Source Type must not be blank in %1 %2.';
                    BEGIN
                        if Rec."Source Type" = 0 then
                            ERROR(Text16500, Rec.FIELDCAPTION("Line No."), Rec."Line No.");
                        if Rec."Source No." <> xRec."Source No." then
                            Rec."Source Name" := '';
                        if Rec."Source No." = '' then begin
                            Rec."Source Name" := '';
                            exit;
                        end;
                    end;
                }
                field("Source Name"; Rec."Source Name")
                {
                    ApplicationArea = ALL;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = ALL;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = all;
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
    }
    var
        GatEntHdrGRec: Record "Gate Entry Header_B2B";
}

