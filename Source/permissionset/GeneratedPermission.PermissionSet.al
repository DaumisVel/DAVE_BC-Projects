permissionset 65000 DAVEPermission
{
    Assignable = true;
    Permissions = tabledata "DAVEReward Level" = RIMD,
        tabledata DAVETask = RIMD,
        table "DAVEReward Level" = X,
        table DAVETask = X,
        codeunit "DAVEDebug Demo" = X,
        codeunit DAVEMyCodeunit = X,
        codeunit DAVEMyProcedures = X,
        codeunit DAVETaskProcessor = X,
        codeunit DAVEValidations = X,
        page DAVEDataTypesCard = X,
        page "DAVEDEMOArmstrong Card" = X,
        page "DAVEDEMOExpressions Card" = X,
        page "DAVELaunch Test Codeunit" = X,
        page "DAVEMy Task Card" = X,
        page "DAVEMy Task List" = X,
        page DAVEStatementsCard = X;
}
