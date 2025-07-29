page 65003 "DAVEPCValidationCard"
{
    PageType = Card;
    SourceTable = "DAVEPCValidationHeader";
    Caption = 'Personal Code Validation Card';
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(Content)
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
        area(Processing)
        {
            action(CheckCode)
            {
                ApplicationArea = All;
                Caption = 'Check Personal Code';
                Image = Check;
                ToolTip = 'Validate the personal code entered in the field.';
                Enabled = not Rec."Has Been Checked";
                trigger OnAction()
                var
                    Validator: Codeunit DAVEPCValidator;
                    CodeValidMsg: Label 'Personal code is valid';
                    CodeInvalidMsg: Label 'Personal code is invalid';

                begin
                    Validator.ValidateCode(Rec);
                    if Validator.AllRulesPassed(Rec."Entry No.") then begin
                        Message(CodeValidMsg);
                        Rec."Is Valid" := true;
                    end
                    else begin
                        Message(CodeInvalidMsg);
                        Rec."Is Valid" := false;
                    end;
                    Rec."Has Been Checked" := true;
                    Rec.Modify(true);
                end;
            }
        }
    }
}
