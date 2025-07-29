table 65000 "DAVETask"
{

    DataClassification = CustomerContent;
    Caption = 'DAVE Task';

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
            Caption = 'ID';
        }

        field(2; "User ID"; Code[100])
        {
            Caption = 'User ID';
        }

        field(3; "Task Type"; Enum "DAVETaskType")
        {
            DataClassification = SystemMetadata; // Review: Jei šiuos duomenis kuria vartotojas, tai greičiausiai bus CustomerContent
            Caption = 'Task Type';
        }

        field(4; "Input Text"; Text[250])
        {
            Caption = 'Input Text';
        }

        field(5; "Result Text"; Text[250])
        {
            Editable = false;
            Caption = 'Result Text';
        }
    }

    keys
    {
        key(PK; "ID")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "User ID" = '' then
            "User ID" := CopyStr(Format(UserId), 1, 100);
    end;
}
