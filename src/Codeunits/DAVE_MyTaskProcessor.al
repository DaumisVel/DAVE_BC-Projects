codeunit 65003 TaskProcessor
{
    Subtype = Normal;

    procedure ProcessTask(var TaskRec: Record Task)
    var
        Result: Text;
        MyProcedures: Codeunit MyProcedures;
    begin
        case TaskRec."Task Type" of
            TaskType::ReverseText:
                Result := MyProcedures.ReverseText(TaskRec."Input Text");


            //TaskRec."Task Type"::"Count Vowels":
            //     Result := Format(CountVowels(TaskRec."Input Text"));

            // Add more task types here if needed

            else
                Result := 'Unsupported task type.';
        end;

        TaskRec."Result Text" := Result;
        TaskRec.Modify();
    end;


}
