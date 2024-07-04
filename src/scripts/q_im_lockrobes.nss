//::///////////////////////////////////////////////
//:: Name: Q Craft Conversation
//:: FileName: q_im_lockrobes
//:: Website: http://www.qnwn.net
//:: Contact: projectq@qnwn.net
//:://////////////////////////////////////////////
/*
    Project Q - Release 1.5

    Return TRUE if
        -   Module switch locking heraldric robe crafting is false
*/
//:://////////////////////////////////////////////
//:: Created By: pstemarie
//:: Created On: 22 Dec 2011
//:://////////////////////////////////////////////

#include "q_inc_switches"

int StartingConditional()
{
    if(GetModuleSwitchValue(MODULE_SWITCH_ENABLE_LOCK_HERALDIC_ROBE_CRAFTING) == FALSE)
        return TRUE;

    return FALSE;
}
