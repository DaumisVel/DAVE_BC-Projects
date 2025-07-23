page 65012 "DAVEAutoModels"
{
    PageType = List;
    SourceTable = DAVEAutoModel;
    Caption = 'Auto Models';
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(MarkCode; Rec."MarkCode") {  }
                field("Code"; Rec."Code") {  }
                field(Description; Rec."Description") {  }
            }
        }
    }
}
