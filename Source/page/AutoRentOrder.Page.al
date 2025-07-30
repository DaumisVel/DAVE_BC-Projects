page 65019 "DAVEAutoRentOrder"
{
    PageType = Card;
    SourceTable = DAVEAutoRentHeader;
    Caption = 'Auto Rental Order';
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(GeneralInfo)
            {
                Caption = 'Rental General Info';
                field("No."; Rec."No.")
                {

                }
                field(CustomerNo; Rec."CustomerNo")
                {
                    LookupPageId = "Customer List";
                }
                field(DriverLicenseImage; Rec.DriverLicenseImage)
                {

                }
                field(RentalDate; Rec."RentalDate")
                {

                }
                field(CarNo; Rec."CarNo")
                {
                    LookupPageId = DAVEAutos;
                    trigger OnValidate()
                    var
                        RentalManagement: Codeunit DAVERentalManagement;
                    begin
                        if Rec.CarNo <> '' then
                            RentalManagement.CreateOrAdjustFirstLine(Rec);
                    end;
                }
                field(ReservedFrom; Rec."ReservedFrom")
                {

                }
                field(ReservedUntil; Rec."ReservedUntil")
                {

                }
                field(TotalAmount; Rec."TotalAmount")
                {

                }
                field(Status; Rec."Status")
                {
                    Editable = false;
                }
            }
            part(RentalLines; "DAVEAutoRentLines")
            {
                SubPageLink = "DocumentNo" = field("No.");
                Caption = 'Rental Lines';
            }
        }
        area(FactBoxes)
        {
            part(DriverLicensePreview; "DAVEDriverLicenseCard")
            {
                Caption = 'Driver License';
                SubPageLink = "No." = field("No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ChangeStatus)
            {
                Caption = 'Change Status';
                ToolTip = 'Change Current Status.';
                Image = ChangeStatus;
                trigger OnAction()
                var
                    RentalStatus: Enum DAVERentalStatus;
                begin
                    Rec.TestField(CustomerNo);
                    Rec.TestField(CarNo);
                    Rec.TestField(ReservedFrom);
                    Rec.TestField(ReservedUntil);
                    Rec.TestField(RentalDate);
                    Rec.TestField(DriverLicenseImage);

                    case Rec.Status of
                        RentalStatus::Open:
                            Rec.Status := RentalStatus::Issued;

                        RentalStatus::Issued:
                            Rec.Status := RentalStatus::Open;
                    end;
                    Rec.Modify(false);
                end;

            }
            action(ReturnCar)
            {
                Caption = 'Return Car';
                Image = Return;
                ToolTip = 'Returns the car and posts rental document.';

                trigger OnAction()
                var
                    RentalPostingService: Codeunit DAVERentalPostingService;
                begin
                    RentalPostingService.PostRentalDocument(Rec);
                    Message('Car has been successfully returned.');
                end;
            }
            action(ImportLicense)
            {
                ApplicationArea = all;
                Caption = 'Import License';
                ToolTip = 'Import Driver License.';
                Image = Import;

                trigger OnAction()
                var
                    FromFileName: Text;
                    InStreamPic: InStream;
                begin
                    Rec.TestField(Status, DAVERentalStatus::Open);
                    if UploadIntoStream('Import', '', 'All Files (*.*)|*.*', FromFileName, InStreamPic) then
                        Rec.DriverLicenseImage.ImportStream(InStreamPic, FromFileName);
                    Rec.Modify(true);
                end;
            }
            action(DeleteLicenseImage)
            {
                Caption = 'Delete License Image';
                ToolTip = 'Deletes Currently Uploaded Drivers License.';
                Image = Delete;
                trigger OnAction()
                begin
                    Rec.TestField(Status, DAVERentalStatus::Open);
                    Clear(Rec."DriverLicenseImage");
                    Rec.Modify(true);
                    CurrPage.Update(true);
                end;
            }
            action(LogDamage)
            {
                Caption = 'Open Damage Log';
                ToolTip = 'Opens Damage Log for this.';
                Image = DocumentEdit;
                trigger OnAction()
                var
                    AutoRentDamage: Record DAVEAutoRentDamage;
                begin
                    Rec.TestField(Status, DAVERentalStatus::Issued);
                    AutoRentDamage.Reset();
                    AutoRentDamage.SetRange(DocumentNo, Rec."No.");
                    PAGE.Run(PAGE::"DAVEAutoRentDamageEntries", AutoRentDamage);
                end;
            }
        }
        area(Reporting)
        {
            action(PrintRentIssuanceDocument)
            {
                Caption = 'Print Rent Issuance Document';
                Image = Report;
                ToolTip = 'Runs report to print Rent Document.';
                trigger OnAction()
                var
                    AutoRentHeader: Record DAVEAutoRentHeader;
                    NoNotExistErr: Label 'Rental order with No. %1 does not exist.', Comment = '%1 = Rental order number';
                    RentalStatus: Enum DAVERentalStatus;
                begin
                    AutoRentHeader.SetRange("No.", Rec."No.");
                    if not AutoRentHeader.Get(Rec."No.") then
                        Error(NoNotExistErr, Rec."No.");
                    AutoRentHeader.TestField(Status, RentalStatus::Issued);
                    Report.Run(Report::DAVEAutoRentIssuanceCard, true, false, AutoRentHeader);
                end;
            }
        }
    }
}
