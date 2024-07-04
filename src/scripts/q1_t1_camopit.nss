#include "q_inc_traps"

void main()
{
    if(GetLocalInt(OBJECT_SELF,"TRP_TRIGGERED"))
        return;

    SetLocalInt(OBJECT_SELF,"TRP_TRIGGERED",1);

    object oTrap = GetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ");

    TrapPlayAnim(oTrap);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,EffectAreaOfEffect(52),GetLocation(oTrap),HoursToSeconds(200));
    return;
}
