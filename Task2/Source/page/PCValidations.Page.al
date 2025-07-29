page 65004 "DAVEPCValidations"
{
    PageType = List;
    SourceTable = "DAVEPCValidationHeader";
    SourceTableView = where("Has Been Checked" = const(true));
    Caption = 'Personal Code Validations';
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Personal Code"; Rec."Personal Code")
                {
                    ToolTip = 'User input for the personal code to be validated.';
                }
                field("Is Valid"; Rec."Is Valid")
                {
                    ToolTip = 'Indicates whether the personal code is valid.';
                }
                field("Broken Rules"; Rec."Broken Rules")
                {
                    ToolTip = 'List of validation rules that were broken during the check.';
                }
            }
            part("Error details"; "DAVEPCRuleDetails")
            {
                SubPageLink = "Entry No." = field("Entry No.");
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(GoToCard)
            {
                Caption = 'Go to Personal Code Validation Card';
                ApplicationArea = All;
                ToolTip = 'Navigate to the Personal Code Validation Card';
                Image = View;
                trigger OnAction()
                var
                    CheckPage: Page "DAVEPCValidationCard";
                begin
                    CheckPage.SetRecord(Rec);
                    CheckPage.Run();
                end;
            }
        }
    }

}
