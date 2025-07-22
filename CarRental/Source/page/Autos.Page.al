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
                field(InsuranceValidUntil;Rec.InsuranceValidUntil) { }
                field(TechnicalInspectionValidUntil;Rec.TechnicalInspectionValidUntil) { }
                field(LocationCode;Rec.LocationCode) { }
                field(RentalResource;Rec.RentalResource) { }
                field(RentalPrice;Rec.RentalPrice) { }
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
                trigger OnAction()
                var
                    DAVEAutoCard: Page DAVEAutoCard;
                begin
                    DAVEAutoCard.SetRecord(Rec);
                    DAVEAutoCard.Run();
                end;
            }
        }

    }
}
