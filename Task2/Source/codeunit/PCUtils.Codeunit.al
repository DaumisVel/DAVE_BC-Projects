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

    procedure ResetValidationRules()
    var
        Rule: Record DAVEPCValidationRules;
        ResetMsg: Label 'This will reset your validation rules to default. Continue?';
    begin
        if Confirm(ResetMsg, true) then
            Rule.DeleteAll();
        Rule.Init();
        Rule."Code" := 'BIRTH_DATE';
        Rule."Caption" := 'Must contain valid birth date';
        Rule."Execution Code" := 'CHECK_DATE';
        Rule."Is Active" := true;
        Rule."Importance" := DAVEPCRuleImportance::Tier3;
        Rule.Insert(true);

        Rule.Init();
        Rule."Code" := 'CENTURY';
        Rule."Caption" := 'First digit must be 1-6';
        Rule."Execution Code" := 'CHECK_CENTURY';
        Rule."Is Active" := true;
        Rule."Importance" := DAVEPCRuleImportance::Tier2;
        Rule.Insert(true);

        Rule.Init();
        Rule."Code" := 'LENGTH';
        Rule."Caption" := 'Code must be 11 digits';
        Rule."Execution Code" := 'CHECK_LENGTH';
        Rule."Is Active" := true;
        Rule."Importance" := DAVEPCRuleImportance::Tier1;
        Rule.Insert(true);

        Rule.Init();
        Rule."Code" := 'NUMERIC';
        Rule."Caption" := 'Code must contain only digits';
        Rule."Execution Code" := 'CHECK_NUMERIC';
        Rule."Is Active" := true;
        Rule."Importance" := DAVEPCRuleImportance::Tier1;
        Rule.Insert(true);

        Rule.Init();
        Rule."Code" := 'BIRTH_NO';
        Rule."Caption" := '8-10th digits must be a valid number (001-999)';
        Rule."Execution Code" := 'CHECK_NO';
        Rule."Is Active" := true;
        Rule."Importance" := DAVEPCRuleImportance::Tier2;
        Rule.Insert(true);

        Rule.Init();
        Rule."Code" := 'SUM';
        Rule."Caption" := 'Checksum digit must be valid';
        Rule."Execution Code" := 'CHECK_CHECKSUM';
        Rule."Is Active" := true;
        Rule."Importance" := DAVEPCRuleImportance::Tier4;
        Rule.Insert(true);
    end;
}
