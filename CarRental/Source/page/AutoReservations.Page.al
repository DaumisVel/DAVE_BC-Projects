page 65015 "DAVEAutoReservations"
{
    PageType = ListPart;
    SourceTable = DAVEAutoReservation;
    Caption = 'Auto Reservations';
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Reservations)
            {
                field(CarNo; Rec."CarNo") { }
                field(LineNo; Rec."LineNo") { }
                field(CustomerNo; Rec."CustomerNo") { }
                field(ReservedFrom; Rec."ReservedFrom") { }
                field(ReservedUntil; Rec."ReservedUntil") { }
            }
        }
    }
}
