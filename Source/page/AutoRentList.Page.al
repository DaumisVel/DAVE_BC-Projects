page 65018 "DAVEAutoRentList"
{
    PageType = List;
    SourceTable = DAVEAutoRentHeader;
    Caption = 'Auto Rents';
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = DAVEAutoRentCard;

    layout
    {
        area(Content)
        {
            repeater(Rentals)
            {
                field("No."; Rec."No.")
                {
                    Caption = 'Rental No.';
                }
                field(CustomerNo; Rec."CustomerNo")
                {
                    Caption = 'Customer No.';
                    LookupPageId = "Customer List";
                }
                field(DriverLicenseImage; Rec.DriverLicenseImage)
                {
                    Caption = 'Driver License Image';
                }
                field(CarNo; Rec."CarNo")
                {
                    Caption = 'Vehicle ID';
                    LookupPageId = DAVEAutos;
                }
                field(ReservedFrom; Rec."ReservedFrom")
                {
                    Caption = 'Reserved From';
                }
                field(ReservedUntil; Rec."ReservedUntil")
                {
                    Caption = 'Reserved Until';
                }
                field(TotalAmount; Rec."TotalAmount")
                {
                    Caption = 'Total Rental Amount';
                }
                field(Status; Rec."Status")
                {
                    Caption = 'Rental Status';
                }
            }
        }
    }
}
