page 50131 "FA Movements Confirmation"
{
    Caption = 'FA Movements Confirmation';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    InstructionalText = 'Do you want to Transfer Fixed asset?';
    ModifyAllowed = false;
    PageType = ConfirmationDialog;

    layout
    {
        area(content)
        {
            field(FixedAssetNo; IndentLine."No.")
            {
                ApplicationArea = all;
                Caption = 'Fixed Asset No.';
                Editable = false;
            }
            field(IssuedDateTime; IssuedDateTime)
            {
                ApplicationArea = all;
                Caption = 'Issued Date Time';
            }
            field(IssuedTo; IssuedTo)
            {
                ApplicationArea = all;
                Caption = 'Issued To User';
            }
            field(FromLocation; FromLocation)
            {
                TableRelation = Location;
                ApplicationArea = all;
                Caption = 'From Location';
            }
            field(ToLocation; ToLocation)
            {
                ApplicationArea = all;
                Caption = 'To Location';
            }
            field(Comment; Comment)
            {
                ApplicationArea = all;
                Caption = 'Comments';
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin

    end;



    var
        IndentLine: Record "Indent Line";
        IssuedDateTime: DateTime;
        FromLocation: Code[20];
        ToLocation: Code[20];
        IssuedTo: Text[50];
        Comment: Text[500];


    procedure Set(var IndentLine1: Record "Indent Line")
    begin
        IndentLine := IndentLine1;
    end;

    procedure ReturnPostingInfo(var IssuedDateTime2: DateTime; var Issueto2: Text[50]; var FromLocation2: Code[20]; var ToLocation2: Code[20]; var Comment2: Text[500])
    var
        IsHandled: Boolean;
    begin
        IssuedDateTime2 := IssuedDateTime;
        Issueto2 := IssuedTo;
        FromLocation2 := FromLocation;
        ToLocation2 := ToLocation;
        Comment2 := Comment;
    end;


}

