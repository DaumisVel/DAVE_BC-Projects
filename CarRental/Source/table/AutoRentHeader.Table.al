table 65016 "DAVEAutoRentHeader"
{
    Caption = 'Vehicle Rental Header';
    LookupPageId = "DAVEAutoRentCard";
    DrillDownPageId = "DAVEAutoRentList";
    DataClassification = CustomerContent;
    Permissions = tabledata DAVEAutoSetup=R,
                  tabledata Customer=R;


    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Rental No.';
            ToolTip = 'Specifies the unique rental document number.';
        }

        field(2; CustomerNo; Code[20])
        {
            Caption = 'Customer No.';
            ToolTip = 'Specifies the customer renting the vehicle.';
            TableRelation = Customer."No.";
            NotBlank = true;
            trigger OnValidate()
            var
            begin
                ValidateCustomerStatus();
            end;

        }

        field(10; DriverLicenseImage; Media)
        {
            Caption = 'Driver License';
            ToolTip = 'Stores the image of the drivers license.';
        }

        field(11; RentalDate; Date)
        {
            Caption = 'Rental Date';
            ToolTip = 'Specifies the date the rental was created.';
        }

        field(5; CarNo; Code[20])
        {
            Caption = 'Vehicle ID';
            ToolTip = 'Specifies the vehicle being rented.';
            TableRelation = DAVEAuto."No.";
            NotBlank = true;
            trigger OnValidate()
            begin
                Validate(ReservedFrom);
                Validate(ReservedUntil);
            end;

        }

        field(12; ReservedFrom; DateTime)
        {
            Caption = 'Reserved From';
            ToolTip = 'Specifies the start date and time of the reservation.';
            trigger OnValidate()
            begin
                ValidateReservationNoOverlap();
            end;
        }

        field(13; ReservedUntil; DateTime)
        {
            Caption = 'Reserved Until';
            ToolTip = 'Specifies the end date and time of the reservation.';
            trigger OnValidate()
            begin
                ValidateReservationNoOverlap();
            end;
        }

        field(14; TotalAmount; Decimal)
        {
            Caption = 'Total Rental Amount';
            ToolTip = 'Specifies the total amount calculated from rental lines.';
            Editable = false;
            // Optional: make this a FlowField if needed
        }

        field(15; Status; Enum DAVERentalStatus)
        {
            Caption = 'Rental Status';
            ToolTip = 'Indicates whether the rental is open or issued.';
            InitValue = Open;
        }
        field (18; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            AllowInCustomizations = Never;
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "CustomerNo", "CarNo", "Status") { }
        fieldgroup(Brick; "No.", "CustomerNo", "CarNo", "ReservedFrom", "ReservedUntil", "Status") { }
    }

    trigger OnInsert()
    var
        AutoSetup: Record DAVEAutoSetup;
        NoSeries: Codeunit "No. Series";
    begin
        if AutoSetup.IsEmpty() then
            AutoSetup.CreateAutoSetup();
        AutoSetup.Get();
        "No. Series" := AutoSetup.RentalCardSeries;
        "No." := NoSeries.GetNextNo("No. Series");
    end;

    local procedure ValidateCustomerStatus()
    var
        Customer: Record Customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        IsBlockedErr: Label 'Customer is Blocked';
        IsInDebtErr: Label 'Customer owes money: %1', Comment = '%1 = Ledger entries remaining amount sum';
        CustTotalAmount: Decimal;
    begin
        Customer.Get(Rec.CustomerNo);
        if Customer.IsBlocked() then
            Error(IsBlockedErr);

        CustLedgerEntry.SetRange("Customer No.", Rec.CustomerNo);
        CustLedgerEntry.SetRange(Open, true);

        CustTotalAmount := 0;
        if CustLedgerEntry.FindSet() then
            repeat
                CustTotalAmount += CustLedgerEntry."Remaining Amount";
            until CustLedgerEntry.Next() = 0;

        if CustTotalAmount > 0 then
            Error(IsInDebtErr, CustTotalAmount);
    end;
    local procedure ValidateReservationNoOverlap()
    var
        OtherRes: Record DAVEAutoReservation;
        OverlapErr: Label 'Reservation overlaps for vehicle %1: %2-%3.', Comment = '%1=CarNo, %2=ReservedFrom, %3=ReservedUntil';
    begin
        // Limit to the same vehicle
        TestField(CarNo);
        OtherRes.SetRange(CarNo, CarNo);
        // Find records where ReservedFrom < this.ReservedUntil
        // AND ReservedUntil > this.ReservedFrom => overlap exists
        OtherRes.SetFilter(ReservedFrom, '< %1', ReservedUntil);
        OtherRes.SetFilter(ReservedUntil, '> %1', ReservedFrom);
        if OtherRes.FindFirst() then
            Error(OverlapErr, CarNo, Format(OtherRes.ReservedFrom), Format(OtherRes.ReservedUntil));
    end;
}
