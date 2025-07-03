codeunit 65003 DAVETaskProcessor
{
    Subtype = Normal;

    procedure ProcessTask(var TaskRec: Record DAVETask)
    var
        MyProcedures: Codeunit DAVEMyProcedures;
        Result: Text;
    begin
        if TaskRec."Task Type" in [TaskRec."Task Type"::ReverseText, TaskRec."Task Type"::CountVowelsConsonants] then
            TaskRec.TestField("Input Text");
        case TaskRec."Task Type" of
            DAVETaskType::ReverseText:
                Result := MyProcedures.ReverseText(TaskRec."Input Text");
            DAVETaskType::FindMinMax:
                Result := MyProcedures.FindMinMax();
            DAVETaskType::FindDuplicates:
                Result := MyProcedures.FindDuplicates();
            DAVETaskType::CountVowelsConsonants:
                Result := MyProcedures.CountVowelsAndConsonants(TaskRec."Input Text");

            else
                Result := 'Unsupported task type.';
        end;

        TaskRec."Result Text" := CopyStr(Result, 1, 250);
        TaskRec.Modify();
    end;


}
