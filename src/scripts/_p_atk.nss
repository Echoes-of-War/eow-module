//::////////////////////////////////////////////////////////////////////////////
//:: _p_atk
//::////////////////////////////////////////////////////////////////////////////
/*

    Player on attacked event.

*/
//::////////////////////////////////////////////////////////////////////////////
//:: Created:   Galefer (03/12/24)
//::////////////////////////////////////////////////////////////////////////////

// INCLUDES  -------------------------------------------------------------------

#include "_i_death"

// EXECUTION  ------------------------------------------------------------------

void main()
{
    object oPC = OBJECT_SELF;
    object oHostileActor = GetLastHostileActor();
    if (GetObjectType(oHostileActor) == OBJECT_TYPE_CREATURE)
        SetLocalObject(oPC, "LAST_HOSTILE", oHostileActor);
    DoBleedoutAttacked(oPC);
}
