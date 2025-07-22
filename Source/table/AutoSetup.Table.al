table 65010 DAVEAutoSetup
{
    DataClassification = ToBeClassified;
    Caption = 'Auto Setup';

    fields
    {
        field(1; PrimaryKey; Code[20])
        {
            Caption = 'Setup Key';
            ToolTip = 'Internal key to identify the setup record.';
            AllowInCustomizations = Never;
        }
        field(10; CarNoSeries; Code[20])
        {
            Caption = 'Car No. Series';
            ToolTip = 'Specifies the number series used for cars.';
            TableRelation = "No. Series".Code;
        }
        field(11; RentalCardSeries; Code[20])
        {
            Caption = 'Rental Card No. Series';
            ToolTip = 'Specifies the number series used for rental cards.';
            TableRelation = "No. Series".Code;
        }
        field(12; AttachmentsLocation; Text[30])
        {
            Caption = 'Attachments Location';
            ToolTip = 'Specifies the location where attachments are stored.';
            TableRelation = Location;
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
        fieldgroup(DropDown; PrimaryKey, CarNoSeries)
        {
        }

        fieldgroup(Brick; PrimaryKey, CarNoSeries)
        {
        }
    }
}
