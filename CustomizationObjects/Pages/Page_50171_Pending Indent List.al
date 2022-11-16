page 50171 "Pending Indent List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Indent Header";
    CardPageId = "Indent Header";
    SourceTableView = where("Released Status" = const("Pending Approval"));

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