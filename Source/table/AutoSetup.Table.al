table 65010 DAVEAutoSetup
{
    DataClassification = SystemMetadata;
    Caption = 'Auto Setup';

    fields
    {
        field(1; PrimaryKey; Code[20])
        {
            Caption = 'Primary Key';
            ToolTip = 'Single record table primary key.';
            AllowInCustomizations = Never;
        }
        field(10; AutomobileNoSeries; Code[20])
        {
            Caption = 'Automobile No. Series';
            ToolTip = 'Specifies the number series used for cars.';
            TableRelation = "No. Series".Code;
        }
        field(11; RentalOrderNoSeries; Code[20])
        {
            Caption = 'Rental Order No. Series';
            ToolTip = 'Specifies the number series used for rental orders.';
            TableRelation = "No. Series".Code;
        }
        field(12; AttachmentsLocation; Code[10])
        {
            Caption = 'Attachments Location';
            ToolTip = 'Specifies the location where attachments are stored.';
            TableRelation = Location.Code;
        }
    }

    keys
    {
        key(PK; "PrimaryKey")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; PrimaryKey, AutomobileNoSeries)
        {
        }

        fieldgroup(Brick; PrimaryKey, AutomobileNoSeries)
        {
        }
    }
}
