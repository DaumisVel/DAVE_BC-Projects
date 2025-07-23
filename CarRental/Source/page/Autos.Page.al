page 65013 "DAVEAutos"
{
    PageType = List;
    SourceTable = DAVEAuto;
    Caption = 'Autos';
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = DAVEAutoCard;

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
        area(Navigation)
        {
            action(OpenReservations)
            {
                Caption = 'Open Reservations';
                ToolTip = 'Opens All Reservations.';
                Image = ItemReservation;
                trigger OnAction()
                begin
                    Page.RunModal(Page::DAVEAutoReservations);
                end;
            }
            action(OpenValidReservations)
            {
                Caption = 'Open Valid Reservations';
                ToolTip = 'Opens Currently Valid Reservations.';
                Image = ItemReservation;
                trigger OnAction()
                begin
                    Page.RunModal(Page::DAVEValidReservations);
                end;
            }
        }
    }
}
