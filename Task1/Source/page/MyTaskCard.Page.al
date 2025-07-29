page 65002 "DAVEMy Task Card"
{
    PageType = Card;
    SourceTable = DAVETask;
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'My Task Card';

    // Review: Užduotyse, kuriose sugeneruojamas skaičių masyvas, niekur nematome input į skaičiavimą.
    //         Būtų buvę logišką jį atvaizduoti "Input Text" lauke, kad matytume ar teisingas rezultatas.
    layout
    {
        area(Content)
        {
            group("Task Details")
            {
                ShowCaption = false;
                // or
                // Caption = 'Task Details';
                field("Task Type"; Rec."Task Type")
                {
                    Editable = (Rec."Result Text" = '');
                    trigger OnValidate()
                    begin
                        // Review: Logika teisinga, bet ji turėtų būti lentelėje lauko OnValidate() trigeryje
                        if Rec."Task Type" in [Rec."Task Type"::FindMinMax, Rec."Task Type"::FindDuplicates] then
                            Rec."Input Text" := '';
                    end;
                }
                field("Input Text"; Rec."Input Text")
                {
                    MultiLine = true;
                    Editable = (Rec."Result Text" = '') and
                               (Rec."Task Type" <> Rec."Task Type"::FindMinMax) and
                               (Rec."Task Type" <> Rec."Task Type"::FindDuplicates);

                }
                field("Result Text"; Rec."Result Text")
                {
                    MultiLine = true;
                    Editable = false; // Review: šitas gali būti aprašytas lentelės lygmenyje. Vartotojas jo niekada neredaguos
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
                Caption = 'Process Task';
                Image = Process;
                ToolTip = 'Processes the current task and displays the result.';

                Enabled = (Rec."Result Text" = '');

                trigger OnAction()
                var
                    TaskProcessor: Codeunit DAVETaskProcessor;
                begin
                    Message('Processing Task %1 of type %2', Rec."ID", Rec."Task Type"); // Review: šitas message užknisa :) manau jo galėtų nebūti
                    TaskProcessor.ProcessTask(Rec);
                end;
            }
        }
    }
}
