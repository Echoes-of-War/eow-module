//::///////////////////////////////////////////////
//:: Name: Q Module OnPlayerChat Event
//:: FileName: q_acp_onchat
//:: Website: http://www.qnwn.net
//:: Contact: projectq@qnwn.net
//:://////////////////////////////////////////////
/*
    Project Q - Release 1.
*/
//:://////////////////////////////////////////////
//:: Created By: thurgood
//:: Created On: 17 August 2009
//:://////////////////////////////////////////////
#include "q_inc_acp"

void main()
{
    // who are we working with?
    object oPC = GetPCChatSpeaker();

    // get the chat string in lower case
    string sText = GetStringLowerCase(GetPCChatMessage());

    Q_ACPCheckChat(oPC, sText);
}
