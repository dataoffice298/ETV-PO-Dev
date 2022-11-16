page 50177 "Centrak Indent Req List"
{
    Caption = 'Central Indent Requisition List';
    CardPageID = "Indent Requisition Document";
    PageType = List;
    SourceTable = "Indent Req Header";
    SourceTableView = where("Resposibility Center" = const('CENTRL REQ'), Status = const(Release));
    UsageCategory = Lists;
    ApplicationArea = all;
    Editable = false;

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
            }
        }
    }

    actions
    {
    }
}

