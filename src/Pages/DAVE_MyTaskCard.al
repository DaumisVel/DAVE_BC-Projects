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
                field("ID"; Rec."ID") { ApplicationArea = All; Editable = false; }
                field("Name"; Rec."User ID") { ApplicationArea = All; Editable = false; }
                field("Task Type"; Rec."Task Type") { ApplicationArea = All; Editable = (Rec."Result Text" = ''); }
                field("Input Text"; Rec."Input Text") { ApplicationArea = All; Editable = (Rec."Result Text" = ''); }
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
                    //CurrPage.Update(); // This refreshes the page to show the new result
                    // Call your logic here: e.g. TaskProcessor.ProcessTask(Rec);
                end;
            }
        }
    }
}
