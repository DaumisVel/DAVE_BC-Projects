enum 65001 "DAVEPCRuleType"
{
    Extensible = true;
    Caption = 'Personal Code Rule Type';


    value(0; LENGHT)
    {
        Caption = 'LENGHT';
    }
    value(1; NUMERIC)
    {
        Caption = 'NUMERIC (only digits) this is a rule that checks if the personal code contains only numeric digits.';
    }
    value(2; FIRSTDIGIT)
    {
        Caption = 'FIRSTDIGIT';
    }
    value(3; DATE)
    {
        Caption = 'DATE';
    }
    value(4; SERIAL)
    {
        Caption = 'SERIAL';
    }
    value(5; CHECKSUM)
    {
        Caption = 'CHECKSUM';
    }
    value(6; EXEPTION)
    {
        Caption = 'EXCEPTION';
    }

}
