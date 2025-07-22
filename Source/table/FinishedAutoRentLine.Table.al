table 65020 "DAVEFinishedAutoRentLine"
{
    Caption = 'Completed Rental Line';

fields
{
    field(1; DocumentNo; Code[20])
    {
        Caption = 'Rental No.';
        ToolTip = 'Specifies the number of the rental document this line belongs to.';
        AllowInCustomizations = Never;
        TableRelation = DAVEFinishedAutoRentHeader."No.";
        Editable = false;
        DataClassification = SystemMetadata;
    }

    field(2; LineNo; Integer)
    {
        Caption = 'Line No.';
        ToolTip = 'Specifies the sequential number of the line within the rental document.';
        Editable = false;
        DataClassification = SystemMetadata;
    }

    field(3; Type; Enum "DAVEAutoRentLineType")
    {
        Caption = 'Line Type';
        ToolTip = 'Specifies whether the line refers to an item or a resource.';
        Editable = false;
        DataClassification = SystemMetadata;
    }

    field(4; "No."; Code[20])
    {
        Caption = 'Item/Resource No.';
        ToolTip = 'Specifies the code of the item or resource being rented.';
        Editable = false;
        DataClassification = SystemMetadata;
    }

    field(5; Description; Text[100])
    {
        Caption = 'Description';
        ToolTip = 'Provides a description of the item or resource being rented.';
        Editable = false;
        DataClassification = SystemMetadata;
    }

    field(6; Quantity; Decimal)
    {
        Caption = 'Quantity';
        ToolTip = 'Specifies units rented.';
        Editable = false;
        DataClassification = CustomerContent;
    }

    field(7; UnitPrice; Decimal)
    {
        Caption = 'Unit Price';
        ToolTip = 'Specifies the price per unit of the item or resource.';
        Editable = false;
        DataClassification = SystemMetadata;
    }
    field(8; Amount; Decimal)
    {
        Caption = 'Line Amount';
        ToolTip = 'Specifies the total amount for this line, calculated as Quantity × Unit Price.';
        Editable = false;
        DataClassification = SystemMetadata;
    }
}

    keys
    {
        key(PK; "DocumentNo", "LineNo") { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "DocumentNo", "LineNo", "Type", "No.", "Amount") { }
        fieldgroup(Brick; "Type", "No.", "Description", "Quantity", "Amount") { }
    }
}
