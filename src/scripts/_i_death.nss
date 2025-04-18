//::////////////////////////////////////////////////////////////////////////////
//:: _i_death
//::////////////////////////////////////////////////////////////////////////////
/*

    Death system include.

*/
//::////////////////////////////////////////////////////////////////////////////
//:: Created:   Galefer (03/12/24)
//::////////////////////////////////////////////////////////////////////////////

// INCLUDES  -------------------------------------------------------------------

#include "_i_generic"

// GLOBALS ---------------------------------------------------------------------

const string DEATH_DATABASE = "DEATH_DATABASE";

const string IS_IN_BLEEDOUT = "IS_IN_BLEEDOUT";
const string BLEEDOUT_HP = "BLEEDOUT_HP";
const string HAS_BLED_OUT = "HAS_BLED_OUT";
const string BLEED_STABILIZED = "BLEED_STABILIZED";

const int DAMAGE_TYPE_TRUE = 123456; // placeholder for true damage

const string GHOST_AREA = "GHOST_AREA";
const string GHOST_PLAYER = "GHOST_PLAYER";
const string ORIGINAL_APPEARANCE = "ORIGINAL_APPEARANCE";

const string PC_CLOSURE = "PC_CLOSURE";
const string PVP_LIVES = "PVP_LIVES";
const string PVP_LIVES_INIT = "PVP_LIVES_INIT";

// MODIFIABLES -----------------------------------------------------------------

// Death Saves

// How many seconds between each death save tick.
const float SECONDS_PER_DEATH_SAVE = 5.0;

// The dice value of the death roll.
const int DEATH_SAVE_ROLL = 100;

// The save required to pass a death save.
const int DEATH_SAVE_DC = 90;

// The HP at which the player bleeds out and dies.
// Note: Cannot be decreased below -9 without settings changes.
const int DEATH_HP_CLAMP = -9;

// Healing & Stabilization

// Amount to heal the player per stabilized tick.
const int STABILIZED_HEAL = 1;

// Whether to use CON modifier as part of the stabilized heal tick.
const int STABILIZED_HEAL_CON = FALSE;

// The DC used against the heal skill when attempting to use a bandage.
const int HEAL_SAVE_DC = 15;

// On Death

// Which appearance should a dead player (ghost) use.
const int DEATH_MODEL_APPEARANCE = APPEARANCE_TYPE_ALLIP;

// This toggles whether players should drop their inventory on death.
const int DROP_INVENTORY_ON_DEATH = TRUE;

// This toggles whether players should drop their equipped items on death.
const int DROP_EQUIPPED_ON_DEATH = TRUE;

// This toggles whether players should drop their gold  on death.
const int DROP_GOLD_ON_DEATH = TRUE;

// This is the level the player begins dropping their inventory.
const int LEVEL_PLAYER_DROPS_INVENTORY = 5;

// On Respawn

// This is the level the player begins paying for respawns.
const int LEVEL_PLAYER_PAYS_ON_RESPAWN = 5;

// The price of XP per respawn. The value is multiplied by player level.
const int XP_PER_LEVEL_PER_RESPAWN = 1000;

// When respawning, a player cannot drop below this level.
const int MINIMUM_LEVEL_FROM_RESPAWNING = 5;

// Respawn waypoint, for alternative respawns
const string WP_RESPAWN = "wp_respawn";

// PvP

// How many PvP lives a player begins with by default.
const int PVP_LIVES_BASE = 3;

// DECLARATIIONS ---------------------------------------------------------------

void InitiateBleedout(object oPC);
void DeInitiateBleedout(object oPC, int iDeath);

int GetIsInBleedout(object oPC);
void SetIsInBleedout(object oPC, int iState);

int GetBleedoutHP(object oPC);
int SetBleedoutHP(object oPC, int iHP);

void DoBleedoutStart(object oPC);
void DoBleedoutTick(object oPC);
void DoBleedoutAttacked(object oPC);

void SetHasBledOut(object oPC, int iState);
int GetHasBledOut(object oPC);
void HandleBleedoutDeath(object oPC);

void DoDeathSave(object oPC);
int GetDeathSave(object oPC, int iTriggered = FALSE);

int GetHasStabilized(object oPC);
void SetHasStabilized(object oPC, int iState);

void DoPlayerRecovery(object oPC, int iHP);
int GetPlayerRecoveryValue(object oPC);

// Afterdeath
object GetCorpse(object oPC);
object CreateCorpse(object oPC);
void RespawnPlayerAtCorpse(object oCorpse);

void DoDeath(object oPC);
void DropInventory(object oPC, object oCorpse);

int GetIsGhost(object oPC);
void SetIsGhost(object oPC, int iState);

int GetIsGhostArea(object oArea);
object CreateGhostArea(object oArea);

object SetupGhostArea(object oArea);

// PvP
void PVPSetRemainingLives(object oPC, int iLives);
int PVPGetRemainingLives(object oPC);

void SetPlayerClosure(object oPC, int iState);
int GetPlayerClosure(object oPC);

// IMPLEMENTATIONS -------------------------------------------------------------

// Bleedout Functions

void InitiateBleedout(object oPC)
{
    // If we're repeating this function because the player bled out
    if (GetHasBledOut(oPC) == TRUE)
    {
        SetHasBledOut(oPC, FALSE);
        SetIsInBleedout(oPC, FALSE);
        return;
    }

    if (GetIsInBleedout(oPC) == TRUE)
    {
        // do nothing
    } else
    {
        // Messy chain to set the PC to 0hp
        effect eRez = EffectResurrection();
        effect eDamage = EffectDamage(1, DAMAGE_TYPE_CUSTOM19, DAMAGE_POWER_ENERGY);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, oPC);
        SetCurrentHitPoints(oPC, 1);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);

        int iPlot = GetPlotFlag(oPC);
        if (iPlot == FALSE)
            SetPlotFlag(oPC, TRUE);

        SetIsInBleedout(oPC, TRUE);
        DoBleedoutStart(oPC);
    }
}

void DeInitiateBleedout(object oPC, int iDeath)
{
    if (iDeath == TRUE)
    {
        if (GetIsInBleedout(oPC) == FALSE)
        {
            // do nothing
        } else
        {
            int iPlot = GetPlotFlag(oPC);
            if (iPlot == TRUE)
                SetPlotFlag(oPC, FALSE);
            effect eDeath = EffectDeath();
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oPC);
            SetHasBledOut(oPC, TRUE);
            SetHasStabilized(oPC, FALSE);
            DoDeath(oPC);
        }
    } else
    {
        if (GetIsInBleedout(oPC) == FALSE)
        {
            // do nothing
        } else
        {
            SetIsInBleedout(oPC, FALSE);
            SetHasStabilized(oPC, FALSE);
            int iPlot = GetPlotFlag(oPC);
            if (iPlot == TRUE)
                SetPlotFlag(oPC, FALSE);
        }
    }
}

void DoBleedoutTick(object oPC)
{
    int iBleedout = GetIsInBleedout(oPC);
    if (iBleedout == TRUE)
    {
        if (GetCurrentHitPoints(oPC) > 0)
        {
            DeInitiateBleedout(oPC, FALSE);
        }  else
        {
            int iStabilized = GetHasStabilized(oPC);
            if (iStabilized == FALSE)
            {
                int iSave = GetDeathSave(oPC);
                int iHP = GetBleedoutHP(oPC);

                if (iSave == TRUE)
                {
                    SetHasStabilized(oPC, TRUE);
                } else
                {
                    iHP = --iHP;
                    SetBleedoutHP(oPC, iHP);
                }

                if (iHP <= DEATH_HP_CLAMP)
                {
                    HandleBleedoutDeath(oPC);
                } else if  (iHP > 0)
                {
                    DoPlayerRecovery(oPC, iHP);
                    DeInitiateBleedout(oPC, FALSE);
                } else
                {
                    DelayCommand(SECONDS_PER_DEATH_SAVE, DoBleedoutTick(oPC));
                }
            } else
            {
                int iHP = GetBleedoutHP(oPC);
                int iRecovery = GetPlayerRecoveryValue(oPC);
                iHP = iHP + iRecovery;
                SetBleedoutHP(oPC, iHP);
                if  (iHP > 0)
                {
                    SendMessageToPC(oPC, "You have recovered.");
                    DoPlayerRecovery(oPC, iHP);
                    DeInitiateBleedout(oPC, FALSE);
                } else
                {
                    SendMessageToPC(oPC, "You are stabilized and recovering.");
                    DelayCommand(SECONDS_PER_DEATH_SAVE, DoBleedoutTick(oPC));
                }
            }
        }
    }
}

void DoBleedoutStart(object oPC)
{
    SendMessageToPC(oPC, "You are bleeding out. You will make a death save every " + IntToString(FloatToInt(SECONDS_PER_DEATH_SAVE)) + " seconds.");
    SetBleedoutHP(oPC, -1);
    DelayCommand(SECONDS_PER_DEATH_SAVE, DoBleedoutTick(oPC));
}

void DoBleedoutAttacked(object oPC)
{
    int iBleedout = GetIsInBleedout(oPC);
    if (iBleedout == TRUE)
    {
        int iStabilized = GetHasStabilized(oPC);
        if (iStabilized == TRUE)
        {
            SetHasStabilized(oPC, FALSE);
        }

        int iSave = GetDeathSave(oPC, TRUE);
        if (iSave == FALSE)
        {
            int iHP = GetBleedoutHP(oPC);
            iHP = --iHP;
            if (iHP <= DEATH_HP_CLAMP)
            {
                HandleBleedoutDeath(oPC);
            } else
            {
                SetBleedoutHP(oPC, iHP);
            }
        }
    }
}

void HandleBleedoutDeath(object oPC)
{
    SendMessageToPC(oPC, "You have bled out and died.");
    DeInitiateBleedout(oPC, TRUE);
}

int GetDeathSave(object oPC, int iTriggered = FALSE)
{
    string sBaseColor = "<cfÌÿ>";
    string sFailureColor = "<cÿ;I>"; // Red color for failure
    string sSuccessColor = "<coþ(>"; // Green color for success
    string sEndColor = "</c>"; // End color tag

    int iDice = DEATH_SAVE_ROLL;
    int iDC = DEATH_SAVE_DC;
    int iRoll = Random(iDice);
    string sSave;
    int iSave;

    if (iRoll > iDC)
    {
        iSave = TRUE;
        sSave = sSuccessColor+"Passed"+sEndColor;
    } else
    {
        iSave = FALSE;
        sSave = sFailureColor+"Failed"+sEndColor;
    }

    if (iTriggered == FALSE)
    {
        SendMessageToPC(oPC, sBaseColor+"Death Save ("+sSave+sBaseColor+") Roll: ("+IntToString(iRoll)+") DC: ("+IntToString(iDC)+")"+sEndColor);
    }
    else
    {
        SendMessageToPC(oPC, "You were hit while down! "+sBaseColor+"Death Save ("+sSave+sBaseColor+") Roll: ("+IntToString(iRoll)+") DC: ("+IntToString(iDC)+")"+sEndColor);
    }

    return iSave;
}

int GetIsInBleedout(object oPC)
{
    int iBleedout = GetCampaignInt(DEATH_DATABASE, IS_IN_BLEEDOUT, oPC);
    return iBleedout;
}

void SetIsInBleedout(object oPC, int iState)
{
    SetCampaignInt(DEATH_DATABASE, IS_IN_BLEEDOUT, iState, oPC);
}

int GetBleedoutHP(object oPC)
{
    int iHP = GetCampaignInt(DEATH_DATABASE, BLEEDOUT_HP, oPC);
    return iHP;
}

void SetBleedoutHP(object oPC, int iHP)
{
    SetCampaignInt(DEATH_DATABASE, BLEEDOUT_HP, iHP, oPC);
    SetCurrentHitPoints(oPC, iHP);
}


int GetHasStabilized(object oPC)
{
    int iStabilized = GetCampaignInt(DEATH_DATABASE, BLEED_STABILIZED, oPC);
    return iStabilized;
}

void SetHasStabilized(object oPC, int iState)
{
    SetCampaignInt(DEATH_DATABASE, BLEED_STABILIZED, iState, oPC);

    if (iState == TRUE)
    {
        SendMessageToPC(oPC, "You have stabilized and you're slowly recovering.");
    } else if (iState == FALSE)
    {

    }
}

void DoPlayerRecovery(object oPC, int iHP)
{
    effect eRez = EffectResurrection();
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, oPC);
    SetCurrentHitPoints(oPC, iHP);
}

int GetPlayerRecoveryValue(object oPC)
{
    int iHP;
    int iVariableHP = STABILIZED_HEAL;
    if (iVariableHP == 0)
    {
        iHP = 1;
    } else
    {
        iHP = iHP + iVariableHP;
    }

    if (STABILIZED_HEAL_CON == TRUE)
    {
        iHP = iHP + GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
    }

    if (iHP < 1)
        iHP = 1;

    return iHP;
}

void SetHasBledOut(object oPC, int iState)
{
    SetCampaignInt(DEATH_DATABASE, BLEED_STABILIZED, iState, oPC);
}

int GetHasBledOut(object oPC)
{
    int iBledOut = GetCampaignInt(DEATH_DATABASE, HAS_BLED_OUT, oPC);
    return iBledOut;
}

////////////////////////////////////////////////////////////////////////////////

// Afterdeath Functions

void PayRespawnCost(object oPC)
{
    int XP_FOR_LEVEL_5 = 10000;

    int nLevel = GetHitDice(oPC);

    SendDebugMessage("PC Level is " + IntToString(nLevel), oPC, "PayRespawnCost");

    if (nLevel >= MINIMUM_LEVEL_FROM_RESPAWNING)
    {
        int nXPCost = XP_PER_LEVEL_PER_RESPAWN * nLevel;
        int nCurrentXP = GetXP(oPC);
        int nNewXP = nCurrentXP - nXPCost;

        SendDebugMessage("Current XP: " + IntToString(nCurrentXP), oPC, "PayRespawnCost");
        SendDebugMessage("XP Cost: " + IntToString(nXPCost), oPC, "PayRespawnCost");
        SendDebugMessage("New XP after deduction: " + IntToString(nNewXP), oPC, "PayRespawnCost");

        if (nNewXP < XP_FOR_LEVEL_5)
        {
            nNewXP = XP_FOR_LEVEL_5;
            SendDebugMessage("Adjusted New XP to minimum threshold: " + IntToString(nNewXP), oPC, "PayRespawnCost");
        }

        SetXP(oPC, nNewXP);
    }
}

void DoGhostRespawn(object oPC, object oShrine)
{
    SendDebugMessage("Started", oPC, "DoGhostRespawn");

    object oGhostArea = GetArea(oPC);
    string sShrine = GetTag(oShrine);
    string sGhostTag = GetTag(oGhostArea);
    string sOriginalTag = GetSubString(sGhostTag, 6, GetStringLength(sGhostTag) - 6);

    SendDebugMessage("Shrine Tag: " + sShrine, oPC, "DoGhostRespawn");
    SendDebugMessage("Original Tag extracted: " + sOriginalTag, oPC, "DoGhostRespawn");

    object oOrigArea = GetObjectByTag(sOriginalTag);
    object oOrigShrine = GetObjectInArea(oOrigArea, sShrine);

    ClearAndJump(oPC, oOrigShrine);
    SendDebugMessage("PC moved to original shrine.", oPC, "DoGhostRespawn");

    PayRespawnCost(oPC);
    SetIsGhost(oPC, FALSE);

    SendDebugMessage("Completed", oPC, "DoGhostRespawn");
}

void DropInventory(object oPC, object oCorpse)
{
    SendDebugMessage("Started", oPC, "DropInventory");

    if (DROP_INVENTORY_ON_DEATH && GetHitDice(oPC) >= LEVEL_PLAYER_DROPS_INVENTORY)
    {
        object oItem = GetFirstItemInInventory(oPC);
        while (GetIsObjectValid(oItem))
        {
            if (GetPlotFlag(oItem) == FALSE)
            {
                object oNewItem = CopyItem(oItem, oCorpse, TRUE);
                DestroyObject(oItem);
                SendDebugMessage("Dropped item: " + GetName(oItem), oPC, "DropInventory");
            }
            oItem = GetNextItemInInventory(oPC);
        }
    }

    if (DROP_EQUIPPED_ON_DEATH && GetHitDice(oPC) >= LEVEL_PLAYER_DROPS_INVENTORY)
    {
        int nSlot;
        for (nSlot = 0; nSlot < NUM_INVENTORY_SLOTS; nSlot++)
        {
            object oEquippedItem = GetItemInSlot(nSlot, oPC);
            if (GetIsObjectValid(oEquippedItem) && GetPlotFlag(oEquippedItem) == FALSE)
            {
                object oNewItem = CopyItem(oEquippedItem, oCorpse, TRUE);
                DestroyObject(oEquippedItem);
                SendDebugMessage("Dropped equipped item: " + GetName(oEquippedItem), oPC, "DropInventory");
            }
        }
    }

    if (DROP_GOLD_ON_DEATH && GetHitDice(oPC) >= LEVEL_PLAYER_DROPS_INVENTORY)
    {
        int nGoldAmount = GetGold(oPC);
        SendDebugMessage("Gold amount to drop: " + IntToString(nGoldAmount), oPC, "DropInventory");
        TakeGoldFromCreature(nGoldAmount, oPC, TRUE);
        GiveGoldToCreature(oCorpse, nGoldAmount);
    }

    SendDebugMessage("Completed", oPC, "DropInventory");
}

object GetCorpse(object oPC)
{
    string sID = GetLastCharacters(GetObjectUUID(oPC), 10);
    string sCorpse = "corpse_" + sID;

    SendDebugMessage("Generated Corpse Tag: " + sCorpse, oPC, "GetCorpse");

    object oCorpse = GetObjectByTag(sCorpse);
    return oCorpse;
}

object CreateCorpse(object oPC)
{
    SendDebugMessage("Started", oPC, "CreateCorpse");

    object oPreviousCorpse = GetCorpse(oPC);
    if (oPreviousCorpse != OBJECT_INVALID)
    {
        DestroyObject(oPreviousCorpse);
        SendDebugMessage("Destroyed previous corpse.", oPC, "CreateCorpse");
    }

    string sID = GetLastCharacters(GetObjectUUID(oPC), 10);
    string sCorpse = "corpse_" + sID;
    location lLocation = GetLocation(oPC);
    object oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE, "corpse", lLocation);
    SetLocalObject(oCorpse, "OWNER", oPC);
    SetTag(oCorpse, sCorpse);
    SendDebugMessage("Created new corpse with tag: " + sCorpse, oPC, "CreateCorpse");

    return oCorpse;
}

void RespawnPlayerAtCorpse(object oCorpse)
{
    object oOwner = GetLocalObject(oCorpse, "OWNER");
    if (oOwner == OBJECT_INVALID || GetPlayerClosure(oOwner) == TRUE)
    {
        AssignCommand(oCorpse, SpeakString("You couldn't reach the soul belonging to this corpse."));
    }
    else
    {
        int iLives = PVPGetRemainingLives(oOwner);
        if (iLives <= 0)
            PVPSetRemainingLives(oOwner, 1);
        SetIsGhost(oOwner, FALSE);
        ClearAndJump(oOwner, oCorpse);
    }
}

void DoDeath(object oPC)
{
    object oCorpse = CreateCorpse(oPC);
    string sCorpseTag = GetTag(oCorpse);
    object oHostileActor = GetLocalObject(oPC, "LAST_HOSTILE");

    SendDebugMessage("Last Hostile Actor: " + GetName(oHostileActor), oPC, "DoDeath");

    int iRemainingLives = PVPGetRemainingLives(oPC);

    if (GetIsPC(oHostileActor) == TRUE)
    {
        object oKiller = oHostileActor;
        int iLives = PVPGetRemainingLives(oPC);
        iRemainingLives = --iLives;

        SendMessageToPC(oPC, "You were killed in PvP by: " + GetName(oKiller));
        SendMessageToPC(oPC, "You have " + IntToString(iRemainingLives) + " PvP lives remaining");
        SendDebugMessage("PvP Death. Remaining lives: " + IntToString(iRemainingLives), oPC, "DoDeath");

        PVPSetRemainingLives(oPC, iRemainingLives);
    }

    if (iRemainingLives <= 0 && GetIsPC(oHostileActor) == TRUE)
    {
        effect eRez = EffectResurrection();
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, oPC);
        DropInventory(oPC, oCorpse);
        DelayCommand(0.1, ClearAndJump(oPC, GetWaypointByTag("wp_permadeath")));
        SendDebugMessage("Permadeath triggered. PC moved to waypoint.", oPC, "DoDeath");
    }
    else
    {
        object oArea = GetArea(oPC);
        object oGhostArea = CreateGhostArea(oArea);

        SendDebugMessage("Is oGhostArea valid: " + DebugBoolean(GetIsObjectValid(oGhostArea)), oPC, "DoDeath");

        effect eRez = EffectResurrection();
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, oPC);

        SetIsGhost(oPC, TRUE);
        DropInventory(oPC, oCorpse);

        object oGhostCorpse = GetObjectInArea(oGhostArea, sCorpseTag);
        SetTag(oGhostCorpse, "ghostcorpse");

//        SendDebugMessage("Is oGhostCorpse valid: " + DebugBoolean(GetIsObjectValid(oGhostCorpse)), oPC, "DoDeath");
//        SendDebugMessage("oGhostCorpse Location: " + GetName(GetArea(oGhostCorpse)), oPC, "DoDeath");

        string sID = GetLastCharacters(GetObjectUUID(oPC), 10);
        string sCorpse = "corpse_" + sID;
//        object oOldCorpse = GetObjectInArea(oGhostArea, sCorpse);
//        DestroyObject(oOldCorpse);
        DestroyObject(oGhostCorpse);

        location lCurrent = GetLocation(oPC);
        vector vPosition = GetPositionFromLocation(lCurrent);
        float fFacing = GetFacingFromLocation(lCurrent);
        location lNewLocation = Location(oGhostArea, vPosition, fFacing);

        DelayCommand(0.1, ClearAndJumpToLocation(oPC, lNewLocation));
        SendDebugMessage("Ghost respawn executed for PC.", oPC, "DoDeath");
    }
}

int GetIsGhost(object oPC)
{
    SendDebugMessage("Checking if PC is a ghost.", oPC, "GetIsGhost");
    int iGhost = GetCampaignInt(DEATH_DATABASE, GHOST_PLAYER, oPC);
    SendDebugMessage("Ghost state is " + IntToString(iGhost), oPC, "GetIsGhost");
    return iGhost;
}

void SetIsGhost(object oPC, int iState)
{
    SendDebugMessage("Setting ghost state for PC to " + IntToString(iState), oPC, "SetIsGhost");
    if (iState == TRUE)
    {
        SetCampaignInt(DEATH_DATABASE, GHOST_PLAYER, TRUE, oPC);
        SetCreatureAppearanceType(oPC, DEATH_MODEL_APPEARANCE);

        effect eGhostSpeed = EffectMovementSpeedIncrease(100);
        TagEffect(eGhostSpeed, "EFFECT_GHOST");

        int iPlot = GetPlotFlag(oPC);
        if (iPlot == FALSE)
        {
            SetPlotFlag(oPC, TRUE);
            SendDebugMessage("Plot flag set to TRUE for ghost.", oPC, "SetIsGhost");
        }
    }
    else
    {
        int iOrigApp = GetCampaignInt(DEATH_DATABASE, ORIGINAL_APPEARANCE, oPC);
        SendDebugMessage("Original appearance ID is: " + IntToString(iOrigApp), oPC, "GetIsGhost");
        SetCampaignInt(DEATH_DATABASE, GHOST_PLAYER, FALSE, oPC);
        SetCreatureAppearanceType(oPC, iOrigApp);

        RemoveEffectsByTag(oPC, "EFFECT_GHOST");

        int iPlot = GetPlotFlag(oPC);
        if (iPlot == TRUE)
        {
            SetPlotFlag(oPC, FALSE);
            SendDebugMessage("Plot flag reset to FALSE for non-ghost.", oPC, "SetIsGhost");
        }
    }
    SendDebugMessage("Completed setting ghost state for PC.", oPC, "SetIsGhost");
}

int GetIsGhostArea(object oArea)
{
    SendDebugMessage("Checking if area is a ghost area.", oArea, "GetIsGhostArea");
    int iGhostArea = GetLocalInt(oArea, GHOST_AREA);
    SendDebugMessage("Ghost area state is " + IntToString(iGhostArea), oArea, "GetIsGhostArea");
    return iGhostArea;
}

object CreateGhostArea(object oArea)
{
    SendDebugMessage("Creating ghost area from area.", oArea, "CreateGhostArea");

    string sTag = GetTag(oArea);
    string sResRef = GetResRef(oArea);
    string sName = GetName(oArea);
    object oNewArea;

    SendDebugMessage("Area Tag: " + sTag + ", ResRef: " + sResRef, oArea, "CreateGhostArea");

    // First check if the area already exists
    object oAreaCheck = GetObjectByTag("ghost_" + sTag);
    if (oAreaCheck != OBJECT_INVALID)
    {
        oNewArea = oAreaCheck;
        SendDebugMessage("Ghost area already exists.", oArea, "CreateGhostArea");
    }
    else
    {
        oNewArea = CopyArea(oArea, "ghost_" + sTag, sName);
        SetLocalInt(oNewArea, GHOST_AREA, TRUE);
        SetIsAreaInstanced(oNewArea, TRUE);

        SetupGhostArea(oNewArea);

        SetFogAmount(FOG_TYPE_ALL, 100, oNewArea);
        SetFogColor(FOG_TYPE_ALL, 0xFFFFFF, oNewArea);
        MusicBackgroundChangeDay(oNewArea, 0);
        MusicBackgroundChangeNight(oNewArea, 0);
        AmbientSoundChangeDay(oNewArea, 0);
        AmbientSoundChangeNight(oNewArea, 0);
        MusicBattleChange(oNewArea, 0);
        SetAreaLightColor(AREA_LIGHT_COLOR_MOON_AMBIENT, 0x111111, oNewArea);
        SetAreaLightColor(AREA_LIGHT_COLOR_MOON_DIFFUSE, 0x111111, oNewArea);
        SetAreaLightColor(AREA_LIGHT_COLOR_SUN_AMBIENT, 0x111111, oNewArea);
        SetAreaLightColor(AREA_LIGHT_COLOR_SUN_DIFFUSE, 0x111111, oNewArea);
        SetSkyBox(0, oNewArea);

        SetName(oNewArea, " [Death] " + sName);
        SendDebugMessage("New ghost area created with name: [Death] " + sName, oNewArea, "CreateGhostArea");
    }
    return oNewArea;
}

void SetupGhostArea(object oArea)
{
    SendDebugMessage("Setting up ghost area.", oArea, "SetupGhostArea");
    object oObject = GetFirstObjectInArea(oArea);

    while (GetIsObjectValid(oObject))
    {
        // Destroy all NPCs
        if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE &&
            !GetIsPC(oObject) &&
            !GetIsDM(oObject))
        {
            DestroyObject(oObject);
            SendDebugMessage("Destroyed NPC: " + GetName(oObject), oArea, "SetupGhostArea");
        }
        // Destroy all containers
        if (GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE &&
            GetHasInventory(oObject))
        {
            DestroyContents(oObject);
            SendDebugMessage("Destroyed container contents: " + GetName(oObject), oArea, "SetupGhostArea");
        }
        oObject = GetNextObjectInArea(oArea);
    }
    SendDebugMessage("Completed setup for ghost area.", oArea, "SetupGhostArea");
}
////////////////////////////////////////////////////////////////////////////////

// PvP Functions

void PVPSetRemainingLives(object oPC, int iLives)
{
    if (iLives < 0)
        iLives = 0;

    SendDebugMessage("Setting PvP lives to " + IntToString(iLives), oPC, "PVPSetRemainingLives");

    SetCampaignInt(DEATH_DATABASE, PVP_LIVES, iLives, oPC);
}

int PVPGetRemainingLives(object oPC)
{
    SendDebugMessage("Checking PvP lives.", oPC, "PVPGetRemainingLives");
    int iLivesInitialized = GetCampaignInt(DEATH_DATABASE, PVP_LIVES_INIT, oPC);
    int iRemainingLives;

    if (iLivesInitialized == FALSE)
    {
        SetCampaignInt(DEATH_DATABASE, PVP_LIVES_INIT, TRUE, oPC);
        iRemainingLives = PVP_LIVES_BASE;
        SendDebugMessage("PvP lives not initialized. Setting to base: " + IntToString(PVP_LIVES_BASE), oPC, "PVPGetRemainingLives");
        PVPSetRemainingLives(oPC, iRemainingLives);
    }
    else
    {
        iRemainingLives = GetCampaignInt(DEATH_DATABASE, PVP_LIVES, oPC);
        SendDebugMessage("PvP lives retrieved: " + IntToString(iRemainingLives), oPC, "PVPGetRemainingLives");
    }

    return iRemainingLives;
}

void SetPlayerClosure(object oPC, int iState)
{
    SendDebugMessage("Setting player closure to " + IntToString(iState), oPC, "SetPlayerClosure");
    SetCampaignInt(DEATH_DATABASE, PC_CLOSURE, iState, oPC);
}

int GetPlayerClosure(object oPC)
{
    SendDebugMessage("Checking player closure.", oPC, "GetPlayerClosure");
    int iClosure = GetCampaignInt(DEATH_DATABASE, PC_CLOSURE, oPC);
    SendDebugMessage("Player closure state is " + IntToString(iClosure), oPC, "GetPlayerClosure");
    return iClosure;
}


////////////////////////////////////////////////////////////////////////////////
