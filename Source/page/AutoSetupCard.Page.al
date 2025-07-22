page 65010 DAVERentalSetupCard
{
    PageType = Card;
    SourceTable = DAVEAutoSetup;
    Caption = 'Auto Setup';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Setup Details';

                field(CarNoSeries; Rec.CarNoSeries)
                {

                }

                field(RentalCardSeries; Rec.RentalCardSeries)
                {

                }

                field(AttachmentsLocation; Rec.AttachmentsLocation)
                {

                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Rec.Get('AUTOSETUP') then begin
            Rec.Init();
            Rec.Insert(true);
        end;
    end;
}
