page 65013 "DAVEAutos"
{
    PageType = List;
    SourceTable = DAVEAuto;
    Caption = 'Autos';
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Autos)
            {
                field("No."; Rec."No.") { }
                field(Name; Rec."Name") { }
                field(MarkCode; Rec."MarkCode") { }
                field(ModelCode; Rec."ModelCode") { }
                field(ManufactureYear; Rec."ManufactureYear") { }
            }
            part(Reservations; "DAVEAutoReservations")
            {
                ApplicationArea = all;
                SubPageLink = CarNo = field("No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(OpenCard)
            {
                ToolTip = 'Open the auto card.';
                Caption = 'Card';
                Image = Card;
                RunObject = page "DAVEAutoCard";
            }
        }

    }
}
