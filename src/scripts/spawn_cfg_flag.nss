//
// Spawn Flags
//
void SpawnFlags(object oSpawn, int nFlagTableNumber)
{
    // Initialize Values
    string sSpawnName = GetLocalString(oSpawn, "f_Flags");
    string sSpawnTag = GetLocalString(oSpawn, "f_Template");
    string sFlags, sTemplate;

//
// Only Make Modifications Between These Lines
// -------------------------------------------


    // Sample Complex Replacement
    // Using FT without FT00 will
    // Default to nFlagTableNumber 0
    if (nFlagTableNumber == 0)
    {
        // Old Method of using SpawnTag
        if (sSpawnTag == "myspawns")
        {
            sFlags = "SP_SN02_SA_RW";
            sTemplate = "NW_DOG";
        }

        if (sSpawnTag == "undead")
        {
            sFlags = "SP_SNO4";
            sTemplate = "NW_ZOMBIE01";
        }
    }
    //

    // Sample Simple Replacement Flag
    // Completely Replaces Flags
    // On Spawnpoints with FT01
    if (nFlagTableNumber == 1)
    {
        sFlags = "SP_SN04_RW_DOD";
        sTemplate = "NW_DOG";
    }
    //

    // Sample Template Flags
    // These Flags Get Added
    // To Spawnpoints with FT02
    if (nFlagTableNumber == 2)
    {
        sFlags = "_RW_PC05R";
    }
    //

    if(nFlagTableNumber == 10)
    {
        string sOwner      = GetLocalString(oSpawn,"sOwner");
        string sSetOwner   = GetCampaignString("Settlement",sOwner+"_sOwner");
        int    nGuardGroup = GetLocalInt(oSpawn,"GuardGroup");
        if(sSetOwner == "") {sTemplate = "";}
        else if (sSetOwner == "sLock")
        {
            switch (nGuardGroup)
            {
                case 1: sTemplate = "sg_lockpf"; break;
                case 2: sTemplate = "sg_lockpa"; break;
                case 3: sTemplate = "sg_lockga"; break;
                case 4: sTemplate = "sg_lockkf"; break;
                case 5: sTemplate = "sg_lockka"; break;
                default: sTemplate = "sg_lockpf";
            }
        }
        else if (sSetOwner == "sTejarn")
        {
            switch (nGuardGroup)
            {
                case 1: sTemplate = "sg_tejpf"; break;
                case 2: sTemplate = "sg_tejpa"; break;
                case 3: sTemplate = "sg_tejga"; break;
                case 4: sTemplate = "sg_tejkf"; break;
                case 5: sTemplate = "sg_tejka"; break;
                default: sTemplate = "sg_tejka";
            }
        }
        else if (sSetOwner == "sSwamp")
        {
            switch (nGuardGroup)
            {
                case 1: sTemplate = "sg_swapf"; break;
                case 2: sTemplate = "sg_swapa"; break;
                case 3: sTemplate = "sg_swaga"; break;
                case 4: sTemplate = "sg_swakf"; break;
                case 5: sTemplate = "sg_swaka"; break;
                default: sTemplate = "sg_swapf";
            }
        }
        else if (sSetOwner == "sSpire")
        {
            switch (nGuardGroup)
            {
                case 1: sTemplate = "sg_spipf"; break;
                case 2: sTemplate = "sg_spipa"; break;
                case 3: sTemplate = "sg_spiga"; break;
                case 4: sTemplate = "sg_spikf"; break;
                case 5: sTemplate = "sg_spika"; break;
                default: sTemplate = "sg_spipf";
            }
        }
        else if (sSetOwner == "sBrost")
        {
            switch (nGuardGroup)
            {
                case 1: sTemplate = "sg_bropf"; break;
                case 2: sTemplate = "sg_bropa"; break;
                case 3: sTemplate = "sg_broga"; break;
                case 4: sTemplate = "sg_brokf"; break;
                case 5: sTemplate = "sg_broka"; break;
                default: sTemplate = "sg_bropf";
            }
        }
        else
        {sTemplate = sSpawnTag;}
        sFlags = sSpawnName+"_SD60";

    }

// -------------------------------------------
// Only Make Modifications Between These Lines
//

    // Record Values
    if (sFlags != "")
    {
        SetLocalString(oSpawn, "f_Flags", sFlags);
    }
    else
    {
        SetLocalString(oSpawn, "f_Flags", sSpawnName);
    }
    if (sTemplate != "")
    {
        SetLocalString(oSpawn, "f_Template", sTemplate);
    }
    else
    {
        SetLocalString(oSpawn, "f_Template", sSpawnTag);
    }
}
