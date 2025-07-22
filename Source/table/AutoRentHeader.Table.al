table 65016 "DAVEAutoRentHeader"
{
    Caption = 'Vehicle Rental Header';
    LookupPageId = "DAVEAutoRentList";
    DrillDownPageId = "DAVEAutoRentList";
    DataClassification = CustomerContent;
    Permissions = tabledata DAVEAutoSetup=RI;


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

        }

        field(12; ReservedFrom; DateTime)
        {
            Caption = 'Reserved From';
            ToolTip = 'Specifies the start date and time of the reservation.';
        }

        field(13; ReservedUntil; DateTime)
        {
            Caption = 'Reserved Until';
            ToolTip = 'Specifies the end date and time of the reservation.';
        }

        field(14; TotalAmount; Decimal)
        {
            Caption = 'Total Rental Amount';
            ToolTip = 'Specifies the total amount calculated from rental lines.';
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
         if AutoSetup.IsEmpty() then begin
            AutoSetup.Init();
            AutoSetup.Insert(false);
        end;
        AutoSetup.Get();
        "No. Series" := AutoSetup.RentalCardSeries;
        "No." := NoSeries.GetNextNo("No. Series");
    end;
}
