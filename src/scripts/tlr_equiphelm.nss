//::///////////////////////////////////////////////
//:: Tailor - Buy Helm
//:: tlr_equiphelm.nss
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Stacy L. Ropella
//:: from Mandragon's mil_tailor
//:://////////////////////////////////////////////

void main()
{
object oModel = OBJECT_SELF;
object oHelmet;
object oHelm = GetItemInSlot(INVENTORY_SLOT_HEAD);

if (GetItemPossessedBy(oModel, "nw_arhe001") == OBJECT_INVALID)
   {
    string sHelm = "nw_arhe001";
    DestroyObject(oHelm);
    object oNewHelm = CreateItemOnObject(sHelm);
    DelayCommand(0.5, ActionEquipItem(oNewHelm, INVENTORY_SLOT_HEAD));
   }
else
   {
       oHelm = (GetItemPossessedBy(oModel, "nw_arhe001"));
       DelayCommand(0.5f, AssignCommand(OBJECT_SELF, ActionEquipItem(oHelm, INVENTORY_SLOT_HEAD)));
   }

}


