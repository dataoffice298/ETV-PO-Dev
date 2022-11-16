page 50111 "Delivery Ratings"
{
    // version PH1.0,PO1.0

    PageType = List;
    SourceTable = "Delivery Ratings";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater("control")
            {
                field("Minumum Value"; Rec."Minumum Value")
                {
                    ApplicationArea = All;
                }
                field("Maximum Value"; Rec."Maximum Value")
                {
                    ApplicationArea = All;
                }
                field(Rating; Rec.Rating)
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

