page 65022 "DAVEFinishedAutoRentOrder"
{
    PageType = Card;
    SourceTable = "DAVEFinishedAutoRentHeader";
    Caption = 'Finished Auto Rental Order';
    UsageCategory = History;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(GeneralInfo)
            {
                Caption = 'General Information';
                field("No."; Rec."No.") { Editable = false; }
                field(CustomerNo; Rec.CustomerNo) { Editable = false; LookupPageId = "Customer List"; }
                field(DriverLicenseImage; Rec.DriverLicenseImage)
                { Editable = false; }
            }
            group(RentalDetails)
            {
                Caption = 'Reservation Details';
                field(RentalDate; Rec.RentalDate) { Editable = false; }
                field(CarNo; Rec.CarNo) { Editable = false; LookupPageId = "DAVEAutos"; }
                field(ReservedFrom; Rec.ReservedFrom) { Editable = false; }
                field(ReservedUntil; Rec.ReservedUntil) { Editable = false; }
                field(TotalAmount; Rec.TotalAmount) { Editable = false; }
            }
            part(RentalLines; "DAVEFinishedRentLines")
            {
                SubPageLink = "DocumentNo" = field("No.");
                Caption = 'Rental Lines';
            }
        }
    }
}
