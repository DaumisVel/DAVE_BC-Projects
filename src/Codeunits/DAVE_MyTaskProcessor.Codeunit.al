codeunit 65003 TaskProcessor
{
    Subtype = Normal;

    procedure ProcessTask(var TaskRec: Record Task)
    var
        Result: Text;
        MyProcedures: Codeunit MyProcedures;
    begin
        if TaskRec."Task Type" in [TaskRec."Task Type"::ReverseText, TaskRec."Task Type"::CountVowelsConsonants] then
            TaskRec.TestField("Input Text");
        case TaskRec."Task Type" of
            TaskType::ReverseText:
                Result := MyProcedures.ReverseText(TaskRec."Input Text");
            TaskType::FindMinMax:
                Result := MyProcedures.FindMinMax();
            TaskType::FindDuplicates:
                Result := MyProcedures.FindDuplicates();
            TaskType::CountVowelsConsonants:
                Result := MyProcedures.CountVowelsAndConsonants(TaskRec."Input Text");

            else
                Result := 'Unsupported task type.';
        end;

        TaskRec."Result Text" := Result;
        TaskRec.Modify();
    end;


}
