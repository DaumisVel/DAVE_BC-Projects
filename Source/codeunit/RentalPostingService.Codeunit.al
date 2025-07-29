codeunit 65011 DAVERentalPostingService
{
    Permissions =
        tabledata DAVEAutoDamage = RI,
        tabledata DAVEAutoRentDamage = R,
        tabledata DAVEAutoRentHeader = RD,
        tabledata DAVEAutoRentLine = RD,
        tabledata DAVEFinishedAutoRentHeader = RI,
        tabledata DAVEFinishedAutoRentLine = RI;
    procedure PostRentalDocument(AutoRentHeader: Record DAVEAutoRentHeader)
    var
        FinishedAutoRentHeader: Record DAVEFinishedAutoRentHeader;
        FinishedAutoRentLine: Record DAVEFinishedAutoRentLine;
        AutoRentLine: Record DAVEAutoRentLine;
        AutoRentDamage: Record DAVEAutoRentDamage;
        AutoDamage: Record DAVEAutoDamage;
        DamageStatus: Enum DAVEAutoDamageStatus;
    begin
        ValidateRentalHeader(AutoRentHeader);

        FinishedAutoRentHeader.Init();
        FinishedAutoRentHeader.TransferFields(AutoRentHeader);
        FinishedAutoRentHeader."No." := AutoRentHeader."No.";
        FinishedAutoRentHeader.Insert(true);

        AutoRentLine.SetRange(DocumentNo, AutoRentHeader."No.");
        if AutoRentLine.FindSet() then
            repeat
                ValidateRentalLine(AutoRentLine);
                FinishedAutoRentLine.Init();
                FinishedAutoRentLine.TransferFields(AutoRentLine, false);
                FinishedAutoRentLine.DocumentNo := AutoRentLine.DocumentNo;
                FinishedAutoRentLine.LineNo := AutoRentLine.LineNo;
                FinishedAutoRentLine.Insert(true);
            until AutoRentLine.Next() = 0;

        AutoRentDamage.SetRange(DocumentNo, AutoRentHeader."No.");
        if AutoRentDamage.FindSet() then
            repeat
                ValidateRentalDamage(AutoRentDamage);
                AutoDamage.Init();
                AutoDamage.CarNo := AutoRentHeader.CarNo;
                AutoDamage.DamageDate := AutoRentDamage.DamageDate;
                AutoDamage.Description := AutoRentDamage.Description;
                AutoDamage.LineNo := 0;
                AutoDamage.Status := DamageStatus::Current;
                AutoDamage.Insert(true);
            until AutoRentDamage.Next() = 0;

        AutoRentLine.DeleteAll(false);
        AutoRentHeader.Delete(false);
    end;

    local procedure ValidateRentalHeader(AutoRentHeader: Record DAVEAutoRentHeader)
    begin
        AutoRentHeader.TestField(Status, DAVERentalStatus::Issued);
        AutoRentHeader.TestField(CarNo);
        AutoRentHeader.TestField(RentalDate);
        AutoRentHeader.TestField(ReservedFrom);
        AutoRentHeader.TestField(ReservedUntil);
        AutoRentHeader.TestField(DriverLicenseImage);
    end;

    local procedure ValidateRentalLine(AutoRentLine: Record DAVEAutoRentLine)
    begin
        AutoRentLine.TestField(Type);
        AutoRentLine.TestField("No.");
        AutoRentLine.TestField(Quantity);
    end;

    local procedure ValidateRentalDamage(AutoRentDamage: Record DAVEAutoRentDamage)
    begin
        AutoRentDamage.TestField(DamageDate);
        AutoRentDamage.TestField(Description);
    end;
}
