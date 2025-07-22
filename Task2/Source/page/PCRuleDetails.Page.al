page 65005 "DAVEPCRuleDetails"
{
    PageType = ListPart;
    SourceTable = DAVEPCValidationLines;
    // SourceTableView = where(Result = const(Failed));
    Caption = 'Validation Rule Details';
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Rule Code"; Rec."Rule Code")
                {
                    ApplicationArea = All;
                }
                field("Rule Description"; Rec."Rule Description") { ApplicationArea = All; }
                field(Result; Rec.Result) { ApplicationArea = All; }
            }
        }
    }
}
