page 65002 "My Task Card"
{
    PageType = Card;
    SourceTable = Task;
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group("Task Details")
            {
                field("Task Type"; Rec."Task Type")
                {
                    ApplicationArea = All;
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
                    Editable = (Rec."Result Text" = '') and
                               (Rec."Task Type" <> Rec."Task Type"::FindMinMax) and
                               (Rec."Task Type" <> Rec."Task Type"::FindDuplicates);

                }
                field("Result Text"; Rec."Result Text") { ApplicationArea = All; Editable = false; }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Process Task")
            {
                ApplicationArea = All;
                Caption = 'Process Task';
                Image = Process;

                Enabled = (Rec."Result Text" = '');

                trigger OnAction()
                var
                    TaskProcessor: Codeunit TaskProcessor;
                begin
                    Message('Processing Task %1 of type %2', Rec."ID", Rec."Task Type");
                    TaskProcessor.ProcessTask(Rec);
                end;
            }
        }
    }
}
