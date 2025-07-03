page 65001 "DAVEMy Task List"
{
    PageType = List;
    SourceTable = DAVETask;
    CardPageId = "DAVEMy Task Card";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ID; Rec."ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier of the task.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user assigned to the task.';
                }
                field("Task Type"; Rec."Task Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the task.';
                }
                field("Input Text"; Rec."Input Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the input text for the task.';
                }
                field("Result Text"; Rec."Result Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the result text of the task.';
                }
            }
        }
    }
}
