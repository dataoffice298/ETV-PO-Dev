page 50132 "Fixed Asset Movements"
{
    ApplicationArea = All;
    Caption = 'Fixed Asset Movements';
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Fixed Asset Movements";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("FA No."; Rec."FA No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FA No. field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Line No. field.';
                }
                field("From Location"; Rec."From Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Location field.';
                }
                field("To Location"; Rec."To Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Location field.';
                }
                field("Issue to User Id"; Rec."Issue to User Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Issue to User Id field.';
                }
                field("Issued Date Time"; Rec."Issued Date Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Issued Date Time field.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field("Created Date Time"; Rec."Created Date Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created Date Time field.';
                }
            }
        }
    }
}
