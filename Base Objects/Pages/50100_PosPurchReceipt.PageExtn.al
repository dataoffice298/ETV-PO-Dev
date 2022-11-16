pageextension 50100 PosPurchReceipt extends "Posted Purchase Receipt"
{
    Editable = false;
    layout
    {
        addlast(Invoicing)
        {
            field("LC No."; Rec."LC No.")
            {
                ApplicationArea = All;
            }
            field("Bill of Entry No"; Rec."Bill of Entry No")
            {
                ApplicationArea = All;
            }
            field("EPCG No."; Rec."EPCG No.")
            {
                ApplicationArea = all;
            }
            field("EPCG Scheme"; rec."EPCG Scheme")
            {
                ApplicationArea = all;
            }
            field("Import Type"; rec."Import Type")
            {
                ApplicationArea = all;
            }

        }

        addfirst(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(120),
                              "No." = FIELD("No.");
            }
        }

    }

    actions
    {
        //B2BMMOn06Oct2022>>
        addafter("&Print")
        {
            action("Posted Purchase Receipt")
            {
                ApplicationArea = All;
                Caption = 'GRN Receipt';
                Image = Report2;
                Promoted = true;

                trigger OnAction()
                var
                    PurRcptHeader: Record "Purch. Rcpt. Header";
                begin
                    PurRcptHeader.RESET;
                    PurRcptHeader.SETRANGE("No.", Rec."No.");
                    REPORT.RUNMODAL(50071, TRUE, TRUE, PurRcptHeader);
                end;
                //B2BMMOn06Oct2022<<
            }
        }
        addafter(Approvals)
        {
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                Promoted = true;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal;

                end;
            }
        }
    }

}