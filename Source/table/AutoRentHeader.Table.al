table 65016 "DAVEAutoRentHeader"
{
    Caption = 'Auto Rental Header';
    LookupPageId = "DAVEAutoRentOrder";
    DrillDownPageId = "DAVEAutoRentOrders";
    Permissions =
        tabledata Customer = R,
        tabledata DAVEAuto = R,
        tabledata DAVEAutoRentHeader = R,
        tabledata DAVEAutoSetup = R;


    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Rental No.';
            ToolTip = 'Specifies the unique rental document number.';
            DataClassification = SystemMetadata;
        }

        field(10; CustomerNo; Code[20])
        {
            Caption = 'Customer No.';
            ToolTip = 'Specifies the customer renting the vehicle.';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
            NotBlank = true;
            trigger OnValidate()
            var
                RentalManagement: Codeunit DAVERentalManagement;
            begin
                RentalManagement.ValidateCustomerStatus(CustomerNo);
            end;

        }

        field(12; RentalDate; Date)
        {
            Caption = 'Rental Date';
            ToolTip = 'Specifies the date when the rental order becomes valid.';
            DataClassification = CustomerContent;
        }

        field(13; CarNo; Code[20])
        {
            Caption = 'Vehicle ID';
            ToolTip = 'Specifies the vehicle No. being rented.';
            DataClassification = SystemMetadata;
            TableRelation = DAVEAuto."No.";
            NotBlank = true;
            trigger OnValidate()
            begin
                if (ReservedFrom <> 0D) and (ReservedUntil <> 0D) then
                    ValidateReservationDates();
            end;

        }

        field(14; ReservedFrom; Date)
        {
            Caption = 'Reserved From';
            ToolTip = 'Specifies the start date of the reservation.';
            DataClassification = CustomerContent;
            NotBlank = true;

            trigger OnValidate()
            var
                RentalManagement: Codeunit DAVERentalManagement;
            begin
                if ("ReservedFrom" = 0D) or ("ReservedUntil" = 0D) then
                    exit;

                ValidateReservationDates();
                ValidateReservedNotFromPast();
                RentalManagement.ValidateReservationOverlap(CarNo, ReservedFrom, ReservedUntil, 0);
            end;
        }

        field(15; ReservedUntil; Date)
        {
            Caption = 'Reserved Until';
            ToolTip = 'Specifies the end date of the reservation.';
            DataClassification = CustomerContent;
            NotBlank = true;

            trigger OnValidate()
            var
                RentalManagement: Codeunit DAVERentalManagement;
            begin
                if ("ReservedFrom" = 0D) and ("ReservedUntil" = 0D) then
                    exit;
                ValidateReservationDates();
                RentalManagement.ValidateReservationOverlap(CarNo, ReservedFrom, ReservedUntil, 0);
                CheckTechnicalInspection();
                CheckInsurance();

            end;
        }

        field(16; TotalAmount; Decimal)
        {
            Caption = 'Total Rental Amount';
            ToolTip = 'Looks up the total amount of the rental order based on the lines.';
            CalcFormula = sum(DAVEAutoRentLine.Amount where(DocumentNo = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }

        field(17; Status; Enum DAVERentalStatus)
        {
            Caption = 'Rental Status';
            ToolTip = 'Indicates whether the rental is open or issued.';
            DataClassification = SystemMetadata;
            InitValue = Open;
        }
        field(18; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            DataClassification = SystemMetadata;
            TableRelation = "No. Series";
            AllowInCustomizations = Never;
        }
        field(5000; DriverLicenseImage; Media)
        {
            Caption = 'Driver License';
            ToolTip = 'Stores the image of the drivers license.';
            DataClassification = CustomerContent;
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
        RentalManagement: Codeunit DAVERentalManagement;
        NoSeries: Codeunit "No. Series";
        CurrStatusErr: Label 'Cannot insert a record with status Issued.';
        RentalStatus: Enum DAVERentalStatus;
    begin
        if Status = RentalStatus::Issued then
            Error(CurrStatusErr);

        RentalManagement.EnsureSetup();
        AutoSetup.Get();
        "No. Series" := AutoSetup.RentalOrderNoSeries;
        "No." := NoSeries.GetNextNo("No. Series");
    end;

    trigger OnModify()
    var
        RentalManagement: Codeunit DAVERentalManagement;
        CurrStatusErr: Label 'Record cant be modified when status is: %1', Comment = '%1 = Status';
        RentalStatus: Enum DAVERentalStatus;
    begin
        if Status = RentalStatus::Issued then
            Error(CurrStatusErr, Status);

        if (ReservedFrom <> xRec.ReservedFrom) or
        (ReservedUntil <> xRec.ReservedUntil) or
        (Rec.CarNo <> xRec.CarNo) then
            RentalManagement.RecalculateLineQuantity(Rec);
    end;

    trigger OnDelete()
    var
        CurrStatusErr: Label 'Record cant be deleted when status is: %1', Comment = '%1 = Status';
        RentalStatus: Enum DAVERentalStatus;
    begin
        if Status = RentalStatus::Issued then
            Error(CurrStatusErr, Status);
    end;


    local procedure CheckTechnicalInspection()
    var
        Auto: Record DAVEAuto;
        TechExpiredErr: Label 'The technical inspection of the vehicle %1 is expired on %2. Please renew it before proceeding.', Comment = '%1 is the vehicle number, %2 is the expiration date of the technical inspection.';
    begin
        if IsCarNoEmpty() then
            exit;
        Auto.Get(CarNo);
        if Auto.TechnicalInspectionValidUntil < ReservedFrom then
            Error(TechExpiredErr, Auto."No.", Auto.TechnicalInspectionValidUntil);
    end;

    local procedure CheckInsurance()
    var
        Auto: Record DAVEAuto;
        InsExpiredErr: Label 'The civil insurance of the vehicle %1 is expired on %2. Please renew it before proceeding.', Comment = '%1 is the vehicle number, %2 is the expiration date of the insurance.';
    begin
        if IsCarNoEmpty() then
            exit;
        Auto.Get(CarNo);
        if Auto.InsuranceValidUntil < ReservedFrom then
            Error(InsExpiredErr, Auto."No.", Auto.InsuranceValidUntil);
    end;

    local procedure IsCarNoEmpty(): Boolean
    begin
        exit(CarNo = '');
    end;

    local procedure ValidateReservationDates()
    var
        InvalidDateErr: Label '%1 must be earlier than %2.', Comment = '%1 - start date, %2 - end date.';
    begin
        if (ReservedFrom > ReservedUntil) then
            Error(InvalidDateErr, ReservedFrom, ReservedUntil);
    end;

    local procedure ValidateReservedNotFromPast()
    var
        PastDateErr: Label 'Reservation start date cannot be in the past. Please select a valid date.';
        Today: Date;
    begin
        Today := WorkDate();
        if ReservedFrom < Today then
            Error(PastDateErr);
    end;
}
