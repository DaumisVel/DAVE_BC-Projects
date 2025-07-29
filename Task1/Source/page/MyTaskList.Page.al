page 65001 "DAVEMy Task List"
{
    PageType = List;
    SourceTable = DAVETask;
    CardPageId = "DAVEMy Task Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'My Tasks';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(ID; Rec."ID")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Task Type"; Rec."Task Type")
                {
                }
                field("Input Text"; Rec."Input Text")
                {
                }
                field("Result Text"; Rec."Result Text")
                {
                    ToolTip = 'Specifies the result text of the task.'; // Review: puslapyje galime nurodyti kitokį ToolTip
                }
            }
        }
    }
}
