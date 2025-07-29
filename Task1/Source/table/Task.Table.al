table 65000 "DAVETask"
{

    DataClassification = ToBeClassified;
    Caption = 'DAVE Task';

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;

        }

        field(2; "User ID"; Code[100])
        {
            DataClassification = ToBeClassified;
        }

        field(3; "Task Type"; Enum "DAVETaskType")
        {
            DataClassification = SystemMetadata;
        }

        field(4; "Input Text"; Text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(5; "Result Text"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
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
