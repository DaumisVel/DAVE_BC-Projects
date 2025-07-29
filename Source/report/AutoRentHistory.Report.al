report 65011 DAVEAutoRentHistory
{
    UsageCategory = History;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;
    Caption = 'Auto Rental History';
    Permissions =
        tabledata Customer = R,
        tabledata DAVEAuto = R,
        tabledata DAVEFinishedAutoRentHeader = R;

    dataset
    {
        dataitem(DAVEAuto; DAVEAuto)
        {
            DataItemTableView = sorting("No.");
            column(No_; "No.") { }
            column(MarkCode; MarkCode) { }
            column(ModelCode; ModelCode) { }

            dataitem(DAVEFinishedAutoRentHeader; DAVEFinishedAutoRentHeader)
            {
                DataItemLink = "CarNo" = field("No.");
                DataItemTableView = sorting(ReservedFrom);
                
                column(ReservedFrom; ReservedFrom) { }
                column(ReservedUntil; ReservedUntil) { }
                column(CustomerName; CustomerName) { }
                column(TotalAmount; TotalAmount) { }


                trigger OnPreDataItem()
                begin
                    if (FromDateFilter <> 0D) and (ToDateFilter <> 0D) then begin
                        SetFilter(ReservedFrom, '<=%1', ToDateFilter);
                        SetFilter(ReservedUntil, '>=%1', FromDateFilter);
                    end;
                end;
                trigger OnAfterGetRecord()
                var
                    Customer: Record Customer;
                begin
                    if Customer.Get("CustomerNo") then
                        CustomerName := Customer.Name;
                end;
            }
        }


    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                field(FromDate; FromDateFilter)
                {
                    Caption = 'From Date';
                    ToolTip = 'Specifies the start date for the rental history report.';
                    ApplicationArea = All;
                }

                field(ToDate; ToDateFilter)
                {
                    Caption = 'To Date';
                    ToolTip = 'Specifies the end date for the rental history report.';
                    ApplicationArea = All;
                }
            }
        }
    }


    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'rdl/AutoRentalHistory.rdl';
        }
    }



    labels
    {
        ReportName = 'Auto Rental History';
    }
    var
        IncorrectDateErr: Label '%1 cannot be later than %2.', Comment = '%1 is the From Date, %2 is the To Date';
        EmptyDateErr: Label 'None or both dates must be specified. Please enter valid dates.', Comment = 'This error occurs when one of the date fields is empty while the other is not.';
        CustomerName: Text;
        FromDateFilter: Date;
        ToDateFilter: Date;


    trigger OnPreReport()
    begin
        if ((FromDateFilter = 0D) and (ToDateFilter <> 0D)) or
            (FromDateFilter <> 0D) and (ToDateFilter = 0D) then
            Error(EmptyDateErr);
        if (FromDateFilter > ToDateFilter) then
            Error(IncorrectDateErr, FromDateFilter, ToDateFilter);
    end;

}
