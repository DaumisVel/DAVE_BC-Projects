page 65014 "DAVEAutoCard"
{
    PageType = Card;
    SourceTable = DAVEAuto;
    Caption = 'Auto Card';
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(CarInformation)
            {
                Caption = 'Vehicle Information';
                field("No."; Rec."No.") { }
                field(Name; Rec."Name") { }
                field(MarkCode; Rec."MarkCode") { }
                field(ModelCode; Rec."ModelCode") { }
                field(ManufactureYear; Rec."ManufactureYear") { }
            }
            group(RentalDetails)
            {
                Caption = 'Rental & Compliance Details';
                field(InsuranceValidUntil; Rec."InsuranceValidUntil") { }
                field(TechnicalInspectionValidUntil; Rec."TechnicalInspectionValidUntil") { }
                field(LocationCode; Rec."LocationCode") { }
                field(RentalResource; Rec."RentalResource") { }
                field(RentalPrice; Rec."RentalPrice")
                {
                    Editable = false;
                }
            }
            part(Reservations; "DAVEAutoReservations")
            {
                SubPageLink = CarNo = field("No.");
            }
        }
    }
}
