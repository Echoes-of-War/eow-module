////////////////////////////////////////////////////////////////////////////////

#include "_inc_generic"
#include "_inc_persvars"

////////////////////////////////////////////////////////////////////////////////

// System variables = do not touch
const string IS_IN_BLEEDOUT = "IS_IN_BLEEDOUT";
const string BLEEDOUT_HP = "BLEEDOUT_HP";
const string HAS_BLED_OUT = "HAS_BLED_OUT";
const string BLEED_STABILIZED = "BLEED_STABILIZED";
const int DAMAGE_TYPE_TRUE = 123456; // placeholder for true damage
const string GHOST_AREA = "GHOST_AREA";
const string GHOST_PLAYER = "GHOST_PLAYER";
const string ORIGINAL_APPEARANCE = "ORIGINAL_APPEARANCE";

////////////////////////////////////////////////////////////////////////////////

// Modifiables

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
const int STABILIZED_HEAL_CON = TRUE;

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
const int XP_PER_LEVEL_PER_RESPAWN = 500;

// When respawning, a player cannot drop below this level.
const int MINIMUM_LEVEL_FROM_RESPAWNING = 5;

// PvP

// How many PvP lives a player begins with by default.
const int PVP_LIVES_BASE = 5;

////////////////////////////////////////////////////////////////////////////////

// Bleedout Implementations

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
////////////////////////////////////////////////////////////////////////////////

// Afterdeath Implementations
object GetCorpse(object oPC);
object CreateCorpse(object oPC);

void DoDeath(object oPC);
void DropInventory(object oPC, object oCorpse);

int GetIsGhost(object oPC);
void SetIsGhost(object oPC, int iState);

int GetIsGhostArea(object oArea);
object CreateGhostArea(object oArea);

////////////////////////////////////////////////////////////////////////////////

// PvP Implementations

//int GetPlayerPvPLives
//int SetPlayerPvPLives

////////////////////////////////////////////////////////////////////////////////

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
    object oToken = GetIDToken(oPC);
    int iBleedout = GetItemInt(oToken, IS_IN_BLEEDOUT);
    return iBleedout;
}

void SetIsInBleedout(object oPC, int iState)
{
    object oToken = GetIDToken(oPC);
    SetItemInt(oToken, IS_IN_BLEEDOUT, iState);
}

int GetBleedoutHP(object oPC)
{
    object oToken = GetIDToken(oPC);
    int iHP = GetItemInt(oToken, BLEEDOUT_HP);
    return iHP;
}

void SetBleedoutHP(object oPC, int iHP)
{
    object oToken = GetIDToken(oPC);
    SetItemInt(oToken, BLEEDOUT_HP, iHP);
    SetCurrentHitPoints(oPC, iHP);
}


int GetHasStabilized(object oPC)
{
    object oToken = GetIDToken(oPC);
    int iStabilized = GetItemInt(oToken, BLEED_STABILIZED);
    return iStabilized;
}

void SetHasStabilized(object oPC, int iState)
{
    object oToken = GetIDToken(oPC);
    SetItemInt(oToken, BLEED_STABILIZED, iState);

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
    object oToken = GetIDToken(oPC);
    SetItemInt(oToken, HAS_BLED_OUT, iState);
}

int GetHasBledOut(object oPC)
{
    object oToken = GetIDToken(oPC);
    int iBledOut = GetItemInt(oToken, HAS_BLED_OUT);
    return iBledOut;
}

////////////////////////////////////////////////////////////////////////////////

// Afterdeath Functions

void PayRespawnCost(object oPC)
{
    int XP_FOR_LEVEL_5 = 10000;

    int nLevel = GetHitDice(oPC);
    if (nLevel >= MINIMUM_LEVEL_FROM_RESPAWNING)
    {
        int nXPCost = XP_PER_LEVEL_PER_RESPAWN * nLevel;
        int nCurrentXP = GetXP(oPC);
        int nNewXP = nCurrentXP - nXPCost;
        if (nNewXP < XP_FOR_LEVEL_5)
        {
            nNewXP = XP_FOR_LEVEL_5;
        }
        SetXP(oPC, nNewXP);
    }
}

void DoGhostRespawn(object oPC, object oShrine)
{
    object oGhostArea = GetArea(oPC);
    string sShrine = GetTag(oShrine);
    string sGhostTag = GetTag(oGhostArea);
    string sOriginalTag = GetSubString(sGhostTag, 6, GetStringLength(sGhostTag) - 6);
    object oOrigArea = GetObjectByTag(sOriginalTag);
    object oOrigShrine = GetObjectInArea(oOrigArea, sShrine);
    ClearAndJump(oPC, oOrigShrine);
    PayRespawnCost(oPC);
    SetIsGhost(oPC, FALSE);
}



void DropInventory(object oPC, object oCorpse)
{
    if (GetHitDice(oPC) >= LEVEL_PLAYER_DROPS_INVENTORY)
    {
        if (DROP_INVENTORY_ON_DEATH)
        {
            object oItem = GetFirstItemInInventory(oPC);
            while (GetIsObjectValid(oItem))
            {
                AssignCommand(oPC, ActionGiveItem(oItem, oCorpse));
                oItem = GetNextItemInInventory(oPC);
            }
        }
        if (DROP_EQUIPPED_ON_DEATH)
        {
            int nSlot;
            for (nSlot = 0; nSlot < NUM_INVENTORY_SLOTS; nSlot++)
            {
                object oEquippedItem = GetItemInSlot(nSlot, oPC);
                if (GetIsObjectValid(oEquippedItem))
                {
                    AssignCommand(oPC, ActionGiveItem(oEquippedItem, oCorpse));
                }
            }
        }
        if (DROP_GOLD_ON_DEATH)
        {
            int nGoldAmount = GetGold(oPC);
            TakeGoldFromCreature(nGoldAmount, oPC, TRUE);
            GiveGoldToCreature(oCorpse, nGoldAmount);
        }
    }
}

object GetCorpse(object oPC)
{
    string sID = GetLastCharacters(GetObjectUUID(oPC), 10);
    string sCorpse = "corpse_"+sID;
    object oCorpse = GetObjectByTag(sCorpse);
    return oCorpse;
}

object CreateCorpse(object oPC)
{
    object oPreviousCorpse = GetCorpse(oPC);
    if (oPreviousCorpse != OBJECT_INVALID)
    {
        DestroyObject(oPreviousCorpse);
    }
    string sID = GetLastCharacters(GetObjectUUID(oPC), 10);
    string sCorpse = "corpse_"+sID;
    location lLocation = GetLocation(oPC);
    object oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE, "corpse", lLocation);
    SetTag(oCorpse, sCorpse);
    return oCorpse;
}

void DoDeath(object oPC)
{
    object oCorpse = CreateCorpse(oPC);
    string sCorpseTag = GetTag(oCorpse);

    object oArea = GetArea(oPC);
    object oGhostArea = CreateGhostArea(oArea);

    effect eRez = EffectResurrection();
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, oPC);
    SetIsGhost(oPC, TRUE);
    DropInventory(oPC, oCorpse);

    object oGhostCorpse = GetObjectInArea(oGhostArea, sCorpseTag);
    SetTag(oGhostCorpse, "ghostcorpse");

    string sID = GetLastCharacters(GetObjectUUID(oPC), 10);
    string sCorpse = "corpse_"+sID;
    object oOldCorpse = GetObjectInArea(oGhostArea, sCorpse);
    DestroyObject(oOldCorpse);

    DelayCommand(0.1, ClearAndJump(oPC, oGhostCorpse));
}

int GetIsGhost(object oPC)
{
    object oToken = GetIDToken(oPC);
    int iGhost = GetItemInt(oToken, GHOST_PLAYER);
    return iGhost;
}

void SetIsGhost(object oPC, int iState)
{
    object oToken = GetIDToken(oPC);
    if (iState == TRUE)
    {
        SetItemInt(oToken, GHOST_PLAYER, TRUE);
        int iApp = GetAppearanceType(oPC);
        SetItemInt(oToken, ORIGINAL_APPEARANCE, iApp);
        SetCreatureAppearanceType(oPC, DEATH_MODEL_APPEARANCE);

        int iPlot = GetPlotFlag(oPC);
        if (iPlot == FALSE)
            SetPlotFlag(oPC, TRUE);
    } else
    {
        int iOrigApp = GetItemInt(oToken, ORIGINAL_APPEARANCE);
        SetItemInt(oToken, GHOST_PLAYER, FALSE);
        SetCreatureAppearanceType(oPC, iOrigApp);

        int iPlot = GetPlotFlag(oPC);
        if (iPlot == TRUE)
            SetPlotFlag(oPC, FALSE);
    }


}

int GetIsGhostArea(object oArea)
{
    int iGhostArea = GetLocalInt(oArea, GHOST_AREA);
    return iGhostArea;
}

object CreateGhostArea(object oArea)
{
    string sTag = GetTag(oArea);
    string sResRef = GetResRef(oArea);
    object oArea = GetObjectByTag(sTag);
    string sName = GetName(oArea);
    object oNewArea;

    // first check if area already exists
    object oAreaCheck = GetObjectByTag("ghost_"+sTag);
    if (oAreaCheck != OBJECT_INVALID)
    {
        oNewArea = oAreaCheck;
    } else
    {
        oNewArea = CopyArea(oArea, "ghost_"+sTag, sName);
        SetLocalInt(oNewArea, GHOST_AREA, TRUE);
        SetEventScript(oNewArea, EVENT_SCRIPT_AREA_ON_EXIT, "_exit_instance");

        DestroyNonPlayerCreatures(oNewArea);

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

        SetName(oNewArea, " [Death] "+sName);
    }
    return oNewArea;
}





////////////////////////////////////////////////////////////////////////////////

// PvP Functions

////////////////////////////////////////////////////////////////////////////////
