#include "te_functions"

const int MYTHIC_XP_BONUS_1 = 1000;
const int MYTHIC_XP_BONUS_2 = 3000;

const string MYTHIC_DATA_KEY_PREFIX = "mythicxp_";

// add one point of mythic xp for given PC and their ability
void TickMythicXp(object oPC, int nAbility, int nTick = 1);

// determines the suitable extraordinary attribute bonuses and applies them to the PC
// this should only be called on rest
void ApplyMythicBonuses(object oPC);

// sets Mythic XP to zero in all abilities
void ResetMythicXp(object oPC);

// sends the PC a combat log for their mythic XP values
void ReportMythicXp(object oPC);



void TickMythicXp(object oPC, int nAbility, int nTick = 1)
{
    object oData = GetItemPossessedBy(oPC,"PC_Data_Object");
    string sDataKey = MYTHIC_DATA_KEY_PREFIX + AbilityToString(nAbility);
    int nMythicXp = GetLocalInt(oData, sDataKey);
    if (nMythicXp < MYTHIC_XP_BONUS_2)
    {
        int nNextMythicXp = nMythicXp + nTick;
        if (nNextMythicXp > MYTHIC_XP_BONUS_2)
        {
            nNextMythicXp = MYTHIC_XP_BONUS_2;
        }
        SetLocalInt(oData, sDataKey, nNextMythicXp);
    }
}

void ApplyMythicBonuses(object oPC)
{
    object oData = GetItemPossessedBy(oPC,"PC_Data_Object");
    int bApplied = FALSE;

    // iterate through each ability and possibly apply a bonus
    int nAbility;
    for (nAbility = 0; nAbility < 6; nAbility++)
    {
        string sDataKey = MYTHIC_DATA_KEY_PREFIX + AbilityToString(nAbility);
        int nMythicXP = GetLocalInt(oData, sDataKey);
        if (nMythicXP >= MYTHIC_XP_BONUS_2)
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectAbilityIncrease(nAbility, 2)), oPC);
            bApplied = TRUE;
        }
        else if (nMythicXP >= MYTHIC_XP_BONUS_1)
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectAbilityIncrease(nAbility, 1)), oPC);
            bApplied = TRUE;
        }
    }

    // alert player if a bonus was applied.
    if (bApplied)
    {
        SendMessageToPC(oPC, "Applied Mythic attribute bonuses");
    }
}

void ResetMythicXp(object oPC)
{
    object oData = GetItemPossessedBy(oPC,"PC_Data_Object");

    // iterate through each ability
    int nAbility;
    for (nAbility = 0; nAbility < 6; nAbility++)
    {
        string sDataKey = MYTHIC_DATA_KEY_PREFIX + AbilityToString(nAbility);
        SetLocalInt(oData, sDataKey, 0);
    }

    SendMessageToPC(oPC, "Mythic Points reset to zero.");
}

void ReportMythicXp(object oPC)
{
    object oData = GetItemPossessedBy(oPC,"PC_Data_Object");
    string sStrMythicXp = IntToString(GetLocalInt(oData, MYTHIC_DATA_KEY_PREFIX + AbilityToString(ABILITY_STRENGTH)));
    string sDexMythicXp = IntToString(GetLocalInt(oData, MYTHIC_DATA_KEY_PREFIX + AbilityToString(ABILITY_DEXTERITY)));
    string sConMythicXp = IntToString(GetLocalInt(oData, MYTHIC_DATA_KEY_PREFIX + AbilityToString(ABILITY_CONSTITUTION)));
    string sIntMythicXp = IntToString(GetLocalInt(oData, MYTHIC_DATA_KEY_PREFIX + AbilityToString(ABILITY_INTELLIGENCE)));
    string sWisMythicXp = IntToString(GetLocalInt(oData, MYTHIC_DATA_KEY_PREFIX + AbilityToString(ABILITY_WISDOM)));
    string sChaMythicXp = IntToString(GetLocalInt(oData, MYTHIC_DATA_KEY_PREFIX + AbilityToString(ABILITY_CHARISMA)));

    string sMessage = "An increase each ability is achieved at "
        +IntToString(MYTHIC_XP_BONUS_1)+" and "+IntToString(MYTHIC_XP_BONUS_2)
        +" Mythic Points. These points are reset on death.\n";
    sMessage += sStrMythicXp + " Mythic Strength Points\n";
    sMessage += sDexMythicXp + " Mythic Dexterity Points\n";
    sMessage += sConMythicXp + " Mythic Constitution Points\n";
    sMessage += sIntMythicXp + " Mythic Intelligence Points\n";
    sMessage += sWisMythicXp + " Mythic Wisdom Points\n";
    sMessage += sChaMythicXp + " Mythic Charisma Points\n";
    SendMessageToPC(oPC, sMessage);
}