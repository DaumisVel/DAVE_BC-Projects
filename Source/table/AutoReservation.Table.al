table 65014 DAVEAutoReservation
{
    Caption = 'Auto Reservation';
    LookupPageId = DAVEAutoReservations;
    DrillDownPageId = DAVEAutoReservations;
    DataClassification = EndUserIdentifiableInformation;
    Permissions = tabledata DAVEAutoReservation = R;

    fields
    {
        field(1; CarNo; Code[20])
        {
            Caption = 'Car No.';
            ToolTip = 'Specifies the unique ID of the reserved vehicle.';
            DataClassification = SystemMetadata;
            TableRelation = DAVEAuto."No.";
            NotBlank = true;
        }

        field(2; LineNo; Integer)
        {
            Caption = 'Line Number';
            ToolTip = 'Specifies the line number of the reservation entry.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
            AllowInCustomizations = Always;
        }

        field(10; CustomerNo; Code[20])
        {
            Caption = 'Customer Number';
            ToolTip = 'Specifies the customer who made the reservation.';
            TableRelation = Customer."No.";
            NotBlank = true;
        }

        field(11; ReservedFrom; Date)
        {
            Caption = 'Reservation Start';
            ToolTip = 'Specifies the start date of the reservation.';
            trigger OnValidate()
            var
                RentalManagement: Codeunit DAVERentalManagement;
                PastDateErr: Label 'Reservation start date cannot be in the past. Please select a valid date.';
                InvalidDatesErr: Label '%1 must be earlier than %2.', Comment = '%1 is the start date, %2 is the end date of the reservation.';
                Today: Date;
            begin
                Today := WorkDate();
                if ReservedFrom < Today then
                    Error(PastDateErr);
                if (ReservedFrom <> 0D) and (ReservedUntil <> 0D) then
                    if ("ReservedFrom" > "ReservedUntil") then
                        Error(InvalidDatesErr);
                RentalManagement.ValidateReservationOverlap(CarNo, ReservedFrom, ReservedUntil, LineNo);
            end;
        }

        field(12; ReservedUntil; Date)
        {
            Caption = 'Reservation End';
            ToolTip = 'Specifies the end date of the reservation.';
            trigger OnValidate()
            var
                RentalManagement: Codeunit DAVERentalManagement;
                InvalidDatesErr: Label '%1 must be earlier than %2.', Comment = '%1 is the start date, %2 is the end date of the reservation.';
            begin
                if ("ReservedFrom" <> 0D) and ("ReservedUntil" <> 0D) then
                    if ("ReservedFrom" > "ReservedUntil") then
                        Error(InvalidDatesErr, ReservedFrom, ReservedUntil);
                RentalManagement.ValidateReservationOverlap(CarNo, ReservedFrom, ReservedUntil, LineNo);
            end;
        }
    }

    keys
    {
        key(PK; "CarNo", "LineNo") { Clustered = true; }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "CarNo", "CustomerNo", "ReservedFrom")
        {
        }

        fieldgroup(Brick; "CarNo", "CustomerNo", "ReservedFrom", "ReservedUntil")
        {
        }
    }
}
