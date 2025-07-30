table 65015 DAVEAutoDamage
{
    Caption = 'Auto Damage';
    LookupPageId = DAVEAutoDamageEntries;
    DrillDownPageId = DAVEAutoDamageEntries;
    DataClassification = CustomerContent;

    fields
    {
        field(1; CarNo; Code[20])
        {
            Caption = 'Auto ID';
            ToolTip = 'Specifies the vehicle that was damaged.';
            TableRelation = DAVEAuto."No.";
            NotBlank = true;
        }

        field(2; LineNo; Integer)
        {
            Caption = 'Line Number';
            ToolTip = 'Specifies the damage entry line number.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
            AllowInCustomizations = Never;
            Editable = false;
        }

        field(10; DamageDate; Date)
        {
            Caption = 'Damage Date';
            ToolTip = 'Specifies the date when the damage occurred.';
            NotBlank = true;
        }

        field(11; Description; Text[100])
        {
            Caption = 'Damage Description';
            ToolTip = 'Describes the nature and extent of the damage.';
            NotBlank = true;
        }

        field(12; Status; Enum DAVEAutoDamageStatus)
        {
            Caption = 'Damage Status';
            ToolTip = 'Indicates whether the damage is current or has been resolved.';
            NotBlank = true;
        }
    }

    keys
    {
        key(PK; CarNo, LineNo) { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; CarNo, DamageDate, Status) { }
        fieldgroup(Brick; CarNo, DamageDate, Description, Status) { }
    }
}
