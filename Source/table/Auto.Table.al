table 65013 DAVEAuto
{
    Caption = 'Auto';
    DataClassification = EndUserIdentifiableInformation;
    LookupPageId = DAVEAutoCard;
    DrillDownPageId = DAVEAutos;
    Permissions = tabledata DAVEAutoSetup = R;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Auto No.';
            ToolTip = 'Specifies the auto number.';
        }
        field(10; Name; Text[100])
        {
            Caption = 'Auto Name';
            ToolTip = 'Specifies the name of the auto.';
            NotBlank = true;
        }
        field(11; MarkCode; Code[20])
        {
            Caption = 'Mark Code';
            ToolTip = 'Specifies the auto mark.';
            TableRelation = DAVEAutoMark.Code;
            NotBlank = true;
        }
        field(12; ModelCode; Code[20])
        {
            Caption = 'Model Code';
            ToolTip = 'Specifies the auto model.';
            TableRelation = DAVEAutoModel.Code where(MarkCode = field(MarkCode));
            NotBlank = true;
        }
        field(13; ManufactureYear; Integer)
        {
            Caption = 'Year of Manufacture';
            ToolTip = 'Specifies the year the auto was manufactured.';
        }
        field(14; InsuranceValidUntil; Date)
        {
            Caption = 'Civil Insurance Expiry Date';
            ToolTip = 'Specifies the expiration date of civil insurance.';
        }
        field(15; TechnicalInspectionValidUntil; Date)
        {
            Caption = 'Technical Inspection Expiry Date';
            ToolTip = 'Specifies the expiration date of technical inspection.';
        }
        field(16; LocationCode; Code[20])
        {
            Caption = 'Storage Location';
            ToolTip = 'Specifies the location of the auto.';
            TableRelation = Location.Code;
            DataClassification = SystemMetadata;
        }
        field(17; RentalResource; Code[20])
        {
            Caption = 'Rental Service Resoruce';
            ToolTip = 'Specifies the rental service resource.';
            TableRelation = Resource."No." where ("Base Unit of Measure" = const('DAY'));
        }
        field(18; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            AllowInCustomizations = Never;
        }
        field(50; RentalPrice; Decimal)
        {
            Caption = 'Rental Price per Day';
            ToolTip = 'Specifies the daily rental price of the vehicle.';
            CalcFormula = lookup(Resource."Unit Price" where("No." = field("RentalResource")));
            FieldClass = FlowField;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name) { }
        fieldgroup(Brick; "No.", Name, MarkCode, ModelCode, ManufactureYear) { }
    }

    trigger OnInsert()
    var
        AutoSetup: Record DAVEAutoSetup;
        NoSeries: Codeunit "No. Series";
        RentalManagement: Codeunit DAVERentalManagement;
    begin
        RentalManagement.EnsureSetup();
        AutoSetup.Get();
        "No. Series" := AutoSetup.AutomobileNoSeries;
        "No." := NoSeries.GetNextNo("No. Series");
    end;
}
