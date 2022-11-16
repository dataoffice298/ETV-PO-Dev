page 50124 "Quotation Creation"
{
    CardPageID = "IndentRequisitionDocument New";
    Editable = false;
    Caption = 'Quotation Comparision Cus';
    PageType = List;
    //UsageCategory = Lists;
    SourceTable = 50045;
    //ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Resposibility Center"; Rec."Resposibility Center")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("RFQ No."; Rec."RFQ No.")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("L&ine")
            {
                Caption = 'L&ine';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    //RunObject = Page 50148;
                    RunPageOnRec = true;
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF RFQNumbers.GET(Rec."RFQ No.") THEN
            //Rec."PR No." := RFQNumbers."PR No.";

        PrevPRNo := '';
        IndentRequisitions2.RESET;
        IndentRequisitions2.SETRANGE(IndentRequisitions2."Document No.", Rec."No.");
        IF IndentRequisitions2.FINDSET THEN
            REPEAT
            /*IF PrevPRNo <> IndentRequisitions2."Indent Consolidation No." THEN BEGIN
                PrevPRNo := IndentRequisitions2."Indent Consolidation No.";
                //Rec."PR No." += IndentRequisitions2."Indent Consolidation No." + ',';
            END;*/
            UNTIL IndentRequisitions2.NEXT = 0
    end;

    var
        UserSetupGrec: Record 91;
        RFQNumbers: Record 50039;
        IndentRequisitions2: Record 50038;
        PrevPRNo: Code[20];
}

