page 65025 "DAVEFininshedAutoRentOrders"
{
    PageType = List;
    SourceTable = DAVEFinishedAutoRentHeader;
    Caption = 'Finished Auto Rental Orders';
    UsageCategory = History;
    ApplicationArea = All;
    Permissions = tabledata DAVEFinishedAutoRentHeader = R;
    CardPageId = DAVEFinishedAutoRentOrder;
    SourceTableView = sorting("No.");

    layout
    {
        area(Content)
        {
            repeater(CompletedRentals)
            {
                field("No."; Rec."No.")
                {

                }
                field(CustomerNo; Rec.CustomerNo)
                {
                    LookupPageId = "Customer List";
                }
                field(RentalDate; Rec.RentalDate)
                {

                }
                field(CarNo; Rec.CarNo)
                {
                    LookupPageId = "DAVEAutos";
                }
                field(ReservedFrom; Rec.ReservedFrom)
                {

                }
                field(ReservedUntil; Rec.ReservedUntil)
                {

                }
                field(TotalAmount; Rec.TotalAmount)
                {
             
                }
            }
        }
    }

    actions
    {

    }
}
