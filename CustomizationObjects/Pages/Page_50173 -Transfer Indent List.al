page 50173 "Transfer Indent List"
{
    // version PH1.0,PO1.0

    CardPageID = "Transfer Indent Header";
    Editable = false;
    PageType = List;
    SourceTable = "Indent Header";
    UsageCategory = Lists;
    ApplicationArea = all;
    Caption = 'Transfer Indent List';
    SourceTableView = where("Indent Transfer" = const(true));//BaluOn19Oct2022>>

    layout
    {
        area(content)
        {
            repeater("Control")
            {
                field("Document Date"; rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Due Date"; rec."Due Date")
                {
                    ApplicationArea = all;
                }
                field(Indentor; rec.Indentor)
                {
                    ApplicationArea = all;
                }
                field("Indent Transfer"; Rec."Indent Transfer")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        PAGE.RUN(PAGE::"Indent Header", Rec);
                    end;
                }
            }
        }
    }
}

