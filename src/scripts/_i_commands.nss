//::////////////////////////////////////////////////////////////////////////////
//:: _i_commands
//::////////////////////////////////////////////////////////////////////////////
/*

    Simple chat command system for debugging purposes.

*/
//::////////////////////////////////////////////////////////////////////////////
//:: Created:   Galefer (01/12/24)
//::////////////////////////////////////////////////////////////////////////////

// INCLUDES  -------------------------------------------------------------------

#include "nw_inc_nui"
#include "_i_generic"
#include "_i_death"

// GLOBALS ---------------------------------------------------------------------

// Prefix for chat commands.
string sPrefix = "!";

// DECLARATIIONS ---------------------------------------------------------------

// Define a JSON array to store commands and descriptions
json jCommands = JsonArray();

// Add a command to the commands list
void AddCommandToList(string sCommand, string sDescription);

// Function to initialize commands
void InitializeCommands();

// Function to handle player chat
void HandleChatCommand(object oPC, string sMessage);

// IMPLEMENTATIONS -------------------------------------------------------------

void AddCommandToList(string sCommand, string sDescription)
{
    json jCommand = JsonObject();
    jCommand = JsonObjectSet(jCommand, "command", JsonString(sPrefix+sCommand));
    jCommand = JsonObjectSet(jCommand, "description", JsonString(sDescription));
    jCommands = JsonArrayInsert(jCommands, jCommand);
}

void InitializeCommands()
{
    // Add all commands and their descriptions
    AddCommandToList("bleedout", "Instantly p the player.");
    AddCommandToList("die", "Instantly kills the player, ignoring bleedout.");
    AddCommandToList("dmg", "Deals 5000 magical damage to the player.");
    AddCommandToList("dmg5", "Deals 5000 magical damage to the player 5 times.");
    AddCommandToList("rez", "Resurrects the player.");
    AddCommandToList("heal", "Heals the player by 20 points.");
    AddCommandToList("deathinfo", "Print info about death systems.");
    AddCommandToList("killall", "Kill all hostiles in area.");
    AddCommandToList("sum1", "Summons a weak bear.");
    AddCommandToList("sum2", "Summons a bear.");
    AddCommandToList("sum3", "Summons a strong bear.");
    AddCommandToList("sum4", "Summons a melee drow [OP].");
    AddCommandToList("sum5", "Summons a ranged drow [OP].");
    AddCommandToList("sum6", "Summons a mage drow [OP].");
}

void HandleChatCommand(object oPC, string sMessage)
{

    int iDebugMode = GetDebugMode();
    if (iDebugMode == FALSE)
        return;

    // Initialize commands if not already done
    if (JsonGetLength(jCommands) == 0)
    {
        InitializeCommands();
    }

    // Check if the message starts with '!' indicating a command
    if (GetStringLeft(sMessage, 1) == sPrefix)
    {

        sMessage = GetStringLowerCase(sMessage);

        // Remove the '!' from the command
        string sCommand = GetStringRight(sMessage, GetStringLength(sMessage) - 1);

        // Handle specific commands
        if (sCommand == "die")
        {
            DoDeath(oPC);
        }
        else if (sCommand == "bleedout")
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(5000, DAMAGE_TYPE_MAGICAL), oPC);
        }
        else if (sCommand == "dmg")
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(5000, DAMAGE_TYPE_MAGICAL), oPC);
        }
        else if (sCommand == "dmg5")
        {
            int i;
            for (i = 0; i < 5; i++)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(5000, DAMAGE_TYPE_MAGICAL), oPC);
            }
        }
        else if (sCommand == "rez")
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
        }
        else if (sCommand == "heal")
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(20), oPC);
        }
        else if (sCommand == "deathinfo")
        {
            int iLives = PVPGetRemainingLives(oPC);
            int iClosure = GetPlayerClosure(oPC);
            int iGhost = GetIsGhost(oPC);
        }
        else if (sCommand == "killall")
        {
            object oArea = GetArea(oPC);
            object oCreature = GetFirstObjectInArea(oArea);

            while (GetIsObjectValid(oCreature))
            {
                // Check if the object is a creature and belongs to the hostile faction
                if (GetObjectType(oCreature) == OBJECT_TYPE_CREATURE && GetIsReactionTypeHostile(oPC, oCreature))
                {
                    DestroyObject(oCreature);
                }

                // Move to the next object in the area
                oCreature = GetNextObjectInArea(oArea);
            }
        }
        else if (sCommand == "sum1")
        {
            CreateObject(OBJECT_TYPE_CREATURE, "nw_bearblck", GetLocation(oPC));
        }
        else if (sCommand == "sum2")
        {
            CreateObject(OBJECT_TYPE_CREATURE, "nw_bearbrwn", GetLocation(oPC));
        }
        else if (sCommand == "sum3")
        {
            CreateObject(OBJECT_TYPE_CREATURE, "nw_beardire", GetLocation(oPC));
        }
        else if (sCommand == "sum4")
        {
            CreateObject(OBJECT_TYPE_CREATURE, "x2_mephdrow009", GetLocation(oPC));
        }
        else if (sCommand == "sum5")
        {
            CreateObject(OBJECT_TYPE_CREATURE, "nw_drowrogue020", GetLocation(oPC));
        }
        else if (sCommand == "sum6")
        {
            CreateObject(OBJECT_TYPE_CREATURE, "x2_mephdrow012", GetLocation(oPC));
        }
        else if (sCommand == "help")
        {
            // Display all available commands and their descriptions
            int i;
            for (i = 0; i < JsonGetLength(jCommands); i++)
            {
                json jCommand = JsonArrayGet(jCommands, i);
                string sCmd = JsonGetString(JsonObjectGet(jCommand, "command"));
                string sDesc = JsonGetString(JsonObjectGet(jCommand, "description"));
                SendMessageToPC(oPC, sCmd + ": " + sDesc);
            }
        }
        else
        {
            SendMessageToPC(oPC, "Unknown command: " + sCommand);
        }
    }
}
