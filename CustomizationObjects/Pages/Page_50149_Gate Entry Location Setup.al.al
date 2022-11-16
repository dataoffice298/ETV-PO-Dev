page 50149 "Gate Entry Location Setup"
{
    PageType = List;
    SourceTable = "Gate Entry Location Setup_B2B";
    UsageCategory = Administration;
    ApplicationArea = ALL;
    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = ALL;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = ALL;
                }
                field("Posting No. Series"; Rec."Posting No. Series")
                {
                    ApplicationArea = ALL;
                }
                field("Allow GateEntry Lines Delete"; Rec."Allow GateEntry Lines Delete")
                {
                    ApplicationArea = ALL;
                }

            }
        }
    }

}

