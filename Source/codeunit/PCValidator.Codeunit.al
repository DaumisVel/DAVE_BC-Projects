codeunit 65004 DAVEPCValidator
{
    procedure IsPersonalCodeValid(var PCValidationHeader: Record DAVEPCValidationHeader): Boolean
    var
        LenghtRuleLbl: Label 'Code must be exactly 11 characters long.';
        DigitRuleLbl: Label 'Code must contain only numeric digits.';
        FirstDigitRuleLbl: Label 'First digit must be 1 or 2 for 20th century or 3 or 4 for 21st century.';
        Code: Code[20];
        IsValid: Boolean;
    begin
        Code := PCValidationHeader."Personal Code";
        IsValid := true;
        if not CheckLength(Code) then begin
            AddRuleLine(PCValidationHeader, "DAVEPCRuleType"::LENGHT, LenghtRuleLbl);
            IsValid := false;
        end;

        if not IsTextDigits(Code) then begin
            AddRuleLine(PCValidationHeader, "DAVEPCRuleType"::NUMERIC, DigitRuleLbl);
            IsValid := false;
        end;

        if not IsValidCenturyDigit(Code) then begin
            AddRuleLine(PCValidationHeader, "DAVEPCRuleType"::FIRSTDIGIT, FirstDigitRuleLbl);
            IsValid := false;
        end;

        // Add more rule checks here

        UpdateBrokenRulesSummary(PCValidationHeader);
        PCValidationHeader."Is Valid" := IsValid;
        exit(IsValid);
    end;

    procedure AddRuleLine(var Header: Record DAVEPCValidationHeader; Rule: Enum "DAVEPCRuleType"; Reason: Text)
    var
        Line: Record DAVEPCValidationLines;
    begin
        Line.Init();
        Line.Validate("Entry No.", Header."Entry No.");
        Line.Validate("Line No.", GetNextLineNo(Header."Entry No."));
        Line."Rule Code" := Rule;
        Line."Rule Description" := CopyStr(Reason, 1, 100);
        Line.Insert();
    end;

    local procedure CheckLength(Code: Code[20]): Boolean
    begin
        exit(StrLen(Code) = 11);
    end;

    local procedure IsTextDigits(Value: Code[20]): Boolean
    var
        i: Integer;
    begin
        for i := 1 to StrLen(Value) do
            if not (Value[i] in ['0' .. '9']) then
                exit(false);
        exit(true);
    end;

    local procedure UpdateBrokenRulesSummary(var Header: Record DAVEPCValidationHeader)
    var
        Line: Record DAVEPCValidationLines;
        Summary: Text;
    begin
        Line.SetRange("Entry No.", Header."Entry No.");
        if Line.FindSet() then
            repeat
                Summary += Format(Line."Rule Code") + ', ';
            until Line.Next() = 0;

        if StrLen(Summary) > 1 then
            Summary := DelStr(Summary, StrLen(Summary) - 1);

        Header."Broken Rules" := CopyStr(Summary, 1, 100);
    end;

    local procedure GetNextLineNo(EntryNo: Integer): Integer
    var
        Line: Record DAVEPCValidationLines;
    begin
        Line.SetRange("Entry No.", EntryNo);
        if Line.FindLast() then
            exit(Line."Line No." + 1);
        exit(1);
    end;

    local procedure IsValidCenturyDigit(Code: Code[20]): Boolean
    var
        FirstDigit: Integer;
        FirstChar: Text;
    begin
        if StrLen(Code) < 1 then
            exit(false);
        FirstChar := CopyStr(Code, 1, 1);
        Evaluate(FirstDigit, FirstChar);
        exit((FirstDigit >= 1) and (FirstDigit <= 6));
    end;

}
