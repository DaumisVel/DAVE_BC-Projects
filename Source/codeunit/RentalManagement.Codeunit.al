codeunit 65010 DAVERentalManagement
{
    Permissions =
        tabledata "Cust. Ledger Entry" = R,
        tabledata Customer = R,
        tabledata DAVEAuto = R,
        tabledata DAVEAutoRentHeader = R,
        tabledata DAVEAutoRentLine = RIM,
        tabledata DAVEAutoReservation = R,
        tabledata DAVEAutoSetup = RI,
        tabledata Resource = R;
    procedure EnsureSetup()
    var
        Setup: Record DAVEAutoSetup;
    begin
        if Setup.IsEmpty() then begin
            Setup.Init();
            Setup.Insert(true);
        end;
    end;

    procedure ValidateReservationOverlap(CarNo: Code[20]; ReservedFrom: Date; ReservedUntil: Date; IgnoreLineNo: Integer)
    var
        OtherRes: Record DAVEAutoReservation;
        OverlapErr: Label 'Reservation overlaps for vehicle %1: %2-%3.', Comment = '%1=CarNo, %2=ReservedFrom, %3=ReservedUntil';
    begin
        if (ReservedFrom = 0D) or (ReservedUntil = 0D) then
            exit;

        OtherRes.SetRange(CarNo, CarNo);
        OtherRes.SetFilter(ReservedFrom, '< %1', ReservedUntil);
        OtherRes.SetFilter(ReservedUntil, '> %1', ReservedFrom);

        if OtherRes.FindFirst() and (OtherRes.LineNo <> IgnoreLineNo) then
            Error(OverlapErr, CarNo, Format(OtherRes.ReservedFrom), Format(OtherRes.ReservedUntil));
    end;

    procedure ValidateCustomerStatus(CustomerNo: Code[20])
    var
        Customer: Record Customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        IsBlockedErr: Label 'Customer is Blocked';
        IsInDebtErr: Label 'Customer owes money: %1', Comment = '%1 = Ledger entries remaining amount sum';
        CustNotFoundErr: Label 'Customer %1 does not exist.', Comment = '%1 = CustomerNo';
        CustTotalAmount: Decimal;
    begin
        if Customer.Get(CustomerNo) then begin
            if Customer.IsBlocked() then
                Error(IsBlockedErr);

            CustLedgerEntry.SetRange("Customer No.", CustomerNo);
            CustLedgerEntry.SetRange(Open, true);

            CustTotalAmount := 0;
            if CustLedgerEntry.FindSet() then
                repeat
                    CustTotalAmount += CustLedgerEntry."Remaining Amount";
                until CustLedgerEntry.Next() = 0;

            if CustTotalAmount > 0 then
                Error(IsInDebtErr, CustTotalAmount);
        end else
            Error(CustNotFoundErr, CustomerNo);
    end;

    procedure RecalculateLineQuantity(RentHeader: Record DAVEAutoRentHeader)
    var
        RentLine: Record DAVEAutoRentLine;
    begin
        RentLine.SetRange("DocumentNo", RentHeader."No.");
        RentLine.SetRange("LineNo", 10000);

        if RentLine.FindFirst() then begin
            RentLine.Quantity := CalcDailyQuantity(RentHeader."ReservedFrom", RentHeader."ReservedUntil");
            RentLine.Amount := RentLine.Quantity * RentLine.UnitPrice;
            RentLine.Modify(false);
            RentHeader.CalcFields(TotalAmount);
        end;
    end;

    procedure CreateOrAdjustFirstLine(AutoRentHeader: Record DAVEAutoRentHeader)
    var
        AutoRentLine: Record DAVEAutoRentLine;
        Resource: Record Resource;
        Auto: Record DAVEAuto;
        CarNotExistErr: Label 'Car with number %1 does not exist.', Comment = '%1 = Car number';
        ResourceNotExistErr: Label 'Resource with number %1 does not exist.', Comment = '%1 = Resource number';
        AutoRentLineType: Enum DAVEAutoRentLineType;
    begin
        if AutoRentLine.Get(AutoRentHeader."No.", 10000) then begin
            if not Auto.Get(AutoRentHeader.CarNo) then
                Error(CarNotExistErr, AutoRentHeader.CarNo);
            AutoRentLine.Type := AutoRentLineType::Resource;
            AutoRentLine."No." := Auto.RentalResource;
            if not Resource.Get(Auto.RentalResource) then
                Error(ResourceNotExistErr, Auto.RentalResource);
            AutoRentLine.Description := Resource.Name;
            AutoRentLine.UnitPrice := Resource."Unit Price";
            AutoRentLine.Modify(false);
        end else begin
            AutoRentLine.Init();
            AutoRentLine.DocumentNo := AutoRentHeader."No.";
            AutoRentLine.LineNo := 10000;
            AutoRentLine.Type := AutoRentLineType::Resource;
            if not Auto.Get(AutoRentHeader.CarNo) then
                Error(CarNotExistErr, AutoRentHeader.CarNo);
            AutoRentLine."No." := Auto.RentalResource;
            if not Resource.Get(Auto.RentalResource) then
                Error(ResourceNotExistErr, Auto.RentalResource);
            AutoRentLine.Description := Resource.Name;
            AutoRentLine.UnitPrice := Resource."Unit Price";
            AutoRentLine.Insert(true);
        end;
        AutoRentHeader.CalcFields(TotalAmount);
    end;

    local procedure CalcDailyQuantity(StartDate: Date; EndDate: Date): Integer
    begin
        if (StartDate = 0D) or (EndDate = 0D) then
            exit(0);

        exit((EndDate - StartDate) + 1);
    end;


}
