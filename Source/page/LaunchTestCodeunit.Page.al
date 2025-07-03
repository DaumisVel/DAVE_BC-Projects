page 65000 "DAVELaunch Test Codeunit"
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
                Tooltip = 'Runs the debug demo codeunit.'; // Added Tooltip property
                trigger OnAction()
                var
                    Debugger: Codeunit "DAVEDebug Demo";
                begin
                    Debugger.Run(); // Triggers OnRun
                end;
            }
        }
    }
}
