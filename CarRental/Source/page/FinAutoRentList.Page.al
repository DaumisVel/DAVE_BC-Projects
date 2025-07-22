page 65025 "DAVEFinAutoRentList"
{
    PageType = List;
    SourceTable = DAVEFinishedAutoRentHeader;
    Caption = 'Completed Rentals';
    UsageCategory = Lists;
    ApplicationArea = All;
    Permissions = tabledata DAVEFinishedAutoRentHeader = R;

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
        area(Processing)
        {
            action(OpenFinishedRental)
            {
                Caption = 'Open Completed Rental';
                ToolTip = 'View details of the completed rental.';
                Image = Card;
                RunObject = page "DAVEFinishedAutoRentCard";
            }
        }
    }
}
