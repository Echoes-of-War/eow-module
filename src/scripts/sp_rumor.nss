//::///////////////////////////////////////////////
//:: FileName sc_011
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 8
//:://////////////////////////////////////////////
#include "loi_mythicxp"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (GetLocalInt(oPC, "RUMOR_TIMER") == 0){
    // Make sure the player has rolled above 25 on Diplomacy
        if(GetSkillRank(SKILL_PERSUADE, oPC) + d20(1) >= 25){
            TickMythicXp(oPC, ABILITY_CHARISMA, 5);
            SetLocalInt(oPC, "RESEARCH_TIMER", 1);
            DelayCommand(43200.0, DeleteLocalInt(oPC,"RESEARCH_TIMER" ));
            return TRUE;
        }
        else
        {
            SetLocalInt(oPC, "RESEARCH_TIMER", 1);
            DelayCommand(43200.0, DeleteLocalInt(oPC,"RESEARCH_TIMER" ));
            return FALSE;
        }
    }
    SendMessageToPC(oPC, "You are unable to ask for rumors right now");
    return FALSE;
 }
