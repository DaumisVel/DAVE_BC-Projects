table 65019 "DAVEFinishedAutoRentHeader"
{
    Caption = 'Completed Rental Header';
    LookupPageId = "DAVEFinAutoRentList";
    DrillDownPageId = "DAVEFinishedAutoRentCard";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Rental No.';
            ToolTip = 'Specifies the unique number of the completed rental document.';
            NotBlank = true;
            DataClassification = SystemMetadata;
        }

        field(2; CustomerNo; Code[20])
        {
            Caption = 'Customer No.';
            ToolTip = 'Specifies the customer who rented the vehicle.';
            TableRelation = Customer."No.";
            NotBlank = true;
            DataClassification = CustomerContent;
        }

        field(3; DriverLicenseImage; Media)
        {
            Caption = 'Driver License';
            ToolTip = 'Stores the image of the drivers license.';
            DataClassification = CustomerContent;
        }

        field(4; RentalDate; Date)
        {
            Caption = 'Rental Date';
            ToolTip = 'Specifies the date when the rental agreement was created.';
            NotBlank = true;
            DataClassification = CustomerContent;
        }

        field(5; CarNo; Code[20])
        {
            Caption = 'Vehicle ID';
            ToolTip = 'Specifies the unique identifier of the rented vehicle.';
            NotBlank = true;
            DataClassification = SystemMetadata;
        }

        field(6; ReservedFrom; DateTime)
        {
            Caption = 'Reserved From';
            ToolTip = 'Specifies the start date and time of the vehicle reservation.';
            TableRelation = DAVEAuto."No.";
            NotBlank = true;
            DataClassification = CustomerContent;
        }

        field(7; ReservedUntil; DateTime)
        {
            Caption = 'Reserved Until';
            ToolTip = 'Specifies the end date and time of the vehicle reservation.';
            NotBlank = true;
            DataClassification = CustomerContent;
        }

        field(8; TotalAmount; Decimal)
        {
            Caption = 'Total Rental Amount';
            ToolTip = 'Specifies the total amount charged for the rental period.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(CustByDate; CustomerNo, ReservedFrom) { Clustered = false; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "CustomerNo", "CarNo", ReservedFrom) { }
        fieldgroup(Brick; "No.", "CustomerNo", "CarNo", "ReservedFrom", "ReservedUntil", TotalAmount) { }
    }
}
