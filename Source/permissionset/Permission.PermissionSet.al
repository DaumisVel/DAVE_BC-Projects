permissionset 65000 DAVEPermission
{
    Assignable = true;
    Permissions = tabledata DAVETask = RIMD,
        tabledata "DAVEPCValidationHeader" = RIMD,
        tabledata "DAVEPCValidationLines" = RIMD,
        tabledata DAVEPCValidationRules = RIMD,
        table DAVETask = X,
        table "DAVEPCValidationHeader" = X,
        table "DAVEPCValidationLines" = X,
        table DAVEPCValidationRules = X,
        codeunit DAVEMyProcedures = X,
        codeunit DAVETaskProcessor = X,
        page "DAVEMy Task Card" = X,
        page "DAVEMy Task List" = X;
}
