page 50147 "Outward Gate Entry SubFrm-NRGP"
{
    Caption = 'NRGP-OUTWARD Subform';
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

                    trigger OnValidate()
                    begin
                    end;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = ALL;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GateEntryHeader: Record "Gate Entry Header_B2B";
                        SalesShipHeader: record "Sales Shipment Header";
                        SalesHeader: Record "Sales Header";
                        PurchHeader: Record "Purchase Header";
                        ReturnShipHeader: Record "Return Shipment Header";
                        TransHeader: Record "Transfer Header";
                        TransShptHeader: Record "Transfer Shipment Header";
                        GateEntryLneLRec: Record "Gate Entry Line_B2B";
                        GateEntLneLRec: Record "Gate Entry Line_B2B";
                        LineNoLVar: Integer;
                        Text16500: Label 'Source Type must not be blank in %1 %2.';
                        //TraVeh: record "Transporter Vehicle";
                        SourName: text[100];
                    begin
                        GateEntryHeader.GET(Rec."Entry Type", Rec."Type", Rec."Gate Entry No.");
                        case Rec."Source Type" of
                            Rec."Source Type"::"Sales Shipment":
                                begin
                                    SalesShipHeader.RESET;
                                    SalesShipHeader.FILTERGROUP(2);
                                    SalesShipHeader.SETRANGE("Location Code", GateEntryHeader."Location Code");
                                    SalesShipHeader.FILTERGROUP(0);
                                    if PAGE.RUNMODAL(0, SalesShipHeader) = ACTION::LookupOK then begin
                                        Rec."Source No." := SalesShipHeader."No.";
                                        Rec."Source Name" := SalesShipHeader."Bill-to Name";
                                    end;
                                end;
                            /*
                        "Source Types"::"Sales Return Order":
                            begin
                                SalesHeader.RESET;
                                SalesHeader.FILTERGROUP(2);
                                SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::"Return Order");
                                SalesHeader.SETRANGE("Location Code", GateEntryHeader."Location Code");
                                SalesHeader.FILTERGROUP(0);
                                if PAGE.RUNMODAL(0, SalesHeader) = ACTION::LookupOK then
                                    VALIDATE("Source No.", SalesHeader."No.");
                            end;*/
                            /*
                        "Source Types"::"Purchase Order":
                            begin
                                PurchHeader.RESET;
                                PurchHeader.FILTERGROUP(2);
                                PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
                                PurchHeader.SETRANGE("Location Code", GateEntryHeader."Location Code");
                                PurchHeader.FILTERGROUP(0);
                                if PAGE.RUNMODAL(0, PurchHeader) = ACTION::LookupOK then
                                    VALIDATE("Source No.", PurchHeader."No.");
                            end;*/
                            Rec."Source Type"::"Purchase Return Shipment":
                                begin
                                    ReturnShipHeader.RESET;
                                    ReturnShipHeader.FILTERGROUP(2);
                                    ReturnShipHeader.SETRANGE("Location Code", GateEntryHeader."Location Code");
                                    ReturnShipHeader.FILTERGROUP(0);
                                    if PAGE.RUNMODAL(0, ReturnShipHeader) = ACTION::LookupOK then begin
                                        Rec."Source No." := ReturnShipHeader."No.";
                                        Rec."Source Name" := ReturnShipHeader."Pay-to Name";
                                    end;
                                end;
                            /*   
                           "Source Types"::"Transfer Receipt":
                               begin
                                   TransHeader.RESET;
                                   TransHeader.FILTERGROUP(2);
                                   TransHeader.SETRANGE("Transfer-to Code", GateEntryHeader."Location Code");
                                   TransHeader.FILTERGROUP(0);
                                   if PAGE.RUNMODAL(0, TransHeader) = ACTION::LookupOK then
                                       VALIDATE("Source No.", TransHeader."No.");
                               end;
                               */
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

                    begin

                        if Rec."Source Type" = 0 then
                            ERROR(Text16500, Rec.FIELDCAPTION("Line No."), Rec."Line No.");

                        if Rec."Source No." <> xRec."Source No." then
                            Rec."Source Name" := '';
                        if Rec."Source No." = '' then begin
                            Rec."Source Name" := '';
                            exit;
                        end;
                        case Rec."Source Type" of
                            Rec."Source Type"::"Purchase Order":
                                begin
                                    PurchHeader.GET(PurchHeader."Document Type"::Order, Rec."Source No.");
                                    Rec."Source Name" := PurchHeader."Pay-to Name";
                                end;
                            Rec."Source Type"::"Purchase Return Shipment":
                                begin
                                    ReturnShipHeader.GET(Rec."Source No.");
                                    Rec."Source Name" := ReturnShipHeader."Pay-to Name";
                                end;
                            Rec."Source Type"::"Transfer Shipment":
                                begin
                                    TransShptHeader.GET(Rec."Source No.");
                                    Rec."Source Name" := TransShptHeader."Transfer-to Name";
                                end;
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
                field("Source Line No."; Rec."Source Line No.")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
    var
        GatEntHdrGRec: Record "Gate Entry Header_B2B";
}

