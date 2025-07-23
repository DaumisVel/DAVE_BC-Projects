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
                field(DriverLicenseImage; Rec."DriverLicenseImage")
                {
                    Caption = 'Driver License';
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
    }
    actions
    {
        area(Processing)
        {
            /*action(ChangeStatus)
            {
                Caption = 'Change Status';
                ToolTip = 'Change Current Status.';
                Image = Card;
                trigger OnAction()
                begin

                end;

            }*/
        }
    }
    /*local procedure CreateFirstLine()
    var
        AutoRentLine: Record DAVEAutoRentLine;
        Resource: Record Resource;
        Auto: Record DAVEAuto;
        AutoRentLineListPart: Page DAVEAutoRentLineListPart;
        AutoRentLineType: Enum DAVEAutoRentLineType;
    begin
        //AutoRentLine.ClearMarks();
        AutoRentLine.Reset();
        AutoRentLine.Init();
        AutoRentLine.DocumentNo := Rec."No.";
        AutoRentLine.LineNo := 10000;
        AutoRentLine.Type := AutoRentLineType::Resource;
        Auto.Get(Rec.CarNo);
        AutoRentLine."No." := Auto.RentalResource;
        Resource.Get(Auto.RentalResource);
        AutoRentLine.Description := Resource.Name;
        AutoRentLine.Insert(true);
        AutoRentLineListPart.Update();
    end;*/
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
        //AutoRentLineListPart.Update();
    end;
}
