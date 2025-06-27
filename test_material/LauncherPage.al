page 65000 "Launch Test Codeunit"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = Customer;

    actions
    {
        area(processing)
        {
            action(RunDebugCode)
            {
                Caption = 'Run Debug Demo';
                trigger OnAction()
                var
                    Debugger: Codeunit "Debug Demo";
                begin
                    Debugger.Run(); // Triggers OnRun
                end;
            }
        }
    }
}
