//::///////////////////////////////////////////////
//:: Tag Based Item script
//:: q1_it_trap048.nss
//:://////////////////////////////////////////////
/*
    Razorwire Kit OnUnAquireItem Event

*/
//:://////////////////////////////////////////////
//:: Created By: Pstemarie
//:: Created On: August 14, 2012
//:://////////////////////////////////////////////
#include "x0_i0_spells"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();

    if (nEvent == X2_ITEM_EVENT_UNACQUIRE)
    {
        object oPC = GetModuleItemLostBy();
        object oTrap = GetNearestTrapToObject(oPC);

        SetLocalLocation(oTrap, "TRP_PLCBL_LOC", GetLocation(oPC));
    }
}
