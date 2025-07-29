table 65011 DAVEAutoMark
{
    Caption = 'Auto Mark';
    DataClassification = CustomerContent;
    LookupPageId = DAVEAutoMarks;
    DrillDownPageId = DAVEAutoMarks;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the code of the auto mark.';
            NotBlank = true;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description of the auto mark.';
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Description) { }
        fieldgroup(Brick; Code, Description) { }
    }
}
