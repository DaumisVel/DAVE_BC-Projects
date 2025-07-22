page 65021 "DAVEAutoRentDamageList"
{
    PageType = List;
    SourceTable = DAVEAutoRentDamage;
    Caption = 'Rental Damage Entries';
    UsageCategory = Lists;
    ApplicationArea = All;
    Permissions = tabledata DAVEAutoRentDamage = RIMD;
    SourceTableView = sorting(DocumentNo, LineNo);

    layout
    {
        area(Content)
        {
            repeater(DamageEntries)
            {
                field(DocumentNo; Rec.DocumentNo)
                {
                    Caption = 'Rental No.';
                    LookupPageId = "DAVEAutoRentList";
                }
                field(LineNo; Rec.LineNo)
                {
                    Caption = 'Line No.';
                }
                field(DamageDate; Rec.DamageDate)
                {
                    Caption = 'Damage Date';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Damage Description';
                }
            }
        }
    }
}
