permissionset 65010 DAVERentPermissions
{
    Caption = 'Rental permissions';
    Assignable = true;
    Permissions = tabledata DAVEAutoSetup=RIMD,
        tabledata DAVEAuto=RIMD,
        tabledata DAVEAutoDamage=RIMD,
        tabledata DAVEAutoMark=RIMD,
        tabledata DAVEAutoModel=RIMD,
        tabledata DAVEAutoRentDamage=RIMD,
        tabledata DAVEAutoRentHeader=RIMD,
        tabledata DAVEAutoRentLine=RIMD,
        tabledata DAVEAutoReservation=RIMD,
        tabledata DAVEFinishedAutoRentHeader=RIMD,
        tabledata DAVEFinishedAutoRentLine=RIMD,
        table DAVEAuto=X,
        table DAVEAutoDamage=X,
        table DAVEAutoMark=X,
        table DAVEAutoModel=X,
        table DAVEAutoRentDamage=X,
        table DAVEAutoRentHeader=X,
        table DAVEAutoRentLine=X,
        table DAVEAutoReservation=X,
        table DAVEAutoSetup=X,
        table DAVEFinishedAutoRentHeader=X,
        table DAVEFinishedAutoRentLine=X,
        page DAVEAutoCard=X,
        page DAVEAutoDamageList=X,
        page DAVEAutoIssuedContracts=X,
        page DAVEAutoMarks=X,
        page DAVEAutoModels=X,
        page DAVEAutoRentCard=X,
        page DAVEAutoRentDamageList=X,
        page DAVEAutoRentLineListPart=X,
        page DAVEAutoRentList=X,
        page DAVEAutoReservations=X,
        page DAVEAutos=X,
        page DAVEFininshedAutoRentList=X,
        page DAVEFinishedAutoRentCard=X,
        page DAVEFinRentLineListPart=X,
        page DAVERentalSetupCard=X,
        page DAVEValidReservations=X,
        page DAVEDriverLicensePreview=X,
        codeunit DAVERentalManagement=X,
        codeunit DAVERentalPostingService=X;
}
