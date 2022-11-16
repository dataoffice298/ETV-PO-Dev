page 50048 "Archive Indent List"
{
    //B2BMSOn13Sep2022

    CardPageID = "Archive Indent";
    Editable = false;
    PageType = List;
    SourceTable = "Archive Indent Header";
    UsageCategory = Lists;
    ApplicationArea = all;

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
                field("Archived Version"; Rec."Archived Version")
                {
                    ApplicationArea = All;
                }
                field("Archived By"; Rec."Archived By")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}

