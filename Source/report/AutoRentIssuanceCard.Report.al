report 65010 "DAVEAutoRentIssuanceCard"
{
    UsageCategory = History;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;
    Caption = 'Auto Rental Issuance Card';
    Permissions =
        tabledata Customer = R,
        tabledata DAVEAuto = R,
        tabledata DAVEAutoRentHeader = R,
        tabledata DAVEAutoRentLine = R;


    dataset
    {
        dataitem(DAVEAutoRentHeader; DAVEAutoRentHeader)
        {
            DataItemTableView = sorting("No.");
            dataitem(DAVEAutoRentLine; DAVEAutoRentLine)
            {
                DataItemLink = "DocumentNo" = field("No.");
                column(ServiceName; "No.") { }
                column(Quantity; Quantity) { }
                column(UnitPrice; UnitPrice) { DecimalPlaces = 2 : 2; }
                column(Amount; Amount) { DecimalPlaces = 2 : 2; }
            }

            column(DocumentNo; "No.") { }
            column(ReservedFrom; ReservedFrom) { }
            column(ReservedUntil; ReservedUntil) { }
            column(CarNo; CarNo) { }
            column(AutoMark; AutoMark) { }
            column(AutoModel; AutoModel) { }
            column(CustomerName; CustomerName) { }


            trigger OnAfterGetRecord()
            var
                Customer: Record Customer;
                Car: Record DAVEAuto;
            begin
                if Customer.Get("CustomerNo") then
                    CustomerName := Customer.Name;

                if Car.Get("CarNo") then begin
                    AutoMark := Car.MarkCode;
                    AutoModel := Car.ModelCode;
                end;
            end;

        }

    }

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'rdl/RentalIssuanceCard.rdl';
        }
    }

    labels
    {
        ReportName = 'Auto Rental Issuance Card';
    }

    var
        CustomerName: Text;
        AutoMark: Code[20];
        AutoModel: Code[20];

}
