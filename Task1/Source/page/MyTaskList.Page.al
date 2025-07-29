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
                    ToolTip = 'Specifies the unique identifier of the task.';
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the user assigned to the task.';
                }
                field("Task Type"; Rec."Task Type")
                {
                    ToolTip = 'Specifies the type of the task.';
                }
                field("Input Text"; Rec."Input Text")
                {
                    ToolTip = 'Specifies the input text for the task.';
                }
                field("Result Text"; Rec."Result Text")
                {
                    ToolTip = 'Specifies the result text of the task.';
                }
            }
        }
    }
}
