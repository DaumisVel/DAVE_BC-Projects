page 65999 DAVEDriverLicenseCard
{
    Caption = 'Driver License Card';
    PageType = CardPart;
    SourceTable = DAVEAutoRentHeader;
    layout
    {
        area(Content)
        {
            field(DriverLicenseImage; Rec."DriverLicenseImage")
            {
                Caption = 'Driver License Image';
                ApplicationArea = All;
            }
        }
    }
}
