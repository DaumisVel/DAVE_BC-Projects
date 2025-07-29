page 65012 DAVEAutoModels
{
    PageType = List;
    SourceTable = DAVEAutoModel;
    SourceTableView = sorting(MarkCode, Code);
    Caption = 'Auto Models';
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(AutoModels)
            {
                field(MarkCode; Rec.MarkCode) { }
                field("Code"; Rec.Code) { }
                field(Description; Rec.Description) { }
            }
        }
    }
}
