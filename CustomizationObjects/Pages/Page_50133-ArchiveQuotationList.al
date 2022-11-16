page 50133 "Archive Quotation List"
{
    ApplicationArea = All;
    Caption = 'Archive Quotation List';
    PageType = List;
    SourceTable = "Archive Quotation Header";
    UsageCategory = Lists;
    CardPageId = "Archived Quotation Document";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Version"; Rec."Version")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Version field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(RFQNumber; Rec.RFQNumber)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RFQNumber field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Modified Date field.';
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Modified By field.';
                }
            }
        }
    }
}
