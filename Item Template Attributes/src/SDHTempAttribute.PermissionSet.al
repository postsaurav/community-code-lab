permissionset 50001 "SDH Temp. Attribute"
{
    Assignable = true;
    Caption = 'Item Temp. Attr. Permmissions', MaxLength = 30;
    Permissions =
        table "SDH Item Attribute Temp." = X,
        tabledata "SDH Item Attribute Temp." = RMID,
        page "SDH Item Attribute Templates" = X,
        codeunit "SDH Item Attribute Temp. Mgt." = X;
}
