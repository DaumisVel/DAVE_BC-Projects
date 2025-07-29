page 65010 DAVERentalSetup
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

                field(AutomobileNoSeries; Rec.AutomobileNoSeries)
                {

                }
                field(RentalOrderNoSeries; Rec.RentalOrderNoSeries)
                {

                }
                field(AttachmentsLocation; Rec.AttachmentsLocation)
                {

                }
            }
        }
    }
}
