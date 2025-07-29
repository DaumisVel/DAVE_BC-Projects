codeunit 65004 DAVEPCValidator
{
    procedure ValidateCode(var Header: Record DAVEPCValidationHeader)
    var
        Rule: Record "DAVEPCValidationRules";
    begin
        Header.TestField("Personal Code");
        Rule.SetRange("Is Active", true);
        Rule.SetCurrentKey(Importance);
        Rule.Ascending(true);
        if Rule.FindSet() then
            repeat
                if this.CanExecuteValidationRule(Header, Rule) then // Review: Man atrodo, kad ši dalis nereikalinga ir būtų galima tikrinti kiekvieną taisyklę
                    this.DispatchValidationRule(Header, Rule);
            until Rule.Next() = 0;

        Header."Has Been Checked" := true;
        this.UpdateBrokenRules(Header);
        Header.Modify();
    end;

    local procedure DispatchValidationRule(
        var Header: Record DAVEPCValidationHeader;
        Rule: Record DAVEPCValidationRules)
    var
        Utils: Codeunit DAVEPCUtils;
    begin
        case Rule."Execution Code" of
            'CHECK_LENGTH':
                this.RunLength(Header, Rule);
            'CHECK_NUMERIC':
                this.RunNumeric(Header, Rule);
            'CHECK_CENTURY':
                this.RunCentury(Header, Rule);
            'CHECK_NO':
                this.RunNo(Header, Rule);
            'CHECK_DATE':
                this.RunDate(Header, Rule);
            'CHECK_CHECKSUM':
                this.RunChecksum(Header, Rule);
            else
                Utils.AddValidationLine(Header, Rule."Code", 'Unknown Execution Code: ' + Rule."Execution Code", DAVEPCRuleResult::Failed);
        end;
    end;

    local procedure CanExecuteValidationRule( // Review: kodas labai sudėtingas. Ar tikrai teikia vertės sprendimui?
                                              //         Atmesadami kai kurias patikras nebetikriname ar AK jas atitinka, todėl gaunamas neteisingas rezultatas: pvz.: 12300115568.
    Header: Record DAVEPCValidationHeader;
    Rule: Record DAVEPCValidationRules): Boolean
    begin
        if (Rule."Execution Code" = 'CHECK_NUMERIC') or (Rule."Execution Code" = 'CHECK_LENGTH') then
            exit(true);

        if not this.ValidationRulePassed(Header."Entry No.", 'LENGTH') or
            not this.ValidationRulePassed(Header."Entry No.", 'NUMERIC') then
            exit(false);

        if Header."Personal Code"[1] = '9' then
            if Rule."Execution Code" in ['CHECK_DATE', 'CHECK_CENTURY', 'CHECK_CHECKSUM', 'CHECK_NO'] then
                exit(false);

        if (CopyStr(Header."Personal Code", 4, 2) = '00') or
           (CopyStr(Header."Personal Code", 6, 2) = '00') then
            if Rule."Execution Code" = 'CHECK_DATE' then
                exit(false);

        exit(true);
    end;

    local procedure ValidationRulePassed(EntryNo: Integer; RuleCode: Code[20]): Boolean
    var
        Line: Record DAVEPCValidationLines;

    begin
        Line.Reset();
        Line.SetRange("Entry No.", EntryNo);
        Line.SetRange("Rule Code", RuleCode);
        Line.SetRange("Result", DAVEPCRuleResult::Failed);
        exit(Line.IsEmpty);
    end;


    local procedure RunLength(
        Header: Record DAVEPCValidationHeader;
        Rule: Record DAVEPCValidationRules)
    var
        Utils: Codeunit DAVEPCUtils;
    begin
        if StrLen(Header."Personal Code") <> 11 then
            Utils.AddValidationLine(Header, Rule."Code", Rule.Caption, DAVEPCRuleResult::Failed)
        else
            Utils.AddValidationLine(Header, Rule."Code", Rule."Caption", DAVEPCRuleResult::Passed);
    end;

    local procedure RunNumeric(
        Header: Record DAVEPCValidationHeader;
        Rule: Record DAVEPCValidationRules)
    var
        Utils: Codeunit DAVEPCUtils;
        CharIndex: Integer;
        Char: Char;
        Code: Text;
    begin
        Code := Header."Personal Code";

        for CharIndex := 1 to StrLen(Code) do begin
            Char := Code[CharIndex];
            if not Utils.IsDigit(Char) then begin
                Utils.AddValidationLine(Header, Rule."Code", Rule."Caption", DAVEPCRuleResult::Failed);
                exit;
            end;
        end;

        Utils.AddValidationLine(Header, Rule."Code", Rule."Caption", DAVEPCRuleResult::Passed);
    end;

    local procedure RunCentury(
        Header: Record DAVEPCValidationHeader;
        Rule: Record DAVEPCValidationRules)
    var
        Utils: Codeunit DAVEPCUtils;
    begin
        case Header."Personal Code"[1] of
            '1', '2', '3', '4', '5', '6':
                Utils.AddValidationLine(Header, Rule."Code", Rule."Caption", DAVEPCRuleResult::Passed);
            else
                Utils.AddValidationLine(Header, Rule."Code", Rule."Caption", DAVEPCRuleResult::Failed);
        end;
    end;

    local procedure RunNo(
        Header: Record DAVEPCValidationHeader;
        Rule: Record DAVEPCValidationRules)
    var
        Utils: Codeunit DAVEPCUtils;
        BirthNoText: Text;
        BirthNoInt: Integer;

    begin
        BirthNoText := CopyStr(Header."Personal Code", 8, 3);
        Evaluate(BirthNoInt, BirthNoText);
        if BirthNoInt in [1 .. 999] then
            Utils.AddValidationLine(Header, Rule."Code", Rule."Caption", DAVEPCRuleResult::Passed)
        else
            Utils.AddValidationLine(Header, Rule."Code", Rule."Caption", DAVEPCRuleResult::Failed);
    end;

    local procedure RunDate(
        Header: Record DAVEPCValidationHeader;
        Rule: Record DAVEPCValidationRules)
    var
        Utils: Codeunit DAVEPCUtils;
        TestDate: Date;
        YearText, MonthText, DayText : Text[2];
        YearInt, MonthInt, DayInt : Integer;
        Success: Boolean;
    begin

        YearText := CopyStr(Header."Personal Code", 2, 2);
        MonthText := CopyStr(Header."Personal Code", 4, 2);
        DayText := CopyStr(Header."Personal Code", 6, 2);
        Evaluate(YearInt, YearText); // Revirew: jei čia bus ne skaitmenys, tai bus runtime klaida
        Evaluate(MonthInt, MonthText);
        Evaluate(DayInt, DayText);

        case Header."Personal Code"[1] of
            '1', '2':
                YearInt := 1800 + YearInt;
            '3', '4':
                YearInt := 1900 + YearInt;
            '5', '6':
                YearInt := 2000 + YearInt;
            else
                Utils.AddValidationLine(Header, Rule."Code", Rule."Caption", DAVEPCRuleResult::Failed);
                exit;
        end;
        Success := false;
        if (MonthInt <> 0) and (DayInt <> 0) then
            Success := Utils.TryBuildDate(DayInt, MonthInt, YearInt, TestDate);
        if Success then
            Utils.AddValidationLine(Header, Rule."Code", Rule."Caption", DAVEPCRuleResult::Passed)
        else
            Utils.AddValidationLine(Header, Rule."Code", Rule."Caption", DAVEPCRuleResult::Failed);
    end;

    local procedure RunChecksum( // Review: complex
        Header: Record DAVEPCValidationHeader;
        Rule: Record DAVEPCValidationRules
    )
    var
        Utils: Codeunit DAVEPCUtils;
        Digits: array[11] of Integer;
        i, S1, S2, R1, R2 : Integer;
        tempText: Text;
    begin
        // Review: kodas labai complex. Galima būtų supaprastinti -> Suskaičiuojam checksum -> tikrinam ar sutampa su 11 simboliu -> fiksuojam rezultatą
        for i := 1 to 11 do begin
            tempText := Header."Personal Code"[i];
            Evaluate(Digits[i], tempText);
        end;


        S1 := Digits[1] * 1 + Digits[2] * 2 + Digits[3] * 3 + Digits[4] * 4 + Digits[5] * 5 +
            Digits[6] * 6 + Digits[7] * 7 + Digits[8] * 8 + Digits[9] * 9 + Digits[10] * 1;

        R1 := S1 mod 11;
        if R1 <> 10 then
            if (R1 = Digits[11]) then
                Utils.AddValidationLine(Header, Rule."Code", Rule."Caption", DAVEPCRuleResult::Passed)
            else
                Utils.AddValidationLine(Header, Rule."Code", Rule."Caption", DAVEPCRuleResult::Failed)
        else begin
            S2 := Digits[1] * 3 + Digits[2] * 4 + Digits[3] * 5 + Digits[4] * 6 + Digits[5] * 7 +
                Digits[6] * 8 + Digits[7] * 9 + Digits[8] * 1 + Digits[9] * 2 + Digits[10] * 3;
            R2 := S2 mod 11;
            if R2 <> 10 then
                if (R2 = Digits[11]) then
                    Utils.AddValidationLine(Header, Rule."Code", Rule."Caption", DAVEPCRuleResult::Passed)
                else
                    Utils.AddValidationLine(Header, Rule."Code", Rule."Caption", DAVEPCRuleResult::Failed)
            else
                if (Digits[11] = 0) then
                    Utils.AddValidationLine(Header, Rule."Code", Rule."Caption", DAVEPCRuleResult::Passed)
                else
                    Utils.AddValidationLine(Header, Rule."Code", Rule."Caption", DAVEPCRuleResult::Failed)
        end;

    end;

    local procedure UpdateBrokenRules(var Header: Record DAVEPCValidationHeader)
    var
        Line: Record DAVEPCValidationLines;
        Broken: Text;
    begin
        Broken := '';

        Line.SetRange("Entry No.", Header."Entry No.");
        Line.SetRange("Result", DAVEPCRuleResult::Failed);

        if Line.FindSet() then
            repeat
                Broken := Broken + Line."Rule Code" + '; ';
            until Line.Next() = 0;

        if Broken <> '' then begin
            Broken := CopyStr(Broken, 1, StrLen(Broken) - 2);
            Header."Broken Rules" := CopyStr(Broken, 1, 100);
        end else
            Header."Broken Rules" := '';
    end;

    procedure AllRulesPassed(EntryNo: Integer): Boolean
    var
        Line: Record DAVEPCValidationLines;
    begin
        Line.SetRange("Entry No.", EntryNo);
        Line.SetRange("Result", DAVEPCRuleResult::Failed);
        exit(Line.IsEmpty());
    end;

}
