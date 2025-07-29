page 65011 DAVEAutoMarks
{
    PageType = List;
    SourceTable = DAVEAutoMark;
    SourceTableView = sorting(Code);
    Caption = 'Auto Marks';
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(AutoMarks)
            {
                field("Code"; Rec.Code) { }
                field(Description; Rec.Description) { }
            }
        }
    }
}
