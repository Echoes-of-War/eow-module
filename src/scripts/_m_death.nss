//::////////////////////////////////////////////////////////////////////////////
//:: _m_death
//::////////////////////////////////////////////////////////////////////////////
/*

    Module death event.

*/
//::////////////////////////////////////////////////////////////////////////////
//:: Created:   Galefer (03/12/24)
//::////////////////////////////////////////////////////////////////////////////

// INCLUDES  -------------------------------------------------------------------

#include "_i_death"

// EXECUTION  ------------------------------------------------------------------

void main()
{
    object oPC = GetLastPlayerDied();
    object oHostileActor = GetLastHostileActor();
    if (GetObjectType(oHostileActor) == OBJECT_TYPE_CREATURE)
        SetLocalObject(oPC, "LAST_HOSTILE", oHostileActor);
    InitiateBleedout(oPC);
}
