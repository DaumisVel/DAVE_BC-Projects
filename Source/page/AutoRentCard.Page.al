page 65019 "DAVEAutoRentCard"
{
    PageType = Card;
    SourceTable = DAVEAutoRentHeader;
    Caption = 'Auto Rent Card';
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
                    Caption = 'Rental No.';
                }
                field(CustomerNo; Rec."CustomerNo")
                {
                    Caption = 'Customer No.';
                    LookupPageId = "Customer List";
                }
                field(DriverLicenseImage; Rec.DriverLicenseImage)
                {
                    Caption = 'Driver License Image';
                }
                field(RentalDate; Rec."RentalDate")
                {
                    Caption = 'Rental Date';
                }
                field(CarNo; Rec."CarNo")
                {
                    Caption = 'Vehicle ID';
                    LookupPageId = DAVEAutos;
                    trigger OnValidate()
                    begin
                        if Rec.CarNo <> '' then
                            AdjustFirstLine();
                    end;
                }
                field(ReservedFrom; Rec."ReservedFrom")
                {
                    Caption = 'Reserved From';
                }
                field(ReservedUntil; Rec."ReservedUntil")
                {
                    Caption = 'Reserved Until';
                }
                field(TotalAmount; Rec."TotalAmount")
                {
                    Caption = 'Total Rental Amount';
                }
                field(Status; Rec."Status")
                {
                    Caption = 'Rental Status';
                    Editable = false;
                }
            }
            part(RentalLines; "DAVEAutoRentLineListPart")
            {
                SubPageLink = "DocumentNo" = field("No.");
                Caption = 'Rental Lines';
            }
        }
        area(FactBoxes)
        {
            part(DriverLicensePreview; "DAVEDriverLicensePreview")
            {
                Caption = 'Uploaded Driver License';
                ApplicationArea = All;
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
                Image = Card;
                trigger OnAction()
                var
                    RentalStatus: Enum DAVERentalStatus;
                begin
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
                ToolTip = 'Mark the car as returned and update rental status.';

                trigger OnAction()
                begin
                    Rec.TestField(Status,DAVERentalStatus::Issued);
                    Rec.TestField(CarNo);
                    Rec.TestField(RentalDate);
                    Rec.TestField(ReservedFrom);
                    Rec.TestField(ReservedUntil);
                    //Rec.TestField(DriverLicenseImage);

                    GenerateRentalCompletion();

                    Message('Car has been successfully returned.');
                end;
            }
            action(ImportLicense)
            {
                ApplicationArea = all;
                Caption = 'Import License';
                Image = Import;

                trigger OnAction()
                var
                    FromFileName: Text;
                    InStreamPic: InStream;
                begin
                    if UploadIntoStream('Import','','All Files (*.*)|*.*', FromFileName, InStreamPic) then
                        Rec.DriverLicenseImage.ImportStream(InStreamPic, FromFileName);
                        Rec.Modify(true);
                end;
            }
            action(DeleteLicenseImage)
            {
                Caption = 'Delete License Image';
                ToolTip = 'Deletes Currently Uploaded Drivers License';
                Image = Delete;
                trigger OnAction()
                begin
                    Clear(Rec."DriverLicenseImage");
                    Rec.Modify(true);
                    CurrPage.Update(true);
                end;
            }
            action(LogDamage)
            {
                Caption = 'Open Damage Document';
                Image = DocumentEdit;
                trigger OnAction()
                begin
                    PAGE.Run(PAGE::"DAVEAutoRentDamageList");
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin

    end;
    procedure UpdateHeader()
    begin
        CurrPage.Update(true);
    end;

    local procedure AdjustFirstLine()
    var
        AutoRentLine: Record DAVEAutoRentLine;
        Resource: Record Resource;
        Auto: Record DAVEAuto;
        AutoRentLineType: Enum DAVEAutoRentLineType;
    begin
        // Try to get existing first line
        if AutoRentLine.Get(Rec."No.", 10000) then begin
            Auto.Get(Rec.CarNo);
            AutoRentLine.Type := AutoRentLineType::Resource;
            AutoRentLine."No." := Auto.RentalResource;
            Resource.Get(Auto.RentalResource);
            AutoRentLine.Description := Resource.Name;
            AutoRentLine.UnitPrice := Resource."Unit Price";
            AutoRentLine.Modify(false); // Update instead of insert
        end else begin
            // Line doesn't exist — create it
            AutoRentLine.Init();
            AutoRentLine.DocumentNo := Rec."No.";
            AutoRentLine.LineNo := 10000;
            AutoRentLine.Type := AutoRentLineType::Resource;
            Auto.Get(Rec.CarNo);
            AutoRentLine."No." := Auto.RentalResource;
            Resource.Get(Auto.RentalResource);
            AutoRentLine.Description := Resource.Name;
            AutoRentLine.UnitPrice := Resource."Unit Price";
            AutoRentLine.Insert(true);
        end;
        // Refresh list part if needed
        Rec.CalcFields(TotalAmount);
        CurrPage.Update(true);
        //AutoRentLineListPart.Update();
    end;
    local procedure GenerateRentalCompletion()
    var
        FinishedAutoRentHeader: Record DAVEFinishedAutoRentHeader;
        FinishedAutoRentLine: Record DAVEFinishedAutoRentLine;
        AutoRentLine: Record DAVEAutoRentLine;
    begin
        FinishedAutoRentHeader.Init();
        FinishedAutoRentHeader.TransferFields(Rec);
        FinishedAutoRentHeader."No." := Rec."No.";
        FinishedAutoRentHeader.Insert(true);

        AutoRentLine.SetRange(DocumentNo, Rec."No.");
            if AutoRentLine.FindSet() then
                repeat
                    FinishedAutoRentLine.Init();
                    FinishedAutoRentLine.TransferFields(AutoRentLine,false);
                    FinishedAutoRentLine.DocumentNo := AutoRentLine.DocumentNo;
                    FinishedAutoRentLine.LineNo := AutoRentLine.LineNo;
                    FinishedAutoRentLine.Insert(true);
                until AutoRentLine.Next() = 0;
        AutoRentLine.DeleteAll(false);
        Rec.Delete(false);

        Message('Rental document %1 completed and original data deleted.', FinishedAutoRentHeader."No.");
    end;


}
