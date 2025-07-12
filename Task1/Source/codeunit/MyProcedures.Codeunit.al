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
        Numbers := this.GenerateRandomIntArray(100);

        MinVal := Numbers.Get(1);
        MaxVal := Numbers.Get(1);

        foreach i in Numbers do begin
            if i < MinVal then
                MinVal := i;
            if i > MaxVal then
                MaxVal := i;
        end;

        exit(StrSubstNo(this.MinMaxOutputFormatTxt, MinVal, MaxVal));
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
        Numbers := this.GenerateRandomIntArray(100);

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
        exit(StrSubstNo(this.VowelConsonantOutputFormatTxt, VowelCount, ConsonantCount));
    end;

    local procedure GenerateRandomIntArray(Length: Integer): List of [Integer]
    var
        RandomArray: List of [Integer];
        i: Integer;
    begin
        for i := 1 to Length do
            RandomArray.Add(Random(1000));
        exit(RandomArray);
    end;


}
