page 50046 "Archive Indent"
{

    PageType = ListPlus;
    SourceTable = "Archive Indent Header";
    Caption = 'Archive Indent Document';
    Editable = false;


    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Archived Version"; Rec."Archived Version")
                {
                    ApplicationArea = All;
                }
                field("Archived By"; Rec."Archived By")
                {
                    ApplicationArea = All;
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Indentor; rec.Indentor)
                {
                    Caption = 'Indentor';
                    ApplicationArea = all;
                }
                field(Department; rec.Department)
                {
                    Visible = true;
                    ApplicationArea = all;
                }
                field("Document Date"; rec."Document Date")
                {
                    Caption = 'Order Date';
                    ApplicationArea = all;
                }
                field("Released Status"; rec."Released Status")
                {
                    Caption = 'Status';
                    ApplicationArea = all;
                }
                field("User Id"; rec."User Id")
                {
                    ApplicationArea = all;
                }
                field(Authorized; rec.Authorized)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Ammendent Comments"; Rec."Ammendent Comments")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Caption = 'Shortcut Dimension 1 Code';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Caption = 'Shortcut Dimension 2 Code';
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ApplicationArea = Location;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the location that items are transferred from.';
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = Location;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the location that the items are transferred to.';
                }
                field("In-Transit Code"; Rec."In-Transit Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the in-transit code for the transfer order, such as a shipping agent.';
                }
            }
            part(ArchiveIndentSubform; "Archive Indent Subform")
            {
                SubPageLink = "Document No." = FIELD("No."), "Archived Version" = field("Archived Version");
                ApplicationArea = All;
            }
        }

    }

}

