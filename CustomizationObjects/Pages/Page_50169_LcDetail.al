page 50169 "Lc Detail"
{
    Caption = 'LC Detail';
    PageType = Card;
    SourceTable = "LC Details";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = PageEditable;  //B2BPGON11OCT2022
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("LC No."; Rec."LC No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the LC No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
                field("Type of Credit Limit"; Rec."Type of Credit Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type of Credit Limit field.';
                }
                field("Type of LC"; Rec."Type of LC")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type of LC field.';
                }
                field("LC advising charges"; Rec."LC advising charges")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the LC advising charges field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Issuing Bank"; Rec."Issuing Bank")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Issuing Bank field.';
                }
                field("Issued To/Received From"; Rec."Issued To/Received From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Issued To/Received From field.';
                }
                field("LC Value"; Rec."LC Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the LC Value field.';
                }
                field("LC Value LCY"; Rec."LC Value LCY")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the LC Value LCY field.';
                }
                field("Receiving Bank"; Rec."Receiving Bank")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receiving Bank field.';
                }
                field("Date of Issue"; Rec."Date of Issue")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date of Issue field.';
                }
                field("Date of Receipt"; Rec."Date of Receipt")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date of Receipt field.';
                }
                field("Bank Interest Rate"; Rec."Bank Interest Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Interest Rate field.';
                }
                field("Bank Commission"; Rec."Bank Commission")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Commission field.';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expiry Date field.';
                }
                field(Closed; Rec.Closed)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Closed field.';
                }

                field(Released; Rec.Released)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Released field.';
                }

                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the E-Mail field.';
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remaining Amount field.';
                }
                field("Renewed Amount"; Rec."Renewed Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Renewed Amount field.';
                }
                field("Revolving Cr. Limit Types"; Rec."Revolving Cr. Limit Types")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Revolving Cr. Limit Types field.';
                }
                field("Value Utilised"; Rec."Value Utilised")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Value Utilised field.';
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Exchange Rate field.';
                }
                field("BILL ID"; Rec."BILL ID")
                {
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BILL ID field.';
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action("Posted Orders")
            {
                Image = PostedOrder;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = false;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SInvHeader: Record "Sales Invoice Header";
                    SalesInvForm: Page "Posted Sales Invoices";
                    PInvHeader: Record "Purch. Inv. Header";
                    PurchaseInvForm: Page "Posted Purchase Invoices";
                begin
                    IF Rec."Transaction Type" = Rec."Transaction Type"::Sale THEN BEGIN
                        SInvHeader.SETRANGE("LC No.", Rec."No.");
                        SalesInvForm.SETTABLEVIEW(SInvHeader);
                        SalesInvForm.RUN;
                    END;
                    IF Rec."Transaction Type" = Rec."Transaction Type"::Purchase THEN BEGIN
                        PInvHeader.SETRANGE("LC No.", Rec."No.");
                        PInvHeader.SETRANGE("Buy-from Vendor No.", Rec."Issued To/Received From");
                        PurchaseInvForm.SETTABLEVIEW(PInvHeader);
                        PurchaseInvForm.RUN;
                    END;
                end;
            }
            action(Orders)
            {
                ApplicationArea = All;
                RunObject = Page "LC Order Details";
                RunPageLink = "Transaction Type" = FIELD("Transaction Type"), "LC No." = FIELD("No.");
                trigger OnAction()
                begin

                end;
            }
        }
        area(Processing)
        {
            action("LC &Release")
            {
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = false;
                ApplicationArea = All;

                trigger OnAction()
                var
                    LetterofCredit: Codeunit MyBaseSubscr;
                begin
                    LetterofCredit.LCRelease(Rec);
                end;
            }
            action("Close LC")
            {
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = false;
                ApplicationArea = All;

                trigger OnAction()
                var
                    LetterofCredit: Codeunit MyBaseSubscr;
                begin
                    LetterofCredit.LCClose(Rec);
                end;
            }
        }
    }
    //B2BPGON11OCT2022
    trigger OnAfterGetRecord();
    begin
        if Rec.Released = true then
            PageEditable := false
        else
            PageEditable := true;
    end;



    var
        PageEditable: Boolean;//B2BPGON11OCT2022
}
