page 65017 "DAVEAutoDamageList"
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
                    Caption = 'Vehicle ID';
                }
                /*field(LineNo; Rec."LineNo")
                {
                    Caption = 'Line No.';
                }*/
                field(DamageDate; Rec."DamageDate")
                {
                    Caption = 'Date of Damage';
                }
                field(Description; Rec."Description")
                {
                    Caption = 'Damage Description';
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Current Damage Status';
                }
            }
        }
    }
}
