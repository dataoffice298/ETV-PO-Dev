page 75466 "Objects Used"
{
    PageType = List;
    ApplicationArea = All;
    Editable = false;
    Caption = 'Objects Used';
    SourceTable = 2000000207;
    UsageCategory = Administration;


    layout
    {
        area(Content)
        {
            repeater(contol1)
            {
                field("User AL Code"; Rec."User AL Code")
                {

                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                }
                field("User Code"; Rec."User Code")
                {
                    ApplicationArea = All;
                }
                field("User Code Hash"; Rec."User Code Hash")
                {
                    ApplicationArea = All;
                }
                field("Object Flags"; Rec."Object Flags")
                {
                    ApplicationArea = All;
                }
                field("Metadata Format"; Rec."Metadata Format")
                {
                    ApplicationArea = all;
                }
                field("Metadata Hash"; Rec."Metadata Hash")
                {
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                }
                field("Object ID"; Rec."Object ID")
                {
                    ApplicationArea = All;
                }
                field("Package ID"; Rec."Package ID")
                {
                    ApplicationArea = All;
                }
                Field("Runtime Package ID"; Rec."Runtime Package ID")
                {
                    ApplicationArea = all;
                }
                field(Metadata; Rec.Metadata)
                {

                }
                field("Metadata Version"; Rec."Metadata Version")
                {
                    ApplicationArea = All;
                }
                field("Object Name"; Rec."Object Name")
                {
                    ApplicationArea = All;
                }
                field("Object Subtype"; Rec."Object Subtype")
                {
                    ApplicationArea = All;
                }
                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = all;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}