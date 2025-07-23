page 65025 "DAVEFininshedAutoRentList"
{
    PageType = List;
    SourceTable = DAVEFinishedAutoRentHeader;
    Caption = 'Completed Rentals';
    UsageCategory = Lists;
    ApplicationArea = All;
    Permissions = tabledata DAVEFinishedAutoRentHeader = R;
    CardPageId = DAVEFinishedAutoRentCard;

    // Optional: sort by rental no.
    SourceTableView = sorting("No.");

    layout
    {
        area(Content)
        {
            repeater(CompletedRentals)
            {
                field("No."; Rec."No.")
                {
                    Caption = 'Rental No.';
                }
                field(CustomerNo; Rec.CustomerNo)
                {
                    Caption = 'Customer No.';
                    LookupPageId = "Customer List";
                }
                field(RentalDate; Rec.RentalDate)
                {
                    Caption = 'Rental Date';
                }
                field(CarNo; Rec.CarNo)
                {
                    Caption = 'Vehicle ID';
                    LookupPageId = "DAVEAutos";
                }
                field(ReservedFrom; Rec.ReservedFrom)
                {
                    Caption = 'Reserved From';
                }
                field(ReservedUntil; Rec.ReservedUntil)
                {
                    Caption = 'Reserved Until';
                }
                field(TotalAmount; Rec.TotalAmount)
                {
                    Caption = 'Total Amount';
                }
            }
        }
    }

    actions
    {

    }
}
