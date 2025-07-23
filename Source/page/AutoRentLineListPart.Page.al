page 65020 "DAVEAutoRentLineListPart"
{
    PageType = ListPart;
    SourceTable = DAVEAutoRentLine;
    Caption = 'Rental Lines';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(LineNo; Rec."LineNo")
                {
                    Caption = 'Line No.';
                }
                field(Type; Rec."Type")
                {
                    Caption = 'Line Type';
                }
                field("No."; Rec."No.")
                {
                    Caption = 'Item/Resource No.';
                }
                field(Description; Rec."Description")
                {
                    Caption = 'Description';
                }
                field(Quantity; Rec."Quantity")
                {
                    Caption = 'Quantity';
                }
                field(UnitPrice; Rec."UnitPrice")
                {
                    Caption = 'Unit Price';
                }
                field(Amount; Rec."Amount")
                {
                    Caption = 'Line Amount';
                    trigger OnValidate()
                    var
                        AutoRentCard: Page DAVEAutoRentCard;
                    begin
                        AutoRentCard.UpdateHeader();
                    end;
                }
            }
        }
    }
}
