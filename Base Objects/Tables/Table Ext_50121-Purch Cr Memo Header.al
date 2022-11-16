tableextension 50121 PurCrMemoExt extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(33002900; "RFQ No."; Code[20])
        {
            Description = 'PO1.0';
            TableRelation = "RFQ Numbers"."RFQ No." WHERE(Completed = FILTER(false));

            trigger OnValidate();
            var
                RFQNumbers: Record "RFQ Numbers";
            begin
            end;
        }
        field(33002901; "Quotation No."; Code[20])
        {
            Description = 'PO1.0';
        }
        field(33002902; "ICN No."; Code[20])
        {
            Description = 'PO1.0';
            Editable = false;
            TableRelation = "Quotation Comparison";
        }
        field(33002903; "Indent Req No"; Code[20])
        {
            Description = 'PO1.0';
        }
        field(33002904; "Approval Status"; Option)
        {
            OptionMembers = ,Open,"Pending Approval",Released;
            OptionCaption = ' ,Open,Pending Approval,Released';
        }

        field(51000; Subject; Text[200])
        {
            Caption = 'Subject';
        }
        field(50110; "LC No."; Code[20])
        {
            Caption = 'LC No.';
        }
        Field(50111; "Bill of Entry No"; Code[20])
        {
            Caption = 'Bill of Entry No';
        }
        Field(50112; "EPCG No."; Code[20])
        {
            Caption = 'EPCG No';
        }
    }

    var
        myInt: Integer;
}