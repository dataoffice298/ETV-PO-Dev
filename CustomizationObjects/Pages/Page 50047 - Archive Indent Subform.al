page 50047 "Archive Indent Subform"
{
    //B2BMSOn13Sep2022

    AutoSplitKey = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Archive Indent Line";
    Caption = 'Archive Indent Lines';
    Editable = false;

    layout
    {
        area(content)
        {
            repeater("Control")
            {
                field(Type; rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Department; rec.Department)
                {
                    ApplicationArea = All;
                }
                field("Delivery Location"; rec."Delivery Location")
                {
                    Caption = 'Location Code';
                    ApplicationArea = All;
                }
                field("Req.Quantity"; rec."Req.Quantity")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Indent Status"; rec."Indent Status")
                {
                    ApplicationArea = All;
                }
                field(Remarks; rec.Remarks)
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                }

            }
        }
    }

}

