//::////////////////////////////////////////////////////////////////////////////
//:: _m_enter
//::////////////////////////////////////////////////////////////////////////////
/*

    Module client enter event script.

*/
//::////////////////////////////////////////////////////////////////////////////
//:: Created:   Galefer (03/12/24)
//::////////////////////////////////////////////////////////////////////////////

// INCLUDES  -------------------------------------------------------------------

#include "_i_generic"
#include "_i_commands"
#include "_i_death"

// DECLARATIIONS ---------------------------------------------------------------

// First time setup, starting items, etc
void DoFirstTimeSetup(object oPC);

// IMPLEMENTATIONS -------------------------------------------------------------

void DoFirstTimeSetup(object oPC)
{

}

// EXECUTION  ------------------------------------------------------------------

void main()
{

    object oPC = GetEnteringObject();
    if (!GetIsPC(oPC))
        return;

    DoFirstTimeSetup(oPC);

    if (GetDebugMode() == TRUE)
    {
        HandleChatCommand(oPC, "!help");
    }

    SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED, "_p_atk");
    SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, "_p_hb");
    SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_DAMAGED, "_p_dmg");

    string sWaypoint;
    int iTP;

    if (GetPlayerClosure(oPC) == TRUE)
    {
        sWaypoint = "wp_closure";
        iTP = TRUE;
    } else
    if (PVPGetRemainingLives(oPC) <= 0)
    {
        sWaypoint = "wp_permadeath";
        iTP = TRUE;
    }

    int iAppearanceSetup = GetCampaignInt(DEATH_DATABASE, "APPEARANCE_SET", oPC);
    if (iAppearanceSetup == FALSE)
    {
        int iApp = GetAppearanceType(oPC);
        SetCampaignInt(DEATH_DATABASE, ORIGINAL_APPEARANCE, iApp, oPC);
        SetCampaignInt(DEATH_DATABASE, "APPEARANCE_SET", TRUE, oPC);
    }

    if (iTP == TRUE)
        DelayCommand(0.1, ClearAndJump(oPC, GetWaypointByTag(sWaypoint)));

    if (GetIsGhost(oPC) == TRUE)
    {
        SetIsGhost(oPC, TRUE);
        object oShrine = GetObjectByTag("shrine");
        object oShrineArea = GetArea(oShrine);
        object oGhostArea = CreateGhostArea(oShrineArea);
        object oGhostShrine = GetFirstObjectInArea(oGhostArea);
        DelayCommand(0.1, ClearAndJump(oPC, oGhostShrine));
        return;
    }

}
