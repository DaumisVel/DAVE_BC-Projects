table 65014 "DAVEAutoReservation"
{
    Caption = 'Auto Reservation';
    LookupPageId = "DAVEAutoReservations";
    DrillDownPageId = "DAVEAutoReservations";
    DataClassification = CustomerContent;
    Permissions = tabledata DAVEAutoReservation=R;

    fields
    {
        field(1; CarNo; Code[20])
        {
            Caption = 'Vehicle ID';
            ToolTip = 'Specifies the unique ID of the reserved vehicle.';
            TableRelation = DAVEAuto."No.";
            NotBlank = true;
        }

        field(2; LineNo; Integer)
        {
            Caption = 'Line Number';
            ToolTip = 'Specifies the line number of the reservation entry.';
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
            ToolTip = 'Specifies the start date and time of the reservation.';
            trigger OnValidate()
            begin
                if ("ReservedFrom" <> 0D) and ("ReservedUntil" <> 0D) then
                    if ("ReservedFrom" > "ReservedUntil") then
                        Error('Reserved From must be earlier than Reserved Until.');
                ValidateReservationNoOverlap();
            end;
        }

        field(12; ReservedUntil; Date)
        {
            Caption = 'Reservation End';
            ToolTip = 'Specifies the end date and time of the reservation.';
            trigger OnValidate()
            begin
                if ("ReservedFrom" <> 0D) and ("ReservedUntil" <> 0D) then
                    if ("ReservedFrom" > "ReservedUntil") then
                        Error('Reserved From must be earlier than Reserved Until.');
                ValidateReservationNoOverlap();
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
    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    local procedure ValidateReservationNoOverlap()
    var
        OtherRes: Record DAVEAutoReservation;
        OverlapErr: Label 'Reservation overlaps for vehicle %1: %2-%3.', Comment = '%1=CarNo, %2=ReservedFrom, %3=ReservedUntil';
    begin
        // Limit to the same vehicle
        OtherRes.SetRange(CarNo, CarNo);
        // Find records where ReservedFrom < this.ReservedUntil
        // AND ReservedUntil > this.ReservedFrom => overlap exists
        OtherRes.SetFilter(ReservedFrom, '< %1', ReservedUntil);
        OtherRes.SetFilter(ReservedUntil, '> %1', ReservedFrom);
        if OtherRes.FindFirst() and (OtherRes.LineNo <> LineNo) then
            Error(OverlapErr, CarNo, Format(OtherRes.ReservedFrom), Format(OtherRes.ReservedUntil));
    end;

}
