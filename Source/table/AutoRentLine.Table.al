table 65017 "DAVEAutoRentLine"
{
    Caption = 'Vehicle Rental Line';
    DataClassification = EndUserIdentifiableInformation;
    Permissions =
        tabledata DAVEAutoRentHeader = R,
        tabledata DAVEAutoRentLine = RD,
        tabledata Item = R,
        tabledata Resource = R,
        tabledata DAVEAuto = R;


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
            DataClassification = SystemMetadata;
            Editable = false;
        }

        field(10; Type; Enum "DAVEAutoRentLineType")
        {
            Caption = 'Type';
            ToolTip = 'Specifies whether the line is for a resource or an item.';
            DataClassification = SystemMetadata;
            trigger OnValidate()
            begin
                "No." := '';
                Description := '';
                UnitPrice := 0;
                CalcAmount();
            end;

        }

        field(11; "No."; Code[20])
        {
            Caption = 'Item/Resource No.';
            ToolTip = 'Specifies the item or resource code depending on the line type.';
            DataClassification = SystemMetadata;
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
            DataClassification = SystemMetadata;
            Editable = false;
        }

        field(13; Quantity; Decimal)
        {
            Caption = 'Quantity';
            ToolTip = 'Specifies the quantity of the item or resource being rented.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalcAmount();
            end;
        }

        field(14; UnitPrice; Decimal)
        {
            Caption = 'Unit Price';
            ToolTip = 'Specifies the price per unit from the selected item or resource.';
            DataClassification = CustomerContent;
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
            DataClassification = CustomerContent;
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
        if LineNo = 0 then
            SetNextLineNo();
        CalcAmount();
    end;

    trigger OnModify()
    var
        AutoRentHeader: Record DAVEAutoRentHeader;
        AutoRentCard: Page DAVEAutoRentOrder;
        FirstLineModErr: Label 'You cannot modify the first line.';
        InvalidModStatusErr: Label 'Record cant be modified when status is: %1', Comment = '%1 = Status';
        DocNoNotFoundErr: Label 'Rental header with DocumentNo %1 not found.', Comment = '%1 = DocumentNo';
        RentalStatus: Enum DAVERentalStatus;
    begin
        if Rec.LineNo = 10000 then
            Error(FirstLineModErr);

        if not AutoRentHeader.Get(DocumentNo) then
            Error(DocNoNotFoundErr, DocumentNo);
        if AutoRentHeader.Status = RentalStatus::Issued then
            Error(InvalidModStatusErr, AutoRentHeader.Status);

        AutoRentHeader.CalcFields(TotalAmount);
        AutoRentCard.Update();
    end;

    trigger OnDelete()
    var
        AutoRentHeader: Record DAVEAutoRentHeader;
        FirstLineDelErr: Label 'Deleting the first line is not allowed.';
        InvalidDelStatusErr: Label 'Record cant be deleted when status is: %1', Comment = '%1 = Status';
        DocNoNotFoundErr: Label 'Rental header with DocumentNo %1 not found.', Comment = '%1 = DocumentNo';
        RentalStatus: Enum DAVERentalStatus;
    begin
        if Rec.LineNo = 10000 then
            Error(FirstLineDelErr);

        if not AutoRentHeader.Get(DocumentNo) then
            Error(DocNoNotFoundErr, DocumentNo);
        if AutoRentHeader.Status = RentalStatus::Issued then
            Error(InvalidDelStatusErr);
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
}
