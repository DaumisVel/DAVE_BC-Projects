page 65021 "DAVEAutoRentDamageEntries"
{
    PageType = List;
    SourceTable = DAVEAutoRentDamage;
    Caption = 'Auto Rental Damage Entries';
    UsageCategory = Lists;
    ApplicationArea = All;
    Permissions = tabledata DAVEAutoRentDamage = RIMD,
                  tabledata DAVEAutoRentHeader = R;
    SourceTableView = sorting(DocumentNo, LineNo);

    layout
    {
        area(Content)
        {
            repeater(DamageEntries)
            {
                field(DocumentNo; Rec.DocumentNo)
                {
                    LookupPageId = "DAVEAutoRentOrders";
                    NotBlank = true;
                }
                field(LineNo; Rec.LineNo)
                {
                    
                }
                field(DamageDate; Rec.DamageDate)
                {
                    NotBlank = true;
                    trigger OnValidate()
                    var
                        AutoRentHeader: Record DAVEAutoRentHeader;
                        DateOutOfRentPeriodErr: Label 'Damage date must be within the rental period from %1 to %2.', Comment = '%1 is the start date and %2 is the end date of the rental period.';
                        NoNotExistErr: Label 'Rental header with No. %1 does not exist.', Comment = '%1 = Rental document number';
                    begin
                        if not AutoRentHeader.Get(Rec.DocumentNo) then
                            Error(NoNotExistErr, Rec.DocumentNo);
                        if (AutoRentHeader.ReservedFrom > Rec.DamageDate) or
                           (AutoRentHeader.ReservedUntil < Rec.DamageDate) then
                            Error(DateOutOfRentPeriodErr, AutoRentHeader.ReservedFrom, AutoRentHeader.ReservedUntil);
                    end;
                }
                field(Description; Rec.Description)
                {
                    NotBlank = true;
                }
            }
        }
    }
}
