page 65001 "My Task List"
{
    PageType = List;
    SourceTable = Task;
    CardPageId = "My Task Card";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID"; Rec.ID) { ApplicationArea = All; } // "ID" field does not exist in the source table
                field("Name"; Rec."User ID") { ApplicationArea = All; }
                field("Task Type"; Rec."Task Type") { ApplicationArea = All; }
                field("Input Text"; Rec."Input Text") { ApplicationArea = All; }
                field("Result Text"; Rec."Result Text") { ApplicationArea = All; }
            }
        }
    }
}
