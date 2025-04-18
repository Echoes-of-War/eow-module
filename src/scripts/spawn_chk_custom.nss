#include "te_functions"

//
// Spawn Check - Custom
//
int ParseFlagValue(string sName, string sFlag, int nDigits, int nDefault);
int ParseSubFlagValue(string sName, string sFlag, int nDigits, string sSubFlag, int nSubDigits, int nDefault);
object GetChildByTag(object oSpawn, string sChildTag);
object GetChildByNumber(object oSpawn, int nChildNum);
object GetSpawnByID(int nSpawnID);
void DeactivateSpawn(object oSpawn);
void DeactivateSpawnsByTag(string sSpawnTag);
void DeactivateAllSpawns();
void DespawnChildren(object oSpawn);
void DespawnChildrenByTag(object oSpawn, string sSpawnTag);

// - [File: spawn_chk_custom]
int SpawnCheckCustom(object oSpawn);
int SpawnCheckCustom(object oSpawn)
{
    // Initialize Values
    int nSpawnCheckCustom = GetLocalInt(oSpawn, "f_SpawnCheckCustom");

    // Block Spawn by Default
    int nProcessSpawn = FALSE;

//
// Only Make Modifications Between These Lines
// -------------------------------------------

    // Check 00
    if (nSpawnCheckCustom == 0)
    {
        // Example, Allow Spawn
        nProcessSpawn = TRUE;
    }
    //

    // Check Group Prior to Spawn
    // Henesua - at present this is unimplemented
    // intention is to prevent a spawn if the group can't bear it
    else if (nSpawnCheckCustom == 1)
    {
        //string sGroup   = GetLocalString(oSpawn, "GROUP_NAME");
        //int nChkState   = GetLocalInt(oSpawn, "GROUP_RATING_MINIMUM");
        nProcessSpawn = TRUE;
    }
    // CHECK NPC LOCATION STATUS PRIOR TO SPAWN
    // intention is to enable an NPC to move their spawn point between locations
    // example: a PC can spawn at either location 1, 2, or 3 depending on a quest state.
    // this script runs a custom schedule script (if the NPC has one)
    // then it checks the database for the NPCs location state (location state is always an integer)
    else if (nSpawnCheckCustom == 2)
    {
        string character_id = GetLocalString(oSpawn, "character_id");
        if(character_id=="")
        {
            object oTemp    = CreateObject(OBJECT_TYPE_CREATURE,GetLocalString(oSpawn,"NESS_TAG"),GetLocation(GetWaypointByTag("wp_temp_location")));

            character_id= GetPCID(oTemp);

            SetLocalString(oSpawn, "character_id",character_id);
            DestroyObject(oTemp,0.1);
        }

        string sNPCSchedule = GetLocalString(oSpawn,"NPC_SCHEDULE_SCRIPT");
        if(sNPCSchedule!="")
            ExecuteScript(sNPCSchedule,oSpawn);

        int nLocationID = GetLocalInt(oSpawn,"NPC_LOCATION_ID");
        if(GetCreatureLocationState(character_id)==nLocationID)
            nProcessSpawn = TRUE;
    }
    // Reproducing Predators
    else if (nSpawnCheckCustom == 10)
    {
        int nChildren = GetLocalInt(oSpawn, "ChildrenSpawned");
        if (nChildren >= 10)
        {
            int nHappy = 0;
            int nPredators;
            int nNth = 1;
            object oPredator = GetNearestObject(OBJECT_TYPE_CREATURE, oSpawn, nNth);
            while (oPredator != OBJECT_INVALID)
            {
                if (GetLocalInt(oPredator, "Predator") == TRUE)
                {
                    nPredators++;
                    if (GetLocalInt(oPredator, "CurrentHungerState") > 0)
                    {
                        nHappy++;
                    }
                }
                nNth++;
                oPredator = GetNearestObject(OBJECT_TYPE_CREATURE, oSpawn, nNth);
            }
            SendMessageToAllDMs("There are " + IntToString(nPredators) + " Predators Alive.");
            if (nHappy >= 2)
            {
                nProcessSpawn = TRUE;
            }
        }
        else
        {
            nProcessSpawn = TRUE;
        }
        if (nProcessSpawn == TRUE)
        {
            SendMessageToAllDMs("A Predator is Born!");
        }
    }
    //

    // Mark Spawn Point processed at night
    else if (nSpawnCheckCustom == 11)
    {
        if (GetIsDawn() == TRUE || GetIsDay() == TRUE)
        {
            nProcessSpawn = TRUE;
            SetLocalInt(oSpawn, "SpawnProcessed", FALSE);
        }
        else
        {
            int nSpawnProcessed = GetLocalInt(oSpawn, "SpawnProcessed");
            if (nSpawnProcessed == FALSE)
            {
                nProcessSpawn = TRUE;
                SetLocalInt(oSpawn, "SpawnProcessed", TRUE);
            }
        }
    }
    //
// -------------------------------------------
// Only Make Modifications Between These Lines
//

    // Return whether Spawn can Proceed
    return nProcessSpawn;
}
