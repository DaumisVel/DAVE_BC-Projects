table 65018 "DAVEAutoRentDamage"
{
    Caption = 'Rental Damage Entry';
    DataClassification = CustomerContent;
    LookupPageId = "DAVEAutoRentDamageList";
    DrillDownPageId = "DAVEAutoRentDamageList";
    Permissions = tabledata DAVEAutoRentDamage=R;


    fields
    {
        field(1; DocumentNo; Code[20])
        {
            Caption = 'Rental No.';
            ToolTip = 'Specifies the rental document number this damage entry belongs to.';
            TableRelation = DAVEAutoRentHeader."No.";
            NotBlank = true;
        }

        field(2; LineNo; Integer)
        {
            Caption = 'Line No.';
            ToolTip = 'Specifies the line number of the damage entry.';
            NotBlank = true;
        }

        field(10; DamageDate; Date)
        {
            Caption = 'Damage Date';
            ToolTip = 'Specifies the date when the damage was recorded.';
            NotBlank = true;
        }

        field(11; Description; Text[100])
        {
            Caption = 'Damage Description';
            ToolTip = 'Describes the damage observed before vehicle return.';
            NotBlank = true;
        }
    }

    keys
    {
        key(PK; "DocumentNo", "LineNo") { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "DocumentNo", "DamageDate") { }
        fieldgroup(Brick; "DocumentNo", "DamageDate", "Description") { }
    }
    trigger OnInsert()
    begin
        SetNextLineNo();
    end;

    local procedure SetNextLineNo()
    var
        LastLine: Record "DAVEAutoRentDamage";
    begin
        LastLine.SetRange(DocumentNo, DocumentNo);
        if LastLine.FindLast() then
            LineNo := LastLine.LineNo + 1
        else
            LineNo := 1;
    end;

}
