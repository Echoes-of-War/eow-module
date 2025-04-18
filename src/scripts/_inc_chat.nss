////////////////////////////////////////////////////////////////////////////////

#include "nw_inc_nui"

////////////////////////////////////////////////////////////////////////////////

const int CHAT_COMMANDS_ENABLED = TRUE;

////////////////////////////////////////////////////////////////////////////////

// Define a JSON array to store commands and descriptions
json jCommands = JsonArray();

// Add a command to the commands list
void AddCommandToList(string sCommand, string sDescription)
{
    json jCommand = JsonObject();
    jCommand = JsonObjectSet(jCommand, "command", JsonString(sCommand));
    jCommand = JsonObjectSet(jCommand, "description", JsonString(sDescription));
    jCommands = JsonArrayInsert(jCommands, jCommand);
}

// Function to initialize commands
void InitializeCommands()
{
    // Add all commands and their descriptions
    AddCommandToList("death", "Instantly kills the player.");
    AddCommandToList("damage", "Deals 5000 magical damage to the player.");
    AddCommandToList("damage5", "Deals 5000 magical damage to the player 5 times.");
    AddCommandToList("rez", "Resurrects the player.");
    AddCommandToList("heal", "Heals the player by 20 points.");
    AddCommandToList("summon1", "Summons a melee unit.");
    AddCommandToList("summon2", "Summons a ranged unit.");
    AddCommandToList("summon3", "Summons a mage unit.");
}

// Function to handle player chat
void HandleChatCommand(object oPC, string sMessage)
{

    if (CHAT_COMMANDS_ENABLED == FALSE)
        return;

    // Initialize commands if not already done
    if (JsonGetLength(jCommands) == 0)
    {
        InitializeCommands();
    }

    // Check if the message starts with '!' indicating a command
    if (GetStringLeft(sMessage, 1) == "!")
    {
        // Remove the '!' from the command
        string sCommand = GetStringRight(sMessage, GetStringLength(sMessage) - 1);

        // Handle specific commands
        if (sCommand == "death")
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
        }
        else if (sCommand == "damage")
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(5000, DAMAGE_TYPE_MAGICAL), oPC);
        }
        else if (sCommand == "damage5")
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
        else if (sCommand == "summon1")
        {
            CreateObject(OBJECT_TYPE_CREATURE, "x2_mephdrow009", GetLocation(oPC));
        }
        else if (sCommand == "summon2")
        {
            CreateObject(OBJECT_TYPE_CREATURE, "nw_drowrogue020", GetLocation(oPC));
        }
        else if (sCommand == "summon3")
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
