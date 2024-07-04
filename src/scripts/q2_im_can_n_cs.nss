//::///////////////////////////////////////////////
//:: Name: Q Can Not Craft Shields?
//:: FileName: q2_im_can_n_cs
//:: Website: http://www.qnwn.net
//:: Contact: projectq@qnwn.net
//:://////////////////////////////////////////////
/*
    Project Q - Release 1.5

    Return TRUE when
        - No valid shield in the left hand OR
        - Shield is marked as plot

    Based on an original script by BioWare
*/
//:://////////////////////////////////////////////
//:: Created By: pstemarie
//:: Created On: 21 Dec 2011
//:://////////////////////////////////////////////

#include "x2_inc_itemprop"

int StartingConditional()
{
    object oW = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,GetPCSpeaker());

    if (!GetIsObjectValid(oW))
    {
        return TRUE;
    }
    else if (GetPlotFlag(oW))
    {
        return TRUE;
    }
    int iShield = (( GetBaseItemType(oW) == BASE_ITEM_SMALLSHIELD ) ||
                   ( GetBaseItemType(oW) == BASE_ITEM_LARGESHIELD ) ||
                   ( GetBaseItemType(oW) == BASE_ITEM_TOWERSHIELD ));
    if (!iShield)
    {
        return TRUE;
    }

    if (!GetHasSkill(SKILL_CRAFT_ARMOR,GetPCSpeaker()))
    {
        return TRUE;
    }
    return FALSE;
}
