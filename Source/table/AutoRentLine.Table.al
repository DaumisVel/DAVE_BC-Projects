table 65017 "DAVEAutoRentLine"
{
    Caption = 'Vehicle Rental Line';
    DataClassification = CustomerContent;

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
            NotBlank = true;
        }

        field(3; Type; Enum "DAVEAutoRentLineType")
        {
            Caption = 'Line Type';
            ToolTip = 'Specifies whether the line is for a resource or an item.';
            trigger OnValidate()
            begin
               // Clear any previous selection when type changes
                Validate("No.", '');
            end;

        }

        field(4; "No."; Code[20])
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

        field(5; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description from the selected item or resource.';
            Editable = false;
        }

        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            ToolTip = 'Specifies the quantity of the item or resource being rented.';
                trigger OnValidate()
                begin
                    CalcAmount();
                end;
        }

        field(7; UnitPrice; Decimal)
        {
            Caption = 'Unit Price';
            ToolTip = 'Specifies the price per unit from the selected item or resource.';
            Editable = false;
            trigger OnValidate()
            begin
                CalcAmount();
            end;

        }

        field(8; Amount; Decimal)
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

    local procedure CalcAmount()
    begin
        Amount := Quantity * UnitPrice;
    end;

    local procedure SetNextLineNo()
    var
        LastLine: Record DAVEAutoRentLine;
    begin
        LastLine.SetRange(DocumentNo, DocumentNo);
        if not LastLine.FindLast() then
            LineNo := 10000
        else
            LineNo := LastLine.LineNo + 10000;
    end;
}
