//::///////////////////////////////////////////////
//:: Tailoring - Copy the PCs Outfit
//:: tlr_copypcoutfit.nss
//:: Copyright (c) 2003 Jake E. Fitch
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Jake E. Fitch (Milambus Mandragon)
//:: Created On: March 8, 2004
//:://////////////////////////////////////////////
void main()
{
    object oPC = GetPCSpeaker();

    object oItem;
    object oSource;

    if(GetLocalInt(OBJECT_SELF, "IsCloakModel") == 1)
    {
        oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, OBJECT_SELF);
        oSource = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
    }
    else
    {
        oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
        oSource = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    }

    int iSourceValue;
    object oCurrent, oNew;

////// Copy Colors
    // Cloth 1
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1);
    oCurrent = oItem;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Cloth 2
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Leather 1
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Leather 2
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Metal 1
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Metal 2
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2, iSourceValue, TRUE);
    DestroyObject(oCurrent);


////// Copy Design

    // Cloak
    if(GetLocalInt(OBJECT_SELF, "IsCloakModel") == 1 &&
       GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC)))
    {
        iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
        oCurrent = oNew;
        oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, iSourceValue, TRUE);
        DestroyObject(oCurrent);
    }
    else
    {
    // Belt
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_BELT);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_BELT, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Left Bicep
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LBICEP);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LBICEP, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Left Foot
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Left Forearm
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOREARM);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOREARM, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Left Hand
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LHAND);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LHAND, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Left Shin
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Left Shoulder
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHOULDER);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHOULDER, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Left Thigh
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LTHIGH);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LTHIGH, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Neck
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_NECK);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_NECK, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Pelvis
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_PELVIS);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_PELVIS, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Right Bicep
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RBICEP);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RBICEP, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Right Foot
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOOT);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOOT, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Right Forearm
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOREARM);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOREARM, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Right Hand
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RHAND);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RHAND, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Right Shin
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHIN);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHIN, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Right Shoulder
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHOULDER);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHOULDER, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Right Thigh
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RTHIGH);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RTHIGH, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Robe
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_ROBE);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_ROBE, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Torso
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO, iSourceValue, TRUE);
    DestroyObject(oCurrent);
    }

    // Equip
    if(GetLocalInt(OBJECT_SELF, "IsCloakModel") == 1)
    {
        DelayCommand(0.5f, AssignCommand(OBJECT_SELF, ActionEquipItem(oNew, INVENTORY_SLOT_CLOAK)));
    }
    else
    {
        DelayCommand(0.5f, AssignCommand(OBJECT_SELF, ActionEquipItem(oNew, INVENTORY_SLOT_CHEST)));
    }
}
