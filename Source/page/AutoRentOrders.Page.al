page 65018 "DAVEAutoRentOrders"
{
    PageType = List;
    SourceTable = DAVEAutoRentHeader;
    Caption = 'Auto Rental Orders';
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = DAVEAutoRentOrder;

    layout
    {
        area(Content)
        {
            repeater(Rentals)
            {
                field("No."; Rec."No.")
                {

                }
                field(CustomerNo; Rec."CustomerNo")
                {
                    LookupPageId = "Customer List";
                }
                field(DriverLicenseImage; Rec.DriverLicenseImage)
                {

                }
                field(CarNo; Rec."CarNo")
                {
                    LookupPageId = DAVEAutos;
                }
                field(ReservedFrom; Rec."ReservedFrom")
                {

                }
                field(ReservedUntil; Rec."ReservedUntil")
                {

                }
                field(TotalAmount; Rec.TotalAmount)
                {

                }
                field(Status; Rec."Status")
                {

                }
            }
        }
    }
}
