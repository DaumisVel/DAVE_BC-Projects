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
        area(Content)
        {
            repeater(Group)
            {
                field("Rule Code"; Rec."Rule Code") { }
                field("Rule Description"; Rec."Rule Description") { }
                field(Result; Rec.Result) { }
            }
        }
    }
}
