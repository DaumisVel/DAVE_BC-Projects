table 65017 "DAVEAutoRentLine"
{
    Caption = 'Vehicle Rental Line';
    DataClassification = CustomerContent;
    Permissions = tabledata Item=R,
                  tabledata Resource=R,
                  tabledata DAVEAutoRentLine=RD;


    fields
    {
        field(1; DocumentNo; Code[20])
        {
            Caption = 'Rental No.';
            ToolTip = 'Specifies the rental document number this line belongs to.';
            TableRelation = DAVEAutoRentHeader."No.";
            NotBlank = true;
            AllowInCustomizations = Never;
        }

        field(2; LineNo; Integer)
        {
            Caption = 'Line No.';
            ToolTip = 'Specifies the line number within the rental document.';
            Editable = false;
        }

        field(10; Type; Enum "DAVEAutoRentLineType")
        {
            Caption = 'Line Type';
            ToolTip = 'Specifies whether the line is for a resource or an item.';
            trigger OnValidate()
            begin
               // Clear any previous selection when type changes
                Validate("No.", '');
            end;

        }

        field(11; "No."; Code[20])
        {
            Caption = 'Item/Resource No.';
            ToolTip = 'Specifies the item or resource code depending on the line type.';
            TableRelation = if ("Type" = const(Item)) Item."No."
                            else if ("Type" = const(Resource)) Resource."No.";
            trigger OnValidate()
            var
                ItemRec: Record Item;
                ResRec: Record Resource;
            begin
                if "Type" = "Type"::Item then begin
                    if ItemRec.Get("No.") then begin
                        Description := ItemRec.Description;
                        UnitPrice := ItemRec."Unit Price";
                    end;
                end else
                    if ResRec.Get("No.") then begin
                        Description := ResRec.Name;
                        UnitPrice := ResRec."Unit Price";
                    end;
                CalcAmount();
            end;

        }

        field(12; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description from the selected item or resource.';
            Editable = false;
        }

        field(13; Quantity; Decimal)
        {
            Caption = 'Quantity';
            ToolTip = 'Specifies the quantity of the item or resource being rented.';
            trigger OnValidate()
            begin
                CalcAmount();
                Modify(false);
            end;
        }

        field(14; UnitPrice; Decimal)
        {
            Caption = 'Unit Price';
            ToolTip = 'Specifies the price per unit from the selected item or resource.';
            Editable = false;
            trigger OnValidate()
            begin
                CalcAmount();
            end;

        }

        field(15; Amount; Decimal)
        {
            Caption = 'Line Amount';
            ToolTip = 'Specifies the total amount calculated as (Quantity * Unit Price).';
            Editable = false;
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
    trigger OnInsert()
    begin
        SetNextLineNo();
        CalcAmount();
    end;
    trigger OnModify()
    var
        AutoRentHeader: Record DAVEAutoRentHeader;
        AutoRentCard: Page DAVEAutoRentCard;
        RentalStatus: Enum DAVERentalStatus;
    begin
        if Rec.LineNo = 10000 then
            Error('You cannot modify the first line.');

        AutoRentHeader.Get(DocumentNo);
        if AutoRentHeader.Status = RentalStatus::Issued then
            Error('Record cant be modified when status is Issued.');
        AutoRentHeader.CalcFields(TotalAmount);
        AutoRentCard.Update();
    end;
    trigger OnDelete()
    var
        AutoRentHeader: Record DAVEAutoRentHeader;
        RentalStatus: Enum DAVERentalStatus;
    begin
        if Rec.LineNo = 10000 then
            Error('Deleting the first line is not allowed.');

        AutoRentHeader.Get(DocumentNo);
        if AutoRentHeader.Status = RentalStatus::Issued then
            Error('You cannot delete an order with Issued status.');
    end;



    local procedure CalcAmount()
    begin
        Amount := Quantity * UnitPrice;
    end;

    local procedure SetNextLineNo()
    var
        LastLine: Record DAVEAutoRentLine;
    begin
        TestField(DocumentNo);
        LastLine.SetRange(DocumentNo, DocumentNo);
        if not LastLine.FindLast() then
            LineNo := 10000
        else
            LineNo := LastLine.LineNo + 10000;
    end;
    procedure CalcDailyQuantity(StartDate: Date; EndDate: Date): Integer
    begin
        if (StartDate = 0D) or (EndDate = 0D) then
            exit(0);

        if EndDate < StartDate then
            Error('ReservedUntil cannot be earlier than ReservedFrom.');

        exit((EndDate - StartDate) + 1);
    end;
}
