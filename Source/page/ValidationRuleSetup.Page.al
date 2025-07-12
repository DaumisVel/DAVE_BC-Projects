page 65006 "DAVEValidationRuleSetup"
{
    PageType = List;
    SourceTable = "DAVEPCValidationRules";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Validation Rule Setup';
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec."Code") { }
                field(Caption; Rec."Caption") { }
                field("Execution Code"; Rec."Execution Code") { }
                field("Is Active"; Rec."Is Active") { }
                field(Importance; Rec.Importance) { }

            }
        }
    }
    actions
    {
        area(processing)
        {
            action("Reset")
            {
                ApplicationArea = All;
                Caption = 'Reset to default rules';
                Image = New;
                ToolTip = 'Press to reset rules';
                trigger OnAction()
                var
                    Seeder: Codeunit DAVEMyProcedures;
                    SetDefaultMsg: Label 'Default validation rules have been restored.';
                begin
                    Seeder.ResetValidationRules();
                    Message(SetDefaultMsg);
                end;
            }
        }
    }
}
