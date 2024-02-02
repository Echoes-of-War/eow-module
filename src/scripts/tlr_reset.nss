//::///////////////////////////////////////////////
//::MIL TAILOR: reset
//::                 onconv mil_tailor
//:://////////////////////////////////////////////
/*
   read the blueprint of our clothes
   destroy clothes
   create the standard blueprint and put it on

*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//:: Modified By: stacy_19201325
//:://////////////////////////////////////////////

void main()
{
    object oNext = GetFirstItemInInventory(OBJECT_SELF);
    while(GetIsObjectValid(oNext))
    {
        DestroyObject(oNext, 0.0);
        oNext = GetNextItemInInventory(OBJECT_SELF);
    }

    object oCloth = GetItemInSlot(INVENTORY_SLOT_CHEST);
    object oHelm = GetItemInSlot(INVENTORY_SLOT_HEAD);
    object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK);
    string sBP = "mil_clothing668";

    object oClothing;
    object oHelmet;

    DestroyObject(oCloth);
    DestroyObject(oHelm);
    DestroyObject(oLeft);
    DestroyObject(oRight);
    DestroyObject(oCloak);

    object oNew = CreateItemOnObject(sBP);
    DelayCommand(0.5, ActionEquipItem(oNew, INVENTORY_SLOT_CHEST));
}
