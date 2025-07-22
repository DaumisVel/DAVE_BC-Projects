table 65003 DAVEPCValidationRules
{
    Caption = 'Personal Code Validation Rules';
    TableType = Normal;
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Validation Rule Code';
            DataClassification = ToBeClassified;
            ToolTip = 'Unique code for the validation rule.';
        }
        field(2; Caption; Text[100])
        {
            Caption = 'Validation Rule Caption';
            DataClassification = ToBeClassified;
            ToolTip = 'Description of the validation rule.';
        }
        field(3; "Execution Code"; Code[50])
        {
            Caption = 'Execution Code';
            DataClassification = ToBeClassified;
            ToolTip = 'Code that defines the logic of the executing rule.';
            InitValue = '';
            Editable = true;
        }
        field(5; "Is Active"; Boolean)
        {
            Caption = 'Is Active';
            InitValue = true;
            DataClassification = ToBeClassified;
            ToolTip = 'Indicates whether the validation rule is currently active.';
        }
        field(7; Importance; Enum DAVEPCRuleImportance)
        {
            Caption = 'Importance';
            DataClassification = ToBeClassified;
            ToolTip = 'Importance level of the validation rule.';
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
        key(KeyByImportance; "Importance")
        {
            Clustered = false;
        }
    }
}
