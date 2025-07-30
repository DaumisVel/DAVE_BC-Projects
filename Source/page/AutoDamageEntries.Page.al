page 65017 DAVEAutoDamageEntries
{
    PageType = List;
    SourceTable = DAVEAutoDamage;
    Caption = 'Auto Damage Entries';
    UsageCategory = Lists;
    ApplicationArea = All;
    Permissions = tabledata DAVEAutoDamage = RIMD;

    layout
    {
        area(Content)
        {
            repeater(Damages)
            {
                field(CarNo; Rec."CarNo")
                {

                }
                field(LineNo; Rec."LineNo")
                {

                }
                field(DamageDate; Rec."DamageDate")
                {

                }
                field(Description; Rec."Description")
                {

                }
                field(Status; Rec.Status)
                {
                   
                }
            }
        }
    }

}
