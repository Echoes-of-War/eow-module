//::///////////////////////////////////////////////
//:: DMFI - OnClientEnter event handler
//:: dmfi_onclienter
//:://////////////////////////////////////////////
/*
  Event handler for the module-level OnClientEnter event. Initializes DMFI system.
*/
//:://////////////////////////////////////////////
//:: 2008.08.02 tsunami282 - created.

#include "dmfi_init_inc"

////////////////////////////////////////////////////////////////////////
void main()
{
    object oUser = GetEnteringObject();
    SetEventScript(oUser, EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED, "_pc_attacked");
    SetEventScript(oUser, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, "_pc_heartbeat");
    // do any other module OnClientEnter work here
    ExecuteScript("x3_mod_def_enter", OBJECT_SELF);

    // initialize DMFI
    dmfiInitialize(oUser);

}
