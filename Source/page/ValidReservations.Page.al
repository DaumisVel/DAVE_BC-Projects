page 65016 "DAVEValidReservations"
{
    PageType = List;
    SourceTable = DAVEAutoReservation;
    Caption = 'Valid Reservations';
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(Reservations)
            {
                field(CarNo; Rec."CarNo") { }
                field(CustomerNo; Rec."CustomerNo") { }
                field(ReservedFrom; Rec."ReservedFrom") { }
                field(ReservedUntil; Rec."ReservedUntil") { }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetFilter("ReservedUntil", '>=%1', Today());
    end;
}
