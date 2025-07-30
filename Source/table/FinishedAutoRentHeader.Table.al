table 65019 "DAVEFinishedAutoRentHeader"
{
    Caption = 'Finished Rental Header';
    LookupPageId = "DAVEFininshedAutoRentOrders";
    DrillDownPageId = "DAVEFinishedAutoRentOrder";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Rental No.';
            ToolTip = 'Specifies the unique number of the completed rental document.';
            NotBlank = true;
            DataClassification = SystemMetadata;
        }

        field(10; CustomerNo; Code[20])
        {
            Caption = 'Customer No.';
            ToolTip = 'Specifies the customer who rented the vehicle.';
            TableRelation = Customer."No.";
            NotBlank = true;
            DataClassification = CustomerContent;
        }

        field(12; RentalDate; Date)
        {
            Caption = 'Rental Date';
            ToolTip = 'Specifies the date when the rental agreement was created.';
            NotBlank = true;
            DataClassification = CustomerContent;
        }

        field(13; CarNo; Code[20])
        {
            Caption = 'Vehicle ID';
            ToolTip = 'Specifies the unique identifier of the rented vehicle.';
            NotBlank = true;
            DataClassification = SystemMetadata;
        }

        field(14; ReservedFrom; Date)
        {
            Caption = 'Reserved From';
            ToolTip = 'Specifies the start date and time of the vehicle reservation.';
            TableRelation = DAVEAuto."No.";
            NotBlank = true;
            DataClassification = CustomerContent;
        }

        field(15; ReservedUntil; Date)
        {
            Caption = 'Reserved Until';
            ToolTip = 'Specifies the end date and time of the vehicle reservation.';
            NotBlank = true;
            DataClassification = CustomerContent;
        }

        field(16; TotalAmount; Decimal)
        {
            Caption = 'Total Rental Amount';
            ToolTip = 'Specifies the total amount calculated from rental lines.';
            Editable = false;
            CalcFormula = sum(DAVEFinishedAutoRentLine.Amount where(DocumentNo = field("No.")));
            FieldClass = FlowField;
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
        key(CustByDate; CustomerNo, ReservedFrom) { Clustered = false; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "CustomerNo", "CarNo", ReservedFrom) { }
        fieldgroup(Brick; "No.", "CustomerNo", "CarNo", "ReservedFrom", "ReservedUntil", TotalAmount) { }
    }
}
