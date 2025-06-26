codeunit 65000 MyProcedures
{
    // This procedure manually reverses a string without using built-in Reverse()
    procedure ReverseText(InputText: Text): Text
    var
        i: Integer;
        OutputText: Text;
    begin
        for i := StrLen(InputText) downto 1 do begin
            OutputText += CopyStr(InputText, i, 1);
        end;

        exit(OutputText);
    end;

    // You can add more procedures later here, e.g. FindMinMax(), CountVowels(), etc.
}