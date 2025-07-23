table 65015 "DAVEAutoDamage"
{
    Caption = 'Auto Damage';
    LookupPageId = "DAVEAutoDamageList";
    DrillDownPageId = "DAVEAutoDamageList";

    fields
    {
        field(1; CarNo; Code[20])
        {
            Caption = 'Auto ID';
            ToolTip = 'Specifies the vehicle that was damaged.';
            TableRelation = DAVEAuto."No.";
            DataClassification = CustomerContent;
            NotBlank = true;
        }

        field(2; LineNo; Integer)
        {
            Caption = 'Line Number';
            ToolTip = 'Specifies the damage entry line number.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }

        field(10; DamageDate; Date)
        {
            Caption = 'Damage Date';
            ToolTip = 'Specifies the date when the damage occurred.';
            DataClassification = CustomerContent;
            NotBlank = true;
        }

        field(11; Description; Text[100])
        {
            Caption = 'Damage Description';
            ToolTip = 'Describes the nature and extent of the damage.';
            NotBlank = true;
        }

        field(12; Status; Enum "DAVEDamageStatus")
        {
            Caption = 'Damage Status';
            ToolTip = 'Indicates whether the damage is current or has been resolved.';
            NotBlank = true;
        }
    }

    keys
    {
        key(PK; "CarNo", "LineNo") { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "CarNo", "DamageDate", "Status") { }
        fieldgroup(Brick; "CarNo", "DamageDate", "Description", "Status") { }
    }
}
