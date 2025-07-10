table 65002 DAVEPCValidationLines
{
    Caption = 'Personal Code Validation Lines';
    TableType = Normal;
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "DAVEPCValidationHeader"."Entry No.";
        }
        field(2; "Line No."; Integer) { }
        field(11; "Rule Code"; Enum "DAVEPCRuleType")
        {
            Caption = 'Broken Rule Code';
            DataClassification = ToBeClassified;
            ToolTip = 'Code representing the validation rule applied to the personal code.';
        }
        field(12; "Rule Description"; Text[100])
        {
            Caption = 'Broken Rule Description';
            DataClassification = ToBeClassified;
            ToolTip = 'Description of the validation rule applied to the personal code.';
        }

    }

    keys
    {
        key(PK; "Entry No.", "Line No.") { Clustered = true; }
    }

}
