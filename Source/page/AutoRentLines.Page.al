page 65020 "DAVEAutoRentLines"
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

                }
                field(Type; Rec."Type")
                {

                }
                field("No."; Rec."No.")
                {

                }
                field(Description; Rec."Description")
                {

                }
                field(Quantity; Rec."Quantity")
                {

                }
                field(UnitPrice; Rec."UnitPrice")
                {

                }
                field(Amount; Rec."Amount")
                {
                   
                }
            }
        }
    }
}
