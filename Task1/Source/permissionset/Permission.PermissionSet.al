permissionset 65000 DAVEPermission
{
    Caption = 'DAVE Permission', MaxLength = 30;
    Assignable = true;
    Permissions = tabledata DAVETask = RIMD,
        table DAVETask = X,
        codeunit DAVEMyProcedures = X,
        codeunit DAVETaskProcessor = X,
        page "DAVEMy Task Card" = X,
        page "DAVEMy Task List" = X;
}
