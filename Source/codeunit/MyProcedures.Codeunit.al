codeunit 65000 DAVEMyProcedures
{
    var
        MinMaxOutputFormatTxt: Label 'Min: %1, Max: %2', Comment = '%1 = Minimum value; %2 = Maximum value';
        VowelConsonantOutputFormatTxt: Label 'Vowels: %1, Consonants: %2', Comment = '%1 = Number of vowels; %2 = Number of consonants';


    procedure ReverseText(InputText: Text): Text
    var
        i: Integer;
        OutputText: Text;
    begin
        for i := StrLen(InputText) downto 1 do
            OutputText += CopyStr(InputText, i, 1);

        exit(OutputText);
    end;

    procedure FindMinMax(): Text
    var
        Numbers: List of [Integer];
        i: Integer;
        MinVal: Integer;
        MaxVal: Integer;
    begin
        Numbers := GenerateRandomIntArray(100);

        MinVal := Numbers.Get(1);
        MaxVal := Numbers.Get(1);

        foreach i in Numbers do begin
            if i < MinVal then
                MinVal := i;
            if i > MaxVal then
                MaxVal := i;
        end;

        exit(StrSubstNo(MinMaxOutputFormatTxt, MinVal, MaxVal));
    end;

    procedure FindDuplicates(): Text
    var
        Numbers: List of [Integer];
        Seen: Dictionary of [Integer, Boolean];
        Duplicates: List of [Integer];
        i: Integer;
        Num: Integer;
        Result: Text;
    begin
        Numbers := GenerateRandomIntArray(100);

        foreach Num in Numbers do
            if not Seen.ContainsKey(Num) then
                Seen.Add(Num, true)
            else
                if not Duplicates.Contains(Num) then
                    Duplicates.Add(Num);


        if Duplicates.Count = 0 then
            exit('No duplicates found.');

        Result := 'Duplicates: ';
        foreach i in Duplicates do
            Result += Format(i) + ', ';

        Result := DelStr(Result, StrLen(Result) - 1, 2);

        exit(Result);
    end;

    procedure CountVowelsAndConsonants(InputText: Text): Text
    var
        Char: Char;
        i: Integer;
        VowelCount: Integer;
        ConsonantCount: Integer;
        LowerChar: Char;
    begin
        for i := 1 to StrLen(InputText) do begin
            Char := InputText[i];
            LowerChar := LowerCase(Format(Char)) [1];

            if LowerChar in ['a', 'ą', 'e', 'ę', 'ė', 'i', 'į', 'y', 'o', 'u', 'ų', 'ū'] then
                VowelCount += 1
            else
                if LowerChar in ['b', 'c', 'č', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 'š', 't', 'v', 'w', 'x', 'z', 'ž'] then
                    ConsonantCount += 1;
        end;
        exit(StrSubstNo(VowelConsonantOutputFormatTxt, VowelCount, ConsonantCount));
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

    local procedure GenerateRandomIntArray(Length: Integer): List of [Integer]
    var
        RandomArray: List of [Integer];
        i: Integer;
    begin
        for i := 1 to Length do
            RandomArray.Add(Random(10));
        exit(RandomArray);
    end;


}
