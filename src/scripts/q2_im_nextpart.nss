//::///////////////////////////////////////////////
//:: Name: Q Shield Crafting Conversation
//:: FileName: q2_im_nextpart
//:: Website: http://www.qnwn.net
//:: Contact: projectq@qnwn.net
//:://////////////////////////////////////////////
/*
    Project Q - Release 1.5

    Changes the appearance of the currently active shield part
    on the tailor to the next available appearance

    Based on an original script by BioWare
*/
//:://////////////////////////////////////////////
//:: Created By: pstemarie
//:: Created On: 21 Dec 2011
//:://////////////////////////////////////////////

#include "q_inc_itemprop"

void main()
{
    int nPart =  GetLocalInt(OBJECT_SELF,"X2_TAILOR_CURRENT_PART");
    object oPC = GetPCSpeaker();
    object oItem = CIGetCurrentModItem(oPC);

    int nCurrentAppearance;
    if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_ARMOR)
    {
        nCurrentAppearance = GetItemAppearance(oItem,ITEM_APPR_TYPE_ARMOR_MODEL,nPart);
    }

    if(GetIsObjectValid(oItem) == TRUE)
    {
        // Store the cost for modifying this item here
        int nCost;
        int nDC;
        object oNew;
        AssignCommand(oPC,ClearAllActions(TRUE));
        if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_ARMOR)
        {
            oNew = IPGetModifiedArmor(oItem, nPart, X2_IP_ARMORTYPE_NEXT, TRUE);
            CISetCurrentModItem(oPC,oNew);
            AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_CHEST));
            nCost = CIGetArmorModificationCost(CIGetCurrentModBackup(oPC),oNew);
            nDC =CIGetArmorModificationDC(CIGetCurrentModBackup(oPC),oNew);
        }
        else if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_WEAPON)
        {
            oNew = Q_IPGetModifiedShield(oItem, ITEM_APPR_TYPE_WEAPON_MODEL, nPart, X2_IP_WEAPONTYPE_NEXT, TRUE);
            CISetCurrentModItem(oPC,oNew);
            AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_LEFTHAND));
            nCost = CIGetWeaponModificationCost(CIGetCurrentModBackup(oPC),oNew); //CIGetArmorModificationCost(CIGetCurrentModBackup(oPC),oNew);
            nDC =15 ; //CIGetArmorModificationDC(CIGetCurrentModBackup(oPC),oNew);
        }
        CIUpdateModItemCostDC(oPC, nDC, nCost);
    }
}
