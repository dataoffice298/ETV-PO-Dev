page 50135 "Archived Quotation Subform"
{
    Caption = 'Archived Quotation Subform';
    PageType = ListPart;
    SourceTable = "Archive Quotation Comparison";
    Editable = false;

    layout
    {

        area(content)
        {
            /*
            field("RFQ No."; RFQNumber)
            {
                Caption = 'RFQ Number';
                TableRelation = "RFQ Numbers"."RFQ No." WHERE(Completed = CONST(true));
                ApplicationArea = All;

                trigger OnValidate();
                begin
                    Rec.RESET;
                    Rec.SETCURRENTKEY("RFQ No.");
                    Rec.SETFILTER("RFQ No.", RFQNumber);
                end;
            } */

            repeater("Control")
            {
                field("<RFQ No2>"; Rec."RFQ No.")
                {
                    Caption = 'RFQ No';
                    ApplicationArea = All;
                }
                field("Quote No."; Rec."Quote No.")
                {
                    ApplicationArea = All;

                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("P & F"; Rec."P & F")
                {
                    ApplicationArea = All;
                }
                field("Excise Duty"; Rec."Excise Duty")
                {
                    ApplicationArea = All;
                }
                field("Sales Tax"; Rec."Sales Tax")
                {
                    ApplicationArea = All;
                }
                field(Freight; Rec.Freight)
                {
                    ApplicationArea = All;
                }
                field(Insurance; Rec.Insurance)
                {
                    ApplicationArea = All;
                }
                field(Discount; Rec.Discount)
                {
                    ApplicationArea = All;
                }
                field(VAT; Rec.VAT)
                {
                    ApplicationArea = All;
                }
                field("Payment Term Code"; Rec."Payment Term Code")
                {
                    ApplicationArea = All;
                }
                field("Delivery Date"; Rec."Delivery Date")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Carry Out Action"; Rec."Carry Out Action")
                {
                    ApplicationArea = All;
                }
                field(Level; Rec.Level)
                {
                    ApplicationArea = All;
                }
                field("Parent Quote No."; Rec."Parent Quote No.")
                {
                    ApplicationArea = All;
                }
                field("Indent No."; Rec."Indent No.")
                {
                    ApplicationArea = All;
                }
                field("Indent Line No."; Rec."Indent Line No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    ApplicationArea = All;
                }
                field("Parent Vendor"; Rec."Parent Vendor")
                {
                    ApplicationArea = All;
                }
                field("Standard Price"; Rec."Standard Price")
                {
                    ApplicationArea = All;
                }
                field(Structure; Rec.Structure)
                {
                    ApplicationArea = All;
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                }
                field(Delivery; Rec.Delivery)
                {
                    ApplicationArea = All;
                }
                field("Payment Terms"; Rec."Payment Terms")
                {
                    ApplicationArea = All;
                }
                field("Total Weightage"; Rec."Total Weightage")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Amt. including Tax"; Rec."Amt. including Tax")
                {
                    ApplicationArea = All;
                }
                field(Rating; Rec.Rating)
                {
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        //  Rec.RESET;
        //  Rec.SETRANGE("RFQ No.", RFQNumber);
    end;

    var
        RFQNumber: Code[20];
}