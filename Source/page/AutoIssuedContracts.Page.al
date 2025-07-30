page 65024 "DAVEAutoIssuedContracts"
{
    PageType = List;
    SourceTable = DAVEAutoRentHeader;
    SourceTableView = where(Status = const(Issued));
    Caption = 'Auto Issued Contracts';
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

                }
                field(CustomerNo; Rec.CustomerNo)
                {

                    LookupPageId = "Customer List";
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
        area(Navigation)
        {
            action(OpenCard)
            {
                Caption = 'Open Card';
                ToolTip = 'Open the selected rental card.';
                Image = Card;
                RunObject = page "DAVEAutoRentOrder";
            }
        }
    }
}
