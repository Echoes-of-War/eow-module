#include "x2_inc_craft"
void main()
{
    object oItem = CIGetCurrentModItem(GetPCSpeaker());
    object oNew = IPCreateAndModifyArmorRobe(oItem,183);
    if (oItem != oNew)
    {
        DestroyObject(oItem);
        AssignCommand(GetPCSpeaker(),ActionEquipItem(oNew,INVENTORY_SLOT_CHEST));
        CISetCurrentModItem(GetPCSpeaker(),oNew);
    }

}
