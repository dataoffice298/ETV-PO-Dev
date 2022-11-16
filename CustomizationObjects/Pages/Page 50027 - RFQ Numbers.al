page 50027 "RFQ Numbers"
{
    // version PH1.0,PO1.0

    PageType = List;
    SourceTable = "RFQ Numbers";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater("Control")
            {
                field("RFQ No."; Rec."RFQ No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Completed; Rec.Completed)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

