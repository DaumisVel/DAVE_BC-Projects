page 65019 "DAVEAutoRentCard"
{
    PageType = Card;
    SourceTable = DAVEAutoRentHeader;
    Caption = 'Auto Rent Card';
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(GeneralInfo)
            {
                Caption = 'Rental General Info';
                field("No."; Rec."No.")
                {
                    Caption = 'Rental No.';
                }
                field(CustomerNo; Rec."CustomerNo")
                {
                    Caption = 'Customer No.';
                    LookupPageId = "Customer List";
                }
                field(DriverLicenseImage; Rec."DriverLicenseImage")
                {
                    Caption = 'Driver License';
                }
                field(RentalDate; Rec."RentalDate")
                {
                    Caption = 'Rental Date';
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
            part(RentalLines; "DAVEAutoRentLineListPart")
            {
                SubPageLink = "DocumentNo" = field("No.");
                Caption = 'Rental Lines';
            }
        }
    }
}
