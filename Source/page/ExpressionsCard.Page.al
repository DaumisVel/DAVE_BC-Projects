page 65111 "DAVEDEMOExpressions Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    Caption = 'Expressions Card';

    layout
    {
        area(Content)
        {
            group(Input)
            {
                Caption = 'Input';
                field(Value1; Value1)
                {
                    ApplicationArea = All;
                    Caption = 'Value1';
                    ToolTip = 'Enter the first value';
                }
                field(Value2; Value2)
                {
                    ApplicationArea = All;
                    Caption = 'Value2';
                    ToolTip = 'Enter the second value';
                }
            }
            group(Output)
            {
                Caption = 'Output';
                field(Result; Result)
                {
                    ApplicationArea = All;
                    Caption = 'Result';
                    ToolTip = 'The result of the operation';
                    Editable = false; // Example of making the field non-editable
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Execute)
            {
                Image = ExecuteBatch;
                ApplicationArea = All;
                ToolTip = 'Click to calculate the result';
                Caption = 'Execute';

                trigger OnAction()
                begin
                    Result := Value1 > Value2;
                end;
            }
        }
    }

    var
        Value1: Integer;
        Value2: Integer;
        Result: Boolean;
}