table 65013 "DAVEAuto"
{
    Caption = 'Auto';
    DataClassification = CustomerContent;
    LookupPageId = DAVEAutoCard;
    DrillDownPageId = DAVEAutos;
    Permissions = tabledata DAVEAutoSetup=R;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Vehicle ID';
            ToolTip = 'Specifies the auto number.';
        }
        field(10; Name; Text[100])
        {
            Caption = 'Vehicle Name';
            ToolTip = 'Specifies the name of the auto.';
        }
        field(11; MarkCode; Code[20])
        {
            Caption = 'Manufacturer';
            ToolTip = 'Specifies the auto mark.';
            TableRelation = "DAVEAutoMark"."Code";
        }
        field(12; ModelCode; Code[20])
        {
            Caption = 'Model';
            ToolTip = 'Specifies the auto model.';
            TableRelation = "DAVEAutoModel"."Code" where("MarkCode" = field("MarkCode"));
        }
        field(13; ManufactureYear; Integer)
        {
            Caption = 'Year of Manufacture';
            ToolTip = 'Specifies the year the auto was manufactured.';
        }
        field(14; InsuranceValidUntil; Date)
        {
            Caption = 'Insurance Expiry Date';
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
        }
        field(17; RentalResource; Code[20])
        {
            Caption = 'Rental Service Resoruce';
            ToolTip = 'Specifies the rental service resource.';
            TableRelation = Resource;
        }
        field (18; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            AllowInCustomizations = Never;
        }
        field(50; RentalPrice; Decimal)
        {
            Caption = 'Calculated Rental Price';
            ToolTip = 'Specifies the * rental price of the vehicle, retrieved from the linked rental service.';
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
        fieldgroup(DropDown; "No.", "Name") { }
        fieldgroup(Brick; "No.", "Name", "MarkCode", "ModelCode", "ManufactureYear") { }
    }

    trigger OnInsert()
    var
        AutoSetup: Record DAVEAutoSetup;
        NoSeries: Codeunit "No. Series";
    begin
        if AutoSetup.IsEmpty() then
            AutoSetup.CreateAutoSetup();
        AutoSetup.Get();
        "No. Series" := AutoSetup.CarNoSeries;
        "No." := NoSeries.GetNextNo("No. Series");
    end;


}
