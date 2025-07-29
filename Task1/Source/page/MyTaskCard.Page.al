page 65002 "DAVEMy Task Card"
{
    PageType = Card;
    SourceTable = DAVETask;
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'My Task Card';

    layout
    {
        area(Content)
        {
            group("Task Details")
            {
                field("Task Type"; Rec."Task Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the task.';
                    Editable = (Rec."Result Text" = '');
                    trigger OnValidate()
                    begin
                        if Rec."Task Type" in [Rec."Task Type"::FindMinMax, Rec."Task Type"::FindDuplicates] then
                            Rec."Input Text" := '';
                    end;
                }
                field("Input Text"; Rec."Input Text")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the input text for the task.';
                    Editable = (Rec."Result Text" = '') and
                               (Rec."Task Type" <> Rec."Task Type"::FindMinMax) and
                               (Rec."Task Type" <> Rec."Task Type"::FindDuplicates);

                }
                field("Result Text"; Rec."Result Text")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Displays the result of the processed task.';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Process Task")
            {
                ApplicationArea = All;
                Caption = 'Process Task';
                Image = Process;
                ToolTip = 'Processes the current task and displays the result.';

                Enabled = (Rec."Result Text" = '');

                trigger OnAction()
                var
                    TaskProcessor: Codeunit DAVETaskProcessor;
                begin
                    Message('Processing Task %1 of type %2', Rec."ID", Rec."Task Type");
                    TaskProcessor.ProcessTask(Rec);
                end;
            }
        }
    }
}
