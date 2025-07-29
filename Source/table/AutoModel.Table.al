table 65012 DAVEAutoModel
{
    Caption = 'Auto Model';
    DataClassification = ToBeClassified;
    LookupPageId = DAVEAutoModels;
    DrillDownPageId = "DAVEAutoModels";

    fields
    {
        field(1; MarkCode; Code[20])
        {
            Caption = 'Mark Code';
            ToolTip = 'Specifies the code of the auto mark.';
            TableRelation = DAVEAutoMark."Code";
            NotBlank = true;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Model Code';
            ToolTip = 'Specifies the code of the auto model.';
            NotBlank = true;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description of the auto model.';
        }
    }

    keys
    {
        key(PK; MarkCode, Code) { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Description) { }
        fieldgroup(Brick; Code, Description, MarkCode) { }
    }
}
