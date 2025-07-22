page 65018 "DAVEAutoRentList"
{
    PageType = List;
    SourceTable = DAVEAutoRentHeader;
    Caption = 'Auto Rents';
    UsageCategory = Lists;
    ApplicationArea = All;

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
    actions
    {
        area(Processing)
        {
            action(OpenCard)
            {
                Caption = 'Open Rental';
                ToolTip = 'Open the rental document.';
                Image = Card;
                RunObject = page "DAVEAutoRentCard";
            }
        }
    }
}
