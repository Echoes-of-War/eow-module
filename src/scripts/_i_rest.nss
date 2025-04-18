//::////////////////////////////////////////////////////////////////////////////
//:: _i_rest
//::////////////////////////////////////////////////////////////////////////////
/*

    Rest stuff

*/
//::////////////////////////////////////////////////////////////////////////////
//:: Created:   Galefer (03/12/24)
//::////////////////////////////////////////////////////////////////////////////

// INCLUDES  -------------------------------------------------------------------

#include "_i_generic"

// GLOBALS ---------------------------------------------------------------------

// How many minutes until the camp cleanup check activates
float fUnusedCampDelay = ConvertMinutesToSeconds(15);

// How many meters away for a camp to be classed as abandoned
const float fUnusedCampMeters = 15.0;

// Resref of the Campfire placeable
const string sCampfire = "_camp_fire";

// Resref of the Tent placeable
const string sTent = "_camp_tent";

// DECLARATIIONS ---------------------------------------------------------------

object GetOwnerOfCamp(object oCamp);

object GetCurrentCampfire(object oPC);

object GetCurrentTent(object oPC);

void CreateCamp(location lCamp, object oPC);

void UnusedCampCleanup(object oTent, object oCampfire, object oOwner);

void ApplyFoodBuffs(object oPC, object oFood);

// IMPLEMENTATIONS -------------------------------------------------------------

void UnusedCampCleanup(object oTent, object oCampfire, object oOwner)
{
    if (GetIsPlayerWithin(oOwner, oTent, fUnusedCampMeters))
    {
        DelayCommand(fUnusedCampDelay, AssignCommand(GetModule(), UnusedCampCleanup(oTent, oCampfire, oOwner)));
    }   else
    {
        DestroyObject(oTent);
        DestroyObject(oCampfire);
    }
}

object GetOwnerOfCamp(object oCamp)
{
    return GetLocalObject(oCamp, "OWNER");
}

object GetCurrentCampfire(object oPC)
{
    string sKey = GetPCPublicCDKey(oPC, TRUE);
    object oCampfire = GetObjectByTag("_camp_fire_"+sKey);
    return oCampfire;
}

object GetCurrentTent(object oPC)
{
    string sKey = GetPCPublicCDKey(oPC, TRUE);
    object oTent = GetObjectByTag("_camp_tent_"+sKey);
    return oTent;
}

void CreateCamp(location lCamp, object oPC)
{
    // Checks to see if the PC attemped to set up camp indoors.
    object oArea = GetArea(oPC);
    int iIsInterior = GetIsAreaInterior(oArea);
    if(iIsInterior)
    {
        SendMessageToPC(oPC, "You can only set up camp outdoors.  Please either find suitable accomidations or head outside.");
        return;
    }

    // Destroy old tent and campfire before creating new ones
    object oOldCampfire = GetCurrentCampfire(oPC);
    if (oOldCampfire != OBJECT_INVALID)
        DestroyObject(oOldCampfire);
    object oOldTent = GetCurrentTent(oPC);
    if (oOldTent != OBJECT_INVALID)
        DestroyObject(oOldTent);

    // Get locations to create camp
    vector vTent = GetChangedPosition(GetPositionFromLocation(lCamp),5.0, 45.0);
    location lTent = Location(oArea, Vector(vTent.x, vTent.y, vTent.z-0.15), 0.0);

    // Create camp
    object oCampfire = CreateObject(OBJECT_TYPE_PLACEABLE, sCampfire, lCamp);
    object oTent = CreateObject(OBJECT_TYPE_PLACEABLE, sTent, lTent);

    // Link camp together
    SetLocalObject(oCampfire, "TENT", oTent);
    SetLocalObject(oTent, "CAMPFIRE", oCampfire);

    // Set owner of camp
    SetLocalObject(oCampfire, "OWNER", oPC);
    SetLocalObject(oTent, "OWNER", oPC);

    // Set unique tags based on CDKEY for ownership logging and persistence
    string sKey = GetPCPublicCDKey(oPC, TRUE);
    string sCampfireTag = sCampfire+"_"+sKey;
    SetTag(oCampfire, sCampfireTag);
    string sTentTag = sTent+"_"+sKey;
    SetTag(oTent, sTentTag);

    // Schedule cleanup
    DelayCommand(fUnusedCampDelay, AssignCommand(GetModule(), UnusedCampCleanup(oTent, oCampfire, oPC)));
}

void ApplyFoodBuffs(object oPC, object oFood)
{
    int iDuration = GetLocalInt(oFood, "DURATION");
    if (iDuration == 0)
        iDuration = 60;
    float fDuration = ConvertMinutesToSeconds(iDuration);

    //Debug
    string sDebugName = GetName(oFood);
    SendDebugMessage("Food selected: "+sDebugName, oPC, "ApplyFoodBuffs");
    SendDebugMessage("Food will last this many minutes: "+IntToString(iDuration), oPC, "ApplyFoodBuffs");
    SendDebugMessage("Food will last this many seconds: "+FloatToString(fDuration), oPC, "ApplyFoodBuffs");


    // Apply ability buffs if the corresponding value is set on the food item
    int nStrength = GetLocalInt(oFood, "STRENGTH");
    if (nStrength > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_STRENGTH, nStrength), oPC, fDuration);
    }

    int nDexterity = GetLocalInt(oFood, "DEXTERITY");
    if (nDexterity > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_DEXTERITY, nDexterity), oPC, fDuration);
    }

    int nConstitution = GetLocalInt(oFood, "CONSTITUTION");
    if (nConstitution > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_CONSTITUTION, nConstitution), oPC, fDuration);
    }

    int nIntelligence = GetLocalInt(oFood, "INTELLIGENCE");
    if (nIntelligence > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_INTELLIGENCE, nIntelligence), oPC, fDuration);
    }

    int nWisdom = GetLocalInt(oFood, "WISDOM");
    if (nWisdom > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_WISDOM, nWisdom), oPC, fDuration);
    }

    int nCharisma = GetLocalInt(oFood, "CHARISMA");
    if (nCharisma > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_CHARISMA, nCharisma), oPC, fDuration);
    }

    // Apply special buffs like invisibility if the value is set on the food item
    int nInvisibility = GetLocalInt(oFood, "INVISIBILITY");
    if (nInvisibility > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectInvisibility(INVISIBILITY_TYPE_NORMAL), oPC, fDuration);
    }

    // Apply immunity buffs (disease, fear, poison) if the value is set on the food item
    int nImmunityDisease = GetLocalInt(oFood, "IMMUNITY_DISEASE");
    if (nImmunityDisease > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_DISEASE), oPC, fDuration);
    }

    int nImmunityFear = GetLocalInt(oFood, "IMMUNITY_FEAR");
    if (nImmunityFear > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_FEAR), oPC, fDuration);
    }

    int nImmunityPoison = GetLocalInt(oFood, "IMMUNITY_POISON");
    if (nImmunityPoison > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_POISON), oPC, fDuration);
    }

    // IMMUNITY_TYPE_ABILITY_DECREASE
    int nImmunityAbilityDecrease = GetLocalInt(oFood, "IMMUNITY_ABILITY_DECREASE");
    if (nImmunityAbilityDecrease > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE), oPC, fDuration);
    }

    // IMMUNITY_TYPE_AC_DECREASE
    int nImmunityACDecrease = GetLocalInt(oFood, "IMMUNITY_AC_DECREASE");
    if (nImmunityACDecrease > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_AC_DECREASE), oPC, fDuration);
    }

    // IMMUNITY_TYPE_ATTACK_DECREASE
    int nImmunityAttackDecrease = GetLocalInt(oFood, "IMMUNITY_ATTACK_DECREASE");
    if (nImmunityAttackDecrease > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_ATTACK_DECREASE), oPC, fDuration);
    }

    // IMMUNITY_TYPE_BLINDNESS
    int nImmunityBlindness = GetLocalInt(oFood, "IMMUNITY_BLINDNESS");
    if (nImmunityBlindness > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_BLINDNESS), oPC, fDuration);
    }

    // IMMUNITY_TYPE_CHARM
    int nImmunityCharm = GetLocalInt(oFood, "IMMUNITY_CHARM");
    if (nImmunityCharm > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_CHARM), oPC, fDuration);
    }

    // IMMUNITY_TYPE_CONFUSED
    int nImmunityConfused = GetLocalInt(oFood, "IMMUNITY_CONFUSED");
    if (nImmunityConfused > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_CONFUSED), oPC, fDuration);
    }

    // IMMUNITY_TYPE_CRITICAL_HIT
    int nImmunityCriticalHit = GetLocalInt(oFood, "IMMUNITY_CRITICAL_HIT");
    if (nImmunityCriticalHit > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT), oPC, fDuration);
    }

    // IMMUNITY_TYPE_CURSED
    int nImmunityCursed = GetLocalInt(oFood, "IMMUNITY_CURSED");
    if (nImmunityCursed > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_CURSED), oPC, fDuration);
    }

    // IMMUNITY_TYPE_DAMAGE_DECREASE
    int nImmunityDamageDecrease = GetLocalInt(oFood, "IMMUNITY_DAMAGE_DECREASE");
    if (nImmunityDamageDecrease > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_DAMAGE_DECREASE), oPC, fDuration);
    }

    // IMMUNITY_TYPE_DAMAGE_IMMUNITY_DECREASE
    int nImmunityDamageImmunityDecrease = GetLocalInt(oFood, "IMMUNITY_DAMAGE_IMMUNITY_DECREASE");
    if (nImmunityDamageImmunityDecrease > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_DAMAGE_IMMUNITY_DECREASE), oPC, fDuration);
    }

    // IMMUNITY_TYPE_DAZED
    int nImmunityDazed = GetLocalInt(oFood, "IMMUNITY_DAZED");
    if (nImmunityDazed > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_DAZED), oPC, fDuration);
    }

    // IMMUNITY_TYPE_DEAFNESS
    int nImmunityDeafness = GetLocalInt(oFood, "IMMUNITY_DEAFNESS");
    if (nImmunityDeafness > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_DEAFNESS), oPC, fDuration);
    }

    // IMMUNITY_TYPE_DEATH
    int nImmunityDeath = GetLocalInt(oFood, "IMMUNITY_DEATH");
    if (nImmunityDeath > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_DEATH), oPC, fDuration);
    }

    // IMMUNITY_TYPE_DOMINATE
    int nImmunityDominate = GetLocalInt(oFood, "IMMUNITY_DOMINATE");
    if (nImmunityDominate > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_DOMINATE), oPC, fDuration);
    }

    // IMMUNITY_TYPE_ENTANGLE
    int nImmunityEntangle = GetLocalInt(oFood, "IMMUNITY_ENTANGLE");
    if (nImmunityEntangle > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_ENTANGLE), oPC, fDuration);
    }

    // IMMUNITY_TYPE_KNOCKDOWN
    int nImmunityKnockdown = GetLocalInt(oFood, "IMMUNITY_KNOCKDOWN");
    if (nImmunityKnockdown > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN), oPC, fDuration);
    }

    // IMMUNITY_TYPE_MIND_SPELLS
    int nImmunityMindSpells = GetLocalInt(oFood, "IMMUNITY_MIND_SPELLS");
    if (nImmunityMindSpells > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS), oPC, fDuration);
    }

    // IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE
    int nImmunityMovementSpeedDecrease = GetLocalInt(oFood, "IMMUNITY_MOVEMENT_SPEED_DECREASE");
    if (nImmunityMovementSpeedDecrease > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE), oPC, fDuration);
    }

    // IMMUNITY_TYPE_NEGATIVE_LEVEL
    int nImmunityNegativeLevel = GetLocalInt(oFood, "IMMUNITY_NEGATIVE_LEVEL");
    if (nImmunityNegativeLevel > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL), oPC, fDuration);
    }

    // IMMUNITY_TYPE_PARALYSIS
    int nImmunityParalysis = GetLocalInt(oFood, "IMMUNITY_PARALYSIS");
    if (nImmunityParalysis > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_PARALYSIS), oPC, fDuration);
    }

    // IMMUNITY_TYPE_SAVING_THROW_DECREASE
    int nImmunitySavingThrowDecrease = GetLocalInt(oFood, "IMMUNITY_SAVING_THROW_DECREASE");
    if (nImmunitySavingThrowDecrease > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_SAVING_THROW_DECREASE), oPC, fDuration);
    }

    // IMMUNITY_TYPE_SKILL_DECREASE
    int nImmunitySkillDecrease = GetLocalInt(oFood, "IMMUNITY_SKILL_DECREASE");
    if (nImmunitySkillDecrease > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_SKILL_DECREASE), oPC, fDuration);
    }

    // IMMUNITY_TYPE_SILENCE
    int nImmunitySilence = GetLocalInt(oFood, "IMMUNITY_SILENCE");
    if (nImmunitySilence > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_SILENCE), oPC, fDuration);
    }

    // IMMUNITY_TYPE_SLEEP
    int nImmunitySleep = GetLocalInt(oFood, "IMMUNITY_SLEEP");
    if (nImmunitySleep > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_SLEEP), oPC, fDuration);
    }

    // IMMUNITY_TYPE_SLOW
    int nImmunitySlow = GetLocalInt(oFood, "IMMUNITY_SLOW");
    if (nImmunitySlow > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_SLOW), oPC, fDuration);
    }

    // IMMUNITY_TYPE_SNEAK_ATTACK
    int nImmunitySneakAttack = GetLocalInt(oFood, "IMMUNITY_SNEAK_ATTACK");
    if (nImmunitySneakAttack > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK), oPC, fDuration);
    }

    // IMMUNITY_TYPE_SPELL_RESISTANCE_DECREASE
    int nImmunitySpellResistanceDecrease = GetLocalInt(oFood, "IMMUNITY_SPELL_RESISTANCE_DECREASE");
    if (nImmunitySpellResistanceDecrease > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_SPELL_RESISTANCE_DECREASE), oPC, fDuration);
    }

    // IMMUNITY_TYPE_TRAP
    int nImmunityTrap = GetLocalInt(oFood, "IMMUNITY_TRAP");
    if (nImmunityTrap > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_TRAP), oPC, fDuration);
    }

    // IMMUNITY_TYPE_STUN
    int nImmunityStun = GetLocalInt(oFood, "IMMUNITY_STUN");
    if (nImmunityStun > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_STUN), oPC, fDuration);
    }

    // Apply additional buffs
    int nHaste = GetLocalInt(oFood, "HASTE");
    if (nHaste > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectHaste(), oPC, fDuration);
    }

    int nSlow = GetLocalInt(oFood, "SLOW");
    if (nSlow > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSlow(), oPC, fDuration);
    }

    int nRegeneration = GetLocalInt(oFood, "REGENERATION");
    if (nRegeneration > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectRegenerate(nRegeneration, RoundsToSeconds(1)), oPC, fDuration);
    }

    int nSeeInvisibility = GetLocalInt(oFood, "SEE_INVISIBILITY");
    if (nSeeInvisibility > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSeeInvisible(), oPC, fDuration);
    }

    int nTrueSeeing = GetLocalInt(oFood, "TRUE_SEEING");
    if (nTrueSeeing > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTrueSeeing(), oPC, fDuration);
    }

    int nDarkVision = GetLocalInt(oFood, "DARKVISION");
    if (nDarkVision > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectUltravision(), oPC, fDuration);
    }

    int nGhostlyVisage = GetLocalInt(oFood, "ETHEREAL");
    if (nGhostlyVisage > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectEthereal(), oPC, fDuration);
    }

    int nSanctuary = GetLocalInt(oFood, "SANCTUARY");
    if (nSanctuary > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSanctuary(nSanctuary), oPC, fDuration);
    }

    // Add the remaining effects from your list

    int nACIncrease = GetLocalInt(oFood, "AC_INCREASE");
    if (nACIncrease > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(nACIncrease), oPC, fDuration);
    }

    int nAttackIncrease = GetLocalInt(oFood, "ATTACK_INCREASE");
    if (nAttackIncrease > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(nAttackIncrease), oPC, fDuration);
    }

    int nConcealment = GetLocalInt(oFood, "CONCEALMENT");
    if (nConcealment > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectConcealment(nConcealment), oPC, fDuration);
    }

    int nDamageIncrease = GetLocalInt(oFood, "DAMAGE_INCREASE");
    if (nDamageIncrease > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(nDamageIncrease, DAMAGE_TYPE_MAGICAL), oPC, fDuration);
    }

    int nDispelMagic = GetLocalInt(oFood, "DISPEL_MAGIC");
    if (nDispelMagic > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDispelMagicAll(nDispelMagic), oPC, fDuration);
    }

    int nMovementSpeedIncrease = GetLocalInt(oFood, "MOVEMENT_SPEED_INCREASE");
    if (nMovementSpeedIncrease > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedIncrease(nMovementSpeedIncrease), oPC, fDuration);
    }

    int nSavingThrowIncrease = GetLocalInt(oFood, "SAVING_THROW_INCREASE");
    if (nSavingThrowIncrease > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_ALL, nSavingThrowIncrease), oPC, fDuration);
    }

    int nSpellImmunity = GetLocalInt(oFood, "SPELL_IMMUNITY");
    if (nSpellImmunity > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSpellImmunity(SPELL_ALL_SPELLS), oPC, fDuration);
    }

    int nSpellLevelAbsorption = GetLocalInt(oFood, "SPELL_LEVEL_ABSORPTION");
    if (nSpellLevelAbsorption > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSpellLevelAbsorption(nSpellLevelAbsorption), oPC, fDuration);
    }

    int nSpellResistanceIncrease = GetLocalInt(oFood, "SPELL_RESISTANCE_INCREASE");
    if (nSpellResistanceIncrease > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSpellResistanceIncrease(nSpellResistanceIncrease), oPC, fDuration);
    }

    int nTemporaryHitpoints = GetLocalInt(oFood, "TEMPORARY_HITPOINTS");
    if (nTemporaryHitpoints > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(nTemporaryHitpoints), oPC, fDuration);
    }

    int nUltravision = GetLocalInt(oFood, "ULTRAVISION");
    if (nUltravision > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectUltravision(), oPC, fDuration);
    }
}

// EXECUTION  ------------------------------------------------------------------

//void main(){}
