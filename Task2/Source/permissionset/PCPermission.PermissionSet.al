permissionset 65001 DAVEPCPermission
{
    Assignable = true;
    Permissions = tabledata "DAVEPCValidationHeader" = RIMD,
        tabledata "DAVEPCValidationLines" = RIMD,
        tabledata DAVEPCValidationRules = RIMD,
        table "DAVEPCValidationHeader" = X,
        table "DAVEPCValidationLines" = X,
        table DAVEPCValidationRules = X;
}
