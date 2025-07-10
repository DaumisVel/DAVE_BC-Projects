page 65003 "DAVEPCValidationCard"
{
    PageType = Card;
    SourceTable = "DAVEPCValidationHeader";
    Caption = 'Personal Code Validation Card';
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Validation Details")
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                    ToolTip = 'Unique identifier for the validation entry.';
                    ApplicationArea = All;
                }
                field("Personal Code"; Rec."Personal Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'User input for the personal code to be validated.';

                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CheckCode)
            {
                ApplicationArea = All;
                Caption = 'Check Personal Code';
                Image = Check;
                ToolTip = 'Validate the personal code entered in the field.';

                trigger OnAction()
                var
                    Validator: Codeunit "DAVEPCValidator";
                    CodeCheckedErr: Label 'Cannot perform validation. Entry has already been checked.';
                    CodeValidMsg: Label 'Validation complete. Code is valid.';
                    CodeInvalidMsg: Label 'Validation complete. Code is invalid.';
                begin
                    if Rec."Has Been Checked" then
                        Error(CodeCheckedErr);

                    if Validator.IsPersonalCodeValid(Rec) then
                        Message(CodeValidMsg)
                    else
                        Message(CodeInvalidMsg);

                    Rec."Has Been Checked" := true;
                    Rec.Modify();
                    CurrPage.Update();
                end;
            }
        }
    }
    var
}
