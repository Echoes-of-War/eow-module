//::///////////////////////////////////////////////
//:: Tailoring - Color Weapon Middle
//:: tlr_colorweapmid.nss
//:: Copyright (c) 2006 Stacy L. Ropella
//:://////////////////////////////////////////////
/*
    Changes the color on an equipped weapon
*/
//:://////////////////////////////////////////////
//:: Created By: Stacy L. Ropella
//:: Created On: January 29, 2006
//:://////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//The Mad Poet - Modified for Avernostra                                      //
//  Project Q shields are 3 piece, treat them as weapons instead              //
////////////////////////////////////////////////////////////////////////////////

#include "tlr_items_inc"

void main()
{
    object oNPC = OBJECT_SELF;
    object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oNPC);
    ColorItem(oNPC, oItem, ITEM_APPR_WEAPON_MODEL_MIDDLE, COLOR_NEXT);
}
