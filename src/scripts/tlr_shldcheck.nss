//::///////////////////////////////////////////////
//:: Tailoring - If Left Hand Item is Shield
//:: Also check to see if weapon copying is allowed
//:: tlr_shldcheck.nss
//:: Copyright (c) 2006 Stacy L. Ropella
//:://////////////////////////////////////////////
/*
    Checks to make sure there is a shield
    equipped in the PC's left hand slot & in the
    model's left hand slot
*/
//:://////////////////////////////////////////////
//:: Created By: Stacy L. Ropella
//:: Created On: January 29, 2006
//:://////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//The Mad Poet - Modified for Avernostra and Project Q                        //
////////////////////////////////////////////////////////////////////////////////

int StartingConditional()
{
    if(GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,GetPCSpeaker()))==BASE_ITEM_SMALLSHIELD
        && GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF))==BASE_ITEM_SMALLSHIELD
        && GetLocalInt(OBJECT_SELF, "Shield_Copy") == 1)
        return TRUE;
    else if(GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,GetPCSpeaker()))==BASE_ITEM_LARGESHIELD
        && GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF))==BASE_ITEM_LARGESHIELD
        && GetLocalInt(OBJECT_SELF, "Shield_Copy") == 1)
        return TRUE;
    else if(GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,GetPCSpeaker()))==BASE_ITEM_TOWERSHIELD
        && GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF))==BASE_ITEM_TOWERSHIELD
        && GetLocalInt(OBJECT_SELF, "Shield_Copy") == 1)
        return TRUE;
    else
        return FALSE;
}
