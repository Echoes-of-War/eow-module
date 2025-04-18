//::////////////////////////////////////////////////////////////////////////////
//:: _x_bandage
//::////////////////////////////////////////////////////////////////////////////
/*

    Bandage execute event.

*/
//::////////////////////////////////////////////////////////////////////////////
//:: Created:   Galefer (03/12/24)
//::////////////////////////////////////////////////////////////////////////////

// INCLUDES  -------------------------------------------------------------------

#include "_i_death"

// EXECUTION  ------------------------------------------------------------------

void main()
{
    object oItem = GetItemActivated();
    object oPC = GetItemActivator();
    object oTarget = GetItemActivatedTarget();

    if (GetIsInBleedout(oTarget) == TRUE)
    {
        int iSkill = GetSkillRank(SKILL_HEAL, oPC, FALSE);
        int iRoll = d20();
        int iTotal = iSkill + iRoll;
        if (iTotal > HEAL_SAVE_DC)
        {
            SetHasStabilized(oTarget, TRUE);
            SendMessageToPC(oPC, "You manage to stop the bleeding");
            SendMessageToPC(oPC,
                "Heal: (" + IntToString(iSkill) + ") + d20: (" + IntToString(iRoll) +
                ") vs. DC: (" + IntToString(HEAL_SAVE_DC) + ")");
        } else
        {
            SendMessageToPC(oPC, "You failed to stop the bleeding");
            SendMessageToPC(oPC,
                "Heal: (" + IntToString(iSkill) + ") + d20: (" + IntToString(iRoll) +
                ") vs. DC: (" + IntToString(HEAL_SAVE_DC) + ")");
        }
    } else
    {
        SendMessageToPC(oPC, "Target is not bleeding out");
    }
}
