page 65000 "DAVELaunch Test Codeunit"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = Customer;
    UsageCategory = None;
    Caption = 'Launch Test Codeunit';

    actions
    {
        area(processing)
        {
            action(RunDebugCode)
            {
                Caption = 'Run Debug Demo';
                Tooltip = 'Runs the debug demo codeunit.'; // Added Tooltip property
                Image = Debug; // Added Image property
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
