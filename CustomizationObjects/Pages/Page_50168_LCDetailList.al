page 50168 "LC Detail List"
{
    ApplicationArea = All;
    Caption = 'LC Detail List';
    Editable = false;
    CardPageId = "Lc Detail";
    PageType = List;
    SourceTable = "LC Details";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("LC No."; Rec."LC No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the LC No. field.';
                }
                field("Issued To/Received From"; Rec."Issued To/Received From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Issued To/Received From field.';
                }
                field("Issuing Bank"; Rec."Issuing Bank")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Issuing Bank field.';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expiry Date field.';
                }
                field(Released; Rec.Released)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Released field.';
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Closed field.';
                }
                field("LC Value"; Rec."LC Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the LC Value field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Value Utilised"; Rec."Value Utilised")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Value Utilised field.';
                }
            }
        }
    }
}
