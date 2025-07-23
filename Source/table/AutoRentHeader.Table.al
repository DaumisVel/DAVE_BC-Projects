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

        field(10; CustomerNo; Code[20])
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

        field(5000; DriverLicenseImage; Media)
        {
            Caption = 'Driver License';
            ToolTip = 'Stores the image of the drivers license.';
            DataClassification = EndUserIdentifiableInformation;
        }

        field(12; RentalDate; Date)
        {
            Caption = 'Rental Date';
            ToolTip = 'Specifies the date the rental was created.';
        }

        field(13; CarNo; Code[20])
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

        field(14; ReservedFrom; Date)
        {
            Caption = 'Reserved From';
            ToolTip = 'Specifies the start date and time of the reservation.';
            trigger OnValidate()
            begin

                if ("ReservedFrom" <> 0D) and ("ReservedUntil" <> 0D) then
                    if ("ReservedFrom" > "ReservedUntil") then
                        Error('Reserved From must be earlier than Reserved Until.');
                ValidateReservationNoOverlap();
            end;
        }

        field(15; ReservedUntil; Date)
        {
            Caption = 'Reserved Until';
            ToolTip = 'Specifies the end date and time of the reservation.';

            trigger OnValidate()
            begin
                if ("ReservedFrom" <> 0D) and ("ReservedUntil" <> 0D) then
                    if ("ReservedFrom" > "ReservedUntil") then
                        Error('Reserved From must be earlier than Reserved Until.');
                ValidateReservationNoOverlap();
            end;
        }

        field(16; TotalAmount; Decimal)
        {
            Caption = 'Total Rental Amount';
            ToolTip = 'Specifies the total amount calculated from rental lines.';
            Editable = false;
            CalcFormula = sum(DAVEAutoRentLine.Amount where(DocumentNo = field("No.")));
            FieldClass = FlowField;
        }

        field(17; Status; Enum DAVERentalStatus)
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

    trigger OnModify()
    var
        RentLine: Record DAVEAutoRentLine;
        RentalStatus: Enum DAVERentalStatus;
    begin
        if Status = RentalStatus::Issued then
            Error('Record cant be modified when status is Issued.');

        if ("ReservedFrom" <> xRec."ReservedFrom") or
        ("ReservedUntil" <> xRec."ReservedUntil") or
        (Rec.CarNo <> xRec."CarNo") then begin
            // Find the first line and recalculate Quantity
            RentLine.SetRange("DocumentNo", "No.");
            RentLine.SetRange("LineNo", 10000);
            if RentLine.FindFirst() then begin
                RentLine.Quantity := RentLine.CalcDailyQuantity("ReservedFrom", "ReservedUntil");
                RentLine.Amount := (RentLine.Quantity * RentLine.UnitPrice);
                RentLine.Modify(false);
                CalcFields(TotalAmount);
            end;
        end;
    end;
    trigger OnDelete()
    var
        RentalStatus: Enum DAVERentalStatus;
    begin
        if Status = RentalStatus::Issued then
            Error('You cannot delete an order with Issued status.');
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
