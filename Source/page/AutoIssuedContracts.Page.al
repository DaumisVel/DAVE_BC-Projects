page 65024 "DAVEAutoIssuedContracts"
{
    PageType = List;
    SourceTable = DAVEAutoRentHeader;
    SourceTableView = where(Status = const(Issued));
    Caption = 'Išduotos Auto sutartys';
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(IssuedContracts)
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
        area(Navigation)
        {
            action(OpenCard)
            {
                Caption = 'Open Card';
                ToolTip = 'Open the selected rental card.';
                Image = Card;
                RunObject = page "DAVEAutoRentCard";
            }
        }
    }
}
