table 65001 "DAVEPCValidationHeader"
{
    Caption = 'Personal Code Validation Header';
    TableType = Normal;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(11; "Personal Code"; Code[20])
        {
            Caption = 'Personal Code';
            trigger OnValidate()
            var
                ModifyMsg: Label 'Personal code cannot be modified after it has been checked.';
            begin
                if "Has Been Checked" then begin
                    Message(ModifyMsg);
                    "Personal Code" := xRec."Personal Code";
                end;
            end;
        }
        field(12; "Is Valid"; Boolean)
        {
            Caption = 'Is Valid';
        }
        field(13; "Has Been Checked"; Boolean)
        {
            Caption = 'Has Been Checked';
            InitValue = false;
            DataClassification = SystemMetadata;
            ToolTip = 'Indicates whether the personal code has been checked.';
        }
        field(14; "Broken Rules"; Text[100])
        {
            Caption = 'Broken Rules';
            ToolTip = 'List of validation rule codes, that were broken during the check.';
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }

}
