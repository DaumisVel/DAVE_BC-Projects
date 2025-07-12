codeunit 65005 DAVEPCUtils
{
    SingleInstance = true;

    procedure IsDigit(Char: Char): Boolean
    begin
        exit(Char in ['0' .. '9']);
    end;

    [TryFunction]
    procedure TryBuildDate(DayInt: Integer; MonthInt: Integer; YearInt: Integer; var TestDate: Date)
    begin
        TestDate := DMY2Date(DayInt, MonthInt, YearInt);
    end;

    procedure GetNextLineNo(EntryNo: Integer): Integer
    var
        Line: Record DAVEPCValidationLines;
    begin
        Line.SetRange("Entry No.", EntryNo);
        if Line.FindLast() then
            exit(Line."Line No." + 10000);
        exit(10000);
    end;

    procedure AddValidationLine(
        var Header: Record DAVEPCValidationHeader;
        RuleCode: Code[20];
        Message: Text[100];
        Result: Enum DAVEPCRuleResult)
    var
        Line: Record DAVEPCValidationLines;
    begin
        Line.Init();
        Line."Entry No." := Header."Entry No.";
        Line."Line No." := GetNextLineNo(Header."Entry No.");
        Line."Rule Code" := RuleCode;
        Line."Rule Description" := Message;
        Line."Result" := Result;
        Line.Insert();
    end;
}
