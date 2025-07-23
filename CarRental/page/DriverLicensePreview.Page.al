page 65999 DAVEDriverLicensePreview
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
