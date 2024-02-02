//::///////////////////////////////////////////////
//:: Tailoring - Increment Weapon Top
//:: tlr_incrweaptop.nss
//:: Copyright (c) 2006 Stacy L. Ropella
//:://////////////////////////////////////////////
/*
    Increments appearances for an equipped weapon
*/
//:://////////////////////////////////////////////
//:: Created By: Stacy L. Ropella
//:: Created On: January 29, 2006
//:://////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//The Mad Poet - Modified for Avernostra                                      //
//  Project Q shields are 3 piece, treat them as weapons instead              //
//  For future knowledge: Q shields do not have effects yet, but leave this   //
//  up for any future updates. Invalid parts will simply remove shield        //
//  from tailor anyway so players will know.                                  //
////////////////////////////////////////////////////////////////////////////////

#include "tlr_items_inc"

void main()
{
    object oNPC = OBJECT_SELF;
    object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oNPC);
    RemakeWeapon(oNPC, oItem, ITEM_APPR_WEAPON_MODEL_TOP, PART_NEXT);
}
