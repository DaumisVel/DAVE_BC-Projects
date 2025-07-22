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
        field(11; "Rule Code"; Code[20])
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
        field(13; Result; Enum "DAVEPCRuleResult")
        {
            Caption = 'Validation Result';
            DataClassification = ToBeClassified;
            ToolTip = 'Result of the validation rule check.';
        }

    }

    keys
    {
        key(PK; "Entry No.", "Line No.") { Clustered = true; }
    }

}
