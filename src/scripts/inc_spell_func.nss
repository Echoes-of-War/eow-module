
/*
Spell Functions
by OldManWhistler

This one script provides fast access to a lot of the information stored in
SPELLS.2DA without having to use slow Get2DAString lookups.

Instead it uses local variables for storing the data at module load time so that
it can be accessed quickly at run time. It uses packed integers to store the
following spell information with only four local variables per spell:
- spell name
- spell script
- hostile setting
- feat or spell
- innate spell level
- innate spell level by class
- range
- metamagic types
- spell school
- projectile type
- immunity type
- target type
- vocal component
- somatic component

For all of the spells in NWN/SOU 1.31 it takes only 2100 local variables to store
6400 pieces of data.

The zip file includes:
- example/test module
- erf
- perl script for regenerating the inc_spell_func script for custom SPELL.2DA files

*/

// ****************************************************************************
// ** INSTALLATION
// ****************************************************************************

// #1 - Import the erf

// #2 - Add the following line to the top of your module OnModuleLoad event script:
// #include "inc_spell_func"

// #3 - Add the following line to the main function of your module OnModuleLoad event script:
// AssignCommand(GetModule(), SFInitialization());

// #4 - Add the following line to any scripts that you want to access the spell
// functions from:
// #include "inc_spell_func"

// ****************************************************************************
// ** FUNCTION PROTOTYPES
// ****************************************************************************

// SFGetIsSpellFeat
//  nSpell - a SPELL_* constant.
// returns TRUE if a spell is really a feat implemented using a spell.
int SFGetIsSpellFeat(int nSpell);

// SFGetInnateSpellLevelByClass
//  nSpell - a SPELL_* constant.
//  nClass - a CLASS_* constant.
// returns -1 on spell not found. Uses innate class columns, does not use innate column.
int SFGetInnateSpellLevelByClass(int nSpell, int nClass);

// SFGetInnateSpellLevel
//  nSpell - a SPELL_* constant.
// returns -1 on spell not found, uses innate columns.
int SFGetInnateSpellLevel(int nSpell);

// SFGetSpellScript
//  nSpell - a SPELL_* constant.
// returns the corresponding script name.
string SFGetSpellScript(int nSpell);

// SFGetSpellName
//  nSpell - a SPELL_* constant.
// returns the spell name, with underscores substituted for spaces.
string SFGetSpellName(int nSpell);

// SFGetIsSpellHarmful
//  nSpell - a SPELL_* constant.
// returns TRUE if this spell is hostile.
int SFGetIsSpellHarmful(int nSpell);

// SFGetSpellMetamagic
//  nSpell - a SPELL_* constant.
// returns the valid metamagic types for this spell. METAMAGIC_*
int SFGetSpellMetamagic(int nSpell);

// SFGetSpellMetamagicName
//  nMeta - a bitwise OR of METAMAGIC_* constants
// returns the name of the constants specified
string SFGetSpellMetamagicName(int nMeta);

// SFGetSpellTarget
//  nSpell - a SPELL_* constant.
// returns the valid target types for for this spell. SPELLFUNC_TARGET_*
int SFGetSpellTarget(int nSpell);

// SFGetSpellTargetName
//  nTarget - a bitwise OR of SPELLFUNC_TARGET_* constants
// returns the name of the constants specified
string SFGetSpellTargetName(int nTarget);

// SFGetIsSpellRange
//  nSpell - a SPELL_* constant.
// returns the spell range. SPELLFUNC_RANGE_*
int SFGetSpellRange(int nSpell);

// SFGetSpellRangeName
//  nRange - a SPELLFUNC_RANGE_* constant
// returns the name of the constants specified
string SFGetSpellRangeName(int nRange);

// SFGetSpellSchool
//  nSpell - a SPELL_* constant.
// returns the spell school constant. SPELL_SCHOOL_*
int SFGetSpellSchool(int nSpell);

// SFGetSpellSchoolName
//  nSpellSchool - a SPELL_SCHOOL_* constant
// returns the name of the constants specified
string SFGetSpellSchoolName(int nSpellSchool);

// SFGetIsSpellVocal
//  nSpell - a SPELL_* constant.
// returns TRUE if the spell has a vocal component.
int SFGetIsSpellVocal(int nSpell);

// SFGetIsSpellSomatic
//  nSpell - a SPELL_* constant.
// returns TRUE if the spell has a somatic component.
int SFGetIsSpellSomatic(int nSpell);

// SFGetSpellProjectile
//  nSpell - a SPELL_* constant.
// returns setting of the proj_type column. PROJECTILE_PATH_TYPE_* or SPELLFUNC_PROJECTILE_PATH_TYPE_*
int SFGetSpellProjectile(int nSpell);

// SFGetSpellProjectileName
//  nProjectile - a PROJECTILE_* constant or SPELLFUNC_PROJECTILE_* constant
// returns the name of the constants specified
string SFGetSpellProjectileName(int nProjectile);

// SFGetSpellImmunityType
//  nSpell - a SPELL_* constant.
// returns the appropriate immunity constant for the spell. SPELLFUNC_IMMUNITE_*
int SFGetSpellImmunityType(int nSpell);

// SFGetSpellImmunityName
//  nImmunity - a SPELLFUNC_IMMUNITY_* constant
// returns the name of the constants specified
string SFGetSpellImmunityName(int nImmunity);

// SFGetSpellInfo
//  nSpell - a SPELL_* constant.
// returns a string with all of the spell information for a specific spell.
// Useful for debugging.
string SFGetSpellInfo(int nSpell);

// SFInitialization
// Used to set up all of the local variables that are used by the other functions.
// Your OnModuleLoad event script should have the follow line:
// AssignCommand(GetModule(), SFInitialization());
void SFInitialization();

// ****************************************************************************
// ** CONSTANTS
// ****************************************************************************

// Is spell hostile? Non-hostile spells are usually bufs.
const int SPELLFUNC_FRIENDLY = 0x00000000;
const int SPELLFUNC_HOSTILE = 0x10000000;

// Is spell a feat? Bioware sometimes implements feats as spells.
const int SPELLFUNC_IS_SPELL = 0x00000000;
const int SPELLFUNC_IS_FEAT = 0x00000001;

// What is the range of the spell? (How far away can it be cast?)
const int SPELLFUNC_RANGE_LARGE = 0x00000000;
const int SPELLFUNC_RANGE_MEDIUM = 0x00000040;
const int SPELLFUNC_RANGE_SMALL = 0x00000080;
const int SPELLFUNC_RANGE_TOUCH = 0x000000c0;
const int SPELLFUNC_RANGE_PERSONAL = 0x00000100; // Self-only

// What projectile path is used when the spell is fired? This is a continuation of the PROJECTILE_PATH_TYPE_* constants
const int SPELLFUNC_PROJECTILE_PATH_TYPE_SPIRAL = 0x00000005;
const int SPELLFUNC_PROJECTILE_PATH_TYPE_LINKED = 0x00000006;
const int SPELLFUNC_PROJECTILE_PATH_TYPE_BOUNCE = 0x00000007;

// What type of immunity counters this spell? This can be used to script special behaviours for fire resistent creatures, etc
const int SPELLFUNC_IMMUNITY_NONE = 0x00000000;
const int SPELLFUNC_IMMUNITY_ACID = 0x00200000;
const int SPELLFUNC_IMMUNITY_COLD = 0x00400000;
const int SPELLFUNC_IMMUNITY_DEATH = 0x00600000;
const int SPELLFUNC_IMMUNITY_DISEASE = 0x00800000;
const int SPELLFUNC_IMMUNITY_DIVINE = 0x00a00000;
const int SPELLFUNC_IMMUNITY_FEAR = 0x00c00000;
const int SPELLFUNC_IMMUNITY_FIRE = 0x00e00000;
const int SPELLFUNC_IMMUNITY_ELECTRICITY = 0x01000000;
const int SPELLFUNC_IMMUNITY_MIND = 0x01200000;
const int SPELLFUNC_IMMUNITY_NEGATIVE = 0x01400000;
const int SPELLFUNC_IMMUNITY_POSITIVE = 0x01600000;
const int SPELLFUNC_IMMUNITY_POISON = 0x01800000;
const int SPELLFUNC_IMMUNITY_SONIC = 0x01a00000;

// What can the spell be targeted against? Might be of use to some AI scripting.
const int SPELLFUNC_TARGET_CREATURE = 0x04000000;
const int SPELLFUNC_TARGET_GROUND = 0x08000000;
const int SPELLFUNC_TARGET_ITEM = 0x10000000;
const int SPELLFUNC_TARGET_DOOR = 0x20000000;
const int SPELLFUNC_TARGET_PLACEABLE = 0x40000000;
const int SPELLFUNC_TARGET_TRIGGER = 0x80000000;

// Does the spell require spoken words to cast? (ie: blocked by Silence)
const int SPELLFUNC_VOCAL = 0x00000002;

// Does the spell require hand gestures to cast?
const int SPELLFUNC_SOMATIC = 0x00000004;


const int SPELLFUNC_HOSTILE_MASK = 0x10000000;
const int SPELLFUNC_FEAT_MASK = 0x00000001;
const int SPELLFUNC_RANGE_MASK = 0x000001c0;
const int SPELLFUNC_RANGE_SHIFT = 0x00000006;
const int SPELLFUNC_METAMAGIC_MASK = 0x0003fe00;
const int SPELLFUNC_METAMAGIC_SHIFT = 0x00000009;
const int SPELLFUNC_SPELL_SCHOOL_MASK = 0x00000038;
const int SPELLFUNC_SPELL_SCHOOL_SHIFT = 0x00000003;
const int SPELLFUNC_PROJECTILE_MASK = 0x001c0000;
const int SPELLFUNC_PROJECTILE_SHIFT = 0x00000012;
const int SPELLFUNC_IMMUNITY_MASK = 0x01e00000;
const int SPELLFUNC_IMMUNITY_SHIFT = 0x00000015;
const int SPELLFUNC_TARGET_MASK = 0xfe000000;
const int SPELLFUNC_TARGET_SHIFT = 0x00000019;
const int SPELLFUNC_VS_MASK = 0x00000006;
const int SPELLFUNC_INNATE_SHIFT = 0x00000000;
const int SPELLFUNC_INNATE_MASK = 0x0000000f;
const int SPELLFUNC_INNATE_BD_SHIFT = 0x00000004;
const int SPELLFUNC_INNATE_BD_MASK = 0x000000f0;
const int SPELLFUNC_INNATE_CL_SHIFT = 0x00000008;
const int SPELLFUNC_INNATE_CL_MASK = 0x00000f00;
const int SPELLFUNC_INNATE_DR_SHIFT = 0x0000000c;
const int SPELLFUNC_INNATE_DR_MASK = 0x0000f000;
const int SPELLFUNC_INNATE_PA_SHIFT = 0x00000010;
const int SPELLFUNC_INNATE_PA_MASK = 0x000f0000;
const int SPELLFUNC_INNATE_RA_SHIFT = 0x00000014;
const int SPELLFUNC_INNATE_RA_MASK = 0x00f00000;
const int SPELLFUNC_INNATE_WZ_SHIFT = 0x00000018;
const int SPELLFUNC_INNATE_WZ_MASK = 0x0f000000;


// ****************************************************************************
// ** FUNCTION DEFINITIONS
// ****************************************************************************

int SFGetIsSpellFeat(int nSpell)
{
    return ( (GetLocalInt(GetModule(), "SFPacked1_"+IntToString(nSpell)) & SPELLFUNC_FEAT_MASK) == SPELLFUNC_IS_FEAT);
}

int SFGetInnateSpellLevelByClass(int nSpell, int nClass)
{
    switch (nClass)
    {
        case CLASS_TYPE_WIZARD:
        case CLASS_TYPE_SORCERER:
            return ( ((GetLocalInt(GetModule(), "SFPacked2_"+IntToString(nSpell)) & SPELLFUNC_INNATE_WZ_MASK) >> SPELLFUNC_INNATE_WZ_SHIFT) - 1);
        case CLASS_TYPE_CLERIC:
            return ( ((GetLocalInt(GetModule(), "SFPacked2_"+IntToString(nSpell)) & SPELLFUNC_INNATE_CL_MASK) >> SPELLFUNC_INNATE_CL_SHIFT) - 1);
        case CLASS_TYPE_DRUID:
            return ( ((GetLocalInt(GetModule(), "SFPacked2_"+IntToString(nSpell)) & SPELLFUNC_INNATE_DR_MASK) >> SPELLFUNC_INNATE_DR_SHIFT) - 1);
        case CLASS_TYPE_BARD:
            return ( ((GetLocalInt(GetModule(), "SFPacked2_"+IntToString(nSpell)) & SPELLFUNC_INNATE_BD_MASK) >> SPELLFUNC_INNATE_BD_SHIFT) - 1);
        case CLASS_TYPE_PALADIN:
            return ( ((GetLocalInt(GetModule(), "SFPacked2_"+IntToString(nSpell)) & SPELLFUNC_INNATE_PA_MASK) >> SPELLFUNC_INNATE_PA_SHIFT) - 1);
        case CLASS_TYPE_RANGER:
            return ( ((GetLocalInt(GetModule(), "SFPacked2_"+IntToString(nSpell)) & SPELLFUNC_INNATE_RA_MASK) >> SPELLFUNC_INNATE_RA_SHIFT) - 1);
    }
    return (-1);
}

int SFGetInnateSpellLevel(int nSpell)
{
    return ( ((GetLocalInt(GetModule(), "SFPacked2_"+IntToString(nSpell)) & SPELLFUNC_INNATE_MASK) >> SPELLFUNC_INNATE_SHIFT) - 1);
}

string SFGetSpellScript(int nSpell)
{
    return (GetLocalString(GetModule(), "SFScripts_"+IntToString(nSpell)));
}

string SFGetSpellName(int nSpell)
{
    return (GetLocalString(GetModule(), "SFNames_"+IntToString(nSpell)));
}

int SFGetIsSpellHarmful(int nSpell)
{
    return ( (GetLocalInt(GetModule(), "SFPacked2_"+IntToString(nSpell)) & SPELLFUNC_HOSTILE_MASK) == SPELLFUNC_HOSTILE);
}

int SFGetSpellMetamagic(int nSpell)
{
    return ( (GetLocalInt(GetModule(), "SFPacked1_"+IntToString(nSpell)) & SPELLFUNC_METAMAGIC_MASK) >> SPELLFUNC_METAMAGIC_SHIFT);
}

string SFGetSpellMetamagicName(int nMeta)
{
    string sReturn = "";
    if (nMeta & METAMAGIC_ANY) sReturn = sReturn +"any/";
    if (nMeta & METAMAGIC_EMPOWER) sReturn = sReturn +"empower/";
    if (nMeta & METAMAGIC_EXTEND) sReturn = sReturn +"extend/";
    if (nMeta & METAMAGIC_MAXIMIZE) sReturn = sReturn +"maximize/";
    if (nMeta & METAMAGIC_QUICKEN) sReturn = sReturn +"quicken/";
    if (nMeta & METAMAGIC_SILENT) sReturn = sReturn +"silent/";
    if (nMeta & METAMAGIC_STILL) sReturn = sReturn +"still/";
    if (sReturn == "") return "none/";
    else return (sReturn);
}

int SFGetSpellTarget(int nSpell)
{
    return ( GetLocalInt(GetModule(), "SFPacked1_"+IntToString(nSpell)) & SPELLFUNC_TARGET_MASK);
}

string SFGetSpellTargetName(int nTarget)
{
    string sReturn = "";
    if (nTarget & SPELLFUNC_TARGET_CREATURE) sReturn = sReturn + "creature/";
    if (nTarget & SPELLFUNC_TARGET_GROUND) sReturn = sReturn + "ground/";
    if (nTarget & SPELLFUNC_TARGET_ITEM) sReturn = sReturn + "item/";
    if (nTarget & SPELLFUNC_TARGET_DOOR) sReturn = sReturn + "door/";
    if (nTarget & SPELLFUNC_TARGET_PLACEABLE) sReturn = sReturn + "placeable/";
    if (nTarget & SPELLFUNC_TARGET_TRIGGER) sReturn = sReturn + "trigger/";
    if (sReturn == "") return "none/";
    else return (sReturn);
}

int SFGetSpellRange(int nSpell)
{
    return ( GetLocalInt(GetModule(), "SFPacked1_"+IntToString(nSpell)) & SPELLFUNC_RANGE_MASK);
}

string SFGetSpellRangeName(int nRange)
{
    switch (nRange)
    {
        case SPELLFUNC_RANGE_LARGE: return "large";
        case SPELLFUNC_RANGE_MEDIUM: return "medium";
        case SPELLFUNC_RANGE_SMALL: return "small";
        case SPELLFUNC_RANGE_TOUCH: return "touch";
        case SPELLFUNC_RANGE_PERSONAL: return "self-only";
    }
    return "unknown range";
}

int SFGetSpellSchool(int nSpell)
{
    return ( (GetLocalInt(GetModule(), "SFPacked1_"+IntToString(nSpell)) & SPELLFUNC_SPELL_SCHOOL_MASK) >> SPELLFUNC_SPELL_SCHOOL_SHIFT);
}

string SFGetSpellSchoolName(int nSpellSchool)
{
    if (nSpellSchool == SPELL_SCHOOL_ABJURATION) return "Abjuration";
    if (nSpellSchool == SPELL_SCHOOL_CONJURATION) return "Conjuration";
    if (nSpellSchool == SPELL_SCHOOL_DIVINATION) return "Divination";
    if (nSpellSchool == SPELL_SCHOOL_ENCHANTMENT) return "Enchantment";
    if (nSpellSchool == SPELL_SCHOOL_EVOCATION) return "Evocation";
    if (nSpellSchool == SPELL_SCHOOL_GENERAL) return "General";
    if (nSpellSchool == SPELL_SCHOOL_ILLUSION) return "Illusion";
    if (nSpellSchool == SPELL_SCHOOL_NECROMANCY) return "Necromancy";
    if (nSpellSchool == SPELL_SCHOOL_TRANSMUTATION) return "Transmutation";
    return "unknown spell school";
}

int SFGetIsSpellVocal(int nSpell)
{
    return ( (GetLocalInt(GetModule(), "SFPacked1_"+IntToString(nSpell)) & SPELLFUNC_VOCAL) > 0);
}

int SFGetIsSpellSomatic(int nSpell)
{
    return ( (GetLocalInt(GetModule(), "SFPacked1_"+IntToString(nSpell)) & SPELLFUNC_SOMATIC) > 0);
}

int SFGetSpellProjectile(int nSpell)
{
    return ( (GetLocalInt(GetModule(), "SFPacked1_"+IntToString(nSpell)) & SPELLFUNC_PROJECTILE_MASK) >> SPELLFUNC_PROJECTILE_SHIFT);
}

string SFGetSpellProjectileName(int nProjectile)
{
    switch (nProjectile)
    {
        case PROJECTILE_PATH_TYPE_ACCELERATING: return "accelerating";
        case PROJECTILE_PATH_TYPE_BALLISTIC: return "ballistic";
        case PROJECTILE_PATH_TYPE_DEFAULT: return "default";
        case PROJECTILE_PATH_TYPE_HIGH_BALLISTIC: return "high ballistic";
        case PROJECTILE_PATH_TYPE_HOMING: return "homing";
        case SPELLFUNC_PROJECTILE_PATH_TYPE_SPIRAL: return "spiral";
        case SPELLFUNC_PROJECTILE_PATH_TYPE_LINKED: return "linked";
        case SPELLFUNC_PROJECTILE_PATH_TYPE_BOUNCE: return "bounce";
    }
    return "unknown projectile";
}

int SFGetSpellImmunityType(int nSpell)
{
    return ( GetLocalInt(GetModule(), "SFPacked1_"+IntToString(nSpell)) & SPELLFUNC_IMMUNITY_MASK);
}

string SFGetSpellImmunityName(int nImmunity)
{
    switch(nImmunity)
    {
        case SPELLFUNC_IMMUNITY_NONE: return "none";
        case SPELLFUNC_IMMUNITY_ACID: return "acid";
        case SPELLFUNC_IMMUNITY_COLD: return "cold";
        case SPELLFUNC_IMMUNITY_DEATH: return "death";
        case SPELLFUNC_IMMUNITY_DISEASE: return "disease";
        case SPELLFUNC_IMMUNITY_DIVINE: return "divine";
        case SPELLFUNC_IMMUNITY_FEAR: return "fear";
        case SPELLFUNC_IMMUNITY_FIRE: return "fire";
        case SPELLFUNC_IMMUNITY_ELECTRICITY: return "electrical";
        case SPELLFUNC_IMMUNITY_MIND: return "mind";
        case SPELLFUNC_IMMUNITY_NEGATIVE: return "negative";
        case SPELLFUNC_IMMUNITY_POSITIVE: return "positive";
        case SPELLFUNC_IMMUNITY_POISON: return "poison";
        case SPELLFUNC_IMMUNITY_SONIC: return "sonic";
    }
    return "unknown immunity";
}

string SFGetSpellInfo(int nSpell)
{
    string sMsg = "";
    int iTmp;
    sMsg += "Spell: "+SFGetSpellName(nSpell)+" Script: "+SFGetSpellScript(nSpell);
    sMsg += ", Feat: "+IntToString(SFGetIsSpellFeat(nSpell));
    sMsg += ", Hostile: "+IntToString(SFGetIsSpellHarmful(nSpell));
    sMsg += ", Somatic: "+IntToString(SFGetIsSpellSomatic(nSpell));
    sMsg += ", Vocal: "+IntToString(SFGetIsSpellVocal(nSpell));
    sMsg += ", Innate level: "+IntToString(SFGetInnateSpellLevel(nSpell));
    sMsg += ", Bard level: "+IntToString(SFGetInnateSpellLevelByClass(nSpell, CLASS_TYPE_BARD));
    sMsg += ", Cleric level: "+IntToString(SFGetInnateSpellLevelByClass(nSpell, CLASS_TYPE_CLERIC));
    sMsg += ", Druid level: "+IntToString(SFGetInnateSpellLevelByClass(nSpell, CLASS_TYPE_DRUID));
    sMsg += ", Paladin level: "+IntToString(SFGetInnateSpellLevelByClass(nSpell, CLASS_TYPE_PALADIN));
    sMsg += ", Ranger level: "+IntToString(SFGetInnateSpellLevelByClass(nSpell, CLASS_TYPE_RANGER));
    sMsg += ", Sorcerer level: "+IntToString(SFGetInnateSpellLevelByClass(nSpell, CLASS_TYPE_SORCERER));
    sMsg += ", Wizard level: "+IntToString(SFGetInnateSpellLevelByClass(nSpell, CLASS_TYPE_WIZARD));
    iTmp = SFGetSpellImmunityType(nSpell);
    sMsg += ", Immunity: "+SFGetSpellImmunityName(iTmp)+" ("+IntToString(iTmp >> SPELLFUNC_IMMUNITY_SHIFT)+")";
    iTmp = SFGetSpellProjectile(nSpell);
    sMsg += ", Projectile: "+SFGetSpellProjectileName(iTmp)+" ("+IntToString(iTmp)+")";
    iTmp = SFGetSpellMetamagic(nSpell);
    sMsg += ", Metamagic: "+SFGetSpellMetamagicName(iTmp)+" ("+IntToString(iTmp)+")";
    iTmp = SFGetSpellRange(nSpell);
    sMsg += ", Range: "+SFGetSpellRangeName(iTmp)+" ("+IntToString(iTmp >> SPELLFUNC_RANGE_SHIFT)+")";
    iTmp = SFGetSpellSchool(nSpell);
    sMsg += ", School: "+SFGetSpellSchoolName(iTmp)+" ("+IntToString(iTmp)+")";
    iTmp = SFGetSpellTarget(nSpell);
    sMsg += ", Target: "+SFGetSpellTargetName(iTmp)+" ("+IntToString(iTmp >> SPELLFUNC_TARGET_SHIFT)+")";
    return (sMsg);
}

void SFInitialization()
{
    SetLocalString(OBJECT_SELF, "SFScripts_0", "NW_S0_AcidFog"); // Acid Fog
    SetLocalString(OBJECT_SELF, "SFScripts_1", "NW_S0_Aid"); // Aid
    SetLocalString(OBJECT_SELF, "SFScripts_10", "NW_S0_BurnHand"); // Burning Hands
    SetLocalString(OBJECT_SELF, "SFScripts_100", "NW_S0_Light"); // Light
    SetLocalString(OBJECT_SELF, "SFScripts_1000", "te_sp_udafd"); // Undeath After Death
    SetLocalString(OBJECT_SELF, "SFScripts_1002", "te_sp_blas"); // Blasphemy
    SetLocalString(OBJECT_SELF, "SFScripts_1005", "te_sp_coldfire"); // Cold Fire
    SetLocalString(OBJECT_SELF, "SFScripts_1006", "te_sp_paralyze"); // Paralyzing touch
    SetLocalString(OBJECT_SELF, "SFScripts_1007", "te_sp_daylight"); // Daylight
    SetLocalString(OBJECT_SELF, "SFScripts_1008", "te_sp_chillt"); // Chill Touch
    SetLocalString(OBJECT_SELF, "SFScripts_1009", "te_sp_comund"); // Command Undead
    SetLocalString(OBJECT_SELF, "SFScripts_101", "NW_S0_LghtnBolt"); // Lightning Bolt
    SetLocalString(OBJECT_SELF, "SFScripts_1010", "te_sp_agansc"); // Aganazzer FlameWave
    SetLocalString(OBJECT_SELF, "SFScripts_1011", "te_sp_falselife"); // False Life
    SetLocalString(OBJECT_SELF, "SFScripts_1012", "te_sp_haltund"); // Halt Undead
    SetLocalString(OBJECT_SELF, "SFScripts_1013", "te_sp_deepsl"); // Deep Slumber
    SetLocalString(OBJECT_SELF, "SFScripts_1014", "te_sp_shadspr"); // Shadow Spray
    SetLocalString(OBJECT_SELF, "SFScripts_1015", "te_sp_disint"); // Disintegrate
    SetLocalString(OBJECT_SELF, "SFScripts_1016", "te_sp_disruptud"); // Disrupt Undead
    SetLocalString(OBJECT_SELF, "SFScripts_1017", "te_sp_glibness"); // Glibness
    SetLocalString(OBJECT_SELF, "SFScripts_1018", "te_sp_crush"); // Crushing Despair
    SetLocalString(OBJECT_SELF, "SFScripts_1019", "te_sp_goodhope"); // Good Hope
    SetLocalString(OBJECT_SELF, "SFScripts_102", "NW_S0_MageArm"); // Mage Armor
    SetLocalString(OBJECT_SELF, "SFScripts_1020", "te_sp_afflic"); // Affliction
    SetLocalString(OBJECT_SELF, "SFScripts_1021", "te_sp_aspect"); // Aspect Of The Deity
    SetLocalString(OBJECT_SELF, "SFScripts_1022", "te_sp_blood"); // Blood Of Martyr
    SetLocalString(OBJECT_SELF, "SFScripts_1023", "te_sp_divine"); // Divine Sacrifice
    SetLocalString(OBJECT_SELF, "SFScripts_1024", "te_sp_lantern"); // Lantern Light
    SetLocalString(OBJECT_SELF, "SFScripts_1025", "te_sp_flesh"); // Fleshshiver
    SetLocalString(OBJECT_SELF, "SFScripts_1026", "te_sp_lively"); // Lively Step
    SetLocalString(OBJECT_SELF, "SFScripts_1027", "te_sp_corro"); // Corrosive Grasp
    SetLocalString(OBJECT_SELF, "SFScripts_1028", "te_sp_shadwell"); // Shadow Well
    SetLocalString(OBJECT_SELF, "SFScripts_1029", "te_sp_memrot"); // Memory Rot
    SetLocalString(OBJECT_SELF, "SFScripts_103", "NW_S0_CircChaos"); // Magic Circle against Chaos
    SetLocalString(OBJECT_SELF, "SFScripts_1030", "te_sp_massbull"); // Mass Bulls Strength
    SetLocalString(OBJECT_SELF, "SFScripts_1031", "te_sp_masscat"); // Mass Cats Grace
    SetLocalString(OBJECT_SELF, "SFScripts_1032", "te_sp_masseag"); // Mass Eagle Splendor
    SetLocalString(OBJECT_SELF, "SFScripts_1033", "te_sp_massend"); // Mass Endurance
    SetLocalString(OBJECT_SELF, "SFScripts_1034", "te_sp_massfox"); // Mass Foxs Cunning
    SetLocalString(OBJECT_SELF, "SFScripts_1035", "te_sp_massowl"); // Mass Owls Wisdom
    SetLocalString(OBJECT_SELF, "SFScripts_1036", "te_sp_attone"); // Atonement
    SetLocalString(OBJECT_SELF, "SFScripts_1037", "te_sp_longst"); // Longstrider
    SetLocalString(OBJECT_SELF, "SFScripts_1038", "te_sp_nondet"); // Nondetection
    SetLocalString(OBJECT_SELF, "SFScripts_1039", "te_sp_rustgra"); // Rusting grasp
    SetLocalString(OBJECT_SELF, "SFScripts_104", "NW_S0_CircEvil"); // Magic Circle against Evil
    SetLocalString(OBJECT_SELF, "SFScripts_1040", "te_sp_wordrec"); // Word of recall
    SetLocalString(OBJECT_SELF, "SFScripts_1041", "te_sp_bligh"); // Blight
    SetLocalString(OBJECT_SELF, "SFScripts_1043", "te_leadership"); // Leadership
    SetLocalString(OBJECT_SELF, "SFScripts_1045", "te_sp_sweap"); // Spiritual Weapon
    SetLocalString(OBJECT_SELF, "SFScripts_1047", "NW_S0_Darkness"); // Darkness
    SetLocalString(OBJECT_SELF, "SFScripts_105", "NW_S0_CircGood"); // Magic Circle against Good
    SetLocalString(OBJECT_SELF, "SFScripts_1050", "te_eb_chain"); // Eldritch Chain
    SetLocalString(OBJECT_SELF, "SFScripts_1051", "te_eb_cone"); // Eldritch Cone
    SetLocalString(OBJECT_SELF, "SFScripts_1052", "te_eb_spear"); // Eldritch Spear
    SetLocalString(OBJECT_SELF, "SFScripts_1053", "te_eb_doom"); // Eldritch Doom
    SetLocalString(OBJECT_SELF, "SFScripts_1054", "te_eb_melee"); // Hideous Blow
    SetLocalString(OBJECT_SELF, "SFScripts_1055", "te_eb_handle"); // Frightful Blast
    SetLocalString(OBJECT_SELF, "SFScripts_1056", "te_eb_handle"); // Sickening Blast
    SetLocalString(OBJECT_SELF, "SFScripts_1057", "te_eb_handle"); // Brimstone Blast
    SetLocalString(OBJECT_SELF, "SFScripts_1058", "te_eb_handle"); // Hellrime Blast
    SetLocalString(OBJECT_SELF, "SFScripts_1059", "te_eb_handle"); // Vitriolic Blast
    SetLocalString(OBJECT_SELF, "SFScripts_106", "NW_S0_CircLaw"); // Magic Circle against Law
    SetLocalString(OBJECT_SELF, "SFScripts_1060", "te_eb_handle"); // Bewitching Blast
    SetLocalString(OBJECT_SELF, "SFScripts_1061", "te_eb_handle"); // Utterdark Blast
    SetLocalString(OBJECT_SELF, "SFScripts_1062", "te_eb_handle"); // Repelling Blast
    SetLocalString(OBJECT_SELF, "SFScripts_1063", "te_sjump"); // Flee The Scene
    SetLocalString(OBJECT_SELF, "SFScripts_1064", "te_sdoor"); // Path Of Shadow
    SetLocalString(OBJECT_SELF, "SFScripts_107", "NW_S0_MagMiss"); // Magic Missile
    SetLocalString(OBJECT_SELF, "SFScripts_1070", "te_sp_orb"); // Orb Lsr Acid
    SetLocalString(OBJECT_SELF, "SFScripts_1071", "te_sp_orb"); // Orb Lsr Cold
    SetLocalString(OBJECT_SELF, "SFScripts_1072", "te_sp_orb"); // Orb Lsr Elec
    SetLocalString(OBJECT_SELF, "SFScripts_1073", "te_sp_orb"); // Orb Lsr Fire
    SetLocalString(OBJECT_SELF, "SFScripts_1074", "te_sp_orb"); // Orb Lsr Sonic
    SetLocalString(OBJECT_SELF, "SFScripts_108", "NW_S0_MagVest"); // Magic Vestment
    SetLocalString(OBJECT_SELF, "SFScripts_109", "NW_S0_MagWeap"); // Magic Weapon
    SetLocalString(OBJECT_SELF, "SFScripts_11", "NW_S0_CallLghtn"); // Call Lightning
    SetLocalString(OBJECT_SELF, "SFScripts_110", "NW_S0_MassBlDf"); // Mass Blindness and Deafness
    SetLocalString(OBJECT_SELF, "SFScripts_111", "NW_S0_MsCharm"); // Mass Charm
    SetLocalString(OBJECT_SELF, "SFScripts_112", "NW_S0_MasDomn"); // Mass Domination
    SetLocalString(OBJECT_SELF, "SFScripts_113", "NW_S0_MasHaste"); // Mass Haste
    SetLocalString(OBJECT_SELF, "SFScripts_114", "NW_S0_MasHeal"); // Mass Heal
    SetLocalString(OBJECT_SELF, "SFScripts_115", "NW_S0_AcidArrow"); // Melfs Acid Arrow
    SetLocalString(OBJECT_SELF, "SFScripts_116", "NW_S0_MetSwarm"); // Meteor Swarm
    SetLocalString(OBJECT_SELF, "SFScripts_117", "NW_S0_MindBlk"); // Mind Blank
    SetLocalString(OBJECT_SELF, "SFScripts_118", "NW_S0_MindFog"); // Mind Fog
    SetLocalString(OBJECT_SELF, "SFScripts_119", "NW_S0_MinGlobe"); // Minor Globe of Invulnerability
    SetLocalString(OBJECT_SELF, "SFScripts_12", "NW_S0_CalmEmot"); // Calm Emotions
    SetLocalString(OBJECT_SELF, "SFScripts_120", "NW_S0_GhostVis"); // Ghostly Visage
    SetLocalString(OBJECT_SELF, "SFScripts_121", "NW_S0_EtherVis"); // Ethereal Visage
    SetLocalString(OBJECT_SELF, "SFScripts_122", "NW_S0_MordDisj"); // Mordenkainens Disjunction
    SetLocalString(OBJECT_SELF, "SFScripts_123", "NW_S0_MordSwrd"); // Mordenkainens Sword
    SetLocalString(OBJECT_SELF, "SFScripts_124", "NW_S0_NatureBal"); // Natures Balance
    SetLocalString(OBJECT_SELF, "SFScripts_125", "NW_S0_NegProt"); // Negative Energy Protection
    SetLocalString(OBJECT_SELF, "SFScripts_126", "NW_S0_RemEffect"); // Neutralize Poison
    SetLocalString(OBJECT_SELF, "SFScripts_127", "NW_S0_PhanKill"); // Phantasmal Killer
    SetLocalString(OBJECT_SELF, "SFScripts_128", "te_planar"); // Planar Binding
    SetLocalString(OBJECT_SELF, "SFScripts_129", "NW_S0_Poison"); // Poison
    SetLocalString(OBJECT_SELF, "SFScripts_13", "NW_S0_CatGrace"); // Cats Grace
    SetLocalString(OBJECT_SELF, "SFScripts_130", "NW_S0_PolySelf"); // Polymorph Self
    SetLocalString(OBJECT_SELF, "SFScripts_131", "NW_S0_PWKill"); // Power Word Kill
    SetLocalString(OBJECT_SELF, "SFScripts_132", "NW_S0_PWStun"); // Power Word Stun
    SetLocalString(OBJECT_SELF, "SFScripts_133", "NW_S0_Prayer"); // Prayer
    SetLocalString(OBJECT_SELF, "SFScripts_134", "NW_S0_Premo"); // Premonition
    SetLocalString(OBJECT_SELF, "SFScripts_135", "NW_S0_PrisSpray"); // Prismatic Spray
    SetLocalString(OBJECT_SELF, "SFScripts_136", "NW_S0_PrChaos"); // Protection from Chaos
    SetLocalString(OBJECT_SELF, "SFScripts_137", "NW_S0_ProEle"); // Protection from Elements
    SetLocalString(OBJECT_SELF, "SFScripts_138", "NW_S0_PrEvil"); // Protection from Evil
    SetLocalString(OBJECT_SELF, "SFScripts_139", "NW_S0_PrGood"); // Protection from Good
    SetLocalString(OBJECT_SELF, "SFScripts_14", "NW_S0_ChLightn"); // Chain Lightning
    SetLocalString(OBJECT_SELF, "SFScripts_140", "NW_S0_PrLaw"); // Protection from Law
    SetLocalString(OBJECT_SELF, "SFScripts_141", "NW_S0_PrSpells"); // Protection from Spells
    SetLocalString(OBJECT_SELF, "SFScripts_142", "NW_S0_RaisDead"); // Raise Dead
    SetLocalString(OBJECT_SELF, "SFScripts_143", "NW_S0_RayEnfeeb"); // Ray of Enfeeblement
    SetLocalString(OBJECT_SELF, "SFScripts_144", "NW_S0_RayFrost"); // Ray of Frost
    SetLocalString(OBJECT_SELF, "SFScripts_145", "NW_S0_RemEffect"); // Remove Blindness and Deafness
    SetLocalString(OBJECT_SELF, "SFScripts_146", "NW_S0_RemEffect"); // Remove Curse
    SetLocalString(OBJECT_SELF, "SFScripts_147", "NW_S0_RemEffect"); // Remove Disease
    SetLocalString(OBJECT_SELF, "SFScripts_148", "NW_S0_RmvFear"); // Remove Fear
    SetLocalString(OBJECT_SELF, "SFScripts_149", "NW_S0_RmvParal"); // Remove Paralysis
    SetLocalString(OBJECT_SELF, "SFScripts_15", "NW_S0_CharmMon"); // Charm Monster
    SetLocalString(OBJECT_SELF, "SFScripts_150", "NW_S0_ResEle"); // Resist Elements
    SetLocalString(OBJECT_SELF, "SFScripts_151", "NW_S0_Resis"); // Resistance
    SetLocalString(OBJECT_SELF, "SFScripts_152", "NW_S0_Restore"); // Restoration
    SetLocalString(OBJECT_SELF, "SFScripts_153", "NW_S0_Resserec"); // Resurrection
    SetLocalString(OBJECT_SELF, "SFScripts_154", "NW_S0_Sanctuary"); // Sanctuary
    SetLocalString(OBJECT_SELF, "SFScripts_155", "NW_S0_Scare"); // Scare
    SetLocalString(OBJECT_SELF, "SFScripts_156", "NW_S0_SearLght"); // Searing Light
    SetLocalString(OBJECT_SELF, "SFScripts_157", "NW_S0_SeeInvis"); // See Invisibility
    SetLocalString(OBJECT_SELF, "SFScripts_158", "NW_S0_Shades"); // Shades
    SetLocalString(OBJECT_SELF, "SFScripts_159", "NW_S0_ShadConj"); // Shadow Conjuration
    SetLocalString(OBJECT_SELF, "SFScripts_16", "NW_S0_CharmPer"); // Charm Person
    SetLocalString(OBJECT_SELF, "SFScripts_160", "NW_S0_ShadShld"); // Shadow Shield
    SetLocalString(OBJECT_SELF, "SFScripts_161", "NW_S0_ShapeChg"); // Shapechange
    SetLocalString(OBJECT_SELF, "SFScripts_162", "NW_S0_ShldLaw"); // Shield of Law
    SetLocalString(OBJECT_SELF, "SFScripts_163", "NW_S0_Silence"); // Silence
    SetLocalString(OBJECT_SELF, "SFScripts_164", "NW_S0_SlayLive"); // Slay Living
    SetLocalString(OBJECT_SELF, "SFScripts_165", "NW_S0_Sleep"); // Sleep
    SetLocalString(OBJECT_SELF, "SFScripts_166", "NW_S0_Slow"); // Slow
    SetLocalString(OBJECT_SELF, "SFScripts_167", "NW_S0_SndBurst"); // Sound Burst
    SetLocalString(OBJECT_SELF, "SFScripts_168", "NW_S0_SplResis"); // Spell Resistance
    SetLocalString(OBJECT_SELF, "SFScripts_169", "NW_S0_SpMantle"); // Spell Mantle
    SetLocalString(OBJECT_SELF, "SFScripts_17", "NW_S0_CharmAni"); // Charm Person or Animal
    SetLocalString(OBJECT_SELF, "SFScripts_170", "NW_S0_SphChaos"); // Sphere of Chaos
    SetLocalString(OBJECT_SELF, "SFScripts_171", "NW_S0_StinkCld"); // Stinking Cloud
    SetLocalString(OBJECT_SELF, "SFScripts_172", "NW_S0_Stoneskn"); // Stoneskin
    SetLocalString(OBJECT_SELF, "SFScripts_173", "NW_S0_StormVeng"); // Storm of Vengeance
    SetLocalString(OBJECT_SELF, "SFScripts_174", "NW_S0_Summon"); // Summon Creature I
    SetLocalString(OBJECT_SELF, "SFScripts_175", "NW_S0_Summon"); // Summon Creature II
    SetLocalString(OBJECT_SELF, "SFScripts_176", "NW_S0_Summon"); // Summon Creature III
    SetLocalString(OBJECT_SELF, "SFScripts_177", "NW_S0_Summon"); // Summon Creature IV
    SetLocalString(OBJECT_SELF, "SFScripts_178", "NW_S0_Summon"); // Summon Creature IX
    SetLocalString(OBJECT_SELF, "SFScripts_179", "NW_S0_Summon"); // Summon Creature V
    SetLocalString(OBJECT_SELF, "SFScripts_18", "NW_S0_CircDeath"); // Circle of Death
    SetLocalString(OBJECT_SELF, "SFScripts_180", "NW_S0_Summon"); // Summon Creature VI
    SetLocalString(OBJECT_SELF, "SFScripts_181", "NW_S0_Summon"); // Summon Creature VII
    SetLocalString(OBJECT_SELF, "SFScripts_182", "NW_S0_Summon"); // Summon Creature VIII
    SetLocalString(OBJECT_SELF, "SFScripts_183", "NW_S0_Sunbeam"); // Sunbeam
    SetLocalString(OBJECT_SELF, "SFScripts_184", "NW_S0_TensTrans"); // Tensers Transformation
    SetLocalString(OBJECT_SELF, "SFScripts_185", "NW_S0_TimeStop"); // Time Stop
    SetLocalString(OBJECT_SELF, "SFScripts_186", "NW_S0_TrueSee"); // True Seeing
    SetLocalString(OBJECT_SELF, "SFScripts_187", "NW_S0_UnhAura"); // Unholy Aura
    SetLocalString(OBJECT_SELF, "SFScripts_188", "NW_S0_VampTch"); // Vampiric Touch
    SetLocalString(OBJECT_SELF, "SFScripts_189", "NW_S0_Virtue"); // Virtue
    SetLocalString(OBJECT_SELF, "SFScripts_19", "NW_S0_CircDoom"); // Circle of Doom
    SetLocalString(OBJECT_SELF, "SFScripts_190", "NW_S0_WailBansh"); // Wail of the Banshee
    SetLocalString(OBJECT_SELF, "SFScripts_191", "NW_S0_WallFire"); // Wall of Fire
    SetLocalString(OBJECT_SELF, "SFScripts_192", "NW_S0_Web"); // Web
    SetLocalString(OBJECT_SELF, "SFScripts_193", "NW_S0_Weird"); // Weird
    SetLocalString(OBJECT_SELF, "SFScripts_194", "NW_S0_WordFaith"); // Word of Faith
    SetLocalString(OBJECT_SELF, "SFScripts_195", "NW_S1_AuraBlind"); // AURA BLINDING
    SetLocalString(OBJECT_SELF, "SFScripts_196", "NW_S1_AuraCold"); // Aura Cold
    SetLocalString(OBJECT_SELF, "SFScripts_197", "NW_S1_AuraElec"); // Aura Electricity
    SetLocalString(OBJECT_SELF, "SFScripts_198", "NW_S1_AuraFear"); // Aura Fear
    SetLocalString(OBJECT_SELF, "SFScripts_199", "NW_S1_AuraFire"); // Aura Fire
    SetLocalString(OBJECT_SELF, "SFScripts_2", "NW_S0_AnimDead"); // Animate Dead
    SetLocalString(OBJECT_SELF, "SFScripts_20", "NW_S0_ClairAdVo"); // Clairaudience and Clairvoyance
    SetLocalString(OBJECT_SELF, "SFScripts_200", "NW_S1_AuraMenac"); // Aura Menace
    SetLocalString(OBJECT_SELF, "SFScripts_201", "NW_S1_AuraProt"); // Aura Protection
    SetLocalString(OBJECT_SELF, "SFScripts_202", "NW_S1_AuraStun"); // Aura Stun
    SetLocalString(OBJECT_SELF, "SFScripts_203", "NW_S1_AuraUnEar"); // Aura Unearthly Visage
    SetLocalString(OBJECT_SELF, "SFScripts_204", "NW_S1_AuraUnnat"); // Aura Unnatural
    SetLocalString(OBJECT_SELF, "SFScripts_205", "NW_S1_BltChrDr"); // Bolt Ability Drain Charisma
    SetLocalString(OBJECT_SELF, "SFScripts_206", "NW_S1_BltConDr"); // Bolt Ability Drain Constitution
    SetLocalString(OBJECT_SELF, "SFScripts_207", "NW_S1_BltDexDr"); // Bolt Ability Drain Dexterity
    SetLocalString(OBJECT_SELF, "SFScripts_208", "NW_S1_BltIntDr"); // Bolt Ability Drain Intelligence
    SetLocalString(OBJECT_SELF, "SFScripts_209", "NW_S1_BltStrDr"); // Bolt Ability Drain Strength
    SetLocalString(OBJECT_SELF, "SFScripts_21", "NW_S0_Clarity"); // Clarity
    SetLocalString(OBJECT_SELF, "SFScripts_210", "NW_S1_BltWisDr"); // Bolt Ability Drain Wisdom
    SetLocalString(OBJECT_SELF, "SFScripts_211", "NW_S1_BltAcid"); // Bolt Acid
    SetLocalString(OBJECT_SELF, "SFScripts_212", "NW_S1_BltCharm"); // Bolt Charm
    SetLocalString(OBJECT_SELF, "SFScripts_213", "NW_S1_BltCold"); // Bolt Cold
    SetLocalString(OBJECT_SELF, "SFScripts_214", "NW_S1_BltConf"); // Bolt Confuse
    SetLocalString(OBJECT_SELF, "SFScripts_215", "NW_S1_BltDaze"); // Bolt Daze
    SetLocalString(OBJECT_SELF, "SFScripts_216", "NW_S1_BltDeath"); // Bolt Death
    SetLocalString(OBJECT_SELF, "SFScripts_217", "NW_S1_BltDisese"); // Bolt Disease
    SetLocalString(OBJECT_SELF, "SFScripts_218", "NW_S1_BltDomn"); // Bolt Dominate
    SetLocalString(OBJECT_SELF, "SFScripts_219", "NW_S1_BltFire"); // Bolt Fire
    SetLocalString(OBJECT_SELF, "SFScripts_22", "NW_S0_ClokChaos"); // Cloak of Chaos
    SetLocalString(OBJECT_SELF, "SFScripts_220", "NW_S1_BltKnckD"); // Bolt Knockdown
    SetLocalString(OBJECT_SELF, "SFScripts_221", "NW_S1_BltLvlDr"); // Bolt Level Drain
    SetLocalString(OBJECT_SELF, "SFScripts_222", "NW_S1_BltLightn"); // Bolt Lightning
    SetLocalString(OBJECT_SELF, "SFScripts_223", "NW_S1_BltParal"); // Bolt Paralyze
    SetLocalString(OBJECT_SELF, "SFScripts_224", "NW_S1_BltPoison"); // Bolt Poison
    SetLocalString(OBJECT_SELF, "SFScripts_225", "NW_S1_BltShards"); // Bolt Shards
    SetLocalString(OBJECT_SELF, "SFScripts_226", "NW_S1_BltSlow"); // Bolt Slow
    SetLocalString(OBJECT_SELF, "SFScripts_227", "NW_S1_BltStun"); // Bolt Stun
    SetLocalString(OBJECT_SELF, "SFScripts_228", "NW_S1_BltWeb"); // Bolt Web
    SetLocalString(OBJECT_SELF, "SFScripts_229", "NW_S1_ConeAcid"); // Cone Acid
    SetLocalString(OBJECT_SELF, "SFScripts_23", "NW_S0_CloudKill"); // Cloudkill
    SetLocalString(OBJECT_SELF, "SFScripts_230", "NW_S1_ConeCold"); // Cone Cold
    SetLocalString(OBJECT_SELF, "SFScripts_2306", "vaei_s3_anim1"); // VAA Anim1
    SetLocalString(OBJECT_SELF, "SFScripts_2307", "vaei_s3_anim2"); // VAA Anim2
    SetLocalString(OBJECT_SELF, "SFScripts_2308", "vaei_s3_anim3"); // VAA Anim3
    SetLocalString(OBJECT_SELF, "SFScripts_2309", "vaei_s3_anim4"); // VAA Anim4
    SetLocalString(OBJECT_SELF, "SFScripts_231", "NW_S1_ConeDisea"); // Cone Disease
    SetLocalString(OBJECT_SELF, "SFScripts_2310", "vaei_s3_anim5"); // VAA Anim5
    SetLocalString(OBJECT_SELF, "SFScripts_2312", "vaei_s3_anim6"); // VAA Anim6
    SetLocalString(OBJECT_SELF, "SFScripts_2313", "vaei_s3_anim7"); // VAA Anim7
    SetLocalString(OBJECT_SELF, "SFScripts_2314", "vaei_s3_anim8"); // VAA Anim8
    SetLocalString(OBJECT_SELF, "SFScripts_2315", "vaei_s3_anim9"); // VAA Anim9
    SetLocalString(OBJECT_SELF, "SFScripts_2316", "vaei_s3_anim10"); // VAA Anim10
    SetLocalString(OBJECT_SELF, "SFScripts_232", "NW_S1_ConeFire"); // Cone Fire
    SetLocalString(OBJECT_SELF, "SFScripts_233", "NW_S1_ConeElec"); // Cone Lightning
    SetLocalString(OBJECT_SELF, "SFScripts_234", "NW_S1_ConePois"); // Cone Poison
    SetLocalString(OBJECT_SELF, "SFScripts_235", "NW_S1_ConeSonic"); // Cone Sonic
    SetLocalString(OBJECT_SELF, "SFScripts_236", "NW_S1_DragAcid"); // Dragon Breath Acid
    SetLocalString(OBJECT_SELF, "SFScripts_237", "NW_S1_DragCold"); // Dragon Breath Cold
    SetLocalString(OBJECT_SELF, "SFScripts_238", "NW_S1_DragFear"); // Dragon Breath Fear
    SetLocalString(OBJECT_SELF, "SFScripts_239", "NW_S1_DragFire"); // Dragon Breath Fire
    SetLocalString(OBJECT_SELF, "SFScripts_24", "NW_S0_ColSpray"); // Color Spray
    SetLocalString(OBJECT_SELF, "SFScripts_240", "NW_S1_DragGas"); // Dragon Breath Gas
    SetLocalString(OBJECT_SELF, "SFScripts_241", "NW_S1_DragLight"); // Dragon Breath Lightning
    SetLocalString(OBJECT_SELF, "SFScripts_242", "NW_S1_DragParal"); // Dragon Breath Paralyze
    SetLocalString(OBJECT_SELF, "SFScripts_243", "NW_S1_DragSleep"); // Dragon Breath Sleep
    SetLocalString(OBJECT_SELF, "SFScripts_244", "NW_S1_DragSlow"); // Dragon Breath Slow
    SetLocalString(OBJECT_SELF, "SFScripts_245", "NW_S1_DragWeak"); // Dragon Breath Weaken
    SetLocalString(OBJECT_SELF, "SFScripts_246", "NW_S1_WingBlast"); // Dragon Wing Buffet
    SetLocalString(OBJECT_SELF, "SFScripts_247", "NW_S1_Feroc1"); // Ferocity 1
    SetLocalString(OBJECT_SELF, "SFScripts_248", "NW_S1_Feroc2"); // Ferocity 2
    SetLocalString(OBJECT_SELF, "SFScripts_249", "NW_S1_Feroc3"); // Ferocity 3
    SetLocalString(OBJECT_SELF, "SFScripts_25", "NW_S0_ConeCold"); // Cone of Cold
    SetLocalString(OBJECT_SELF, "SFScripts_250", "NW_S1_GazeCharm"); // Gaze Charm
    SetLocalString(OBJECT_SELF, "SFScripts_251", "NW_S1_GazeConfu"); // Gaze Confusion
    SetLocalString(OBJECT_SELF, "SFScripts_252", "NW_S1_GazeDaze"); // Gaze Daze
    SetLocalString(OBJECT_SELF, "SFScripts_253", "NW_S1_GazeDeath"); // Gaze Death
    SetLocalString(OBJECT_SELF, "SFScripts_254", "NW_S1_GazeLaw"); // Gaze Destroy Chaos
    SetLocalString(OBJECT_SELF, "SFScripts_255", "NW_S1_GazeGood"); // Gaze Destroy Evil
    SetLocalString(OBJECT_SELF, "SFScripts_256", "NW_S1_GazeEvil"); // Gaze Destroy Good
    SetLocalString(OBJECT_SELF, "SFScripts_257", "NW_S1_GazeChaos"); // Gaze Destroy Law
    SetLocalString(OBJECT_SELF, "SFScripts_258", "NW_S1_GazeDomn"); // Gaze Dominate
    SetLocalString(OBJECT_SELF, "SFScripts_259", "NW_S1_GazeDoom"); // Gaze Doom
    SetLocalString(OBJECT_SELF, "SFScripts_26", "NW_S0_Confusion"); // Confusion
    SetLocalString(OBJECT_SELF, "SFScripts_260", "NW_S1_GazeFear"); // Gaze Fear
    SetLocalString(OBJECT_SELF, "SFScripts_261", "NW_S1_GazeParal"); // Gaze Paralysis
    SetLocalString(OBJECT_SELF, "SFScripts_262", "NW_S1_GazeStun"); // Gaze Stunned
    SetLocalString(OBJECT_SELF, "SFScripts_263", "NW_S1_GolemGas"); // Golem Breath Gas
    SetLocalString(OBJECT_SELF, "SFScripts_264", "NW_S1_HndBreath"); // Hell Hound Firebreath
    SetLocalString(OBJECT_SELF, "SFScripts_265", "NW_S1_HowlConf"); // Howl Confuse
    SetLocalString(OBJECT_SELF, "SFScripts_266", "NW_S1_HowlDaze"); // Howl Daze
    SetLocalString(OBJECT_SELF, "SFScripts_267", "NW_S1_HowlDeath"); // Howl Death
    SetLocalString(OBJECT_SELF, "SFScripts_268", "NW_S1_HowlDoom"); // Howl Doom
    SetLocalString(OBJECT_SELF, "SFScripts_269", "NW_S1_HowlFear"); // Howl Fear
    SetLocalString(OBJECT_SELF, "SFScripts_27", "NW_S0_Contagion"); // Contagion
    SetLocalString(OBJECT_SELF, "SFScripts_270", "NW_S1_HowlParal"); // Howl Paralysis
    SetLocalString(OBJECT_SELF, "SFScripts_271", "NW_S1_HowlSonic"); // Howl Sonic
    SetLocalString(OBJECT_SELF, "SFScripts_272", "NW_S1_HowlStun"); // Howl Stun
    SetLocalString(OBJECT_SELF, "SFScripts_273", "NW_S1_Intens1"); // Intensity 1
    SetLocalString(OBJECT_SELF, "SFScripts_274", "NW_S1_Intens2"); // Intensity 2
    SetLocalString(OBJECT_SELF, "SFScripts_275", "NW_S1_Intens3"); // Intensity 3
    SetLocalString(OBJECT_SELF, "SFScripts_276", "NW_S1_KrenScare"); // Krenshar Scare
    SetLocalString(OBJECT_SELF, "SFScripts_277", "NW_S0_CurLgtW"); // Lesser Body Adjustment
    SetLocalString(OBJECT_SELF, "SFScripts_278", "NW_S1_MephSalt"); // Mephit Salt Breath
    SetLocalString(OBJECT_SELF, "SFScripts_279", "NW_S1_MephSteam"); // Mephit Steam Breath
    SetLocalString(OBJECT_SELF, "SFScripts_28", "NW_S0_ConUnd"); // Control Undead
    SetLocalString(OBJECT_SELF, "SFScripts_280", "NW_S1_MumUndead"); // Mummy Bolster Undead
    SetLocalString(OBJECT_SELF, "SFScripts_281", "NW_S1_PulsDrwn"); // Pulse Drown
    SetLocalString(OBJECT_SELF, "SFScripts_282", "NW_S1_PulsSpore"); // Pulse Spores
    SetLocalString(OBJECT_SELF, "SFScripts_283", "NW_S1_PulsWind"); // Pulse Whirlwind
    SetLocalString(OBJECT_SELF, "SFScripts_284", "NW_S1_PulsFire"); // Pulse Fire
    SetLocalString(OBJECT_SELF, "SFScripts_285", "NW_S1_PulsElec"); // Pulse Lightning
    SetLocalString(OBJECT_SELF, "SFScripts_286", "NW_S1_PulsCold"); // Pulse Cold
    SetLocalString(OBJECT_SELF, "SFScripts_287", "NW_S1_PulsNeg"); // Pulse Negative
    SetLocalString(OBJECT_SELF, "SFScripts_288", "NW_S1_PulsHoly"); // Pulse Holy
    SetLocalString(OBJECT_SELF, "SFScripts_289", "NW_S1_PulsDeath"); // Pulse Death
    SetLocalString(OBJECT_SELF, "SFScripts_29", "NW_S0_CrGrUnd"); // Create Greater Undead
    SetLocalString(OBJECT_SELF, "SFScripts_290", "NW_S1_PulsLvlDr"); // Pulse Level Drain
    SetLocalString(OBJECT_SELF, "SFScripts_291", "NW_S1_PulsIntDr"); // Pulse Ability Drain Intelligence
    SetLocalString(OBJECT_SELF, "SFScripts_292", "NW_S1_PulsChrDr"); // Pulse Ability Drain Charisma
    SetLocalString(OBJECT_SELF, "SFScripts_293", "NW_S1_PulsConDr"); // Pulse Ability Drain Constitution
    SetLocalString(OBJECT_SELF, "SFScripts_294", "NW_S1_PulsDexDr"); // Pulse Ability Drain Dexterity
    SetLocalString(OBJECT_SELF, "SFScripts_295", "NW_S1_PulsStrDr"); // Pulse Ability Drain Strength
    SetLocalString(OBJECT_SELF, "SFScripts_296", "NW_S1_PulsWisDr"); // Pulse Ability Drain Wisdom
    SetLocalString(OBJECT_SELF, "SFScripts_297", "NW_S1_PulsPois"); // Pulse Poison
    SetLocalString(OBJECT_SELF, "SFScripts_298", "NW_S1_PulsDis"); // Pulse Disease
    SetLocalString(OBJECT_SELF, "SFScripts_299", "NW_S1_Rage1"); // Rage 3
    SetLocalString(OBJECT_SELF, "SFScripts_3", "NW_S0_Barkskin"); // Barkskin
    SetLocalString(OBJECT_SELF, "SFScripts_30", "NW_S0_CrUndead"); // Create Undead
    SetLocalString(OBJECT_SELF, "SFScripts_300", "NW_S1_Rage2"); // Rage 4
    SetLocalString(OBJECT_SELF, "SFScripts_301", "NW_S1_Rage3"); // Rage 5
    SetLocalString(OBJECT_SELF, "SFScripts_302", "NW_S1_SmokeClaw"); // Smoke Claw
    SetLocalString(OBJECT_SELF, "SFScripts_303", "NW_S1_SummSlaad"); // Summon Slaad
    SetLocalString(OBJECT_SELF, "SFScripts_304", "NW_S1_SummTanar"); // Summon Tanarri
    SetLocalString(OBJECT_SELF, "SFScripts_305", "NW_S1_HowlParal"); // Trumpet Blast
    SetLocalString(OBJECT_SELF, "SFScripts_306", "NW_S1_TyrantFog"); // Tyrant Fog Mist
    SetLocalString(OBJECT_SELF, "SFScripts_307", "NW_S1_BarbRage"); // BARBARIAN RAGE
    SetLocalString(OBJECT_SELF, "SFScripts_308", "NW_S2_TurnDead"); // Turn Undead
    SetLocalString(OBJECT_SELF, "SFScripts_309", "NW_S2_Wholeness"); // Wholeness of Body
    SetLocalString(OBJECT_SELF, "SFScripts_31", "NW_S0_CurCrWn"); // Cure Critical Wounds
    SetLocalString(OBJECT_SELF, "SFScripts_310", "NW_S2_Palm"); // Quivering Palm
    SetLocalString(OBJECT_SELF, "SFScripts_311", "NW_S2_Empty"); // Empty Body
    SetLocalString(OBJECT_SELF, "SFScripts_312", "NW_S2_DetecEvil"); // Detect Evil
    SetLocalString(OBJECT_SELF, "SFScripts_313", "NW_S2_LayOnHand"); // Lay On Hands
    SetLocalString(OBJECT_SELF, "SFScripts_314", "NW_S2_CourageA"); // Aura Of Courage
    SetLocalString(OBJECT_SELF, "SFScripts_315", "NW_S2_SmiteEvil"); // Smite Evil
    SetLocalString(OBJECT_SELF, "SFScripts_316", "NW_S0_RemEffect"); // Remove Disease
    SetLocalString(OBJECT_SELF, "SFScripts_317", "NW_S2_AnimalCom"); // Summon Animal Companion
    SetLocalString(OBJECT_SELF, "SFScripts_318", "NW_S2_Familiar"); // Summon Familiar
    SetLocalString(OBJECT_SELF, "SFScripts_319", "NW_S2_ElemShape"); // Elemental Shape
    SetLocalString(OBJECT_SELF, "SFScripts_32", "NW_S0_CurLgtW"); // Cure Light Wounds
    SetLocalString(OBJECT_SELF, "SFScripts_320", "NW_S2_WildShape"); // Wild Shape
    SetLocalString(OBJECT_SELF, "SFScripts_321", "NW_S0_ProtAlign"); // PROTECTION FROM ALIGNMENT
    SetLocalString(OBJECT_SELF, "SFScripts_322", "NW_S0_ProtCircl"); // Magic Circle against Alignment
    SetLocalString(OBJECT_SELF, "SFScripts_323", "NW_S0_ProtAura"); // Aura versus Alignment
    SetLocalString(OBJECT_SELF, "SFScripts_324", "NW_S0_SummShad"); // SHADES Summon Shadow
    SetLocalString(OBJECT_SELF, "SFScripts_325", "NW_S0_PrElm_C"); // DELETED PRO Cold
    SetLocalString(OBJECT_SELF, "SFScripts_326", "NW_S0_PrElm_F"); // DELETED PRO Fire
    SetLocalString(OBJECT_SELF, "SFScripts_327", "NW_S0_PrElm_A"); // DELETED PRO Acid
    SetLocalString(OBJECT_SELF, "SFScripts_328", "NW_S0_PrElm_S"); // DELETED PRO Sonic
    SetLocalString(OBJECT_SELF, "SFScripts_329", "NW_S0_PrElm_E"); // DELETED PRO Elec
    SetLocalString(OBJECT_SELF, "SFScripts_33", "NW_S0_CurMinW"); // Cure Minor Wounds
    SetLocalString(OBJECT_SELF, "SFScripts_330", "NW_S0_EndElm_C"); // DELETED END Cold
    SetLocalString(OBJECT_SELF, "SFScripts_331", "NW_S0_EndElm_F"); // DELETED END Fire
    SetLocalString(OBJECT_SELF, "SFScripts_332", "NW_S0_EndElm_A"); // DELETED END Acid
    SetLocalString(OBJECT_SELF, "SFScripts_333", "NW_S0_EndElm_S"); // DELETED END Sonic
    SetLocalString(OBJECT_SELF, "SFScripts_334", "NW_S0_EndElm_E"); // DELETED END Elec
    SetLocalString(OBJECT_SELF, "SFScripts_335", "NW_S0_ResElm_C"); // DELETED RES Cold
    SetLocalString(OBJECT_SELF, "SFScripts_336", "NW_S0_ResElm_F"); // DELETED RES Fire
    SetLocalString(OBJECT_SELF, "SFScripts_337", "NW_S0_ResElm_A"); // DELETED RES Acid
    SetLocalString(OBJECT_SELF, "SFScripts_338", "NW_S0_ResElm_S"); // DELETED RES Sonic
    SetLocalString(OBJECT_SELF, "SFScripts_339", "NW_S0_ResElm_E"); // DELETED RES Elec
    SetLocalString(OBJECT_SELF, "SFScripts_34", "NW_S0_CurModW"); // Cure Moderate Wounds
    SetLocalString(OBJECT_SELF, "SFScripts_340", "NW_S0_ConeCold"); // SHADES Cone of Cold
    SetLocalString(OBJECT_SELF, "SFScripts_341", "NW_S0_Fireball"); // SHADES Fireball
    SetLocalString(OBJECT_SELF, "SFScripts_342", "NW_S0_Stoneskn"); // SHADES Stoneskin
    SetLocalString(OBJECT_SELF, "SFScripts_343", "NW_S0_WallFire"); // SHADES Wall of Fire
    SetLocalString(OBJECT_SELF, "SFScripts_344", "NW_S0_SummShad"); // SHADOW CON Summon Shadow
    SetLocalString(OBJECT_SELF, "SFScripts_345", "NW_S0_Darkness"); // SHADOW CON Darkness
    SetLocalString(OBJECT_SELF, "SFScripts_346", "NW_S0_Invisib"); // SHADOW CON Inivsibility
    SetLocalString(OBJECT_SELF, "SFScripts_347", "NW_S0_MageArm"); // SHADOW CON Mage Armor
    SetLocalString(OBJECT_SELF, "SFScripts_348", "NW_S0_MagMiss"); // SHADOW CON Magic Missile
    SetLocalString(OBJECT_SELF, "SFScripts_349", "NW_S0_SummShad"); // GR SHADOW CON Summon Shadow
    SetLocalString(OBJECT_SELF, "SFScripts_35", "NW_S0_CurSerW"); // Cure Serious Wounds
    SetLocalString(OBJECT_SELF, "SFScripts_350", "NW_S0_AcidArrow"); // GR SHADOW CON Acid Arrow
    SetLocalString(OBJECT_SELF, "SFScripts_351", "NW_S0_GhostVis"); // GR SHADOW CON Ghostly Visage
    SetLocalString(OBJECT_SELF, "SFScripts_352", "NW_S0_Web"); // GR SHADOW CON Web
    SetLocalString(OBJECT_SELF, "SFScripts_353", "NW_S0_MinGlobe"); // GR SHADOW CON Minor Globe
    SetLocalString(OBJECT_SELF, "SFScripts_354", "NW_S0_EagleSpl"); // Eagle Splendor
    SetLocalString(OBJECT_SELF, "SFScripts_355", "NW_S0_OwlWis"); // Owls Wisdom
    SetLocalString(OBJECT_SELF, "SFScripts_356", "NW_S0_FoxCunng"); // Foxs Cunning
    SetLocalString(OBJECT_SELF, "SFScripts_357", "NW_S0_GrEagleSp"); // Greater Eagle Splendor
    SetLocalString(OBJECT_SELF, "SFScripts_358", "NW_S0_GrOwlWis"); // Greater Owls Wisdom
    SetLocalString(OBJECT_SELF, "SFScripts_359", "NW_S0_GrFoxsCu"); // Greater Foxs Cunning
    SetLocalString(OBJECT_SELF, "SFScripts_36", "NW_S0_Darkness"); // Darkness
    SetLocalString(OBJECT_SELF, "SFScripts_360", "NW_S0_GrBullStr"); // Greater Bulls Strength
    SetLocalString(OBJECT_SELF, "SFScripts_361", "NW_S0_GrCatsGr"); // Greater Cats Grace
    SetLocalString(OBJECT_SELF, "SFScripts_362", "NW_S0_GrEndur"); // Greater Endurance
    SetLocalString(OBJECT_SELF, "SFScripts_363", "NW_S0_Awaken"); // Awaken
    SetLocalString(OBJECT_SELF, "SFScripts_364", "NW_S0_CrpDoom"); // Creeping Doom
    SetLocalString(OBJECT_SELF, "SFScripts_365", "NW_S0_DarkVis"); // Ultravision
    SetLocalString(OBJECT_SELF, "SFScripts_366", "NW_S0_Destruc"); // Destruction
    SetLocalString(OBJECT_SELF, "SFScripts_367", "NW_S0_HorrWilt"); // Horrid Wilting
    SetLocalString(OBJECT_SELF, "SFScripts_368", "NW_S0_IceStorm"); // Ice Storm
    SetLocalString(OBJECT_SELF, "SFScripts_369", "NW_S0_EneBuffer"); // Energy Buffer
    SetLocalString(OBJECT_SELF, "SFScripts_37", "NW_S0_Daze"); // Daze
    SetLocalString(OBJECT_SELF, "SFScripts_370", "NW_S0_NegBurst"); // Negative Energy Burst
    SetLocalString(OBJECT_SELF, "SFScripts_371", "NW_S0_NegRay"); // Negative Energy Ray
    SetLocalString(OBJECT_SELF, "SFScripts_372", "NW_S0_AuraVital"); // Aura of Vitality
    SetLocalString(OBJECT_SELF, "SFScripts_373", "NW_S0_WarCry"); // War Cry
    SetLocalString(OBJECT_SELF, "SFScripts_374", "NW_S0_Regen"); // Regenerate
    SetLocalString(OBJECT_SELF, "SFScripts_375", "NW_S0_Evards"); // Evards Black Tentacles
    SetLocalString(OBJECT_SELF, "SFScripts_376", "NW_S0_Lore"); // Legend Lore
    SetLocalString(OBJECT_SELF, "SFScripts_377", "NW_S0_FindTrap"); // Find Traps
    SetLocalString(OBJECT_SELF, "SFScripts_378", "NW_S1_SummMeph"); // Summon Mephit
    SetLocalString(OBJECT_SELF, "SFScripts_379", "NW_S1_SummCeles"); // Summon Celestial
    SetLocalString(OBJECT_SELF, "SFScripts_38", "NW_S0_DeaWard"); // Death Ward
    SetLocalString(OBJECT_SELF, "SFScripts_380", "NW_S2_BatMast"); // Battle Mastery Spell
    SetLocalString(OBJECT_SELF, "SFScripts_381", "NW_S2_DivStr"); // Divine Strength
    SetLocalString(OBJECT_SELF, "SFScripts_382", "NW_S2_DivProt"); // Divine Protection
    SetLocalString(OBJECT_SELF, "SFScripts_383", "NW_S0_SummShad02"); // Negative Plane Avatar
    SetLocalString(OBJECT_SELF, "SFScripts_384", "NW_S2_DivTrick"); // Divine Trickery
    SetLocalString(OBJECT_SELF, "SFScripts_385", "NW_S0_ExtraThf"); // Rogues Cunning
    SetLocalString(OBJECT_SELF, "SFScripts_386", "NW_S3_ActItem01"); // ACTIVATE ITEM
    SetLocalString(OBJECT_SELF, "SFScripts_387", "NW_S0_PolySelf"); // Polymorph SwordSpider
    SetLocalString(OBJECT_SELF, "SFScripts_388", "NW_S0_PolySelf"); // Polymorph Ogre
    SetLocalString(OBJECT_SELF, "SFScripts_389", "NW_S0_PolySelf"); // Polymorph UMBER HULK
    SetLocalString(OBJECT_SELF, "SFScripts_39", "NW_S0_DelFirebal"); // Delayed Blast Fireball
    SetLocalString(OBJECT_SELF, "SFScripts_390", "NW_S0_PolySelf"); // Polymorph Satyr
    SetLocalString(OBJECT_SELF, "SFScripts_391", "NW_S0_PolySelf"); // Polymorph Ooze
    SetLocalString(OBJECT_SELF, "SFScripts_392", "NW_S0_ShapeChg"); // Shapechange RED DRAGON
    SetLocalString(OBJECT_SELF, "SFScripts_393", "NW_S0_ShapeChg"); // Shapechange FIRE GIANT
    SetLocalString(OBJECT_SELF, "SFScripts_394", "NW_S0_ShapeChg"); // Shapechange BALOR
    SetLocalString(OBJECT_SELF, "SFScripts_395", "NW_S0_ShapeChg"); // Shapechange DEATH SLAAD
    SetLocalString(OBJECT_SELF, "SFScripts_396", "NW_S0_ShapeChg"); // Shapechange IRON GOLEM
    SetLocalString(OBJECT_SELF, "SFScripts_397", "NW_S2_ElemShape"); // Elemental Shape FIRE
    SetLocalString(OBJECT_SELF, "SFScripts_398", "NW_S2_ElemShape"); // Elemental Shape WATER
    SetLocalString(OBJECT_SELF, "SFScripts_399", "NW_S2_ElemShape"); // Elemental Shape EARTH
    SetLocalString(OBJECT_SELF, "SFScripts_4", "NW_S0_BesCurse"); // Bestow Curse
    SetLocalString(OBJECT_SELF, "SFScripts_40", "NW_S0_Dismissal"); // Dismissal
    SetLocalString(OBJECT_SELF, "SFScripts_400", "NW_S2_ElemShape"); // Elemental Shape AIR
    SetLocalString(OBJECT_SELF, "SFScripts_401", "NW_S2_WildShape"); // Wild Shape BROWN BEAR
    SetLocalString(OBJECT_SELF, "SFScripts_402", "NW_S2_WildShape"); // Wild Shape PANTHER
    SetLocalString(OBJECT_SELF, "SFScripts_403", "NW_S2_WildShape"); // Wild Shape WOLF
    SetLocalString(OBJECT_SELF, "SFScripts_404", "NW_S2_WildShape"); // Wild Shape BOAR
    SetLocalString(OBJECT_SELF, "SFScripts_405", "NW_S2_WildShape"); // Wild Shape BADGER
    SetLocalString(OBJECT_SELF, "SFScripts_406", "NW_S3_Alcohol"); // Special Alcohol Beer
    SetLocalString(OBJECT_SELF, "SFScripts_407", "NW_S3_Alcohol"); // Special Alcohol Wine
    SetLocalString(OBJECT_SELF, "SFScripts_408", "NW_S3_Alcohol"); // Special Alcohol Spirits
    SetLocalString(OBJECT_SELF, "SFScripts_409", "NW_S3_Herb"); // Special Herb Belladonna
    SetLocalString(OBJECT_SELF, "SFScripts_41", "NW_S0_DisMagic"); // Dispel Magic
    SetLocalString(OBJECT_SELF, "SFScripts_410", "NW_S3_Herb"); // Special Herb Garlic
    SetLocalString(OBJECT_SELF, "SFScripts_411", "NW_S2_BardSong"); // Bards Song
    SetLocalString(OBJECT_SELF, "SFScripts_412", "NW_S1_AuraDrag"); // Aura Fear Dragon
    SetLocalString(OBJECT_SELF, "SFScripts_413", "NW_S3_ActItem01"); // ACTIVATE ITEM SELF
    SetLocalString(OBJECT_SELF, "SFScripts_414", "x0_s0_divfav"); // Divine Favor
    SetLocalString(OBJECT_SELF, "SFScripts_415", "x0_s0_truestrike"); // True Strike
    SetLocalString(OBJECT_SELF, "SFScripts_416", "X0_S0_Flare"); // Flare
    SetLocalString(OBJECT_SELF, "SFScripts_417", "x0_s0_shield"); // Shield
    SetLocalString(OBJECT_SELF, "SFScripts_418", "x0_s0_entrshield"); // Entropic Shield
    SetLocalString(OBJECT_SELF, "SFScripts_419", "x0_s0_clight"); // Continual Flame
    SetLocalString(OBJECT_SELF, "SFScripts_42", "NW_S0_DivPower"); // Divine Power
    SetLocalString(OBJECT_SELF, "SFScripts_420", "x0_s0_oneland"); // One With The Land
    SetLocalString(OBJECT_SELF, "SFScripts_421", "x0_s0_camo"); // Camoflage
    SetLocalString(OBJECT_SELF, "SFScripts_422", "x0_s0_bldfrenzy"); // Blood Frenzy
    SetLocalString(OBJECT_SELF, "SFScripts_423", "x0_s0_bombard"); // Bombardment
    SetLocalString(OBJECT_SELF, "SFScripts_424", "X0_S0_AcidSplash"); // Acid Splash
    SetLocalString(OBJECT_SELF, "SFScripts_425", "x0_s0_quillfire"); // Quillfire
    SetLocalString(OBJECT_SELF, "SFScripts_426", "x0_s0_earthquake"); // Earthquake
    SetLocalString(OBJECT_SELF, "SFScripts_427", "x0_s0_sunburst"); // Sunburst
    SetLocalString(OBJECT_SELF, "SFScripts_428", "NW_S3_ActItem01"); // ACTIVATE ITEM SELF2
    SetLocalString(OBJECT_SELF, "SFScripts_429", "x0_s0_auraglory"); // AuraOfGlory
    SetLocalString(OBJECT_SELF, "SFScripts_43", "NW_S0_DomAn"); // Dominate Animal
    SetLocalString(OBJECT_SELF, "SFScripts_430", "x0_s0_banishment"); // Banishment
    SetLocalString(OBJECT_SELF, "SFScripts_431", "x0_s0_inflict"); // Inflict Minor Wounds
    SetLocalString(OBJECT_SELF, "SFScripts_432", "x0_s0_inflict"); // Inflict Light Wounds
    SetLocalString(OBJECT_SELF, "SFScripts_433", "x0_s0_inflict"); // Inflict Moderate Wounds
    SetLocalString(OBJECT_SELF, "SFScripts_434", "x0_s0_inflict"); // Inflict Serious Wounds
    SetLocalString(OBJECT_SELF, "SFScripts_435", "x0_s0_inflict"); // Inflict Critical Wounds
    SetLocalString(OBJECT_SELF, "SFScripts_436", "X0_S0_IRONHORN"); // BalagarnsIronHorn
    SetLocalString(OBJECT_SELF, "SFScripts_437", "X0_S0_Drown"); // Drown
    SetLocalString(OBJECT_SELF, "SFScripts_438", "x0_s0_owlins"); // Owls Insight
    SetLocalString(OBJECT_SELF, "SFScripts_439", "X0_S0_ElecJolt"); // Electric Jolt
    SetLocalString(OBJECT_SELF, "SFScripts_44", "NW_S0_DomMon"); // Dominate Monster
    SetLocalString(OBJECT_SELF, "SFScripts_440", "x0_s0_firebrand"); // Firebrand
    SetLocalString(OBJECT_SELF, "SFScripts_441", "x0_s0_woundwhis"); // Wounding Whispers
    SetLocalString(OBJECT_SELF, "SFScripts_442", "x0_s0_amplify"); // Amplify
    SetLocalString(OBJECT_SELF, "SFScripts_443", "x0_s0_ether"); // Etherealness
    SetLocalString(OBJECT_SELF, "SFScripts_444", "x0_s0_udetfoe"); // Undeaths Eternal Foe
    SetLocalString(OBJECT_SELF, "SFScripts_445", "x0_s0_dirge"); // Dirge
    SetLocalString(OBJECT_SELF, "SFScripts_446", "x0_s0_inferno"); // Inferno
    SetLocalString(OBJECT_SELF, "SFScripts_447", "x0_s0_missstorm1"); // Isaacs Lesser Missile Storm
    SetLocalString(OBJECT_SELF, "SFScripts_448", "x0_s0_missstorm2"); // Isaacs Greater Missile Storm
    SetLocalString(OBJECT_SELF, "SFScripts_449", "X0_S0_Bane"); // Bane
    SetLocalString(OBJECT_SELF, "SFScripts_45", "NW_S0_DomPers"); // Dominate Person
    SetLocalString(OBJECT_SELF, "SFScripts_450", "X0_S0_ShieldFait"); // Shield of Faith
    SetLocalString(OBJECT_SELF, "SFScripts_451", "te_planarally"); // Planar Ally
    SetLocalString(OBJECT_SELF, "SFScripts_452", "x0_s0_magicfang"); // Magic Fang
    SetLocalString(OBJECT_SELF, "SFScripts_453", "x0_s0_gmagicfang"); // Greater Magic Fang
    SetLocalString(OBJECT_SELF, "SFScripts_454", "x0_s0_spikegro"); // Spike Growth
    SetLocalString(OBJECT_SELF, "SFScripts_455", "x0_s0_masscamo"); // Mass Camoflage
    SetLocalString(OBJECT_SELF, "SFScripts_456", "x0_s0_exretreat"); // Expeditious Retreat
    SetLocalString(OBJECT_SELF, "SFScripts_457", "x0_s0_laugh"); // Tashas Hideous Laughter
    SetLocalString(OBJECT_SELF, "SFScripts_458", "x0_s0_displace"); // Displacement
    SetLocalString(OBJECT_SELF, "SFScripts_459", "x0_s0_bigby1"); // Bigbys Interposing Hand
    SetLocalString(OBJECT_SELF, "SFScripts_46", "NW_S0_Doom"); // Doom
    SetLocalString(OBJECT_SELF, "SFScripts_460", "x0_s0_bigby2"); // Bigbys Forceful Hand
    SetLocalString(OBJECT_SELF, "SFScripts_461", "x0_s0_bigby3"); // Bigbys Grasping Hand
    SetLocalString(OBJECT_SELF, "SFScripts_462", "x0_s0_bigby4"); // Bigbys Clenched Fist
    SetLocalString(OBJECT_SELF, "SFScripts_463", "x0_s0_bigby5"); // Bigbys Crushing Hand
    SetLocalString(OBJECT_SELF, "SFScripts_464", "x0_s3_alchem"); // Grenade Fire
    SetLocalString(OBJECT_SELF, "SFScripts_465", "x0_s3_tangle"); // Grenade Tangle
    SetLocalString(OBJECT_SELF, "SFScripts_466", "x0_s3_holy"); // Grenade Holy
    SetLocalString(OBJECT_SELF, "SFScripts_467", "x0_s3_choke"); // Grenade Choking
    SetLocalString(OBJECT_SELF, "SFScripts_468", "x0_s3_thunder"); // Grenade Thunderstone
    SetLocalString(OBJECT_SELF, "SFScripts_469", "x0_s3_acid"); // Grenade Acid
    SetLocalString(OBJECT_SELF, "SFScripts_47", "NW_S0_FireShld"); // Elemental Shield
    SetLocalString(OBJECT_SELF, "SFScripts_470", "x0_s3_gag"); // Grenade Chicken
    SetLocalString(OBJECT_SELF, "SFScripts_471", "x0_s3_caltrop"); // Grenade Caltrops
    SetLocalString(OBJECT_SELF, "SFScripts_472", "x0_s3_portal"); // ACTIVATE ITEM PORTAL
    SetLocalString(OBJECT_SELF, "SFScripts_473", "x0_s2_divmight"); // Divine Might
    SetLocalString(OBJECT_SELF, "SFScripts_474", "x0_s2_divshield"); // Divine Shield
    SetLocalString(OBJECT_SELF, "SFScripts_475", "x0_S2_Daze"); // SHADOW DAZE
    SetLocalString(OBJECT_SELF, "SFScripts_476", "X0_S2_ShadSum"); // SUMMON SHADOW
    SetLocalString(OBJECT_SELF, "SFScripts_477", "X0_S2_ShadEvade"); // SHADOW EVADE
    SetLocalString(OBJECT_SELF, "SFScripts_478", "x0_s2_HarpSmile"); // TYMORAS SMILE
    SetLocalString(OBJECT_SELF, "SFScripts_479", "x0_s2_HarpItem"); // CRAFT HARPER ITEM
    SetLocalString(OBJECT_SELF, "SFScripts_48", "NW_S0_EleSwarm"); // Elemental Swarm
    SetLocalString(OBJECT_SELF, "SFScripts_480", "NW_S0_Sleep"); // Sleep
    SetLocalString(OBJECT_SELF, "SFScripts_481", "NW_S0_CatGrace"); // Cats Grace
    SetLocalString(OBJECT_SELF, "SFScripts_482", "NW_S0_EagleSpl"); // Eagle Splendor
    SetLocalString(OBJECT_SELF, "SFScripts_483", "NW_S0_Invisib"); // Invisibility
    SetLocalString(OBJECT_SELF, "SFScripts_485", "x0_s0_fleshsto"); // Flesh to stone
    SetLocalString(OBJECT_SELF, "SFScripts_486", "x0_s0_stoflesh"); // Stone to flesh
    SetLocalString(OBJECT_SELF, "SFScripts_487", "x0_s3_arrow"); // Trap Arrow
    SetLocalString(OBJECT_SELF, "SFScripts_488", "x0_s3_bolt"); // Trap Bolt
    SetLocalString(OBJECT_SELF, "SFScripts_49", "NW_S0_Endurce"); // Endurance
    SetLocalString(OBJECT_SELF, "SFScripts_493", "x0_s3_dart"); // Trap Dart
    SetLocalString(OBJECT_SELF, "SFScripts_494", "x0_s3_shurik"); // Trap Shuriken
    SetLocalString(OBJECT_SELF, "SFScripts_495", "x0_s1_PetrBreath"); // Breath Petrify
    SetLocalString(OBJECT_SELF, "SFScripts_496", "x0_s1_PetrTouch"); // Touch Petrify
    SetLocalString(OBJECT_SELF, "SFScripts_497", "x0_s1_PetrGaze"); // Gaze Petrify
    SetLocalString(OBJECT_SELF, "SFScripts_498", "x0_s1_MantSpike"); // Manticore Spikes
    SetLocalString(OBJECT_SELF, "SFScripts_499", "x0_s3_rodwonder"); // RodOfWonder
    SetLocalString(OBJECT_SELF, "SFScripts_5", "NW_S0_BladeBar"); // Blade Barrier
    SetLocalString(OBJECT_SELF, "SFScripts_50", "NW_S0_EndEle"); // Endure Elements
    SetLocalString(OBJECT_SELF, "SFScripts_500", "x0_s3_deckmany"); // DeckOfManyThings
    SetLocalString(OBJECT_SELF, "SFScripts_502", "x0_s3_summonelem"); // ElementalSummoningItem
    SetLocalString(OBJECT_SELF, "SFScripts_503", "x0_s3_deckavatar"); // DeckAvatar
    SetLocalString(OBJECT_SELF, "SFScripts_504", "x0_s3_gemspray"); // Gem Spray
    SetLocalString(OBJECT_SELF, "SFScripts_505", "x0_s3_butter"); // Butterfly Spray
    SetLocalString(OBJECT_SELF, "SFScripts_507", "x0_s3_pstone"); // PowerStone
    SetLocalString(OBJECT_SELF, "SFScripts_508", "x0_s3_spellstaff"); // Spellstaff
    SetLocalString(OBJECT_SELF, "SFScripts_509", "x0_s3_charger"); // Charger
    SetLocalString(OBJECT_SELF, "SFScripts_51", "NW_S0_EneDrain"); // Energy Drain
    SetLocalString(OBJECT_SELF, "SFScripts_510", "x0_s3_charger"); // Decharger
    SetLocalString(OBJECT_SELF, "SFScripts_511", "x0_s3_koboldjump"); // Kobold Jump
    SetLocalString(OBJECT_SELF, "SFScripts_512", "X2_S0_Crumble"); // Crumble
    SetLocalString(OBJECT_SELF, "SFScripts_513", "X2_S0_InfestMag"); // Infestation of Maggots
    SetLocalString(OBJECT_SELF, "SFScripts_514", "X2_S0_HealStng"); // Healing Sting
    SetLocalString(OBJECT_SELF, "SFScripts_515", "X2_S0_GrtThdclp"); // Great Thunderclap
    SetLocalString(OBJECT_SELF, "SFScripts_516", "X2_S0_BallLghtng"); // Ball Lightning
    SetLocalString(OBJECT_SELF, "SFScripts_517", "X2_S0_BattTide"); // Battletide
    SetLocalString(OBJECT_SELF, "SFScripts_518", "X2_S0_Combust"); // Combust
    SetLocalString(OBJECT_SELF, "SFScripts_519", "X2_S0_DthArm"); // Death Armor
    SetLocalString(OBJECT_SELF, "SFScripts_52", "NW_S0_Enervat"); // Enervation
    SetLocalString(OBJECT_SELF, "SFScripts_520", "X2_S0_ElecLoop"); // Gedlees Electric Loop
    SetLocalString(OBJECT_SELF, "SFScripts_521", "X2_S0_HoriBoom"); // Horizikauls Boom
    SetLocalString(OBJECT_SELF, "SFScripts_522", "X2_S0_Ironguts"); // Ironguts
    SetLocalString(OBJECT_SELF, "SFScripts_523", "X2_S0_AcidBrth"); // Mestils Acid Breath
    SetLocalString(OBJECT_SELF, "SFScripts_524", "X2_S0_AcidShth"); // Mestils Acid Sheath
    SetLocalString(OBJECT_SELF, "SFScripts_525", "X2_S0_MonRegen"); // Monstrous Regeneration
    SetLocalString(OBJECT_SELF, "SFScripts_526", "X2_S0_ScntSphere"); // Scintillating Sphere
    SetLocalString(OBJECT_SELF, "SFScripts_527", "X2_S0_StnBones"); // Stone Bones
    SetLocalString(OBJECT_SELF, "SFScripts_528", "X2_S0_Undeath"); // Undeath to Death
    SetLocalString(OBJECT_SELF, "SFScripts_529", "X2_S0_VineMine"); // Vine Mine
    SetLocalString(OBJECT_SELF, "SFScripts_53", "NW_S0_Entangle"); // Entangle
    SetLocalString(OBJECT_SELF, "SFScripts_530", "X2_S0_VineMEnt"); // Vine Mine Entangle
    SetLocalString(OBJECT_SELF, "SFScripts_531", "X2_S0_VineMHmp"); // Vine Mine Hamper Movement
    SetLocalString(OBJECT_SELF, "SFScripts_532", "X2_S0_VineMCam"); // Vine Mine Camouflage
    SetLocalString(OBJECT_SELF, "SFScripts_533", "X2_S0_BlckBlde"); // Black Blade of Disaster
    SetLocalString(OBJECT_SELF, "SFScripts_534", "X2_S0_PersBlde"); // Shelgarns Persistent Blade
    SetLocalString(OBJECT_SELF, "SFScripts_535", "X2_S0_BldeThst"); // Blade Thirst
    SetLocalString(OBJECT_SELF, "SFScripts_536", "X2_S0_DeafClng"); // Deafening Clang
    SetLocalString(OBJECT_SELF, "SFScripts_537", "X2_S0_BlssWeap"); // Bless Weapon
    SetLocalString(OBJECT_SELF, "SFScripts_538", "X2_S0_HolySwrd"); // Holy Sword
    SetLocalString(OBJECT_SELF, "SFScripts_539", "X2_S0_KeenEdge"); // Keen Edge
    SetLocalString(OBJECT_SELF, "SFScripts_54", "NW_S0_Fear"); // Fear
    SetLocalString(OBJECT_SELF, "SFScripts_541", "X2_S0_Blckstff"); // Blackstaff
    SetLocalString(OBJECT_SELF, "SFScripts_542", "X2_S0_FlmeWeap"); // Flame Weapon
    SetLocalString(OBJECT_SELF, "SFScripts_543", "X2_S0_IceDagg"); // Ice Dagger
    SetLocalString(OBJECT_SELF, "SFScripts_544", "X2_S0_MagcWeap"); // Magic Weapon
    SetLocalString(OBJECT_SELF, "SFScripts_545", "X2_S0_GrMagWeap"); // Greater Magic Weapon
    SetLocalString(OBJECT_SELF, "SFScripts_546", "X2_S0_MagcVest"); // Magic Vestment
    SetLocalString(OBJECT_SELF, "SFScripts_547", "X2_S0_Stnehold"); // Stonehold
    SetLocalString(OBJECT_SELF, "SFScripts_548", "X2_S0_Darkfire"); // Darkfire
    SetLocalString(OBJECT_SELF, "SFScripts_549", "X2_S0_GlphWard"); // Glyph of Warding
    SetLocalString(OBJECT_SELF, "SFScripts_55", "NW_S0_FeebMind"); // Feeblemind
    SetLocalString(OBJECT_SELF, "SFScripts_551", "x2_m1_mindblast"); // MONSTER MindBlast
    SetLocalString(OBJECT_SELF, "SFScripts_552", "x2_m1_CharmMon"); // MONSTER CharmMonster
    SetLocalString(OBJECT_SELF, "SFScripts_553", "x2_p1_ballista"); // Goblin Ballista Fireball
    SetLocalString(OBJECT_SELF, "SFScripts_554", "x2_sp_is_drose"); // Ioun Stone Dusty Rose
    SetLocalString(OBJECT_SELF, "SFScripts_555", "x2_sp_is_pblue"); // Ioun Stone Pale Blue
    SetLocalString(OBJECT_SELF, "SFScripts_556", "x2_sp_is_sblue"); // Ioun Stone Scarlet Blue
    SetLocalString(OBJECT_SELF, "SFScripts_557", "x2_sp_is_blue"); // Ioun Stone Blue
    SetLocalString(OBJECT_SELF, "SFScripts_558", "x2_sp_is_dred"); // Ioun Stone Deep Red
    SetLocalString(OBJECT_SELF, "SFScripts_559", "x2_sp_is_pink"); // Ioun Stone Pink
    SetLocalString(OBJECT_SELF, "SFScripts_56", "NW_S0_FingDeath"); // Finger of Death
    SetLocalString(OBJECT_SELF, "SFScripts_560", "x2_sp_is_pgreen"); // Ioun Stone Pink Green
    SetLocalString(OBJECT_SELF, "SFScripts_561", "x2_s2_whirl"); // Whirlwind
    SetLocalString(OBJECT_SELF, "SFScripts_562", "x2_s0_auraglory"); // AuraOfGlory X2
    SetLocalString(OBJECT_SELF, "SFScripts_563", "x2_s0_hasteslow"); // Haste Slow X2
    SetLocalString(OBJECT_SELF, "SFScripts_564", "x2_s0_CrShadow"); // Summon Shadow X2
    SetLocalString(OBJECT_SELF, "SFScripts_565", "x2_s0_TideBattle"); // Tide of Battle
    SetLocalString(OBJECT_SELF, "SFScripts_566", "x2_s0_EvilBlight"); // Evil Blight
    SetLocalString(OBJECT_SELF, "SFScripts_567", "x2_s0_cureother"); // Cure Critical Wounds Others
    SetLocalString(OBJECT_SELF, "SFScripts_568", "x2_s0_restother"); // Restoration Others
    SetLocalString(OBJECT_SELF, "SFScripts_569", "X2_S0_CldBewld"); // Cloud of Bewilderment
    SetLocalString(OBJECT_SELF, "SFScripts_57", "NW_S0_FireStrm"); // Fire Storm
    SetLocalString(OBJECT_SELF, "SFScripts_58", "NW_S0_Fireball"); // Fireball
    SetLocalString(OBJECT_SELF, "SFScripts_59", "NW_S0_FlmArrow"); // Flame Arrow
    SetLocalString(OBJECT_SELF, "SFScripts_595", "te_planar"); // BGSummonLesserFiend
    SetLocalString(OBJECT_SELF, "SFScripts_596", "te_grplanar"); // BGSummonGreaterFiend
    SetLocalString(OBJECT_SELF, "SFScripts_597", "te_bg_nightmare"); // BGNightmare
    SetLocalString(OBJECT_SELF, "SFScripts_6", "NW_S0_Bless"); // Bless
    SetLocalString(OBJECT_SELF, "SFScripts_60", "NW_S0_FlmLash"); // Flame Lash
    SetLocalString(OBJECT_SELF, "SFScripts_600", "CLS_AA_IMBUE"); // ARImbueArrow
    SetLocalString(OBJECT_SELF, "SFScripts_601", "x1_s2_seeker"); // ARSeekerArrow
    SetLocalString(OBJECT_SELF, "SFScripts_602", "x1_s2_seeker"); // ARSeekerArrow2
    SetLocalString(OBJECT_SELF, "SFScripts_603", "x1_s2_hailarrow"); // ARHailOfArrows
    SetLocalString(OBJECT_SELF, "SFScripts_604", "x1_s2_deatharrow"); // ARArrowOfDeath
    SetLocalString(OBJECT_SELF, "SFScripts_605", "NW_S0_GhostVis"); // ASGhostlyVisage
    SetLocalString(OBJECT_SELF, "SFScripts_606", "NW_S0_Darkness"); // ASDarkness
    SetLocalString(OBJECT_SELF, "SFScripts_607", "NW_S0_Invisib"); // ASInvisibility
    SetLocalString(OBJECT_SELF, "SFScripts_608", "NW_S0_ImprInvis"); // ASImprovedInvisibility
    SetLocalString(OBJECT_SELF, "SFScripts_609", "x0_s2_blkdead"); // BGCreateDead
    SetLocalString(OBJECT_SELF, "SFScripts_61", "NW_S0_FlmStrike"); // Flame Strike
    SetLocalString(OBJECT_SELF, "SFScripts_610", "X0_S2_Fiend"); // BGFiendish
    SetLocalString(OBJECT_SELF, "SFScripts_611", "x0_s0_inflict"); // BGInflictSerious
    SetLocalString(OBJECT_SELF, "SFScripts_612", "x0_s0_inflict"); // BGInflictCritical
    SetLocalString(OBJECT_SELF, "SFScripts_613", "NW_S0_Contagion"); // BK Contagion
    SetLocalString(OBJECT_SELF, "SFScripts_614", "NW_S0_BullStr"); // BK BullsStrength
    SetLocalString(OBJECT_SELF, "SFScripts_615", "x0_s3_clonefist"); // Twinfists
    SetLocalString(OBJECT_SELF, "SFScripts_616", "x0_s3_lyriclich"); // LichLyrics
    SetLocalString(OBJECT_SELF, "SFScripts_617", "x0_s3_berry"); // Iceberry
    SetLocalString(OBJECT_SELF, "SFScripts_618", "x0_s3_berry"); // Flameberry
    SetLocalString(OBJECT_SELF, "SFScripts_619", "x0_s3_prayer"); // PrayerBox
    SetLocalString(OBJECT_SELF, "SFScripts_62", "NW_S0_FreeMove"); // Freedom of Movement
    SetLocalString(OBJECT_SELF, "SFScripts_620", "x0_s3_koboldjump"); // Flying Debris
    SetLocalString(OBJECT_SELF, "SFScripts_622", "x2_s2_DivWrath"); // DC Divine Wrath
    SetLocalString(OBJECT_SELF, "SFScripts_623", "NW_S0_AnimDead"); // PM Animate Dead
    SetLocalString(OBJECT_SELF, "SFScripts_624", "X2_S2_SumUndead"); // PM Summon Undead
    SetLocalString(OBJECT_SELF, "SFScripts_625", "X2_S2_UndGraft1"); // PM Undead Graft1
    SetLocalString(OBJECT_SELF, "SFScripts_626", "X2_S2_UndGraft1"); // PM Undead Graft2
    SetLocalString(OBJECT_SELF, "SFScripts_627", "X2_S2_SumGrUnd"); // PM Summon Greater Undead
    SetLocalString(OBJECT_SELF, "SFScripts_628", "X2_S2_DthMstTch"); // PM Deathless Master Touch
    SetLocalString(OBJECT_SELF, "SFScripts_63", "NW_S0_Gate"); // Gate
    SetLocalString(OBJECT_SELF, "SFScripts_636", "X2_S2_HELLBALL"); // Hellball
    SetLocalString(OBJECT_SELF, "SFScripts_637", "X2_S2_MumDust"); // Mummy Dust
    SetLocalString(OBJECT_SELF, "SFScripts_638", "X2_S2_DragKnght"); // Dragon Knight
    SetLocalString(OBJECT_SELF, "SFScripts_639", "X2_S2_EpMageArm"); // Epic Mage Armor
    SetLocalString(OBJECT_SELF, "SFScripts_64", "NW_S0_GhoulTch"); // Ghoul Touch
    SetLocalString(OBJECT_SELF, "SFScripts_640", "X2_S2_Ruin"); // Ruin
    SetLocalString(OBJECT_SELF, "SFScripts_641", "X2_S2_DefStance"); // DWDEF Defensive Stance
    SetLocalString(OBJECT_SELF, "SFScripts_642", "X2_S2_MghtyRage"); // Mighty Rage
    SetLocalString(OBJECT_SELF, "SFScripts_643", "NW_S2_TurnDead"); // PlanarTurning
    SetLocalString(OBJECT_SELF, "SFScripts_644", "X2_S2_CurseSong"); // Curse Song
    SetLocalString(OBJECT_SELF, "SFScripts_645", "x2_s2_whirl"); // Improved Whirlwind
    SetLocalString(OBJECT_SELF, "SFScripts_646", "X2_S2_GWildShp"); // Greater Wild Shape 1
    SetLocalString(OBJECT_SELF, "SFScripts_647", "x2_s2_blindspd"); // Epic Blinding speed
    SetLocalString(OBJECT_SELF, "SFScripts_648", "x2_s2_DyeArmor"); // Dye Armor cloth1
    SetLocalString(OBJECT_SELF, "SFScripts_649", "x2_s2_DyeArmor"); // Dye Armor Cloth2
    SetLocalString(OBJECT_SELF, "SFScripts_65", "NW_S0_GlobeInv"); // Globe of Invulnerability
    SetLocalString(OBJECT_SELF, "SFScripts_650", "x2_s2_DyeArmor"); // Dye Armor Leather1
    SetLocalString(OBJECT_SELF, "SFScripts_651", "x2_s2_DyeArmor"); // Dye Armor Leather2
    SetLocalString(OBJECT_SELF, "SFScripts_652", "x2_s2_DyeArmor"); // Dye Armor Metal1
    SetLocalString(OBJECT_SELF, "SFScripts_653", "x2_s2_DyeArmor"); // Dye Armor Metal2
    SetLocalString(OBJECT_SELF, "SFScripts_654", "x2_s2_AddProp"); // Add Item Property
    SetLocalString(OBJECT_SELF, "SFScripts_655", "x2_s2_PoisonWp"); // Poison Weapon
    SetLocalString(OBJECT_SELF, "SFScripts_656", "x2_s2_Crafting"); // Craft Weapon
    SetLocalString(OBJECT_SELF, "SFScripts_657", "x2_s2_Crafting"); // Craft Armor
    SetLocalString(OBJECT_SELF, "SFScripts_658", "X2_S2_GWildShp"); // Greater Wild Shape Wyrmling Red
    SetLocalString(OBJECT_SELF, "SFScripts_659", "X2_S2_GWildShp"); // Greater Wild Shape Wyrmling Blue
    SetLocalString(OBJECT_SELF, "SFScripts_66", "NW_S0_Grease"); // Grease
    SetLocalString(OBJECT_SELF, "SFScripts_660", "X2_S2_GWildShp"); // Greater Wild Shape Wyrmling Black
    SetLocalString(OBJECT_SELF, "SFScripts_661", "X2_S2_GWildShp"); // Greater Wild Shape Wyrmling White
    SetLocalString(OBJECT_SELF, "SFScripts_662", "X2_S2_GWildShp"); // Greater Wild Shape Wyrmling Green
    SetLocalString(OBJECT_SELF, "SFScripts_663", "x2_S1_wyrmbreath"); // WyrmlingPCBreathCold
    SetLocalString(OBJECT_SELF, "SFScripts_664", "x2_S1_wyrmbreath"); // WyrmlingPCBreathAcid
    SetLocalString(OBJECT_SELF, "SFScripts_665", "x2_S1_wyrmbreath"); // WyrmlingPCBreathFire
    SetLocalString(OBJECT_SELF, "SFScripts_666", "x2_S1_wyrmbreath"); // WyrmlingPCBreathGas
    SetLocalString(OBJECT_SELF, "SFScripts_667", "x2_S1_wyrmbreath"); // WyrmlingPCBreathLightning
    SetLocalString(OBJECT_SELF, "SFScripts_668", "x2_s3_"); // ITEM Teleport
    SetLocalString(OBJECT_SELF, "SFScripts_669", "X2_S3_CHAOSSHLD"); // ITEM Chaos Shield
    SetLocalString(OBJECT_SELF, "SFScripts_67", "NW_S0_GrDispel"); // Greater Dispelling
    SetLocalString(OBJECT_SELF, "SFScripts_670", "X2_S2_GWildShp"); // Greater Wild Shape Basilisk
    SetLocalString(OBJECT_SELF, "SFScripts_671", "X2_S2_GWildShp"); // Greater Wild Shape Beholder
    SetLocalString(OBJECT_SELF, "SFScripts_672", "X2_S2_GWildShp"); // Greater Wild Shape Harpy
    SetLocalString(OBJECT_SELF, "SFScripts_673", "X2_S2_GWildShp"); // Greater Wild Shape Drider
    SetLocalString(OBJECT_SELF, "SFScripts_674", "X2_S2_GWildShp"); // Greater Wild Shape Manticore
    SetLocalString(OBJECT_SELF, "SFScripts_675", "X2_S2_GWildShp"); // Greater Wild Shape 2
    SetLocalString(OBJECT_SELF, "SFScripts_676", "X2_S2_GWildShp"); // Greater Wild Shape 3
    SetLocalString(OBJECT_SELF, "SFScripts_677", "X2_S2_GWildShp"); // Greater Wild Shape 4
    SetLocalString(OBJECT_SELF, "SFScripts_678", "X2_S2_GWildShp"); // Greater Wild Shape Gargoyle
    SetLocalString(OBJECT_SELF, "SFScripts_679", "X2_S2_GWildShp"); // Greater Wild Shape Medusa
    SetLocalString(OBJECT_SELF, "SFScripts_68", "NW_S0_GrMgWeap"); // Greater Magic Weapon
    SetLocalString(OBJECT_SELF, "SFScripts_680", "X2_S2_GWildShp"); // Greater Wild Shape Minotaur
    SetLocalString(OBJECT_SELF, "SFScripts_681", "X2_S2_GWildShp"); // Humanoid Shape
    SetLocalString(OBJECT_SELF, "SFScripts_682", "X2_S2_GWildShp"); // Humanoid Shape Drow
    SetLocalString(OBJECT_SELF, "SFScripts_683", "X2_S2_GWildShp"); // Humanoid Shape Lizardfolk
    SetLocalString(OBJECT_SELF, "SFScripts_684", "X2_S2_GWildShp"); // Humanoid Shape KoboldAssa
    SetLocalString(OBJECT_SELF, "SFScripts_685", "X2_S2_GWildShp"); // Undead shape
    SetLocalString(OBJECT_SELF, "SFScripts_686", "X2_S1_harpycry"); // Harpysong
    SetLocalString(OBJECT_SELF, "SFScripts_687", "x2_s1_petrgaze"); // GWildShape Stonegaze
    SetLocalString(OBJECT_SELF, "SFScripts_688", "x2_s1_driderdark"); // GWildShape DriderDarkness
    SetLocalString(OBJECT_SELF, "SFScripts_689", "x2_s3_slayraks"); // SlayRakshasa
    SetLocalString(OBJECT_SELF, "SFScripts_69", "te_grplanar"); // Greater Planar Binding
    SetLocalString(OBJECT_SELF, "SFScripts_690", "x2_S2_discbreath"); // RedDragonDiscipleBreath
    SetLocalString(OBJECT_SELF, "SFScripts_691", "X2_S2_GWildShp"); // Greater Wild Shape Mindflayer
    SetLocalString(OBJECT_SELF, "SFScripts_692", "x2_s1_GWSpikes"); // Greater Wild Shape Spikes
    SetLocalString(OBJECT_SELF, "SFScripts_693", "x2_s1_gwmindbl"); // GWildShape Mindblast
    SetLocalString(OBJECT_SELF, "SFScripts_694", "X2_S2_GWildShp"); // Greater Wild Shape DireTiger
    SetLocalString(OBJECT_SELF, "SFScripts_695", "X2_S2_EpicWard"); // Epic Warding
    SetLocalString(OBJECT_SELF, "SFScripts_696", "X2_S3_FlamingD"); // OnHitFireDamage
    SetLocalString(OBJECT_SELF, "SFScripts_697", "NW_S3_ActItem01"); // ACTIVATE ITEM L
    SetLocalString(OBJECT_SELF, "SFScripts_698", "X2_S1_DragNeg"); // Dragon Breath Negative
    SetLocalString(OBJECT_SELF, "SFScripts_7", "NW_S0_BlessWeap"); // Bless Weapon
    SetLocalString(OBJECT_SELF, "SFScripts_70", "NW_S0_GrRestore"); // Greater Restoration
    SetLocalString(OBJECT_SELF, "SFScripts_700", "X2_S3_OnHitCast"); // ACTIVATE ITEM ONHITSPELLCAST
    SetLocalString(OBJECT_SELF, "SFScripts_701", "X2_S1_SummBaatez"); // Summon Baatezu
    SetLocalString(OBJECT_SELF, "SFScripts_702", "X2_S3_PlanarRift"); // OnHitPlanarRift
    SetLocalString(OBJECT_SELF, "SFScripts_703", "X2_S3_Darkfire"); // OnHitDarkfire
    SetLocalString(OBJECT_SELF, "SFScripts_704", "X2_S2_GWildShp"); // Undead Shape risen lord
    SetLocalString(OBJECT_SELF, "SFScripts_705", "X2_S2_GWildShp"); // Undead Shape Vampire
    SetLocalString(OBJECT_SELF, "SFScripts_706", "X2_S2_GWildShp"); // Undead Shape Spectre
    SetLocalString(OBJECT_SELF, "SFScripts_707", "X2_S2_GWildShp"); // Greater Wild Shape Red dragon
    SetLocalString(OBJECT_SELF, "SFScripts_708", "X2_S2_GWildShp"); // Greater Wild Shape Blue dragon
    SetLocalString(OBJECT_SELF, "SFScripts_709", "X2_S2_GWildShp"); // Greater Wild Shape Green dragon
    SetLocalString(OBJECT_SELF, "SFScripts_71", "NW_S0_GrShConj"); // Greater Shadow Conjuration
    SetLocalString(OBJECT_SELF, "SFScripts_710", "x1_s1_eyebray"); // EyeballRay0
    SetLocalString(OBJECT_SELF, "SFScripts_711", "x1_s1_eyebray"); // EyeballRay1
    SetLocalString(OBJECT_SELF, "SFScripts_712", "x1_s1_eyebray"); // EyeballRay2
    SetLocalString(OBJECT_SELF, "SFScripts_713", "x2_s1_mblast10"); // Mindflayer Mindblast 10
    SetLocalString(OBJECT_SELF, "SFScripts_715", "x2_s1_golemslam"); // Golem Ranged Slam
    SetLocalString(OBJECT_SELF, "SFScripts_716", "x2_s1_suckbrain"); // SuckBrain
    SetLocalString(OBJECT_SELF, "SFScripts_717", "X2_S3_sequencer"); // ACTIVATE ITEM SEQUENCER 1
    SetLocalString(OBJECT_SELF, "SFScripts_718", "X2_S3_sequencer"); // ACTIVATE ITEM SEQUENCER 2
    SetLocalString(OBJECT_SELF, "SFScripts_719", "X2_S3_sequencer"); // ACTIVATE ITEM SEQUENCER 3
    SetLocalString(OBJECT_SELF, "SFScripts_72", "NW_S0_GrSpBrch"); // Greater Spell Breach
    SetLocalString(OBJECT_SELF, "SFScripts_720", "X2_S3_sequencer"); // CLEAR SEQUENCER
    SetLocalString(OBJECT_SELF, "SFScripts_721", "X2_S3_flameskin"); // OnHitFlamingSkin
    SetLocalString(OBJECT_SELF, "SFScripts_722", "x0_s3_koboldjump"); // Mimic Eat
    SetLocalString(OBJECT_SELF, "SFScripts_724", "x2_s1_ether"); // Etherealness
    SetLocalString(OBJECT_SELF, "SFScripts_725", "X2_S2_GWildShp"); // Dragon Shape
    SetLocalString(OBJECT_SELF, "SFScripts_726", "x0_s3_koboldjump"); // Mimic Eat Enemy
    SetLocalString(OBJECT_SELF, "SFScripts_727", "x2_s1_beantimag"); // Beholder Anti Magic Cone
    SetLocalString(OBJECT_SELF, "SFScripts_729", "x0_s3_koboldjump"); // Mimic Steal armor
    SetLocalString(OBJECT_SELF, "SFScripts_73", "NW_S0_GrSpMant"); // Greater Spell Mantle
    SetLocalString(OBJECT_SELF, "SFScripts_731", "x2_s1_bebweb"); // Bebelith Web
    SetLocalString(OBJECT_SELF, "SFScripts_732", "X2_S2_GWildShp"); // Outsider Shape
    SetLocalString(OBJECT_SELF, "SFScripts_733", "X2_S2_GWildShp"); // Outsider Shape Azer
    SetLocalString(OBJECT_SELF, "SFScripts_734", "X2_S2_GWildShp"); // Outsider Shape Rakshasa
    SetLocalString(OBJECT_SELF, "SFScripts_735", "X2_S2_GWildShp"); // Outsider Shape DeathSlaad
    SetLocalString(OBJECT_SELF, "SFScripts_736", "x2_s1_beholdatt"); // Beholder Special Spell AI
    SetLocalString(OBJECT_SELF, "SFScripts_737", "X2_S2_GWildShp"); // Construct Shape
    SetLocalString(OBJECT_SELF, "SFScripts_738", "X2_S2_GWildShp"); // Construct Shape StoneGolem
    SetLocalString(OBJECT_SELF, "SFScripts_739", "X2_S2_GWildShp"); // Construct Shape DemonFleshGolem
    SetLocalString(OBJECT_SELF, "SFScripts_74", "NW_S0_GrStoneSk"); // Greater Stoneskin
    SetLocalString(OBJECT_SELF, "SFScripts_740", "X2_S2_GWildShp"); // Construct Shape IronGolem
    SetLocalString(OBJECT_SELF, "SFScripts_741", "x2_s1_psibarr"); // Psionic Inertial Barrier
    SetLocalString(OBJECT_SELF, "SFScripts_742", "x2_s2_Crafting"); // Craft Weapon Component
    SetLocalString(OBJECT_SELF, "SFScripts_743", "x2_s2_Crafting"); // Craft Armor Component
    SetLocalString(OBJECT_SELF, "SFScripts_744", "x2_s3_bomb"); // Grenade FireBomb
    SetLocalString(OBJECT_SELF, "SFScripts_745", "x2_s3_bomb"); // Grenade AcidBomb
    SetLocalString(OBJECT_SELF, "SFScripts_75", "x0_s0_gustwind"); // Gust of Wind
    SetLocalString(OBJECT_SELF, "SFScripts_756", "X2_S3_RuinArmor"); // OnHitBebilithAttack
    SetLocalString(OBJECT_SELF, "SFScripts_757", "X2_S1_shadblend"); // ShadowBlend
    SetLocalString(OBJECT_SELF, "SFScripts_758", "X2_S3_DemiTouch"); // OnHitDemilichTouch
    SetLocalString(OBJECT_SELF, "SFScripts_759", "NW_S0_Harm"); // UndeadSelfHarm
    SetLocalString(OBJECT_SELF, "SFScripts_76", "NW_S0_HammGods"); // Hammer of the Gods
    SetLocalString(OBJECT_SELF, "SFScripts_760", "X2_S3_DracTouch"); // OnHitDracolichTouch
    SetLocalString(OBJECT_SELF, "SFScripts_761", "X2_S0_HellFire"); // Aura of Hellfire
    SetLocalString(OBJECT_SELF, "SFScripts_762", "x2_s0_HellInfern"); // Hell Inferno
    SetLocalString(OBJECT_SELF, "SFScripts_763", "x2_s1_psimconc"); // Psionic Mass Concussion
    SetLocalString(OBJECT_SELF, "SFScripts_764", "x2_s0_glphwardx"); // GlyphOfWardingDefault
    SetLocalString(OBJECT_SELF, "SFScripts_767", "X2_S3_IntItemTlk"); // Intelligent Weapon Talk
    SetLocalString(OBJECT_SELF, "SFScripts_768", "X2_S3_IntItemIjc"); // Intelligent Weapon OnHit
    SetLocalString(OBJECT_SELF, "SFScripts_769", "x2_s1_shadow"); // Shadow Attack
    SetLocalString(OBJECT_SELF, "SFScripts_77", "NW_S0_Harm"); // Harm
    SetLocalString(OBJECT_SELF, "SFScripts_770", "x2_s1_chaosspit"); // Slaad Chaos Spittle
    SetLocalString(OBJECT_SELF, "SFScripts_771", "x2_s1_prisbreath"); // Dragon Breath Prismatic
    SetLocalString(OBJECT_SELF, "SFScripts_772", "NW_S0_Fireball"); // Spiral Fireball
    SetLocalString(OBJECT_SELF, "SFScripts_773", "x2_s1_bat1rocks"); // Battle Boulder Toss
    SetLocalString(OBJECT_SELF, "SFScripts_774", "x2_s1_defforce"); // Deflecting Force
    SetLocalString(OBJECT_SELF, "SFScripts_775", "x2_s1_hurlrock"); // Giant hurl rock
    SetLocalString(OBJECT_SELF, "SFScripts_776", "x2_s1_beholdray"); // Beholder Node 1
    SetLocalString(OBJECT_SELF, "SFScripts_777", "x2_s1_beholdray"); // Beholder Node 2
    SetLocalString(OBJECT_SELF, "SFScripts_778", "x2_s1_beholdray"); // Beholder Node 3
    SetLocalString(OBJECT_SELF, "SFScripts_779", "x2_s1_beholdray"); // Beholder Node 4
    SetLocalString(OBJECT_SELF, "SFScripts_78", "NW_S0_Haste"); // Haste
    SetLocalString(OBJECT_SELF, "SFScripts_780", "x2_s1_beholdray"); // Beholder Node 5
    SetLocalString(OBJECT_SELF, "SFScripts_783", "x2_s1_beholdray"); // Beholder Node 6
    SetLocalString(OBJECT_SELF, "SFScripts_784", "x2_s1_beholdray"); // Beholder Node 7
    SetLocalString(OBJECT_SELF, "SFScripts_785", "x2_s1_beholdray"); // Beholder Node 8
    SetLocalString(OBJECT_SELF, "SFScripts_786", "x2_s1_beholdray"); // Beholder Node 9
    SetLocalString(OBJECT_SELF, "SFScripts_787", "x2_s1_beholdray"); // Beholder Node 10
    SetLocalString(OBJECT_SELF, "SFScripts_788", "X2_S3_paralyze"); // OnHitParalyze
    SetLocalString(OBJECT_SELF, "SFScripts_789", "x2_s1_illithidb"); // Illithid Mindblast
    SetLocalString(OBJECT_SELF, "SFScripts_79", "NW_S0_Heal"); // Heal
    SetLocalString(OBJECT_SELF, "SFScripts_790", "X2_S3_deafclng"); // OnHitDeafenClang
    SetLocalString(OBJECT_SELF, "SFScripts_791", "X2_S3_misceffect"); // OnHitKnockDown
    SetLocalString(OBJECT_SELF, "SFScripts_792", "X2_S3_misceffect"); // OnHitFreeze
    SetLocalString(OBJECT_SELF, "SFScripts_793", "x2_s0_demonhand"); // Demonic Grappling Hand
    SetLocalString(OBJECT_SELF, "SFScripts_794", "x2_p1_ballista2"); // Ballista Bolt
    SetLocalString(OBJECT_SELF, "SFScripts_795", "NW_S3_ActItem01"); // ACTIVATE ITEM T
    SetLocalString(OBJECT_SELF, "SFScripts_796", "x2_s2_edragbrth"); // Dragon Breath Lightning
    SetLocalString(OBJECT_SELF, "SFScripts_797", "x2_s2_edragbrth"); // Dragon Breath Fire
    SetLocalString(OBJECT_SELF, "SFScripts_798", "x2_s2_edragbrth"); // Dragon Breath Gas
    SetLocalString(OBJECT_SELF, "SFScripts_799", "x2_s2_vampinvis"); // Vampire Invisibility
    SetLocalString(OBJECT_SELF, "SFScripts_8", "NW_S0_BlindDeaf"); // Blindness and Deafness
    SetLocalString(OBJECT_SELF, "SFScripts_80", "NW_S0_HealCirc"); // Healing Circle
    SetLocalString(OBJECT_SELF, "SFScripts_800", "x2_s2_shiftdom"); // Vampire DominationGaze
    SetLocalString(OBJECT_SELF, "SFScripts_801", "x2_s2_gwburn"); // Azer Fire Blast
    SetLocalString(OBJECT_SELF, "SFScripts_802", "x2_s2_gwdrain"); // Shifter Spectre Attack
    SetLocalString(OBJECT_SELF, "SFScripts_803", "nw_s1_evileye"); // SeaHag EvilEye
    SetLocalString(OBJECT_SELF, "SFScripts_804", "nw_s1_horrappr"); // Aura HorrificAppearance
    SetLocalString(OBJECT_SELF, "SFScripts_805", "NW_S1_trogstink"); // Troglodyte Stench
    SetLocalString(OBJECT_SELF, "SFScripts_806", "x3_s2_pdk_rally"); // PDK RallyingCry
    SetLocalString(OBJECT_SELF, "SFScripts_807", "x3_s2_pdk_shield"); // PDK Shield
    SetLocalString(OBJECT_SELF, "SFScripts_808", "x3_s2_pdk_fear"); // PDK Fear
    SetLocalString(OBJECT_SELF, "SFScripts_809", "x3_s2_pdk_wrath"); // PDK OathOfWrath
    SetLocalString(OBJECT_SELF, "SFScripts_81", "NW_S0_HoldAnim"); // Hold Animal
    SetLocalString(OBJECT_SELF, "SFScripts_810", "x3_s2_pdk_stand"); // PDK FinalStand
    SetLocalString(OBJECT_SELF, "SFScripts_811", "x3_s2_pdk_inspir"); // PDK InspireCourage
    SetLocalString(OBJECT_SELF, "SFScripts_813", "x3_s3_horse"); // Horse Mount
    SetLocalString(OBJECT_SELF, "SFScripts_814", "x3_s3_horse"); // Horse Dismount
    SetLocalString(OBJECT_SELF, "SFScripts_815", "x3_s3_horse"); // Horse Party Mount
    SetLocalString(OBJECT_SELF, "SFScripts_816", "x3_s3_horse"); // Horse Party Dismount
    SetLocalString(OBJECT_SELF, "SFScripts_817", "x3_s3_horse"); // Horse Assign Mount
    SetLocalString(OBJECT_SELF, "SFScripts_818", "x3_s3_palmount"); // Paladin Summon Mount
    SetLocalString(OBJECT_SELF, "SFScripts_819", "x3_s1_nmsmoke"); // Nightmare Smoke
    SetLocalString(OBJECT_SELF, "SFScripts_82", "NW_S0_HoldMon"); // Hold Monster
    SetLocalString(OBJECT_SELF, "SFScripts_820", "x3_dm_tool01"); // DM TOOL 01
    SetLocalString(OBJECT_SELF, "SFScripts_821", "x3_dm_tool02"); // DM TOOL 02
    SetLocalString(OBJECT_SELF, "SFScripts_822", "x3_dm_tool03"); // DM TOOL 03
    SetLocalString(OBJECT_SELF, "SFScripts_823", "x3_dm_tool04"); // DM TOOL 04
    SetLocalString(OBJECT_SELF, "SFScripts_824", "x3_dm_tool05"); // DM TOOL 05
    SetLocalString(OBJECT_SELF, "SFScripts_825", "x3_dm_tool06"); // DM TOOL 06
    SetLocalString(OBJECT_SELF, "SFScripts_826", "x3_dm_tool07"); // DM TOOL 07
    SetLocalString(OBJECT_SELF, "SFScripts_827", "x3_dm_tool08"); // DM TOOL 08
    SetLocalString(OBJECT_SELF, "SFScripts_828", "x3_dm_tool09"); // DM TOOL 09
    SetLocalString(OBJECT_SELF, "SFScripts_829", "x3_dm_tool10"); // DM TOOL 10
    SetLocalString(OBJECT_SELF, "SFScripts_83", "NW_S0_HoldPers"); // Hold Person
    SetLocalString(OBJECT_SELF, "SFScripts_830", "x3_pl_tool01"); // EXAMINE
    SetLocalString(OBJECT_SELF, "SFScripts_831", "x3_pl_tool02"); // DEBUFF
    SetLocalString(OBJECT_SELF, "SFScripts_832", "x3_pl_tool03"); // PLAYER TOOL 03
    SetLocalString(OBJECT_SELF, "SFScripts_833", "x3_pl_tool04"); // PLAYER TOOL 04
    SetLocalString(OBJECT_SELF, "SFScripts_834", "x3_pl_tool05"); // PLAYER TOOL 05
    SetLocalString(OBJECT_SELF, "SFScripts_835", "x3_pl_tool06"); // PLAYER TOOL 06
    SetLocalString(OBJECT_SELF, "SFScripts_836", "x3_pl_tool07"); // PLAYER TOOL 07
    SetLocalString(OBJECT_SELF, "SFScripts_837", "x3_pl_tool08"); // PLAYER TOOL 08
    SetLocalString(OBJECT_SELF, "SFScripts_838", "x3_pl_tool09"); // PLAYER TOOL 09
    SetLocalString(OBJECT_SELF, "SFScripts_839", "x3_pl_tool10"); // PLAYER TOOL 10
    SetLocalString(OBJECT_SELF, "SFScripts_84", "NW_S0_HolyAura"); // Holy Aura
    SetLocalString(OBJECT_SELF, "SFScripts_842", "te_smite"); // Smite Infidel
    SetLocalString(OBJECT_SELF, "SFScripts_844", "te_bl_plague"); // Plague
    SetLocalString(OBJECT_SELF, "SFScripts_845", "te_bl_sumanim"); // Summon Undead Animal
    SetLocalString(OBJECT_SELF, "SFScripts_846", "te_bl_blightfire"); // Blightfire
    SetLocalString(OBJECT_SELF, "SFScripts_848", "te_natlycan"); // Background NatLycan Transform
    SetLocalString(OBJECT_SELF, "SFScripts_85", "NW_S0_HolySwrd"); // Holy Sword
    SetLocalString(OBJECT_SELF, "SFScripts_850", "te_war_skills"); // Artificer Assistant
    SetLocalString(OBJECT_SELF, "SFScripts_851", "te_war_ironhorn"); // Baleful Utterance
    SetLocalString(OBJECT_SELF, "SFScripts_852", "te_war_skills"); // Beguiling Influence
    SetLocalString(OBJECT_SELF, "SFScripts_853", "te_war_dark"); // Dark Ones Own Luck
    SetLocalString(OBJECT_SELF, "SFScripts_854", "NW_S0_Darkness"); // Darkness
    SetLocalString(OBJECT_SELF, "SFScripts_855", "te_war_darkvis"); // Ultravision
    SetLocalString(OBJECT_SELF, "SFScripts_856", "te_war_entrshiel"); // Entropic Shield
    SetLocalString(OBJECT_SELF, "SFScripts_857", "te_war_skills"); // Leaps And Bounds
    SetLocalString(OBJECT_SELF, "SFScripts_858", "te_war_seeinvis"); // See Invisibility
    SetLocalString(OBJECT_SELF, "SFScripts_859", "te_war_skills"); // All Seeing Eyes
    SetLocalString(OBJECT_SELF, "SFScripts_86", "NW_S0_Identify"); // Identify
    SetLocalString(OBJECT_SELF, "SFScripts_861", "te_war_skills"); // Dark Arcana
    SetLocalString(OBJECT_SELF, "SFScripts_862", "te_war_skills"); // Cloak Of Shadows
    SetLocalString(OBJECT_SELF, "SFScripts_863", "te_war_shroud"); // Shrouding Transformation
    SetLocalString(OBJECT_SELF, "SFScripts_865", "te_war_curse"); // Bestow Curse
    SetLocalString(OBJECT_SELF, "SFScripts_866", "NW_S0_CrUndead"); // Create Undead
    SetLocalString(OBJECT_SELF, "SFScripts_867", "te_war_darm"); // Death Armor
    SetLocalString(OBJECT_SELF, "SFScripts_868", "te_war_dompers"); // Dominate Person
    SetLocalString(OBJECT_SELF, "SFScripts_869", "te_war_dismag"); // Dispel Magic
    SetLocalString(OBJECT_SELF, "SFScripts_87", "NW_S0_Implosion"); // Implosion
    SetLocalString(OBJECT_SELF, "SFScripts_870", "te_war_ward"); // Eldritch Ward
    SetLocalString(OBJECT_SELF, "SFScripts_871", "te_war_endelem"); // Endure Elements
    SetLocalString(OBJECT_SELF, "SFScripts_872", "te_war_exretre"); // Expeditious Retreat
    SetLocalString(OBJECT_SELF, "SFScripts_873", "te_war_invis"); // Invisibility
    SetLocalString(OBJECT_SELF, "SFScripts_875", "NW_S0_CrGrUnd"); // Create Greater Undead
    SetLocalString(OBJECT_SELF, "SFScripts_876", "te_war_evard"); // Evards Black Tentacles
    SetLocalString(OBJECT_SELF, "SFScripts_877", "te_war_grdispel"); // Greater Dispelling
    SetLocalString(OBJECT_SELF, "SFScripts_878", "te_war_impinvis"); // Improved Invisibility
    SetLocalString(OBJECT_SELF, "SFScripts_879", "NW_S0_GrSpBrch"); // Greater Spell Breach
    SetLocalString(OBJECT_SELF, "SFScripts_88", "NW_S0_ImprInvis"); // Improved Invisibility
    SetLocalString(OBJECT_SELF, "SFScripts_881", "te_war_cirdeath"); // Circle of Death
    SetLocalString(OBJECT_SELF, "SFScripts_882", "te_war_dommon"); // Dominate Monster
    SetLocalString(OBJECT_SELF, "SFScripts_883", "te_war_ether"); // Etherealness
    SetLocalString(OBJECT_SELF, "SFScripts_884", "te_war_fingdeath"); // Finger of Death
    SetLocalString(OBJECT_SELF, "SFScripts_885", "te_war_gate"); // Gate
    SetLocalString(OBJECT_SELF, "SFScripts_886", "te_fiendpoly"); // FiendishPolymorph
    SetLocalString(OBJECT_SELF, "SFScripts_89", "NW_S0_IncCloud"); // Incendiary Cloud
    SetLocalString(OBJECT_SELF, "SFScripts_890", "te_callfiend"); // FEAT CALLFIENDS
    SetLocalString(OBJECT_SELF, "SFScripts_892", "te_sundead"); // SummonUndead1
    SetLocalString(OBJECT_SELF, "SFScripts_893", "te_sundead"); // SummonUndead2
    SetLocalString(OBJECT_SELF, "SFScripts_894", "te_sundead"); // SummonUndead3
    SetLocalString(OBJECT_SELF, "SFScripts_895", "te_sundead"); // SummonUndead4
    SetLocalString(OBJECT_SELF, "SFScripts_896", "te_sundead"); // SummonUndead5
    SetLocalString(OBJECT_SELF, "SFScripts_899", "te_eb_acid"); // Eldritch Blast Acid
    SetLocalString(OBJECT_SELF, "SFScripts_9", "NW_S0_BullStr"); // Bulls Strength
    SetLocalString(OBJECT_SELF, "SFScripts_90", "NW_S0_Invisib"); // Invisibility
    SetLocalString(OBJECT_SELF, "SFScripts_900", "te_eb_cold"); // Eldritch Blast Cold
    SetLocalString(OBJECT_SELF, "SFScripts_901", "te_eb_fire"); // Eldritch Blast Fire
    SetLocalString(OBJECT_SELF, "SFScripts_902", "te_eb_norm"); // Eldritch Blast Magic
    SetLocalString(OBJECT_SELF, "SFScripts_903", "te_eb_neg"); // Eldritch Blast Negative
    SetLocalString(OBJECT_SELF, "SFScripts_905", "te_eeb_acid"); // Eldritch Blast EMP Acid
    SetLocalString(OBJECT_SELF, "SFScripts_906", "te_eeb_cold"); // Eldritch Blast EMP Cold
    SetLocalString(OBJECT_SELF, "SFScripts_907", "te_eeb_fire"); // Eldritch Blast EMP Fire
    SetLocalString(OBJECT_SELF, "SFScripts_908", "te_eeb_magic"); // Eldritch Blast EMP Magic
    SetLocalString(OBJECT_SELF, "SFScripts_909", "te_eeb_neg"); // Eldritch Blast EMP Negative
    SetLocalString(OBJECT_SELF, "SFScripts_91", "NW_S0_InvPurge"); // Invisibility Purge
    SetLocalString(OBJECT_SELF, "SFScripts_911", "te_sc_blast"); // Spellfire Blast
    SetLocalString(OBJECT_SELF, "SFScripts_912", "te_sc_absorb"); // Spellfire Absorb
    SetLocalString(OBJECT_SELF, "SFScripts_913", "te_sc_heal_t"); // Spellfire Heal T
    SetLocalString(OBJECT_SELF, "SFScripts_914", "te_sc_destroy"); // Spellfire Destroy
    SetLocalString(OBJECT_SELF, "SFScripts_915", "te_sc_heal_t"); // Spellfire Heal R
    SetLocalString(OBJECT_SELF, "SFScripts_916", "te_sc_burst"); // Spellfire Burst
    SetLocalString(OBJECT_SELF, "SFScripts_917", "NW_S0_Haste"); // Spellfire Haste
    SetLocalString(OBJECT_SELF, "SFScripts_918", "te_sc_crown"); // Spellfire Crown
    SetLocalString(OBJECT_SELF, "SFScripts_919", "te_sc_maelstrom"); // Spellfire Maelstrom
    SetLocalString(OBJECT_SELF, "SFScripts_92", "NW_S0_InvSph"); // Invisibility Sphere
    SetLocalString(OBJECT_SELF, "SFScripts_922", "te_wildshape1"); // Wild Shape Mammal
    SetLocalString(OBJECT_SELF, "SFScripts_923", "te_wildshape1"); // Wild Shape BROWN BEAR
    SetLocalString(OBJECT_SELF, "SFScripts_924", "te_wildshape1"); // Wild Shape PANTHER
    SetLocalString(OBJECT_SELF, "SFScripts_925", "te_wildshape1"); // Wild Shape WOLF
    SetLocalString(OBJECT_SELF, "SFScripts_926", "te_wildshape1"); // Wild Shape BOAR
    SetLocalString(OBJECT_SELF, "SFScripts_927", "te_wildshape1"); // Wild Shape BADGER
    SetLocalString(OBJECT_SELF, "SFScripts_928", "te_wildshape2"); // Wild Shape Reptile
    SetLocalString(OBJECT_SELF, "SFScripts_929", "te_wildshape2"); // Wild Shape VIPER
    SetLocalString(OBJECT_SELF, "SFScripts_93", "NW_S0_Knock"); // Knock
    SetLocalString(OBJECT_SELF, "SFScripts_930", "te_wildshape2"); // Wild Shape COBRA
    SetLocalString(OBJECT_SELF, "SFScripts_931", "te_wildshape2"); // Wild Shape TORTOISE
    SetLocalString(OBJECT_SELF, "SFScripts_932", "te_wildshape2"); // Wild Shape SALT CROC
    SetLocalString(OBJECT_SELF, "SFScripts_933", "te_wildshape2"); // Wild Shape GIANT
    SetLocalString(OBJECT_SELF, "SFScripts_934", "te_wildshape3"); // Wild Shape Avian
    SetLocalString(OBJECT_SELF, "SFScripts_935", "te_wildshape3"); // Wild Shape Falcon
    SetLocalString(OBJECT_SELF, "SFScripts_936", "te_wildshape3"); // Wild Shape Crane
    SetLocalString(OBJECT_SELF, "SFScripts_937", "te_wildshape3"); // Wild Shape Raven
    SetLocalString(OBJECT_SELF, "SFScripts_938", "te_wildshape3"); // Wild Shape Owl
    SetLocalString(OBJECT_SELF, "SFScripts_939", "te_wildshape3"); // Wild Shape Sparrow
    SetLocalString(OBJECT_SELF, "SFScripts_94", "NW_S0_LsDispel"); // Lesser Dispel
    SetLocalString(OBJECT_SELF, "SFScripts_941", "te_sjump"); // Dimension Door
    SetLocalString(OBJECT_SELF, "SFScripts_943", "te_darkbolt"); // DARK BOLT
    SetLocalString(OBJECT_SELF, "SFScripts_944", "te_cler_charm"); // CHARM DOMAIN POWER
    SetLocalString(OBJECT_SELF, "SFScripts_945", "te_cler_illus"); // ILLUSION DOMAIN POWER
    SetLocalString(OBJECT_SELF, "SFScripts_946", "te_cler_magc"); // MAGIC DOMAIN POWER
    SetLocalString(OBJECT_SELF, "SFScripts_948", "te_teleport"); // Teleport
    SetLocalString(OBJECT_SELF, "SFScripts_949", "te_shambler"); // SUMMON SHAMBLING MOUND
    SetLocalString(OBJECT_SELF, "SFScripts_95", "NW_S0_LsMndBlk"); // Lesser Mind Blank
    SetLocalString(OBJECT_SELF, "SFScripts_950", "te_planeshift"); // Plane Shift
    SetLocalString(OBJECT_SELF, "SFScripts_953", "te_treestride"); // Tree Stride
    SetLocalString(OBJECT_SELF, "SFScripts_954", "te_wildshape4"); // Wild Shape PLANT
    SetLocalString(OBJECT_SELF, "SFScripts_955", "te_wildshape4"); // WILD SHAPE ASS VINE
    SetLocalString(OBJECT_SELF, "SFScripts_956", "te_wildshape4"); // WILD SHAPE TREANT
    SetLocalString(OBJECT_SELF, "SFScripts_957", "te_wildshape4"); // WILD SHAPE Shambling
    SetLocalString(OBJECT_SELF, "SFScripts_958", "te_sjump"); // Shadow Jump
    SetLocalString(OBJECT_SELF, "SFScripts_959", "te_sknife"); // Shadow Knife
    SetLocalString(OBJECT_SELF, "SFScripts_96", "te_lplanar"); // Lesser Planar Binding
    SetLocalString(OBJECT_SELF, "SFScripts_960", "te_smaster"); // Shadow Mastery
    SetLocalString(OBJECT_SELF, "SFScripts_961", "te_sdoor"); // Shadow Walk
    SetLocalString(OBJECT_SELF, "SFScripts_964", "te_bs_sword"); // BS SWORD STYLE
    SetLocalString(OBJECT_SELF, "SFScripts_965", "te_bs_strike"); // BS ARCANE STRIKE
    SetLocalString(OBJECT_SELF, "SFScripts_967", "te_shieldshad"); // Shield of Shadows
    SetLocalString(OBJECT_SELF, "SFScripts_97", "NW_S0_LsRestor"); // Lesser Restoration
    SetLocalString(OBJECT_SELF, "SFScripts_970", "te_spellward"); // Spell Ward
    SetLocalString(OBJECT_SELF, "SFScripts_971", "te_apoth"); // Apothecary and arsenal
    SetLocalString(OBJECT_SELF, "SFScripts_972", "te_eyesoforder"); // Eyes of the order
    SetLocalString(OBJECT_SELF, "SFScripts_973", "NW_S2_DetecEvil"); // Detect Evil
    SetLocalString(OBJECT_SELF, "SFScripts_974", "te_dr_weather"); // Control Weather
    SetLocalString(OBJECT_SELF, "SFScripts_975", "te_research"); // Research New Spell
    SetLocalString(OBJECT_SELF, "SFScripts_976", "te_sp_purge"); // Spellfire Purge
    SetLocalString(OBJECT_SELF, "SFScripts_977", "te_vamp_blood"); // Blood Drain
    SetLocalString(OBJECT_SELF, "SFScripts_978", "te_vamp_child"); // ChildrenOfTheNight
    SetLocalString(OBJECT_SELF, "SFScripts_979", "te_vamp_dom"); // Dominate Person
    SetLocalString(OBJECT_SELF, "SFScripts_98", "NW_S0_LsSpBrch"); // Lesser Spell Breach
    SetLocalString(OBJECT_SELF, "SFScripts_980", "te_vamp_mist"); // Mist Form
    SetLocalString(OBJECT_SELF, "SFScripts_981", "te_vamp_bat"); // Bat Form
    SetLocalString(OBJECT_SELF, "SFScripts_982", "te_vamp_wolf"); // Wolf Form
    SetLocalString(OBJECT_SELF, "SFScripts_984", "te_sp_summnt"); // Summon Mount
    SetLocalString(OBJECT_SELF, "SFScripts_985", "te_sp_hero"); // Heroism
    SetLocalString(OBJECT_SELF, "SFScripts_986", "te_sp_herogtr"); // Heroism Greater
    SetLocalString(OBJECT_SELF, "SFScripts_987", "te_sp_lullaby"); // Lullaby
    SetLocalString(OBJECT_SELF, "SFScripts_988", "te_sp_rage"); // Rage
    SetLocalString(OBJECT_SELF, "SFScripts_989", "te_sp_clghtstorm"); // Call Lightning Storm
    SetLocalString(OBJECT_SELF, "SFScripts_99", "NW_S0_LsSpMant"); // Lesser Spell Mantle
    SetLocalString(OBJECT_SELF, "SFScripts_990", "te_sp_claws"); // Claws Of Darkness
    SetLocalString(OBJECT_SELF, "SFScripts_991", "te_sp_polarray"); // Polar Ray
    SetLocalString(OBJECT_SELF, "SFScripts_992", "te_sp_scorch"); // Scorching Ray
    SetLocalString(OBJECT_SELF, "SFScripts_993", "te_sp_blur"); // Blur
    SetLocalString(OBJECT_SELF, "SFScripts_994", "te_sp_shcrown"); // Verrakeths Shadow Crown
    SetLocalString(OBJECT_SELF, "SFScripts_995", "te_sp_eschew"); // EschewMaterialToggle
    SetLocalString(OBJECT_SELF, "SFScripts_998", "te_sp_protarrow"); // Protection From Arrows
    SetLocalString(OBJECT_SELF, "SFNames_0", "Acid Fog"); // Acid Fog
    SetLocalString(OBJECT_SELF, "SFNames_1", "Aid"); // Aid
    SetLocalString(OBJECT_SELF, "SFNames_10", "Burning Hands"); // Burning Hands
    SetLocalString(OBJECT_SELF, "SFNames_100", "Light"); // Light
    SetLocalString(OBJECT_SELF, "SFNames_1000", "Undeath After Death"); // Undeath After Death
    SetLocalString(OBJECT_SELF, "SFNames_1002", "Blasphemy"); // Blasphemy
    SetLocalString(OBJECT_SELF, "SFNames_1005", "Cold Fire"); // Cold Fire
    SetLocalString(OBJECT_SELF, "SFNames_1006", "Paralyzing touch"); // Paralyzing touch
    SetLocalString(OBJECT_SELF, "SFNames_1007", "Daylight"); // Daylight
    SetLocalString(OBJECT_SELF, "SFNames_1008", "Chill Touch"); // Chill Touch
    SetLocalString(OBJECT_SELF, "SFNames_1009", "Command Undead"); // Command Undead
    SetLocalString(OBJECT_SELF, "SFNames_101", "Lightning Bolt"); // Lightning Bolt
    SetLocalString(OBJECT_SELF, "SFNames_1010", "Aganazzer FlameWave"); // Aganazzer FlameWave
    SetLocalString(OBJECT_SELF, "SFNames_1011", "False Life"); // False Life
    SetLocalString(OBJECT_SELF, "SFNames_1012", "Halt Undead"); // Halt Undead
    SetLocalString(OBJECT_SELF, "SFNames_1013", "Deep Slumber"); // Deep Slumber
    SetLocalString(OBJECT_SELF, "SFNames_1014", "Shadow Spray"); // Shadow Spray
    SetLocalString(OBJECT_SELF, "SFNames_1015", "Disintegrate"); // Disintegrate
    SetLocalString(OBJECT_SELF, "SFNames_1016", "Disrupt Undead"); // Disrupt Undead
    SetLocalString(OBJECT_SELF, "SFNames_1017", "Glibness"); // Glibness
    SetLocalString(OBJECT_SELF, "SFNames_1018", "Crushing Despair"); // Crushing Despair
    SetLocalString(OBJECT_SELF, "SFNames_1019", "Good Hope"); // Good Hope
    SetLocalString(OBJECT_SELF, "SFNames_102", "Mage Armor"); // Mage Armor
    SetLocalString(OBJECT_SELF, "SFNames_1020", "Affliction"); // Affliction
    SetLocalString(OBJECT_SELF, "SFNames_1021", "Aspect Of The Deity"); // Aspect Of The Deity
    SetLocalString(OBJECT_SELF, "SFNames_1022", "Blood Of Martyr"); // Blood Of Martyr
    SetLocalString(OBJECT_SELF, "SFNames_1023", "Divine Sacrifice"); // Divine Sacrifice
    SetLocalString(OBJECT_SELF, "SFNames_1024", "Lantern Light"); // Lantern Light
    SetLocalString(OBJECT_SELF, "SFNames_1025", "Fleshshiver"); // Fleshshiver
    SetLocalString(OBJECT_SELF, "SFNames_1026", "Lively Step"); // Lively Step
    SetLocalString(OBJECT_SELF, "SFNames_1027", "Corrosive Grasp"); // Corrosive Grasp
    SetLocalString(OBJECT_SELF, "SFNames_1028", "Shadow Well"); // Shadow Well
    SetLocalString(OBJECT_SELF, "SFNames_1029", "Memory Rot"); // Memory Rot
    SetLocalString(OBJECT_SELF, "SFNames_103", "Magic Circle against Chaos"); // Magic Circle against Chaos
    SetLocalString(OBJECT_SELF, "SFNames_1030", "Mass Bulls Strength"); // Mass Bulls Strength
    SetLocalString(OBJECT_SELF, "SFNames_1031", "Mass Cats Grace"); // Mass Cats Grace
    SetLocalString(OBJECT_SELF, "SFNames_1032", "Mass Eagle Splendor"); // Mass Eagle Splendor
    SetLocalString(OBJECT_SELF, "SFNames_1033", "Mass Endurance"); // Mass Endurance
    SetLocalString(OBJECT_SELF, "SFNames_1034", "Mass Foxs Cunning"); // Mass Foxs Cunning
    SetLocalString(OBJECT_SELF, "SFNames_1035", "Mass Owls Wisdom"); // Mass Owls Wisdom
    SetLocalString(OBJECT_SELF, "SFNames_1036", "Atonement"); // Atonement
    SetLocalString(OBJECT_SELF, "SFNames_1037", "Longstrider"); // Longstrider
    SetLocalString(OBJECT_SELF, "SFNames_1038", "Nondetection"); // Nondetection
    SetLocalString(OBJECT_SELF, "SFNames_1039", "Rusting grasp"); // Rusting grasp
    SetLocalString(OBJECT_SELF, "SFNames_104", "Magic Circle against Evil"); // Magic Circle against Evil
    SetLocalString(OBJECT_SELF, "SFNames_1040", "Word of recall"); // Word of recall
    SetLocalString(OBJECT_SELF, "SFNames_1041", "Blight"); // Blight
    SetLocalString(OBJECT_SELF, "SFNames_1043", "Leadership"); // Leadership
    SetLocalString(OBJECT_SELF, "SFNames_1045", "Spiritual Weapon"); // Spiritual Weapon
    SetLocalString(OBJECT_SELF, "SFNames_1047", "Darkness"); // Darkness
    SetLocalString(OBJECT_SELF, "SFNames_105", "Magic Circle against Good"); // Magic Circle against Good
    SetLocalString(OBJECT_SELF, "SFNames_1050", "Eldritch Chain"); // Eldritch Chain
    SetLocalString(OBJECT_SELF, "SFNames_1051", "Eldritch Cone"); // Eldritch Cone
    SetLocalString(OBJECT_SELF, "SFNames_1052", "Eldritch Spear"); // Eldritch Spear
    SetLocalString(OBJECT_SELF, "SFNames_1053", "Eldritch Doom"); // Eldritch Doom
    SetLocalString(OBJECT_SELF, "SFNames_1054", "Hideous Blow"); // Hideous Blow
    SetLocalString(OBJECT_SELF, "SFNames_1055", "Frightful Blast"); // Frightful Blast
    SetLocalString(OBJECT_SELF, "SFNames_1056", "Sickening Blast"); // Sickening Blast
    SetLocalString(OBJECT_SELF, "SFNames_1057", "Brimstone Blast"); // Brimstone Blast
    SetLocalString(OBJECT_SELF, "SFNames_1058", "Hellrime Blast"); // Hellrime Blast
    SetLocalString(OBJECT_SELF, "SFNames_1059", "Vitriolic Blast"); // Vitriolic Blast
    SetLocalString(OBJECT_SELF, "SFNames_106", "Magic Circle against Law"); // Magic Circle against Law
    SetLocalString(OBJECT_SELF, "SFNames_1060", "Bewitching Blast"); // Bewitching Blast
    SetLocalString(OBJECT_SELF, "SFNames_1061", "Utterdark Blast"); // Utterdark Blast
    SetLocalString(OBJECT_SELF, "SFNames_1062", "Repelling Blast"); // Repelling Blast
    SetLocalString(OBJECT_SELF, "SFNames_1063", "Flee The Scene"); // Flee The Scene
    SetLocalString(OBJECT_SELF, "SFNames_1064", "Path Of Shadow"); // Path Of Shadow
    SetLocalString(OBJECT_SELF, "SFNames_107", "Magic Missile"); // Magic Missile
    SetLocalString(OBJECT_SELF, "SFNames_1070", "Orb Lsr Acid"); // Orb Lsr Acid
    SetLocalString(OBJECT_SELF, "SFNames_1071", "Orb Lsr Cold"); // Orb Lsr Cold
    SetLocalString(OBJECT_SELF, "SFNames_1072", "Orb Lsr Elec"); // Orb Lsr Elec
    SetLocalString(OBJECT_SELF, "SFNames_1073", "Orb Lsr Fire"); // Orb Lsr Fire
    SetLocalString(OBJECT_SELF, "SFNames_1074", "Orb Lsr Sonic"); // Orb Lsr Sonic
    SetLocalString(OBJECT_SELF, "SFNames_108", "Magic Vestment"); // Magic Vestment
    SetLocalString(OBJECT_SELF, "SFNames_109", "Magic Weapon"); // Magic Weapon
    SetLocalString(OBJECT_SELF, "SFNames_11", "Call Lightning"); // Call Lightning
    SetLocalString(OBJECT_SELF, "SFNames_110", "Mass Blindness and Deafness"); // Mass Blindness and Deafness
    SetLocalString(OBJECT_SELF, "SFNames_111", "Mass Charm"); // Mass Charm
    SetLocalString(OBJECT_SELF, "SFNames_112", "Mass Domination"); // Mass Domination
    SetLocalString(OBJECT_SELF, "SFNames_113", "Mass Haste"); // Mass Haste
    SetLocalString(OBJECT_SELF, "SFNames_114", "Mass Heal"); // Mass Heal
    SetLocalString(OBJECT_SELF, "SFNames_115", "Melfs Acid Arrow"); // Melfs Acid Arrow
    SetLocalString(OBJECT_SELF, "SFNames_116", "Meteor Swarm"); // Meteor Swarm
    SetLocalString(OBJECT_SELF, "SFNames_117", "Mind Blank"); // Mind Blank
    SetLocalString(OBJECT_SELF, "SFNames_118", "Mind Fog"); // Mind Fog
    SetLocalString(OBJECT_SELF, "SFNames_119", "Minor Globe of Invulnerability"); // Minor Globe of Invulnerability
    SetLocalString(OBJECT_SELF, "SFNames_12", "Calm Emotions"); // Calm Emotions
    SetLocalString(OBJECT_SELF, "SFNames_120", "Ghostly Visage"); // Ghostly Visage
    SetLocalString(OBJECT_SELF, "SFNames_121", "Ethereal Visage"); // Ethereal Visage
    SetLocalString(OBJECT_SELF, "SFNames_122", "Mordenkainens Disjunction"); // Mordenkainens Disjunction
    SetLocalString(OBJECT_SELF, "SFNames_123", "Mordenkainens Sword"); // Mordenkainens Sword
    SetLocalString(OBJECT_SELF, "SFNames_124", "Natures Balance"); // Natures Balance
    SetLocalString(OBJECT_SELF, "SFNames_125", "Negative Energy Protection"); // Negative Energy Protection
    SetLocalString(OBJECT_SELF, "SFNames_126", "Neutralize Poison"); // Neutralize Poison
    SetLocalString(OBJECT_SELF, "SFNames_127", "Phantasmal Killer"); // Phantasmal Killer
    SetLocalString(OBJECT_SELF, "SFNames_128", "Planar Binding"); // Planar Binding
    SetLocalString(OBJECT_SELF, "SFNames_129", "Poison"); // Poison
    SetLocalString(OBJECT_SELF, "SFNames_13", "Cats Grace"); // Cats Grace
    SetLocalString(OBJECT_SELF, "SFNames_130", "Polymorph Self"); // Polymorph Self
    SetLocalString(OBJECT_SELF, "SFNames_131", "Power Word Kill"); // Power Word Kill
    SetLocalString(OBJECT_SELF, "SFNames_132", "Power Word Stun"); // Power Word Stun
    SetLocalString(OBJECT_SELF, "SFNames_133", "Prayer"); // Prayer
    SetLocalString(OBJECT_SELF, "SFNames_134", "Premonition"); // Premonition
    SetLocalString(OBJECT_SELF, "SFNames_135", "Prismatic Spray"); // Prismatic Spray
    SetLocalString(OBJECT_SELF, "SFNames_136", "Protection from Chaos"); // Protection from Chaos
    SetLocalString(OBJECT_SELF, "SFNames_137", "Protection from Elements"); // Protection from Elements
    SetLocalString(OBJECT_SELF, "SFNames_138", "Protection from Evil"); // Protection from Evil
    SetLocalString(OBJECT_SELF, "SFNames_139", "Protection from Good"); // Protection from Good
    SetLocalString(OBJECT_SELF, "SFNames_14", "Chain Lightning"); // Chain Lightning
    SetLocalString(OBJECT_SELF, "SFNames_140", "Protection from Law"); // Protection from Law
    SetLocalString(OBJECT_SELF, "SFNames_141", "Protection from Spells"); // Protection from Spells
    SetLocalString(OBJECT_SELF, "SFNames_142", "Raise Dead"); // Raise Dead
    SetLocalString(OBJECT_SELF, "SFNames_143", "Ray of Enfeeblement"); // Ray of Enfeeblement
    SetLocalString(OBJECT_SELF, "SFNames_144", "Ray of Frost"); // Ray of Frost
    SetLocalString(OBJECT_SELF, "SFNames_145", "Remove Blindness and Deafness"); // Remove Blindness and Deafness
    SetLocalString(OBJECT_SELF, "SFNames_146", "Remove Curse"); // Remove Curse
    SetLocalString(OBJECT_SELF, "SFNames_147", "Remove Disease"); // Remove Disease
    SetLocalString(OBJECT_SELF, "SFNames_148", "Remove Fear"); // Remove Fear
    SetLocalString(OBJECT_SELF, "SFNames_149", "Remove Paralysis"); // Remove Paralysis
    SetLocalString(OBJECT_SELF, "SFNames_15", "Charm Monster"); // Charm Monster
    SetLocalString(OBJECT_SELF, "SFNames_150", "Resist Elements"); // Resist Elements
    SetLocalString(OBJECT_SELF, "SFNames_151", "Resistance"); // Resistance
    SetLocalString(OBJECT_SELF, "SFNames_152", "Restoration"); // Restoration
    SetLocalString(OBJECT_SELF, "SFNames_153", "Resurrection"); // Resurrection
    SetLocalString(OBJECT_SELF, "SFNames_154", "Sanctuary"); // Sanctuary
    SetLocalString(OBJECT_SELF, "SFNames_155", "Scare"); // Scare
    SetLocalString(OBJECT_SELF, "SFNames_156", "Searing Light"); // Searing Light
    SetLocalString(OBJECT_SELF, "SFNames_157", "See Invisibility"); // See Invisibility
    SetLocalString(OBJECT_SELF, "SFNames_158", "Shades"); // Shades
    SetLocalString(OBJECT_SELF, "SFNames_159", "Shadow Conjuration"); // Shadow Conjuration
    SetLocalString(OBJECT_SELF, "SFNames_16", "Charm Person"); // Charm Person
    SetLocalString(OBJECT_SELF, "SFNames_160", "Shadow Shield"); // Shadow Shield
    SetLocalString(OBJECT_SELF, "SFNames_161", "Shapechange"); // Shapechange
    SetLocalString(OBJECT_SELF, "SFNames_162", "Shield of Law"); // Shield of Law
    SetLocalString(OBJECT_SELF, "SFNames_163", "Silence"); // Silence
    SetLocalString(OBJECT_SELF, "SFNames_164", "Slay Living"); // Slay Living
    SetLocalString(OBJECT_SELF, "SFNames_165", "Sleep"); // Sleep
    SetLocalString(OBJECT_SELF, "SFNames_166", "Slow"); // Slow
    SetLocalString(OBJECT_SELF, "SFNames_167", "Sound Burst"); // Sound Burst
    SetLocalString(OBJECT_SELF, "SFNames_168", "Spell Resistance"); // Spell Resistance
    SetLocalString(OBJECT_SELF, "SFNames_169", "Spell Mantle"); // Spell Mantle
    SetLocalString(OBJECT_SELF, "SFNames_17", "Charm Person or Animal"); // Charm Person or Animal
    SetLocalString(OBJECT_SELF, "SFNames_170", "Sphere of Chaos"); // Sphere of Chaos
    SetLocalString(OBJECT_SELF, "SFNames_171", "Stinking Cloud"); // Stinking Cloud
    SetLocalString(OBJECT_SELF, "SFNames_172", "Stoneskin"); // Stoneskin
    SetLocalString(OBJECT_SELF, "SFNames_173", "Storm of Vengeance"); // Storm of Vengeance
    SetLocalString(OBJECT_SELF, "SFNames_174", "Summon Creature I"); // Summon Creature I
    SetLocalString(OBJECT_SELF, "SFNames_175", "Summon Creature II"); // Summon Creature II
    SetLocalString(OBJECT_SELF, "SFNames_176", "Summon Creature III"); // Summon Creature III
    SetLocalString(OBJECT_SELF, "SFNames_177", "Summon Creature IV"); // Summon Creature IV
    SetLocalString(OBJECT_SELF, "SFNames_178", "Summon Creature IX"); // Summon Creature IX
    SetLocalString(OBJECT_SELF, "SFNames_179", "Summon Creature V"); // Summon Creature V
    SetLocalString(OBJECT_SELF, "SFNames_18", "Circle of Death"); // Circle of Death
    SetLocalString(OBJECT_SELF, "SFNames_180", "Summon Creature VI"); // Summon Creature VI
    SetLocalString(OBJECT_SELF, "SFNames_181", "Summon Creature VII"); // Summon Creature VII
    SetLocalString(OBJECT_SELF, "SFNames_182", "Summon Creature VIII"); // Summon Creature VIII
    SetLocalString(OBJECT_SELF, "SFNames_183", "Sunbeam"); // Sunbeam
    SetLocalString(OBJECT_SELF, "SFNames_184", "Tensers Transformation"); // Tensers Transformation
    SetLocalString(OBJECT_SELF, "SFNames_185", "Time Stop"); // Time Stop
    SetLocalString(OBJECT_SELF, "SFNames_186", "True Seeing"); // True Seeing
    SetLocalString(OBJECT_SELF, "SFNames_187", "Unholy Aura"); // Unholy Aura
    SetLocalString(OBJECT_SELF, "SFNames_188", "Vampiric Touch"); // Vampiric Touch
    SetLocalString(OBJECT_SELF, "SFNames_189", "Virtue"); // Virtue
    SetLocalString(OBJECT_SELF, "SFNames_19", "Circle of Doom"); // Circle of Doom
    SetLocalString(OBJECT_SELF, "SFNames_190", "Wail of the Banshee"); // Wail of the Banshee
    SetLocalString(OBJECT_SELF, "SFNames_191", "Wall of Fire"); // Wall of Fire
    SetLocalString(OBJECT_SELF, "SFNames_192", "Web"); // Web
    SetLocalString(OBJECT_SELF, "SFNames_193", "Weird"); // Weird
    SetLocalString(OBJECT_SELF, "SFNames_194", "Word of Faith"); // Word of Faith
    SetLocalString(OBJECT_SELF, "SFNames_195", "AURA BLINDING"); // AURA BLINDING
    SetLocalString(OBJECT_SELF, "SFNames_196", "Aura Cold"); // Aura Cold
    SetLocalString(OBJECT_SELF, "SFNames_197", "Aura Electricity"); // Aura Electricity
    SetLocalString(OBJECT_SELF, "SFNames_198", "Aura Fear"); // Aura Fear
    SetLocalString(OBJECT_SELF, "SFNames_199", "Aura Fire"); // Aura Fire
    SetLocalString(OBJECT_SELF, "SFNames_2", "Animate Dead"); // Animate Dead
    SetLocalString(OBJECT_SELF, "SFNames_20", "Clairaudience and Clairvoyance"); // Clairaudience and Clairvoyance
    SetLocalString(OBJECT_SELF, "SFNames_200", "Aura Menace"); // Aura Menace
    SetLocalString(OBJECT_SELF, "SFNames_201", "Aura Protection"); // Aura Protection
    SetLocalString(OBJECT_SELF, "SFNames_202", "Aura Stun"); // Aura Stun
    SetLocalString(OBJECT_SELF, "SFNames_203", "Aura Unearthly Visage"); // Aura Unearthly Visage
    SetLocalString(OBJECT_SELF, "SFNames_204", "Aura Unnatural"); // Aura Unnatural
    SetLocalString(OBJECT_SELF, "SFNames_205", "Bolt Ability Drain Charisma"); // Bolt Ability Drain Charisma
    SetLocalString(OBJECT_SELF, "SFNames_206", "Bolt Ability Drain Constitution"); // Bolt Ability Drain Constitution
    SetLocalString(OBJECT_SELF, "SFNames_207", "Bolt Ability Drain Dexterity"); // Bolt Ability Drain Dexterity
    SetLocalString(OBJECT_SELF, "SFNames_208", "Bolt Ability Drain Intelligence"); // Bolt Ability Drain Intelligence
    SetLocalString(OBJECT_SELF, "SFNames_209", "Bolt Ability Drain Strength"); // Bolt Ability Drain Strength
    SetLocalString(OBJECT_SELF, "SFNames_21", "Clarity"); // Clarity
    SetLocalString(OBJECT_SELF, "SFNames_210", "Bolt Ability Drain Wisdom"); // Bolt Ability Drain Wisdom
    SetLocalString(OBJECT_SELF, "SFNames_211", "Bolt Acid"); // Bolt Acid
    SetLocalString(OBJECT_SELF, "SFNames_212", "Bolt Charm"); // Bolt Charm
    SetLocalString(OBJECT_SELF, "SFNames_213", "Bolt Cold"); // Bolt Cold
    SetLocalString(OBJECT_SELF, "SFNames_214", "Bolt Confuse"); // Bolt Confuse
    SetLocalString(OBJECT_SELF, "SFNames_215", "Bolt Daze"); // Bolt Daze
    SetLocalString(OBJECT_SELF, "SFNames_216", "Bolt Death"); // Bolt Death
    SetLocalString(OBJECT_SELF, "SFNames_217", "Bolt Disease"); // Bolt Disease
    SetLocalString(OBJECT_SELF, "SFNames_218", "Bolt Dominate"); // Bolt Dominate
    SetLocalString(OBJECT_SELF, "SFNames_219", "Bolt Fire"); // Bolt Fire
    SetLocalString(OBJECT_SELF, "SFNames_22", "Cloak of Chaos"); // Cloak of Chaos
    SetLocalString(OBJECT_SELF, "SFNames_220", "Bolt Knockdown"); // Bolt Knockdown
    SetLocalString(OBJECT_SELF, "SFNames_221", "Bolt Level Drain"); // Bolt Level Drain
    SetLocalString(OBJECT_SELF, "SFNames_222", "Bolt Lightning"); // Bolt Lightning
    SetLocalString(OBJECT_SELF, "SFNames_223", "Bolt Paralyze"); // Bolt Paralyze
    SetLocalString(OBJECT_SELF, "SFNames_224", "Bolt Poison"); // Bolt Poison
    SetLocalString(OBJECT_SELF, "SFNames_225", "Bolt Shards"); // Bolt Shards
    SetLocalString(OBJECT_SELF, "SFNames_226", "Bolt Slow"); // Bolt Slow
    SetLocalString(OBJECT_SELF, "SFNames_227", "Bolt Stun"); // Bolt Stun
    SetLocalString(OBJECT_SELF, "SFNames_228", "Bolt Web"); // Bolt Web
    SetLocalString(OBJECT_SELF, "SFNames_229", "Cone Acid"); // Cone Acid
    SetLocalString(OBJECT_SELF, "SFNames_23", "Cloudkill"); // Cloudkill
    SetLocalString(OBJECT_SELF, "SFNames_230", "Cone Cold"); // Cone Cold
    SetLocalString(OBJECT_SELF, "SFNames_2306", "VAA Anim1"); // VAA Anim1
    SetLocalString(OBJECT_SELF, "SFNames_2307", "VAA Anim2"); // VAA Anim2
    SetLocalString(OBJECT_SELF, "SFNames_2308", "VAA Anim3"); // VAA Anim3
    SetLocalString(OBJECT_SELF, "SFNames_2309", "VAA Anim4"); // VAA Anim4
    SetLocalString(OBJECT_SELF, "SFNames_231", "Cone Disease"); // Cone Disease
    SetLocalString(OBJECT_SELF, "SFNames_2310", "VAA Anim5"); // VAA Anim5
    SetLocalString(OBJECT_SELF, "SFNames_2312", "VAA Anim6"); // VAA Anim6
    SetLocalString(OBJECT_SELF, "SFNames_2313", "VAA Anim7"); // VAA Anim7
    SetLocalString(OBJECT_SELF, "SFNames_2314", "VAA Anim8"); // VAA Anim8
    SetLocalString(OBJECT_SELF, "SFNames_2315", "VAA Anim9"); // VAA Anim9
    SetLocalString(OBJECT_SELF, "SFNames_2316", "VAA Anim10"); // VAA Anim10
    SetLocalString(OBJECT_SELF, "SFNames_232", "Cone Fire"); // Cone Fire
    SetLocalString(OBJECT_SELF, "SFNames_233", "Cone Lightning"); // Cone Lightning
    SetLocalString(OBJECT_SELF, "SFNames_234", "Cone Poison"); // Cone Poison
    SetLocalString(OBJECT_SELF, "SFNames_235", "Cone Sonic"); // Cone Sonic
    SetLocalString(OBJECT_SELF, "SFNames_236", "Dragon Breath Acid"); // Dragon Breath Acid
    SetLocalString(OBJECT_SELF, "SFNames_237", "Dragon Breath Cold"); // Dragon Breath Cold
    SetLocalString(OBJECT_SELF, "SFNames_238", "Dragon Breath Fear"); // Dragon Breath Fear
    SetLocalString(OBJECT_SELF, "SFNames_239", "Dragon Breath Fire"); // Dragon Breath Fire
    SetLocalString(OBJECT_SELF, "SFNames_24", "Color Spray"); // Color Spray
    SetLocalString(OBJECT_SELF, "SFNames_240", "Dragon Breath Gas"); // Dragon Breath Gas
    SetLocalString(OBJECT_SELF, "SFNames_241", "Dragon Breath Lightning"); // Dragon Breath Lightning
    SetLocalString(OBJECT_SELF, "SFNames_242", "Dragon Breath Paralyze"); // Dragon Breath Paralyze
    SetLocalString(OBJECT_SELF, "SFNames_243", "Dragon Breath Sleep"); // Dragon Breath Sleep
    SetLocalString(OBJECT_SELF, "SFNames_244", "Dragon Breath Slow"); // Dragon Breath Slow
    SetLocalString(OBJECT_SELF, "SFNames_245", "Dragon Breath Weaken"); // Dragon Breath Weaken
    SetLocalString(OBJECT_SELF, "SFNames_246", "Dragon Wing Buffet"); // Dragon Wing Buffet
    SetLocalString(OBJECT_SELF, "SFNames_247", "Ferocity 1"); // Ferocity 1
    SetLocalString(OBJECT_SELF, "SFNames_248", "Ferocity 2"); // Ferocity 2
    SetLocalString(OBJECT_SELF, "SFNames_249", "Ferocity 3"); // Ferocity 3
    SetLocalString(OBJECT_SELF, "SFNames_25", "Cone of Cold"); // Cone of Cold
    SetLocalString(OBJECT_SELF, "SFNames_250", "Gaze Charm"); // Gaze Charm
    SetLocalString(OBJECT_SELF, "SFNames_251", "Gaze Confusion"); // Gaze Confusion
    SetLocalString(OBJECT_SELF, "SFNames_252", "Gaze Daze"); // Gaze Daze
    SetLocalString(OBJECT_SELF, "SFNames_253", "Gaze Death"); // Gaze Death
    SetLocalString(OBJECT_SELF, "SFNames_254", "Gaze Destroy Chaos"); // Gaze Destroy Chaos
    SetLocalString(OBJECT_SELF, "SFNames_255", "Gaze Destroy Evil"); // Gaze Destroy Evil
    SetLocalString(OBJECT_SELF, "SFNames_256", "Gaze Destroy Good"); // Gaze Destroy Good
    SetLocalString(OBJECT_SELF, "SFNames_257", "Gaze Destroy Law"); // Gaze Destroy Law
    SetLocalString(OBJECT_SELF, "SFNames_258", "Gaze Dominate"); // Gaze Dominate
    SetLocalString(OBJECT_SELF, "SFNames_259", "Gaze Doom"); // Gaze Doom
    SetLocalString(OBJECT_SELF, "SFNames_26", "Confusion"); // Confusion
    SetLocalString(OBJECT_SELF, "SFNames_260", "Gaze Fear"); // Gaze Fear
    SetLocalString(OBJECT_SELF, "SFNames_261", "Gaze Paralysis"); // Gaze Paralysis
    SetLocalString(OBJECT_SELF, "SFNames_262", "Gaze Stunned"); // Gaze Stunned
    SetLocalString(OBJECT_SELF, "SFNames_263", "Golem Breath Gas"); // Golem Breath Gas
    SetLocalString(OBJECT_SELF, "SFNames_264", "Hell Hound Firebreath"); // Hell Hound Firebreath
    SetLocalString(OBJECT_SELF, "SFNames_265", "Howl Confuse"); // Howl Confuse
    SetLocalString(OBJECT_SELF, "SFNames_266", "Howl Daze"); // Howl Daze
    SetLocalString(OBJECT_SELF, "SFNames_267", "Howl Death"); // Howl Death
    SetLocalString(OBJECT_SELF, "SFNames_268", "Howl Doom"); // Howl Doom
    SetLocalString(OBJECT_SELF, "SFNames_269", "Howl Fear"); // Howl Fear
    SetLocalString(OBJECT_SELF, "SFNames_27", "Contagion"); // Contagion
    SetLocalString(OBJECT_SELF, "SFNames_270", "Howl Paralysis"); // Howl Paralysis
    SetLocalString(OBJECT_SELF, "SFNames_271", "Howl Sonic"); // Howl Sonic
    SetLocalString(OBJECT_SELF, "SFNames_272", "Howl Stun"); // Howl Stun
    SetLocalString(OBJECT_SELF, "SFNames_273", "Intensity 1"); // Intensity 1
    SetLocalString(OBJECT_SELF, "SFNames_274", "Intensity 2"); // Intensity 2
    SetLocalString(OBJECT_SELF, "SFNames_275", "Intensity 3"); // Intensity 3
    SetLocalString(OBJECT_SELF, "SFNames_276", "Krenshar Scare"); // Krenshar Scare
    SetLocalString(OBJECT_SELF, "SFNames_277", "Lesser Body Adjustment"); // Lesser Body Adjustment
    SetLocalString(OBJECT_SELF, "SFNames_278", "Mephit Salt Breath"); // Mephit Salt Breath
    SetLocalString(OBJECT_SELF, "SFNames_279", "Mephit Steam Breath"); // Mephit Steam Breath
    SetLocalString(OBJECT_SELF, "SFNames_28", "Control Undead"); // Control Undead
    SetLocalString(OBJECT_SELF, "SFNames_280", "Mummy Bolster Undead"); // Mummy Bolster Undead
    SetLocalString(OBJECT_SELF, "SFNames_281", "Pulse Drown"); // Pulse Drown
    SetLocalString(OBJECT_SELF, "SFNames_282", "Pulse Spores"); // Pulse Spores
    SetLocalString(OBJECT_SELF, "SFNames_283", "Pulse Whirlwind"); // Pulse Whirlwind
    SetLocalString(OBJECT_SELF, "SFNames_284", "Pulse Fire"); // Pulse Fire
    SetLocalString(OBJECT_SELF, "SFNames_285", "Pulse Lightning"); // Pulse Lightning
    SetLocalString(OBJECT_SELF, "SFNames_286", "Pulse Cold"); // Pulse Cold
    SetLocalString(OBJECT_SELF, "SFNames_287", "Pulse Negative"); // Pulse Negative
    SetLocalString(OBJECT_SELF, "SFNames_288", "Pulse Holy"); // Pulse Holy
    SetLocalString(OBJECT_SELF, "SFNames_289", "Pulse Death"); // Pulse Death
    SetLocalString(OBJECT_SELF, "SFNames_29", "Create Greater Undead"); // Create Greater Undead
    SetLocalString(OBJECT_SELF, "SFNames_290", "Pulse Level Drain"); // Pulse Level Drain
    SetLocalString(OBJECT_SELF, "SFNames_291", "Pulse Ability Drain Intelligence"); // Pulse Ability Drain Intelligence
    SetLocalString(OBJECT_SELF, "SFNames_292", "Pulse Ability Drain Charisma"); // Pulse Ability Drain Charisma
    SetLocalString(OBJECT_SELF, "SFNames_293", "Pulse Ability Drain Constitution"); // Pulse Ability Drain Constitution
    SetLocalString(OBJECT_SELF, "SFNames_294", "Pulse Ability Drain Dexterity"); // Pulse Ability Drain Dexterity
    SetLocalString(OBJECT_SELF, "SFNames_295", "Pulse Ability Drain Strength"); // Pulse Ability Drain Strength
    SetLocalString(OBJECT_SELF, "SFNames_296", "Pulse Ability Drain Wisdom"); // Pulse Ability Drain Wisdom
    SetLocalString(OBJECT_SELF, "SFNames_297", "Pulse Poison"); // Pulse Poison
    SetLocalString(OBJECT_SELF, "SFNames_298", "Pulse Disease"); // Pulse Disease
    SetLocalString(OBJECT_SELF, "SFNames_299", "Rage 3"); // Rage 3
    SetLocalString(OBJECT_SELF, "SFNames_3", "Barkskin"); // Barkskin
    SetLocalString(OBJECT_SELF, "SFNames_30", "Create Undead"); // Create Undead
    SetLocalString(OBJECT_SELF, "SFNames_300", "Rage 4"); // Rage 4
    SetLocalString(OBJECT_SELF, "SFNames_301", "Rage 5"); // Rage 5
    SetLocalString(OBJECT_SELF, "SFNames_302", "Smoke Claw"); // Smoke Claw
    SetLocalString(OBJECT_SELF, "SFNames_303", "Summon Slaad"); // Summon Slaad
    SetLocalString(OBJECT_SELF, "SFNames_304", "Summon Tanarri"); // Summon Tanarri
    SetLocalString(OBJECT_SELF, "SFNames_305", "Trumpet Blast"); // Trumpet Blast
    SetLocalString(OBJECT_SELF, "SFNames_306", "Tyrant Fog Mist"); // Tyrant Fog Mist
    SetLocalString(OBJECT_SELF, "SFNames_307", "BARBARIAN RAGE"); // BARBARIAN RAGE
    SetLocalString(OBJECT_SELF, "SFNames_308", "Turn Undead"); // Turn Undead
    SetLocalString(OBJECT_SELF, "SFNames_309", "Wholeness of Body"); // Wholeness of Body
    SetLocalString(OBJECT_SELF, "SFNames_31", "Cure Critical Wounds"); // Cure Critical Wounds
    SetLocalString(OBJECT_SELF, "SFNames_310", "Quivering Palm"); // Quivering Palm
    SetLocalString(OBJECT_SELF, "SFNames_311", "Empty Body"); // Empty Body
    SetLocalString(OBJECT_SELF, "SFNames_312", "Detect Evil"); // Detect Evil
    SetLocalString(OBJECT_SELF, "SFNames_313", "Lay On Hands"); // Lay On Hands
    SetLocalString(OBJECT_SELF, "SFNames_314", "Aura Of Courage"); // Aura Of Courage
    SetLocalString(OBJECT_SELF, "SFNames_315", "Smite Evil"); // Smite Evil
    SetLocalString(OBJECT_SELF, "SFNames_316", "Remove Disease"); // Remove Disease
    SetLocalString(OBJECT_SELF, "SFNames_317", "Summon Animal Companion"); // Summon Animal Companion
    SetLocalString(OBJECT_SELF, "SFNames_318", "Summon Familiar"); // Summon Familiar
    SetLocalString(OBJECT_SELF, "SFNames_319", "Elemental Shape"); // Elemental Shape
    SetLocalString(OBJECT_SELF, "SFNames_32", "Cure Light Wounds"); // Cure Light Wounds
    SetLocalString(OBJECT_SELF, "SFNames_320", "Wild Shape"); // Wild Shape
    SetLocalString(OBJECT_SELF, "SFNames_321", "PROTECTION FROM ALIGNMENT"); // PROTECTION FROM ALIGNMENT
    SetLocalString(OBJECT_SELF, "SFNames_322", "Magic Circle against Alignment"); // Magic Circle against Alignment
    SetLocalString(OBJECT_SELF, "SFNames_323", "Aura versus Alignment"); // Aura versus Alignment
    SetLocalString(OBJECT_SELF, "SFNames_324", "SHADES Summon Shadow"); // SHADES Summon Shadow
    SetLocalString(OBJECT_SELF, "SFNames_325", "DELETED PRO Cold"); // DELETED PRO Cold
    SetLocalString(OBJECT_SELF, "SFNames_326", "DELETED PRO Fire"); // DELETED PRO Fire
    SetLocalString(OBJECT_SELF, "SFNames_327", "DELETED PRO Acid"); // DELETED PRO Acid
    SetLocalString(OBJECT_SELF, "SFNames_328", "DELETED PRO Sonic"); // DELETED PRO Sonic
    SetLocalString(OBJECT_SELF, "SFNames_329", "DELETED PRO Elec"); // DELETED PRO Elec
    SetLocalString(OBJECT_SELF, "SFNames_33", "Cure Minor Wounds"); // Cure Minor Wounds
    SetLocalString(OBJECT_SELF, "SFNames_330", "DELETED END Cold"); // DELETED END Cold
    SetLocalString(OBJECT_SELF, "SFNames_331", "DELETED END Fire"); // DELETED END Fire
    SetLocalString(OBJECT_SELF, "SFNames_332", "DELETED END Acid"); // DELETED END Acid
    SetLocalString(OBJECT_SELF, "SFNames_333", "DELETED END Sonic"); // DELETED END Sonic
    SetLocalString(OBJECT_SELF, "SFNames_334", "DELETED END Elec"); // DELETED END Elec
    SetLocalString(OBJECT_SELF, "SFNames_335", "DELETED RES Cold"); // DELETED RES Cold
    SetLocalString(OBJECT_SELF, "SFNames_336", "DELETED RES Fire"); // DELETED RES Fire
    SetLocalString(OBJECT_SELF, "SFNames_337", "DELETED RES Acid"); // DELETED RES Acid
    SetLocalString(OBJECT_SELF, "SFNames_338", "DELETED RES Sonic"); // DELETED RES Sonic
    SetLocalString(OBJECT_SELF, "SFNames_339", "DELETED RES Elec"); // DELETED RES Elec
    SetLocalString(OBJECT_SELF, "SFNames_34", "Cure Moderate Wounds"); // Cure Moderate Wounds
    SetLocalString(OBJECT_SELF, "SFNames_340", "SHADES Cone of Cold"); // SHADES Cone of Cold
    SetLocalString(OBJECT_SELF, "SFNames_341", "SHADES Fireball"); // SHADES Fireball
    SetLocalString(OBJECT_SELF, "SFNames_342", "SHADES Stoneskin"); // SHADES Stoneskin
    SetLocalString(OBJECT_SELF, "SFNames_343", "SHADES Wall of Fire"); // SHADES Wall of Fire
    SetLocalString(OBJECT_SELF, "SFNames_344", "SHADOW CON Summon Shadow"); // SHADOW CON Summon Shadow
    SetLocalString(OBJECT_SELF, "SFNames_345", "SHADOW CON Darkness"); // SHADOW CON Darkness
    SetLocalString(OBJECT_SELF, "SFNames_346", "SHADOW CON Inivsibility"); // SHADOW CON Inivsibility
    SetLocalString(OBJECT_SELF, "SFNames_347", "SHADOW CON Mage Armor"); // SHADOW CON Mage Armor
    SetLocalString(OBJECT_SELF, "SFNames_348", "SHADOW CON Magic Missile"); // SHADOW CON Magic Missile
    SetLocalString(OBJECT_SELF, "SFNames_349", "GR SHADOW CON Summon Shadow"); // GR SHADOW CON Summon Shadow
    SetLocalString(OBJECT_SELF, "SFNames_35", "Cure Serious Wounds"); // Cure Serious Wounds
    SetLocalString(OBJECT_SELF, "SFNames_350", "GR SHADOW CON Acid Arrow"); // GR SHADOW CON Acid Arrow
    SetLocalString(OBJECT_SELF, "SFNames_351", "GR SHADOW CON Ghostly Visage"); // GR SHADOW CON Ghostly Visage
    SetLocalString(OBJECT_SELF, "SFNames_352", "GR SHADOW CON Web"); // GR SHADOW CON Web
    SetLocalString(OBJECT_SELF, "SFNames_353", "GR SHADOW CON Minor Globe"); // GR SHADOW CON Minor Globe
    SetLocalString(OBJECT_SELF, "SFNames_354", "Eagle Splendor"); // Eagle Splendor
    SetLocalString(OBJECT_SELF, "SFNames_355", "Owls Wisdom"); // Owls Wisdom
    SetLocalString(OBJECT_SELF, "SFNames_356", "Foxs Cunning"); // Foxs Cunning
    SetLocalString(OBJECT_SELF, "SFNames_357", "Greater Eagle Splendor"); // Greater Eagle Splendor
    SetLocalString(OBJECT_SELF, "SFNames_358", "Greater Owls Wisdom"); // Greater Owls Wisdom
    SetLocalString(OBJECT_SELF, "SFNames_359", "Greater Foxs Cunning"); // Greater Foxs Cunning
    SetLocalString(OBJECT_SELF, "SFNames_36", "Darkness"); // Darkness
    SetLocalString(OBJECT_SELF, "SFNames_360", "Greater Bulls Strength"); // Greater Bulls Strength
    SetLocalString(OBJECT_SELF, "SFNames_361", "Greater Cats Grace"); // Greater Cats Grace
    SetLocalString(OBJECT_SELF, "SFNames_362", "Greater Endurance"); // Greater Endurance
    SetLocalString(OBJECT_SELF, "SFNames_363", "Awaken"); // Awaken
    SetLocalString(OBJECT_SELF, "SFNames_364", "Creeping Doom"); // Creeping Doom
    SetLocalString(OBJECT_SELF, "SFNames_365", "Ultravision"); // Ultravision
    SetLocalString(OBJECT_SELF, "SFNames_366", "Destruction"); // Destruction
    SetLocalString(OBJECT_SELF, "SFNames_367", "Horrid Wilting"); // Horrid Wilting
    SetLocalString(OBJECT_SELF, "SFNames_368", "Ice Storm"); // Ice Storm
    SetLocalString(OBJECT_SELF, "SFNames_369", "Energy Buffer"); // Energy Buffer
    SetLocalString(OBJECT_SELF, "SFNames_37", "Daze"); // Daze
    SetLocalString(OBJECT_SELF, "SFNames_370", "Negative Energy Burst"); // Negative Energy Burst
    SetLocalString(OBJECT_SELF, "SFNames_371", "Negative Energy Ray"); // Negative Energy Ray
    SetLocalString(OBJECT_SELF, "SFNames_372", "Aura of Vitality"); // Aura of Vitality
    SetLocalString(OBJECT_SELF, "SFNames_373", "War Cry"); // War Cry
    SetLocalString(OBJECT_SELF, "SFNames_374", "Regenerate"); // Regenerate
    SetLocalString(OBJECT_SELF, "SFNames_375", "Evards Black Tentacles"); // Evards Black Tentacles
    SetLocalString(OBJECT_SELF, "SFNames_376", "Legend Lore"); // Legend Lore
    SetLocalString(OBJECT_SELF, "SFNames_377", "Find Traps"); // Find Traps
    SetLocalString(OBJECT_SELF, "SFNames_378", "Summon Mephit"); // Summon Mephit
    SetLocalString(OBJECT_SELF, "SFNames_379", "Summon Celestial"); // Summon Celestial
    SetLocalString(OBJECT_SELF, "SFNames_38", "Death Ward"); // Death Ward
    SetLocalString(OBJECT_SELF, "SFNames_380", "Battle Mastery Spell"); // Battle Mastery Spell
    SetLocalString(OBJECT_SELF, "SFNames_381", "Divine Strength"); // Divine Strength
    SetLocalString(OBJECT_SELF, "SFNames_382", "Divine Protection"); // Divine Protection
    SetLocalString(OBJECT_SELF, "SFNames_383", "Negative Plane Avatar"); // Negative Plane Avatar
    SetLocalString(OBJECT_SELF, "SFNames_384", "Divine Trickery"); // Divine Trickery
    SetLocalString(OBJECT_SELF, "SFNames_385", "Rogues Cunning"); // Rogues Cunning
    SetLocalString(OBJECT_SELF, "SFNames_386", "ACTIVATE ITEM"); // ACTIVATE ITEM
    SetLocalString(OBJECT_SELF, "SFNames_387", "Polymorph SwordSpider"); // Polymorph SwordSpider
    SetLocalString(OBJECT_SELF, "SFNames_388", "Polymorph Ogre"); // Polymorph Ogre
    SetLocalString(OBJECT_SELF, "SFNames_389", "Polymorph UMBER HULK"); // Polymorph UMBER HULK
    SetLocalString(OBJECT_SELF, "SFNames_39", "Delayed Blast Fireball"); // Delayed Blast Fireball
    SetLocalString(OBJECT_SELF, "SFNames_390", "Polymorph Satyr"); // Polymorph Satyr
    SetLocalString(OBJECT_SELF, "SFNames_391", "Polymorph Ooze"); // Polymorph Ooze
    SetLocalString(OBJECT_SELF, "SFNames_392", "Shapechange RED DRAGON"); // Shapechange RED DRAGON
    SetLocalString(OBJECT_SELF, "SFNames_393", "Shapechange FIRE GIANT"); // Shapechange FIRE GIANT
    SetLocalString(OBJECT_SELF, "SFNames_394", "Shapechange BALOR"); // Shapechange BALOR
    SetLocalString(OBJECT_SELF, "SFNames_395", "Shapechange DEATH SLAAD"); // Shapechange DEATH SLAAD
    SetLocalString(OBJECT_SELF, "SFNames_396", "Shapechange IRON GOLEM"); // Shapechange IRON GOLEM
    SetLocalString(OBJECT_SELF, "SFNames_397", "Elemental Shape FIRE"); // Elemental Shape FIRE
    SetLocalString(OBJECT_SELF, "SFNames_398", "Elemental Shape WATER"); // Elemental Shape WATER
    SetLocalString(OBJECT_SELF, "SFNames_399", "Elemental Shape EARTH"); // Elemental Shape EARTH
    SetLocalString(OBJECT_SELF, "SFNames_4", "Bestow Curse"); // Bestow Curse
    SetLocalString(OBJECT_SELF, "SFNames_40", "Dismissal"); // Dismissal
    SetLocalString(OBJECT_SELF, "SFNames_400", "Elemental Shape AIR"); // Elemental Shape AIR
    SetLocalString(OBJECT_SELF, "SFNames_401", "Wild Shape BROWN BEAR"); // Wild Shape BROWN BEAR
    SetLocalString(OBJECT_SELF, "SFNames_402", "Wild Shape PANTHER"); // Wild Shape PANTHER
    SetLocalString(OBJECT_SELF, "SFNames_403", "Wild Shape WOLF"); // Wild Shape WOLF
    SetLocalString(OBJECT_SELF, "SFNames_404", "Wild Shape BOAR"); // Wild Shape BOAR
    SetLocalString(OBJECT_SELF, "SFNames_405", "Wild Shape BADGER"); // Wild Shape BADGER
    SetLocalString(OBJECT_SELF, "SFNames_406", "Special Alcohol Beer"); // Special Alcohol Beer
    SetLocalString(OBJECT_SELF, "SFNames_407", "Special Alcohol Wine"); // Special Alcohol Wine
    SetLocalString(OBJECT_SELF, "SFNames_408", "Special Alcohol Spirits"); // Special Alcohol Spirits
    SetLocalString(OBJECT_SELF, "SFNames_409", "Special Herb Belladonna"); // Special Herb Belladonna
    SetLocalString(OBJECT_SELF, "SFNames_41", "Dispel Magic"); // Dispel Magic
    SetLocalString(OBJECT_SELF, "SFNames_410", "Special Herb Garlic"); // Special Herb Garlic
    SetLocalString(OBJECT_SELF, "SFNames_411", "Bards Song"); // Bards Song
    SetLocalString(OBJECT_SELF, "SFNames_412", "Aura Fear Dragon"); // Aura Fear Dragon
    SetLocalString(OBJECT_SELF, "SFNames_413", "ACTIVATE ITEM SELF"); // ACTIVATE ITEM SELF
    SetLocalString(OBJECT_SELF, "SFNames_414", "Divine Favor"); // Divine Favor
    SetLocalString(OBJECT_SELF, "SFNames_415", "True Strike"); // True Strike
    SetLocalString(OBJECT_SELF, "SFNames_416", "Flare"); // Flare
    SetLocalString(OBJECT_SELF, "SFNames_417", "Shield"); // Shield
    SetLocalString(OBJECT_SELF, "SFNames_418", "Entropic Shield"); // Entropic Shield
    SetLocalString(OBJECT_SELF, "SFNames_419", "Continual Flame"); // Continual Flame
    SetLocalString(OBJECT_SELF, "SFNames_42", "Divine Power"); // Divine Power
    SetLocalString(OBJECT_SELF, "SFNames_420", "One With The Land"); // One With The Land
    SetLocalString(OBJECT_SELF, "SFNames_421", "Camoflage"); // Camoflage
    SetLocalString(OBJECT_SELF, "SFNames_422", "Blood Frenzy"); // Blood Frenzy
    SetLocalString(OBJECT_SELF, "SFNames_423", "Bombardment"); // Bombardment
    SetLocalString(OBJECT_SELF, "SFNames_424", "Acid Splash"); // Acid Splash
    SetLocalString(OBJECT_SELF, "SFNames_425", "Quillfire"); // Quillfire
    SetLocalString(OBJECT_SELF, "SFNames_426", "Earthquake"); // Earthquake
    SetLocalString(OBJECT_SELF, "SFNames_427", "Sunburst"); // Sunburst
    SetLocalString(OBJECT_SELF, "SFNames_428", "ACTIVATE ITEM SELF2"); // ACTIVATE ITEM SELF2
    SetLocalString(OBJECT_SELF, "SFNames_429", "AuraOfGlory"); // AuraOfGlory
    SetLocalString(OBJECT_SELF, "SFNames_43", "Dominate Animal"); // Dominate Animal
    SetLocalString(OBJECT_SELF, "SFNames_430", "Banishment"); // Banishment
    SetLocalString(OBJECT_SELF, "SFNames_431", "Inflict Minor Wounds"); // Inflict Minor Wounds
    SetLocalString(OBJECT_SELF, "SFNames_432", "Inflict Light Wounds"); // Inflict Light Wounds
    SetLocalString(OBJECT_SELF, "SFNames_433", "Inflict Moderate Wounds"); // Inflict Moderate Wounds
    SetLocalString(OBJECT_SELF, "SFNames_434", "Inflict Serious Wounds"); // Inflict Serious Wounds
    SetLocalString(OBJECT_SELF, "SFNames_435", "Inflict Critical Wounds"); // Inflict Critical Wounds
    SetLocalString(OBJECT_SELF, "SFNames_436", "BalagarnsIronHorn"); // BalagarnsIronHorn
    SetLocalString(OBJECT_SELF, "SFNames_437", "Drown"); // Drown
    SetLocalString(OBJECT_SELF, "SFNames_438", "Owls Insight"); // Owls Insight
    SetLocalString(OBJECT_SELF, "SFNames_439", "Electric Jolt"); // Electric Jolt
    SetLocalString(OBJECT_SELF, "SFNames_44", "Dominate Monster"); // Dominate Monster
    SetLocalString(OBJECT_SELF, "SFNames_440", "Firebrand"); // Firebrand
    SetLocalString(OBJECT_SELF, "SFNames_441", "Wounding Whispers"); // Wounding Whispers
    SetLocalString(OBJECT_SELF, "SFNames_442", "Amplify"); // Amplify
    SetLocalString(OBJECT_SELF, "SFNames_443", "Etherealness"); // Etherealness
    SetLocalString(OBJECT_SELF, "SFNames_444", "Undeaths Eternal Foe"); // Undeaths Eternal Foe
    SetLocalString(OBJECT_SELF, "SFNames_445", "Dirge"); // Dirge
    SetLocalString(OBJECT_SELF, "SFNames_446", "Inferno"); // Inferno
    SetLocalString(OBJECT_SELF, "SFNames_447", "Isaacs Lesser Missile Storm"); // Isaacs Lesser Missile Storm
    SetLocalString(OBJECT_SELF, "SFNames_448", "Isaacs Greater Missile Storm"); // Isaacs Greater Missile Storm
    SetLocalString(OBJECT_SELF, "SFNames_449", "Bane"); // Bane
    SetLocalString(OBJECT_SELF, "SFNames_45", "Dominate Person"); // Dominate Person
    SetLocalString(OBJECT_SELF, "SFNames_450", "Shield of Faith"); // Shield of Faith
    SetLocalString(OBJECT_SELF, "SFNames_451", "Planar Ally"); // Planar Ally
    SetLocalString(OBJECT_SELF, "SFNames_452", "Magic Fang"); // Magic Fang
    SetLocalString(OBJECT_SELF, "SFNames_453", "Greater Magic Fang"); // Greater Magic Fang
    SetLocalString(OBJECT_SELF, "SFNames_454", "Spike Growth"); // Spike Growth
    SetLocalString(OBJECT_SELF, "SFNames_455", "Mass Camoflage"); // Mass Camoflage
    SetLocalString(OBJECT_SELF, "SFNames_456", "Expeditious Retreat"); // Expeditious Retreat
    SetLocalString(OBJECT_SELF, "SFNames_457", "Tashas Hideous Laughter"); // Tashas Hideous Laughter
    SetLocalString(OBJECT_SELF, "SFNames_458", "Displacement"); // Displacement
    SetLocalString(OBJECT_SELF, "SFNames_459", "Bigbys Interposing Hand"); // Bigbys Interposing Hand
    SetLocalString(OBJECT_SELF, "SFNames_46", "Doom"); // Doom
    SetLocalString(OBJECT_SELF, "SFNames_460", "Bigbys Forceful Hand"); // Bigbys Forceful Hand
    SetLocalString(OBJECT_SELF, "SFNames_461", "Bigbys Grasping Hand"); // Bigbys Grasping Hand
    SetLocalString(OBJECT_SELF, "SFNames_462", "Bigbys Clenched Fist"); // Bigbys Clenched Fist
    SetLocalString(OBJECT_SELF, "SFNames_463", "Bigbys Crushing Hand"); // Bigbys Crushing Hand
    SetLocalString(OBJECT_SELF, "SFNames_464", "Grenade Fire"); // Grenade Fire
    SetLocalString(OBJECT_SELF, "SFNames_465", "Grenade Tangle"); // Grenade Tangle
    SetLocalString(OBJECT_SELF, "SFNames_466", "Grenade Holy"); // Grenade Holy
    SetLocalString(OBJECT_SELF, "SFNames_467", "Grenade Choking"); // Grenade Choking
    SetLocalString(OBJECT_SELF, "SFNames_468", "Grenade Thunderstone"); // Grenade Thunderstone
    SetLocalString(OBJECT_SELF, "SFNames_469", "Grenade Acid"); // Grenade Acid
    SetLocalString(OBJECT_SELF, "SFNames_47", "Elemental Shield"); // Elemental Shield
    SetLocalString(OBJECT_SELF, "SFNames_470", "Grenade Chicken"); // Grenade Chicken
    SetLocalString(OBJECT_SELF, "SFNames_471", "Grenade Caltrops"); // Grenade Caltrops
    SetLocalString(OBJECT_SELF, "SFNames_472", "ACTIVATE ITEM PORTAL"); // ACTIVATE ITEM PORTAL
    SetLocalString(OBJECT_SELF, "SFNames_473", "Divine Might"); // Divine Might
    SetLocalString(OBJECT_SELF, "SFNames_474", "Divine Shield"); // Divine Shield
    SetLocalString(OBJECT_SELF, "SFNames_475", "SHADOW DAZE"); // SHADOW DAZE
    SetLocalString(OBJECT_SELF, "SFNames_476", "SUMMON SHADOW"); // SUMMON SHADOW
    SetLocalString(OBJECT_SELF, "SFNames_477", "SHADOW EVADE"); // SHADOW EVADE
    SetLocalString(OBJECT_SELF, "SFNames_478", "TYMORAS SMILE"); // TYMORAS SMILE
    SetLocalString(OBJECT_SELF, "SFNames_479", "CRAFT HARPER ITEM"); // CRAFT HARPER ITEM
    SetLocalString(OBJECT_SELF, "SFNames_48", "Elemental Swarm"); // Elemental Swarm
    SetLocalString(OBJECT_SELF, "SFNames_480", "Sleep"); // Sleep
    SetLocalString(OBJECT_SELF, "SFNames_481", "Cats Grace"); // Cats Grace
    SetLocalString(OBJECT_SELF, "SFNames_482", "Eagle Splendor"); // Eagle Splendor
    SetLocalString(OBJECT_SELF, "SFNames_483", "Invisibility"); // Invisibility
    SetLocalString(OBJECT_SELF, "SFNames_485", "Flesh to stone"); // Flesh to stone
    SetLocalString(OBJECT_SELF, "SFNames_486", "Stone to flesh"); // Stone to flesh
    SetLocalString(OBJECT_SELF, "SFNames_487", "Trap Arrow"); // Trap Arrow
    SetLocalString(OBJECT_SELF, "SFNames_488", "Trap Bolt"); // Trap Bolt
    SetLocalString(OBJECT_SELF, "SFNames_49", "Endurance"); // Endurance
    SetLocalString(OBJECT_SELF, "SFNames_493", "Trap Dart"); // Trap Dart
    SetLocalString(OBJECT_SELF, "SFNames_494", "Trap Shuriken"); // Trap Shuriken
    SetLocalString(OBJECT_SELF, "SFNames_495", "Breath Petrify"); // Breath Petrify
    SetLocalString(OBJECT_SELF, "SFNames_496", "Touch Petrify"); // Touch Petrify
    SetLocalString(OBJECT_SELF, "SFNames_497", "Gaze Petrify"); // Gaze Petrify
    SetLocalString(OBJECT_SELF, "SFNames_498", "Manticore Spikes"); // Manticore Spikes
    SetLocalString(OBJECT_SELF, "SFNames_499", "RodOfWonder"); // RodOfWonder
    SetLocalString(OBJECT_SELF, "SFNames_5", "Blade Barrier"); // Blade Barrier
    SetLocalString(OBJECT_SELF, "SFNames_50", "Endure Elements"); // Endure Elements
    SetLocalString(OBJECT_SELF, "SFNames_500", "DeckOfManyThings"); // DeckOfManyThings
    SetLocalString(OBJECT_SELF, "SFNames_502", "ElementalSummoningItem"); // ElementalSummoningItem
    SetLocalString(OBJECT_SELF, "SFNames_503", "DeckAvatar"); // DeckAvatar
    SetLocalString(OBJECT_SELF, "SFNames_504", "Gem Spray"); // Gem Spray
    SetLocalString(OBJECT_SELF, "SFNames_505", "Butterfly Spray"); // Butterfly Spray
    SetLocalString(OBJECT_SELF, "SFNames_507", "PowerStone"); // PowerStone
    SetLocalString(OBJECT_SELF, "SFNames_508", "Spellstaff"); // Spellstaff
    SetLocalString(OBJECT_SELF, "SFNames_509", "Charger"); // Charger
    SetLocalString(OBJECT_SELF, "SFNames_51", "Energy Drain"); // Energy Drain
    SetLocalString(OBJECT_SELF, "SFNames_510", "Decharger"); // Decharger
    SetLocalString(OBJECT_SELF, "SFNames_511", "Kobold Jump"); // Kobold Jump
    SetLocalString(OBJECT_SELF, "SFNames_512", "Crumble"); // Crumble
    SetLocalString(OBJECT_SELF, "SFNames_513", "Infestation of Maggots"); // Infestation of Maggots
    SetLocalString(OBJECT_SELF, "SFNames_514", "Healing Sting"); // Healing Sting
    SetLocalString(OBJECT_SELF, "SFNames_515", "Great Thunderclap"); // Great Thunderclap
    SetLocalString(OBJECT_SELF, "SFNames_516", "Ball Lightning"); // Ball Lightning
    SetLocalString(OBJECT_SELF, "SFNames_517", "Battletide"); // Battletide
    SetLocalString(OBJECT_SELF, "SFNames_518", "Combust"); // Combust
    SetLocalString(OBJECT_SELF, "SFNames_519", "Death Armor"); // Death Armor
    SetLocalString(OBJECT_SELF, "SFNames_52", "Enervation"); // Enervation
    SetLocalString(OBJECT_SELF, "SFNames_520", "Gedlees Electric Loop"); // Gedlees Electric Loop
    SetLocalString(OBJECT_SELF, "SFNames_521", "Horizikauls Boom"); // Horizikauls Boom
    SetLocalString(OBJECT_SELF, "SFNames_522", "Ironguts"); // Ironguts
    SetLocalString(OBJECT_SELF, "SFNames_523", "Mestils Acid Breath"); // Mestils Acid Breath
    SetLocalString(OBJECT_SELF, "SFNames_524", "Mestils Acid Sheath"); // Mestils Acid Sheath
    SetLocalString(OBJECT_SELF, "SFNames_525", "Monstrous Regeneration"); // Monstrous Regeneration
    SetLocalString(OBJECT_SELF, "SFNames_526", "Scintillating Sphere"); // Scintillating Sphere
    SetLocalString(OBJECT_SELF, "SFNames_527", "Stone Bones"); // Stone Bones
    SetLocalString(OBJECT_SELF, "SFNames_528", "Undeath to Death"); // Undeath to Death
    SetLocalString(OBJECT_SELF, "SFNames_529", "Vine Mine"); // Vine Mine
    SetLocalString(OBJECT_SELF, "SFNames_53", "Entangle"); // Entangle
    SetLocalString(OBJECT_SELF, "SFNames_530", "Vine Mine Entangle"); // Vine Mine Entangle
    SetLocalString(OBJECT_SELF, "SFNames_531", "Vine Mine Hamper Movement"); // Vine Mine Hamper Movement
    SetLocalString(OBJECT_SELF, "SFNames_532", "Vine Mine Camouflage"); // Vine Mine Camouflage
    SetLocalString(OBJECT_SELF, "SFNames_533", "Black Blade of Disaster"); // Black Blade of Disaster
    SetLocalString(OBJECT_SELF, "SFNames_534", "Shelgarns Persistent Blade"); // Shelgarns Persistent Blade
    SetLocalString(OBJECT_SELF, "SFNames_535", "Blade Thirst"); // Blade Thirst
    SetLocalString(OBJECT_SELF, "SFNames_536", "Deafening Clang"); // Deafening Clang
    SetLocalString(OBJECT_SELF, "SFNames_537", "Bless Weapon"); // Bless Weapon
    SetLocalString(OBJECT_SELF, "SFNames_538", "Holy Sword"); // Holy Sword
    SetLocalString(OBJECT_SELF, "SFNames_539", "Keen Edge"); // Keen Edge
    SetLocalString(OBJECT_SELF, "SFNames_54", "Fear"); // Fear
    SetLocalString(OBJECT_SELF, "SFNames_541", "Blackstaff"); // Blackstaff
    SetLocalString(OBJECT_SELF, "SFNames_542", "Flame Weapon"); // Flame Weapon
    SetLocalString(OBJECT_SELF, "SFNames_543", "Ice Dagger"); // Ice Dagger
    SetLocalString(OBJECT_SELF, "SFNames_544", "Magic Weapon"); // Magic Weapon
    SetLocalString(OBJECT_SELF, "SFNames_545", "Greater Magic Weapon"); // Greater Magic Weapon
    SetLocalString(OBJECT_SELF, "SFNames_546", "Magic Vestment"); // Magic Vestment
    SetLocalString(OBJECT_SELF, "SFNames_547", "Stonehold"); // Stonehold
    SetLocalString(OBJECT_SELF, "SFNames_548", "Darkfire"); // Darkfire
    SetLocalString(OBJECT_SELF, "SFNames_549", "Glyph of Warding"); // Glyph of Warding
    SetLocalString(OBJECT_SELF, "SFNames_55", "Feeblemind"); // Feeblemind
    SetLocalString(OBJECT_SELF, "SFNames_551", "MONSTER MindBlast"); // MONSTER MindBlast
    SetLocalString(OBJECT_SELF, "SFNames_552", "MONSTER CharmMonster"); // MONSTER CharmMonster
    SetLocalString(OBJECT_SELF, "SFNames_553", "Goblin Ballista Fireball"); // Goblin Ballista Fireball
    SetLocalString(OBJECT_SELF, "SFNames_554", "Ioun Stone Dusty Rose"); // Ioun Stone Dusty Rose
    SetLocalString(OBJECT_SELF, "SFNames_555", "Ioun Stone Pale Blue"); // Ioun Stone Pale Blue
    SetLocalString(OBJECT_SELF, "SFNames_556", "Ioun Stone Scarlet Blue"); // Ioun Stone Scarlet Blue
    SetLocalString(OBJECT_SELF, "SFNames_557", "Ioun Stone Blue"); // Ioun Stone Blue
    SetLocalString(OBJECT_SELF, "SFNames_558", "Ioun Stone Deep Red"); // Ioun Stone Deep Red
    SetLocalString(OBJECT_SELF, "SFNames_559", "Ioun Stone Pink"); // Ioun Stone Pink
    SetLocalString(OBJECT_SELF, "SFNames_56", "Finger of Death"); // Finger of Death
    SetLocalString(OBJECT_SELF, "SFNames_560", "Ioun Stone Pink Green"); // Ioun Stone Pink Green
    SetLocalString(OBJECT_SELF, "SFNames_561", "Whirlwind"); // Whirlwind
    SetLocalString(OBJECT_SELF, "SFNames_562", "AuraOfGlory X2"); // AuraOfGlory X2
    SetLocalString(OBJECT_SELF, "SFNames_563", "Haste Slow X2"); // Haste Slow X2
    SetLocalString(OBJECT_SELF, "SFNames_564", "Summon Shadow X2"); // Summon Shadow X2
    SetLocalString(OBJECT_SELF, "SFNames_565", "Tide of Battle"); // Tide of Battle
    SetLocalString(OBJECT_SELF, "SFNames_566", "Evil Blight"); // Evil Blight
    SetLocalString(OBJECT_SELF, "SFNames_567", "Cure Critical Wounds Others"); // Cure Critical Wounds Others
    SetLocalString(OBJECT_SELF, "SFNames_568", "Restoration Others"); // Restoration Others
    SetLocalString(OBJECT_SELF, "SFNames_569", "Cloud of Bewilderment"); // Cloud of Bewilderment
    SetLocalString(OBJECT_SELF, "SFNames_57", "Fire Storm"); // Fire Storm
    SetLocalString(OBJECT_SELF, "SFNames_58", "Fireball"); // Fireball
    SetLocalString(OBJECT_SELF, "SFNames_59", "Flame Arrow"); // Flame Arrow
    SetLocalString(OBJECT_SELF, "SFNames_595", "BGSummonLesserFiend"); // BGSummonLesserFiend
    SetLocalString(OBJECT_SELF, "SFNames_596", "BGSummonGreaterFiend"); // BGSummonGreaterFiend
    SetLocalString(OBJECT_SELF, "SFNames_597", "BGNightmare"); // BGNightmare
    SetLocalString(OBJECT_SELF, "SFNames_6", "Bless"); // Bless
    SetLocalString(OBJECT_SELF, "SFNames_60", "Flame Lash"); // Flame Lash
    SetLocalString(OBJECT_SELF, "SFNames_600", "ARImbueArrow"); // ARImbueArrow
    SetLocalString(OBJECT_SELF, "SFNames_601", "ARSeekerArrow"); // ARSeekerArrow
    SetLocalString(OBJECT_SELF, "SFNames_602", "ARSeekerArrow2"); // ARSeekerArrow2
    SetLocalString(OBJECT_SELF, "SFNames_603", "ARHailOfArrows"); // ARHailOfArrows
    SetLocalString(OBJECT_SELF, "SFNames_604", "ARArrowOfDeath"); // ARArrowOfDeath
    SetLocalString(OBJECT_SELF, "SFNames_605", "ASGhostlyVisage"); // ASGhostlyVisage
    SetLocalString(OBJECT_SELF, "SFNames_606", "ASDarkness"); // ASDarkness
    SetLocalString(OBJECT_SELF, "SFNames_607", "ASInvisibility"); // ASInvisibility
    SetLocalString(OBJECT_SELF, "SFNames_608", "ASImprovedInvisibility"); // ASImprovedInvisibility
    SetLocalString(OBJECT_SELF, "SFNames_609", "BGCreateDead"); // BGCreateDead
    SetLocalString(OBJECT_SELF, "SFNames_61", "Flame Strike"); // Flame Strike
    SetLocalString(OBJECT_SELF, "SFNames_610", "BGFiendish"); // BGFiendish
    SetLocalString(OBJECT_SELF, "SFNames_611", "BGInflictSerious"); // BGInflictSerious
    SetLocalString(OBJECT_SELF, "SFNames_612", "BGInflictCritical"); // BGInflictCritical
    SetLocalString(OBJECT_SELF, "SFNames_613", "BK Contagion"); // BK Contagion
    SetLocalString(OBJECT_SELF, "SFNames_614", "BK BullsStrength"); // BK BullsStrength
    SetLocalString(OBJECT_SELF, "SFNames_615", "Twinfists"); // Twinfists
    SetLocalString(OBJECT_SELF, "SFNames_616", "LichLyrics"); // LichLyrics
    SetLocalString(OBJECT_SELF, "SFNames_617", "Iceberry"); // Iceberry
    SetLocalString(OBJECT_SELF, "SFNames_618", "Flameberry"); // Flameberry
    SetLocalString(OBJECT_SELF, "SFNames_619", "PrayerBox"); // PrayerBox
    SetLocalString(OBJECT_SELF, "SFNames_62", "Freedom of Movement"); // Freedom of Movement
    SetLocalString(OBJECT_SELF, "SFNames_620", "Flying Debris"); // Flying Debris
    SetLocalString(OBJECT_SELF, "SFNames_622", "DC Divine Wrath"); // DC Divine Wrath
    SetLocalString(OBJECT_SELF, "SFNames_623", "PM Animate Dead"); // PM Animate Dead
    SetLocalString(OBJECT_SELF, "SFNames_624", "PM Summon Undead"); // PM Summon Undead
    SetLocalString(OBJECT_SELF, "SFNames_625", "PM Undead Graft1"); // PM Undead Graft1
    SetLocalString(OBJECT_SELF, "SFNames_626", "PM Undead Graft2"); // PM Undead Graft2
    SetLocalString(OBJECT_SELF, "SFNames_627", "PM Summon Greater Undead"); // PM Summon Greater Undead
    SetLocalString(OBJECT_SELF, "SFNames_628", "PM Deathless Master Touch"); // PM Deathless Master Touch
    SetLocalString(OBJECT_SELF, "SFNames_63", "Gate"); // Gate
    SetLocalString(OBJECT_SELF, "SFNames_636", "Hellball"); // Hellball
    SetLocalString(OBJECT_SELF, "SFNames_637", "Mummy Dust"); // Mummy Dust
    SetLocalString(OBJECT_SELF, "SFNames_638", "Dragon Knight"); // Dragon Knight
    SetLocalString(OBJECT_SELF, "SFNames_639", "Epic Mage Armor"); // Epic Mage Armor
    SetLocalString(OBJECT_SELF, "SFNames_64", "Ghoul Touch"); // Ghoul Touch
    SetLocalString(OBJECT_SELF, "SFNames_640", "Ruin"); // Ruin
    SetLocalString(OBJECT_SELF, "SFNames_641", "DWDEF Defensive Stance"); // DWDEF Defensive Stance
    SetLocalString(OBJECT_SELF, "SFNames_642", "Mighty Rage"); // Mighty Rage
    SetLocalString(OBJECT_SELF, "SFNames_643", "PlanarTurning"); // PlanarTurning
    SetLocalString(OBJECT_SELF, "SFNames_644", "Curse Song"); // Curse Song
    SetLocalString(OBJECT_SELF, "SFNames_645", "Improved Whirlwind"); // Improved Whirlwind
    SetLocalString(OBJECT_SELF, "SFNames_646", "Greater Wild Shape 1"); // Greater Wild Shape 1
    SetLocalString(OBJECT_SELF, "SFNames_647", "Epic Blinding speed"); // Epic Blinding speed
    SetLocalString(OBJECT_SELF, "SFNames_648", "Dye Armor cloth1"); // Dye Armor cloth1
    SetLocalString(OBJECT_SELF, "SFNames_649", "Dye Armor Cloth2"); // Dye Armor Cloth2
    SetLocalString(OBJECT_SELF, "SFNames_65", "Globe of Invulnerability"); // Globe of Invulnerability
    SetLocalString(OBJECT_SELF, "SFNames_650", "Dye Armor Leather1"); // Dye Armor Leather1
    SetLocalString(OBJECT_SELF, "SFNames_651", "Dye Armor Leather2"); // Dye Armor Leather2
    SetLocalString(OBJECT_SELF, "SFNames_652", "Dye Armor Metal1"); // Dye Armor Metal1
    SetLocalString(OBJECT_SELF, "SFNames_653", "Dye Armor Metal2"); // Dye Armor Metal2
    SetLocalString(OBJECT_SELF, "SFNames_654", "Add Item Property"); // Add Item Property
    SetLocalString(OBJECT_SELF, "SFNames_655", "Poison Weapon"); // Poison Weapon
    SetLocalString(OBJECT_SELF, "SFNames_656", "Craft Weapon"); // Craft Weapon
    SetLocalString(OBJECT_SELF, "SFNames_657", "Craft Armor"); // Craft Armor
    SetLocalString(OBJECT_SELF, "SFNames_658", "Greater Wild Shape Wyrmling Red"); // Greater Wild Shape Wyrmling Red
    SetLocalString(OBJECT_SELF, "SFNames_659", "Greater Wild Shape Wyrmling Blue"); // Greater Wild Shape Wyrmling Blue
    SetLocalString(OBJECT_SELF, "SFNames_66", "Grease"); // Grease
    SetLocalString(OBJECT_SELF, "SFNames_660", "Greater Wild Shape Wyrmling Black"); // Greater Wild Shape Wyrmling Black
    SetLocalString(OBJECT_SELF, "SFNames_661", "Greater Wild Shape Wyrmling White"); // Greater Wild Shape Wyrmling White
    SetLocalString(OBJECT_SELF, "SFNames_662", "Greater Wild Shape Wyrmling Green"); // Greater Wild Shape Wyrmling Green
    SetLocalString(OBJECT_SELF, "SFNames_663", "WyrmlingPCBreathCold"); // WyrmlingPCBreathCold
    SetLocalString(OBJECT_SELF, "SFNames_664", "WyrmlingPCBreathAcid"); // WyrmlingPCBreathAcid
    SetLocalString(OBJECT_SELF, "SFNames_665", "WyrmlingPCBreathFire"); // WyrmlingPCBreathFire
    SetLocalString(OBJECT_SELF, "SFNames_666", "WyrmlingPCBreathGas"); // WyrmlingPCBreathGas
    SetLocalString(OBJECT_SELF, "SFNames_667", "WyrmlingPCBreathLightning"); // WyrmlingPCBreathLightning
    SetLocalString(OBJECT_SELF, "SFNames_668", "ITEM Teleport"); // ITEM Teleport
    SetLocalString(OBJECT_SELF, "SFNames_669", "ITEM Chaos Shield"); // ITEM Chaos Shield
    SetLocalString(OBJECT_SELF, "SFNames_67", "Greater Dispelling"); // Greater Dispelling
    SetLocalString(OBJECT_SELF, "SFNames_670", "Greater Wild Shape Basilisk"); // Greater Wild Shape Basilisk
    SetLocalString(OBJECT_SELF, "SFNames_671", "Greater Wild Shape Beholder"); // Greater Wild Shape Beholder
    SetLocalString(OBJECT_SELF, "SFNames_672", "Greater Wild Shape Harpy"); // Greater Wild Shape Harpy
    SetLocalString(OBJECT_SELF, "SFNames_673", "Greater Wild Shape Drider"); // Greater Wild Shape Drider
    SetLocalString(OBJECT_SELF, "SFNames_674", "Greater Wild Shape Manticore"); // Greater Wild Shape Manticore
    SetLocalString(OBJECT_SELF, "SFNames_675", "Greater Wild Shape 2"); // Greater Wild Shape 2
    SetLocalString(OBJECT_SELF, "SFNames_676", "Greater Wild Shape 3"); // Greater Wild Shape 3
    SetLocalString(OBJECT_SELF, "SFNames_677", "Greater Wild Shape 4"); // Greater Wild Shape 4
    SetLocalString(OBJECT_SELF, "SFNames_678", "Greater Wild Shape Gargoyle"); // Greater Wild Shape Gargoyle
    SetLocalString(OBJECT_SELF, "SFNames_679", "Greater Wild Shape Medusa"); // Greater Wild Shape Medusa
    SetLocalString(OBJECT_SELF, "SFNames_68", "Greater Magic Weapon"); // Greater Magic Weapon
    SetLocalString(OBJECT_SELF, "SFNames_680", "Greater Wild Shape Minotaur"); // Greater Wild Shape Minotaur
    SetLocalString(OBJECT_SELF, "SFNames_681", "Humanoid Shape"); // Humanoid Shape
    SetLocalString(OBJECT_SELF, "SFNames_682", "Humanoid Shape Drow"); // Humanoid Shape Drow
    SetLocalString(OBJECT_SELF, "SFNames_683", "Humanoid Shape Lizardfolk"); // Humanoid Shape Lizardfolk
    SetLocalString(OBJECT_SELF, "SFNames_684", "Humanoid Shape KoboldAssa"); // Humanoid Shape KoboldAssa
    SetLocalString(OBJECT_SELF, "SFNames_685", "Undead shape"); // Undead shape
    SetLocalString(OBJECT_SELF, "SFNames_686", "Harpysong"); // Harpysong
    SetLocalString(OBJECT_SELF, "SFNames_687", "GWildShape Stonegaze"); // GWildShape Stonegaze
    SetLocalString(OBJECT_SELF, "SFNames_688", "GWildShape DriderDarkness"); // GWildShape DriderDarkness
    SetLocalString(OBJECT_SELF, "SFNames_689", "SlayRakshasa"); // SlayRakshasa
    SetLocalString(OBJECT_SELF, "SFNames_69", "Greater Planar Binding"); // Greater Planar Binding
    SetLocalString(OBJECT_SELF, "SFNames_690", "RedDragonDiscipleBreath"); // RedDragonDiscipleBreath
    SetLocalString(OBJECT_SELF, "SFNames_691", "Greater Wild Shape Mindflayer"); // Greater Wild Shape Mindflayer
    SetLocalString(OBJECT_SELF, "SFNames_692", "Greater Wild Shape Spikes"); // Greater Wild Shape Spikes
    SetLocalString(OBJECT_SELF, "SFNames_693", "GWildShape Mindblast"); // GWildShape Mindblast
    SetLocalString(OBJECT_SELF, "SFNames_694", "Greater Wild Shape DireTiger"); // Greater Wild Shape DireTiger
    SetLocalString(OBJECT_SELF, "SFNames_695", "Epic Warding"); // Epic Warding
    SetLocalString(OBJECT_SELF, "SFNames_696", "OnHitFireDamage"); // OnHitFireDamage
    SetLocalString(OBJECT_SELF, "SFNames_697", "ACTIVATE ITEM L"); // ACTIVATE ITEM L
    SetLocalString(OBJECT_SELF, "SFNames_698", "Dragon Breath Negative"); // Dragon Breath Negative
    SetLocalString(OBJECT_SELF, "SFNames_7", "Bless Weapon"); // Bless Weapon
    SetLocalString(OBJECT_SELF, "SFNames_70", "Greater Restoration"); // Greater Restoration
    SetLocalString(OBJECT_SELF, "SFNames_700", "ACTIVATE ITEM ONHITSPELLCAST"); // ACTIVATE ITEM ONHITSPELLCAST
    SetLocalString(OBJECT_SELF, "SFNames_701", "Summon Baatezu"); // Summon Baatezu
    SetLocalString(OBJECT_SELF, "SFNames_702", "OnHitPlanarRift"); // OnHitPlanarRift
    SetLocalString(OBJECT_SELF, "SFNames_703", "OnHitDarkfire"); // OnHitDarkfire
    SetLocalString(OBJECT_SELF, "SFNames_704", "Undead Shape risen lord"); // Undead Shape risen lord
    SetLocalString(OBJECT_SELF, "SFNames_705", "Undead Shape Vampire"); // Undead Shape Vampire
    SetLocalString(OBJECT_SELF, "SFNames_706", "Undead Shape Spectre"); // Undead Shape Spectre
    SetLocalString(OBJECT_SELF, "SFNames_707", "Greater Wild Shape Red dragon"); // Greater Wild Shape Red dragon
    SetLocalString(OBJECT_SELF, "SFNames_708", "Greater Wild Shape Blue dragon"); // Greater Wild Shape Blue dragon
    SetLocalString(OBJECT_SELF, "SFNames_709", "Greater Wild Shape Green dragon"); // Greater Wild Shape Green dragon
    SetLocalString(OBJECT_SELF, "SFNames_71", "Greater Shadow Conjuration"); // Greater Shadow Conjuration
    SetLocalString(OBJECT_SELF, "SFNames_710", "EyeballRay0"); // EyeballRay0
    SetLocalString(OBJECT_SELF, "SFNames_711", "EyeballRay1"); // EyeballRay1
    SetLocalString(OBJECT_SELF, "SFNames_712", "EyeballRay2"); // EyeballRay2
    SetLocalString(OBJECT_SELF, "SFNames_713", "Mindflayer Mindblast 10"); // Mindflayer Mindblast 10
    SetLocalString(OBJECT_SELF, "SFNames_715", "Golem Ranged Slam"); // Golem Ranged Slam
    SetLocalString(OBJECT_SELF, "SFNames_716", "SuckBrain"); // SuckBrain
    SetLocalString(OBJECT_SELF, "SFNames_717", "ACTIVATE ITEM SEQUENCER 1"); // ACTIVATE ITEM SEQUENCER 1
    SetLocalString(OBJECT_SELF, "SFNames_718", "ACTIVATE ITEM SEQUENCER 2"); // ACTIVATE ITEM SEQUENCER 2
    SetLocalString(OBJECT_SELF, "SFNames_719", "ACTIVATE ITEM SEQUENCER 3"); // ACTIVATE ITEM SEQUENCER 3
    SetLocalString(OBJECT_SELF, "SFNames_72", "Greater Spell Breach"); // Greater Spell Breach
    SetLocalString(OBJECT_SELF, "SFNames_720", "CLEAR SEQUENCER"); // CLEAR SEQUENCER
    SetLocalString(OBJECT_SELF, "SFNames_721", "OnHitFlamingSkin"); // OnHitFlamingSkin
    SetLocalString(OBJECT_SELF, "SFNames_722", "Mimic Eat"); // Mimic Eat
    SetLocalString(OBJECT_SELF, "SFNames_724", "Etherealness"); // Etherealness
    SetLocalString(OBJECT_SELF, "SFNames_725", "Dragon Shape"); // Dragon Shape
    SetLocalString(OBJECT_SELF, "SFNames_726", "Mimic Eat Enemy"); // Mimic Eat Enemy
    SetLocalString(OBJECT_SELF, "SFNames_727", "Beholder Anti Magic Cone"); // Beholder Anti Magic Cone
    SetLocalString(OBJECT_SELF, "SFNames_729", "Mimic Steal armor"); // Mimic Steal armor
    SetLocalString(OBJECT_SELF, "SFNames_73", "Greater Spell Mantle"); // Greater Spell Mantle
    SetLocalString(OBJECT_SELF, "SFNames_731", "Bebelith Web"); // Bebelith Web
    SetLocalString(OBJECT_SELF, "SFNames_732", "Outsider Shape"); // Outsider Shape
    SetLocalString(OBJECT_SELF, "SFNames_733", "Outsider Shape Azer"); // Outsider Shape Azer
    SetLocalString(OBJECT_SELF, "SFNames_734", "Outsider Shape Rakshasa"); // Outsider Shape Rakshasa
    SetLocalString(OBJECT_SELF, "SFNames_735", "Outsider Shape DeathSlaad"); // Outsider Shape DeathSlaad
    SetLocalString(OBJECT_SELF, "SFNames_736", "Beholder Special Spell AI"); // Beholder Special Spell AI
    SetLocalString(OBJECT_SELF, "SFNames_737", "Construct Shape"); // Construct Shape
    SetLocalString(OBJECT_SELF, "SFNames_738", "Construct Shape StoneGolem"); // Construct Shape StoneGolem
    SetLocalString(OBJECT_SELF, "SFNames_739", "Construct Shape DemonFleshGolem"); // Construct Shape DemonFleshGolem
    SetLocalString(OBJECT_SELF, "SFNames_74", "Greater Stoneskin"); // Greater Stoneskin
    SetLocalString(OBJECT_SELF, "SFNames_740", "Construct Shape IronGolem"); // Construct Shape IronGolem
    SetLocalString(OBJECT_SELF, "SFNames_741", "Psionic Inertial Barrier"); // Psionic Inertial Barrier
    SetLocalString(OBJECT_SELF, "SFNames_742", "Craft Weapon Component"); // Craft Weapon Component
    SetLocalString(OBJECT_SELF, "SFNames_743", "Craft Armor Component"); // Craft Armor Component
    SetLocalString(OBJECT_SELF, "SFNames_744", "Grenade FireBomb"); // Grenade FireBomb
    SetLocalString(OBJECT_SELF, "SFNames_745", "Grenade AcidBomb"); // Grenade AcidBomb
    SetLocalString(OBJECT_SELF, "SFNames_75", "Gust of Wind"); // Gust of Wind
    SetLocalString(OBJECT_SELF, "SFNames_756", "OnHitBebilithAttack"); // OnHitBebilithAttack
    SetLocalString(OBJECT_SELF, "SFNames_757", "ShadowBlend"); // ShadowBlend
    SetLocalString(OBJECT_SELF, "SFNames_758", "OnHitDemilichTouch"); // OnHitDemilichTouch
    SetLocalString(OBJECT_SELF, "SFNames_759", "UndeadSelfHarm"); // UndeadSelfHarm
    SetLocalString(OBJECT_SELF, "SFNames_76", "Hammer of the Gods"); // Hammer of the Gods
    SetLocalString(OBJECT_SELF, "SFNames_760", "OnHitDracolichTouch"); // OnHitDracolichTouch
    SetLocalString(OBJECT_SELF, "SFNames_761", "Aura of Hellfire"); // Aura of Hellfire
    SetLocalString(OBJECT_SELF, "SFNames_762", "Hell Inferno"); // Hell Inferno
    SetLocalString(OBJECT_SELF, "SFNames_763", "Psionic Mass Concussion"); // Psionic Mass Concussion
    SetLocalString(OBJECT_SELF, "SFNames_764", "GlyphOfWardingDefault"); // GlyphOfWardingDefault
    SetLocalString(OBJECT_SELF, "SFNames_767", "Intelligent Weapon Talk"); // Intelligent Weapon Talk
    SetLocalString(OBJECT_SELF, "SFNames_768", "Intelligent Weapon OnHit"); // Intelligent Weapon OnHit
    SetLocalString(OBJECT_SELF, "SFNames_769", "Shadow Attack"); // Shadow Attack
    SetLocalString(OBJECT_SELF, "SFNames_77", "Harm"); // Harm
    SetLocalString(OBJECT_SELF, "SFNames_770", "Slaad Chaos Spittle"); // Slaad Chaos Spittle
    SetLocalString(OBJECT_SELF, "SFNames_771", "Dragon Breath Prismatic"); // Dragon Breath Prismatic
    SetLocalString(OBJECT_SELF, "SFNames_772", "Spiral Fireball"); // Spiral Fireball
    SetLocalString(OBJECT_SELF, "SFNames_773", "Battle Boulder Toss"); // Battle Boulder Toss
    SetLocalString(OBJECT_SELF, "SFNames_774", "Deflecting Force"); // Deflecting Force
    SetLocalString(OBJECT_SELF, "SFNames_775", "Giant hurl rock"); // Giant hurl rock
    SetLocalString(OBJECT_SELF, "SFNames_776", "Beholder Node 1"); // Beholder Node 1
    SetLocalString(OBJECT_SELF, "SFNames_777", "Beholder Node 2"); // Beholder Node 2
    SetLocalString(OBJECT_SELF, "SFNames_778", "Beholder Node 3"); // Beholder Node 3
    SetLocalString(OBJECT_SELF, "SFNames_779", "Beholder Node 4"); // Beholder Node 4
    SetLocalString(OBJECT_SELF, "SFNames_78", "Haste"); // Haste
    SetLocalString(OBJECT_SELF, "SFNames_780", "Beholder Node 5"); // Beholder Node 5
    SetLocalString(OBJECT_SELF, "SFNames_783", "Beholder Node 6"); // Beholder Node 6
    SetLocalString(OBJECT_SELF, "SFNames_784", "Beholder Node 7"); // Beholder Node 7
    SetLocalString(OBJECT_SELF, "SFNames_785", "Beholder Node 8"); // Beholder Node 8
    SetLocalString(OBJECT_SELF, "SFNames_786", "Beholder Node 9"); // Beholder Node 9
    SetLocalString(OBJECT_SELF, "SFNames_787", "Beholder Node 10"); // Beholder Node 10
    SetLocalString(OBJECT_SELF, "SFNames_788", "OnHitParalyze"); // OnHitParalyze
    SetLocalString(OBJECT_SELF, "SFNames_789", "Illithid Mindblast"); // Illithid Mindblast
    SetLocalString(OBJECT_SELF, "SFNames_79", "Heal"); // Heal
    SetLocalString(OBJECT_SELF, "SFNames_790", "OnHitDeafenClang"); // OnHitDeafenClang
    SetLocalString(OBJECT_SELF, "SFNames_791", "OnHitKnockDown"); // OnHitKnockDown
    SetLocalString(OBJECT_SELF, "SFNames_792", "OnHitFreeze"); // OnHitFreeze
    SetLocalString(OBJECT_SELF, "SFNames_793", "Demonic Grappling Hand"); // Demonic Grappling Hand
    SetLocalString(OBJECT_SELF, "SFNames_794", "Ballista Bolt"); // Ballista Bolt
    SetLocalString(OBJECT_SELF, "SFNames_795", "ACTIVATE ITEM T"); // ACTIVATE ITEM T
    SetLocalString(OBJECT_SELF, "SFNames_796", "Dragon Breath Lightning"); // Dragon Breath Lightning
    SetLocalString(OBJECT_SELF, "SFNames_797", "Dragon Breath Fire"); // Dragon Breath Fire
    SetLocalString(OBJECT_SELF, "SFNames_798", "Dragon Breath Gas"); // Dragon Breath Gas
    SetLocalString(OBJECT_SELF, "SFNames_799", "Vampire Invisibility"); // Vampire Invisibility
    SetLocalString(OBJECT_SELF, "SFNames_8", "Blindness and Deafness"); // Blindness and Deafness
    SetLocalString(OBJECT_SELF, "SFNames_80", "Healing Circle"); // Healing Circle
    SetLocalString(OBJECT_SELF, "SFNames_800", "Vampire DominationGaze"); // Vampire DominationGaze
    SetLocalString(OBJECT_SELF, "SFNames_801", "Azer Fire Blast"); // Azer Fire Blast
    SetLocalString(OBJECT_SELF, "SFNames_802", "Shifter Spectre Attack"); // Shifter Spectre Attack
    SetLocalString(OBJECT_SELF, "SFNames_803", "SeaHag EvilEye"); // SeaHag EvilEye
    SetLocalString(OBJECT_SELF, "SFNames_804", "Aura HorrificAppearance"); // Aura HorrificAppearance
    SetLocalString(OBJECT_SELF, "SFNames_805", "Troglodyte Stench"); // Troglodyte Stench
    SetLocalString(OBJECT_SELF, "SFNames_806", "PDK RallyingCry"); // PDK RallyingCry
    SetLocalString(OBJECT_SELF, "SFNames_807", "PDK Shield"); // PDK Shield
    SetLocalString(OBJECT_SELF, "SFNames_808", "PDK Fear"); // PDK Fear
    SetLocalString(OBJECT_SELF, "SFNames_809", "PDK OathOfWrath"); // PDK OathOfWrath
    SetLocalString(OBJECT_SELF, "SFNames_81", "Hold Animal"); // Hold Animal
    SetLocalString(OBJECT_SELF, "SFNames_810", "PDK FinalStand"); // PDK FinalStand
    SetLocalString(OBJECT_SELF, "SFNames_811", "PDK InspireCourage"); // PDK InspireCourage
    SetLocalString(OBJECT_SELF, "SFNames_813", "Horse Mount"); // Horse Mount
    SetLocalString(OBJECT_SELF, "SFNames_814", "Horse Dismount"); // Horse Dismount
    SetLocalString(OBJECT_SELF, "SFNames_815", "Horse Party Mount"); // Horse Party Mount
    SetLocalString(OBJECT_SELF, "SFNames_816", "Horse Party Dismount"); // Horse Party Dismount
    SetLocalString(OBJECT_SELF, "SFNames_817", "Horse Assign Mount"); // Horse Assign Mount
    SetLocalString(OBJECT_SELF, "SFNames_818", "Paladin Summon Mount"); // Paladin Summon Mount
    SetLocalString(OBJECT_SELF, "SFNames_819", "Nightmare Smoke"); // Nightmare Smoke
    SetLocalString(OBJECT_SELF, "SFNames_82", "Hold Monster"); // Hold Monster
    SetLocalString(OBJECT_SELF, "SFNames_820", "DM TOOL 01"); // DM TOOL 01
    SetLocalString(OBJECT_SELF, "SFNames_821", "DM TOOL 02"); // DM TOOL 02
    SetLocalString(OBJECT_SELF, "SFNames_822", "DM TOOL 03"); // DM TOOL 03
    SetLocalString(OBJECT_SELF, "SFNames_823", "DM TOOL 04"); // DM TOOL 04
    SetLocalString(OBJECT_SELF, "SFNames_824", "DM TOOL 05"); // DM TOOL 05
    SetLocalString(OBJECT_SELF, "SFNames_825", "DM TOOL 06"); // DM TOOL 06
    SetLocalString(OBJECT_SELF, "SFNames_826", "DM TOOL 07"); // DM TOOL 07
    SetLocalString(OBJECT_SELF, "SFNames_827", "DM TOOL 08"); // DM TOOL 08
    SetLocalString(OBJECT_SELF, "SFNames_828", "DM TOOL 09"); // DM TOOL 09
    SetLocalString(OBJECT_SELF, "SFNames_829", "DM TOOL 10"); // DM TOOL 10
    SetLocalString(OBJECT_SELF, "SFNames_83", "Hold Person"); // Hold Person
    SetLocalString(OBJECT_SELF, "SFNames_830", "EXAMINE"); // EXAMINE
    SetLocalString(OBJECT_SELF, "SFNames_831", "DEBUFF"); // DEBUFF
    SetLocalString(OBJECT_SELF, "SFNames_832", "PLAYER TOOL 03"); // PLAYER TOOL 03
    SetLocalString(OBJECT_SELF, "SFNames_833", "PLAYER TOOL 04"); // PLAYER TOOL 04
    SetLocalString(OBJECT_SELF, "SFNames_834", "PLAYER TOOL 05"); // PLAYER TOOL 05
    SetLocalString(OBJECT_SELF, "SFNames_835", "PLAYER TOOL 06"); // PLAYER TOOL 06
    SetLocalString(OBJECT_SELF, "SFNames_836", "PLAYER TOOL 07"); // PLAYER TOOL 07
    SetLocalString(OBJECT_SELF, "SFNames_837", "PLAYER TOOL 08"); // PLAYER TOOL 08
    SetLocalString(OBJECT_SELF, "SFNames_838", "PLAYER TOOL 09"); // PLAYER TOOL 09
    SetLocalString(OBJECT_SELF, "SFNames_839", "PLAYER TOOL 10"); // PLAYER TOOL 10
    SetLocalString(OBJECT_SELF, "SFNames_84", "Holy Aura"); // Holy Aura
    SetLocalString(OBJECT_SELF, "SFNames_842", "Smite Infidel"); // Smite Infidel
    SetLocalString(OBJECT_SELF, "SFNames_844", "Plague"); // Plague
    SetLocalString(OBJECT_SELF, "SFNames_845", "Summon Undead Animal"); // Summon Undead Animal
    SetLocalString(OBJECT_SELF, "SFNames_846", "Blightfire"); // Blightfire
    SetLocalString(OBJECT_SELF, "SFNames_848", "Background NatLycan Transform"); // Background NatLycan Transform
    SetLocalString(OBJECT_SELF, "SFNames_85", "Holy Sword"); // Holy Sword
    SetLocalString(OBJECT_SELF, "SFNames_850", "Artificer Assistant"); // Artificer Assistant
    SetLocalString(OBJECT_SELF, "SFNames_851", "Baleful Utterance"); // Baleful Utterance
    SetLocalString(OBJECT_SELF, "SFNames_852", "Beguiling Influence"); // Beguiling Influence
    SetLocalString(OBJECT_SELF, "SFNames_853", "Dark Ones Own Luck"); // Dark Ones Own Luck
    SetLocalString(OBJECT_SELF, "SFNames_854", "Darkness"); // Darkness
    SetLocalString(OBJECT_SELF, "SFNames_855", "Ultravision"); // Ultravision
    SetLocalString(OBJECT_SELF, "SFNames_856", "Entropic Shield"); // Entropic Shield
    SetLocalString(OBJECT_SELF, "SFNames_857", "Leaps And Bounds"); // Leaps And Bounds
    SetLocalString(OBJECT_SELF, "SFNames_858", "See Invisibility"); // See Invisibility
    SetLocalString(OBJECT_SELF, "SFNames_859", "All Seeing Eyes"); // All Seeing Eyes
    SetLocalString(OBJECT_SELF, "SFNames_86", "Identify"); // Identify
    SetLocalString(OBJECT_SELF, "SFNames_861", "Dark Arcana"); // Dark Arcana
    SetLocalString(OBJECT_SELF, "SFNames_862", "Cloak Of Shadows"); // Cloak Of Shadows
    SetLocalString(OBJECT_SELF, "SFNames_863", "Shrouding Transformation"); // Shrouding Transformation
    SetLocalString(OBJECT_SELF, "SFNames_865", "Bestow Curse"); // Bestow Curse
    SetLocalString(OBJECT_SELF, "SFNames_866", "Create Undead"); // Create Undead
    SetLocalString(OBJECT_SELF, "SFNames_867", "Death Armor"); // Death Armor
    SetLocalString(OBJECT_SELF, "SFNames_868", "Dominate Person"); // Dominate Person
    SetLocalString(OBJECT_SELF, "SFNames_869", "Dispel Magic"); // Dispel Magic
    SetLocalString(OBJECT_SELF, "SFNames_87", "Implosion"); // Implosion
    SetLocalString(OBJECT_SELF, "SFNames_870", "Eldritch Ward"); // Eldritch Ward
    SetLocalString(OBJECT_SELF, "SFNames_871", "Endure Elements"); // Endure Elements
    SetLocalString(OBJECT_SELF, "SFNames_872", "Expeditious Retreat"); // Expeditious Retreat
    SetLocalString(OBJECT_SELF, "SFNames_873", "Invisibility"); // Invisibility
    SetLocalString(OBJECT_SELF, "SFNames_875", "Create Greater Undead"); // Create Greater Undead
    SetLocalString(OBJECT_SELF, "SFNames_876", "Evards Black Tentacles"); // Evards Black Tentacles
    SetLocalString(OBJECT_SELF, "SFNames_877", "Greater Dispelling"); // Greater Dispelling
    SetLocalString(OBJECT_SELF, "SFNames_878", "Improved Invisibility"); // Improved Invisibility
    SetLocalString(OBJECT_SELF, "SFNames_879", "Greater Spell Breach"); // Greater Spell Breach
    SetLocalString(OBJECT_SELF, "SFNames_88", "Improved Invisibility"); // Improved Invisibility
    SetLocalString(OBJECT_SELF, "SFNames_881", "Circle of Death"); // Circle of Death
    SetLocalString(OBJECT_SELF, "SFNames_882", "Dominate Monster"); // Dominate Monster
    SetLocalString(OBJECT_SELF, "SFNames_883", "Etherealness"); // Etherealness
    SetLocalString(OBJECT_SELF, "SFNames_884", "Finger of Death"); // Finger of Death
    SetLocalString(OBJECT_SELF, "SFNames_885", "Gate"); // Gate
    SetLocalString(OBJECT_SELF, "SFNames_886", "FiendishPolymorph"); // FiendishPolymorph
    SetLocalString(OBJECT_SELF, "SFNames_89", "Incendiary Cloud"); // Incendiary Cloud
    SetLocalString(OBJECT_SELF, "SFNames_890", "FEAT CALLFIENDS"); // FEAT CALLFIENDS
    SetLocalString(OBJECT_SELF, "SFNames_892", "SummonUndead1"); // SummonUndead1
    SetLocalString(OBJECT_SELF, "SFNames_893", "SummonUndead2"); // SummonUndead2
    SetLocalString(OBJECT_SELF, "SFNames_894", "SummonUndead3"); // SummonUndead3
    SetLocalString(OBJECT_SELF, "SFNames_895", "SummonUndead4"); // SummonUndead4
    SetLocalString(OBJECT_SELF, "SFNames_896", "SummonUndead5"); // SummonUndead5
    SetLocalString(OBJECT_SELF, "SFNames_899", "Eldritch Blast Acid"); // Eldritch Blast Acid
    SetLocalString(OBJECT_SELF, "SFNames_9", "Bulls Strength"); // Bulls Strength
    SetLocalString(OBJECT_SELF, "SFNames_90", "Invisibility"); // Invisibility
    SetLocalString(OBJECT_SELF, "SFNames_900", "Eldritch Blast Cold"); // Eldritch Blast Cold
    SetLocalString(OBJECT_SELF, "SFNames_901", "Eldritch Blast Fire"); // Eldritch Blast Fire
    SetLocalString(OBJECT_SELF, "SFNames_902", "Eldritch Blast Magic"); // Eldritch Blast Magic
    SetLocalString(OBJECT_SELF, "SFNames_903", "Eldritch Blast Negative"); // Eldritch Blast Negative
    SetLocalString(OBJECT_SELF, "SFNames_905", "Eldritch Blast EMP Acid"); // Eldritch Blast EMP Acid
    SetLocalString(OBJECT_SELF, "SFNames_906", "Eldritch Blast EMP Cold"); // Eldritch Blast EMP Cold
    SetLocalString(OBJECT_SELF, "SFNames_907", "Eldritch Blast EMP Fire"); // Eldritch Blast EMP Fire
    SetLocalString(OBJECT_SELF, "SFNames_908", "Eldritch Blast EMP Magic"); // Eldritch Blast EMP Magic
    SetLocalString(OBJECT_SELF, "SFNames_909", "Eldritch Blast EMP Negative"); // Eldritch Blast EMP Negative
    SetLocalString(OBJECT_SELF, "SFNames_91", "Invisibility Purge"); // Invisibility Purge
    SetLocalString(OBJECT_SELF, "SFNames_911", "Spellfire Blast"); // Spellfire Blast
    SetLocalString(OBJECT_SELF, "SFNames_912", "Spellfire Absorb"); // Spellfire Absorb
    SetLocalString(OBJECT_SELF, "SFNames_913", "Spellfire Heal T"); // Spellfire Heal T
    SetLocalString(OBJECT_SELF, "SFNames_914", "Spellfire Destroy"); // Spellfire Destroy
    SetLocalString(OBJECT_SELF, "SFNames_915", "Spellfire Heal R"); // Spellfire Heal R
    SetLocalString(OBJECT_SELF, "SFNames_916", "Spellfire Burst"); // Spellfire Burst
    SetLocalString(OBJECT_SELF, "SFNames_917", "Spellfire Haste"); // Spellfire Haste
    SetLocalString(OBJECT_SELF, "SFNames_918", "Spellfire Crown"); // Spellfire Crown
    SetLocalString(OBJECT_SELF, "SFNames_919", "Spellfire Maelstrom"); // Spellfire Maelstrom
    SetLocalString(OBJECT_SELF, "SFNames_92", "Invisibility Sphere"); // Invisibility Sphere
    SetLocalString(OBJECT_SELF, "SFNames_922", "Wild Shape Mammal"); // Wild Shape Mammal
    SetLocalString(OBJECT_SELF, "SFNames_923", "Wild Shape BROWN BEAR"); // Wild Shape BROWN BEAR
    SetLocalString(OBJECT_SELF, "SFNames_924", "Wild Shape PANTHER"); // Wild Shape PANTHER
    SetLocalString(OBJECT_SELF, "SFNames_925", "Wild Shape WOLF"); // Wild Shape WOLF
    SetLocalString(OBJECT_SELF, "SFNames_926", "Wild Shape BOAR"); // Wild Shape BOAR
    SetLocalString(OBJECT_SELF, "SFNames_927", "Wild Shape BADGER"); // Wild Shape BADGER
    SetLocalString(OBJECT_SELF, "SFNames_928", "Wild Shape Reptile"); // Wild Shape Reptile
    SetLocalString(OBJECT_SELF, "SFNames_929", "Wild Shape VIPER"); // Wild Shape VIPER
    SetLocalString(OBJECT_SELF, "SFNames_93", "Knock"); // Knock
    SetLocalString(OBJECT_SELF, "SFNames_930", "Wild Shape COBRA"); // Wild Shape COBRA
    SetLocalString(OBJECT_SELF, "SFNames_931", "Wild Shape TORTOISE"); // Wild Shape TORTOISE
    SetLocalString(OBJECT_SELF, "SFNames_932", "Wild Shape SALT CROC"); // Wild Shape SALT CROC
    SetLocalString(OBJECT_SELF, "SFNames_933", "Wild Shape GIANT"); // Wild Shape GIANT
    SetLocalString(OBJECT_SELF, "SFNames_934", "Wild Shape Avian"); // Wild Shape Avian
    SetLocalString(OBJECT_SELF, "SFNames_935", "Wild Shape Falcon"); // Wild Shape Falcon
    SetLocalString(OBJECT_SELF, "SFNames_936", "Wild Shape Crane"); // Wild Shape Crane
    SetLocalString(OBJECT_SELF, "SFNames_937", "Wild Shape Raven"); // Wild Shape Raven
    SetLocalString(OBJECT_SELF, "SFNames_938", "Wild Shape Owl"); // Wild Shape Owl
    SetLocalString(OBJECT_SELF, "SFNames_939", "Wild Shape Sparrow"); // Wild Shape Sparrow
    SetLocalString(OBJECT_SELF, "SFNames_94", "Lesser Dispel"); // Lesser Dispel
    SetLocalString(OBJECT_SELF, "SFNames_941", "Dimension Door"); // Dimension Door
    SetLocalString(OBJECT_SELF, "SFNames_943", "DARK BOLT"); // DARK BOLT
    SetLocalString(OBJECT_SELF, "SFNames_944", "CHARM DOMAIN POWER"); // CHARM DOMAIN POWER
    SetLocalString(OBJECT_SELF, "SFNames_945", "ILLUSION DOMAIN POWER"); // ILLUSION DOMAIN POWER
    SetLocalString(OBJECT_SELF, "SFNames_946", "MAGIC DOMAIN POWER"); // MAGIC DOMAIN POWER
    SetLocalString(OBJECT_SELF, "SFNames_948", "Teleport"); // Teleport
    SetLocalString(OBJECT_SELF, "SFNames_949", "SUMMON SHAMBLING MOUND"); // SUMMON SHAMBLING MOUND
    SetLocalString(OBJECT_SELF, "SFNames_95", "Lesser Mind Blank"); // Lesser Mind Blank
    SetLocalString(OBJECT_SELF, "SFNames_950", "Plane Shift"); // Plane Shift
    SetLocalString(OBJECT_SELF, "SFNames_953", "Tree Stride"); // Tree Stride
    SetLocalString(OBJECT_SELF, "SFNames_954", "Wild Shape PLANT"); // Wild Shape PLANT
    SetLocalString(OBJECT_SELF, "SFNames_955", "WILD SHAPE ASS VINE"); // WILD SHAPE ASS VINE
    SetLocalString(OBJECT_SELF, "SFNames_956", "WILD SHAPE TREANT"); // WILD SHAPE TREANT
    SetLocalString(OBJECT_SELF, "SFNames_957", "WILD SHAPE Shambling"); // WILD SHAPE Shambling
    SetLocalString(OBJECT_SELF, "SFNames_958", "Shadow Jump"); // Shadow Jump
    SetLocalString(OBJECT_SELF, "SFNames_959", "Shadow Knife"); // Shadow Knife
    SetLocalString(OBJECT_SELF, "SFNames_96", "Lesser Planar Binding"); // Lesser Planar Binding
    SetLocalString(OBJECT_SELF, "SFNames_960", "Shadow Mastery"); // Shadow Mastery
    SetLocalString(OBJECT_SELF, "SFNames_961", "Shadow Walk"); // Shadow Walk
    SetLocalString(OBJECT_SELF, "SFNames_964", "BS SWORD STYLE"); // BS SWORD STYLE
    SetLocalString(OBJECT_SELF, "SFNames_965", "BS ARCANE STRIKE"); // BS ARCANE STRIKE
    SetLocalString(OBJECT_SELF, "SFNames_967", "Shield of Shadows"); // Shield of Shadows
    SetLocalString(OBJECT_SELF, "SFNames_97", "Lesser Restoration"); // Lesser Restoration
    SetLocalString(OBJECT_SELF, "SFNames_970", "Spell Ward"); // Spell Ward
    SetLocalString(OBJECT_SELF, "SFNames_971", "Apothecary and arsenal"); // Apothecary and arsenal
    SetLocalString(OBJECT_SELF, "SFNames_972", "Eyes of the order"); // Eyes of the order
    SetLocalString(OBJECT_SELF, "SFNames_973", "Detect Evil"); // Detect Evil
    SetLocalString(OBJECT_SELF, "SFNames_974", "Control Weather"); // Control Weather
    SetLocalString(OBJECT_SELF, "SFNames_975", "Research New Spell"); // Research New Spell
    SetLocalString(OBJECT_SELF, "SFNames_976", "Spellfire Purge"); // Spellfire Purge
    SetLocalString(OBJECT_SELF, "SFNames_977", "Blood Drain"); // Blood Drain
    SetLocalString(OBJECT_SELF, "SFNames_978", "ChildrenOfTheNight"); // ChildrenOfTheNight
    SetLocalString(OBJECT_SELF, "SFNames_979", "Dominate Person"); // Dominate Person
    SetLocalString(OBJECT_SELF, "SFNames_98", "Lesser Spell Breach"); // Lesser Spell Breach
    SetLocalString(OBJECT_SELF, "SFNames_980", "Mist Form"); // Mist Form
    SetLocalString(OBJECT_SELF, "SFNames_981", "Bat Form"); // Bat Form
    SetLocalString(OBJECT_SELF, "SFNames_982", "Wolf Form"); // Wolf Form
    SetLocalString(OBJECT_SELF, "SFNames_984", "Summon Mount"); // Summon Mount
    SetLocalString(OBJECT_SELF, "SFNames_985", "Heroism"); // Heroism
    SetLocalString(OBJECT_SELF, "SFNames_986", "Heroism Greater"); // Heroism Greater
    SetLocalString(OBJECT_SELF, "SFNames_987", "Lullaby"); // Lullaby
    SetLocalString(OBJECT_SELF, "SFNames_988", "Rage"); // Rage
    SetLocalString(OBJECT_SELF, "SFNames_989", "Call Lightning Storm"); // Call Lightning Storm
    SetLocalString(OBJECT_SELF, "SFNames_99", "Lesser Spell Mantle"); // Lesser Spell Mantle
    SetLocalString(OBJECT_SELF, "SFNames_990", "Claws Of Darkness"); // Claws Of Darkness
    SetLocalString(OBJECT_SELF, "SFNames_991", "Polar Ray"); // Polar Ray
    SetLocalString(OBJECT_SELF, "SFNames_992", "Scorching Ray"); // Scorching Ray
    SetLocalString(OBJECT_SELF, "SFNames_993", "Blur"); // Blur
    SetLocalString(OBJECT_SELF, "SFNames_994", "Verrakeths Shadow Crown"); // Verrakeths Shadow Crown
    SetLocalString(OBJECT_SELF, "SFNames_995", "EschewMaterialToggle"); // EschewMaterialToggle
    SetLocalString(OBJECT_SELF, "SFNames_998", "Protection From Arrows"); // Protection From Arrows
    SetLocalInt(OBJECT_SELF, "SFPacked1_0", 0x7c247e16); // Acid Fog
    SetLocalInt(OBJECT_SELF, "SFPacked1_1", 0x57207ee6); // Aid
    SetLocalInt(OBJECT_SELF, "SFPacked1_10", 0x7ce07ac6); // Burning Hands
    SetLocalInt(OBJECT_SELF, "SFPacked1_100", 0x560034ea); // Light
    SetLocalInt(OBJECT_SELF, "SFPacked1_1000", 0x060070fe); // Undeath After Death
    SetLocalInt(OBJECT_SELF, "SFPacked1_1002", 0x08007f2e); // Blasphemy
    SetLocalInt(OBJECT_SELF, "SFPacked1_1005", 0x660000ae); // Cold Fire
    SetLocalInt(OBJECT_SELF, "SFPacked1_1006", 0x040400fe); // Paralyzing touch
    SetLocalInt(OBJECT_SELF, "SFPacked1_1007", 0x1e0074ae); // Daylight
    SetLocalInt(OBJECT_SELF, "SFPacked1_1008", 0x17407afe); // Chill Touch
    SetLocalInt(OBJECT_SELF, "SFPacked1_1009", 0x14107ebe); // Command Undead
    SetLocalInt(OBJECT_SELF, "SFPacked1_101", 0x75187a6e); // Lightning Bolt
    SetLocalInt(OBJECT_SELF, "SFPacked1_1010", 0x1ce47aae); // Aganazzer FlameWave
    SetLocalInt(OBJECT_SELF, "SFPacked1_1011", 0x12007f3e); // False Life
    SetLocalInt(OBJECT_SELF, "SFPacked1_1012", 0x1d30747e); // Halt Undead
    SetLocalInt(OBJECT_SELF, "SFPacked1_1013", 0x1d307e66); // Deep Slumber
    SetLocalInt(OBJECT_SELF, "SFPacked1_1014", 0x1c007e76); // Shadow Spray
    SetLocalInt(OBJECT_SELF, "SFPacked1_1015", 0x7e007a86); // Disintegrate
    SetLocalInt(OBJECT_SELF, "SFPacked1_1016", 0x75307abe); // Disrupt Undead
    SetLocalInt(OBJECT_SELF, "SFPacked1_1017", 0x02003544); // Glibness
    SetLocalInt(OBJECT_SELF, "SFPacked1_1018", 0x7d2074a6); // Crushing Despair
    SetLocalInt(OBJECT_SELF, "SFPacked1_1019", 0x17207466); // Good Hope
    SetLocalInt(OBJECT_SELF, "SFPacked1_102", 0x560074d6); // Mage Armor
    SetLocalInt(OBJECT_SELF, "SFPacked1_1020", 0x148070e6); // Affliction
    SetLocalInt(OBJECT_SELF, "SFPacked1_1021", 0x02007546); // Aspect Of The Deity
    SetLocalInt(OBJECT_SELF, "SFPacked1_1022", 0x14007a7e); // Blood Of Martyr
    SetLocalInt(OBJECT_SELF, "SFPacked1_1023", 0x02007526); // Divine Sacrifice
    SetLocalInt(OBJECT_SELF, "SFPacked1_1024", 0x74a07aae); // Lantern Light
    SetLocalInt(OBJECT_SELF, "SFPacked1_1025", 0x04007ebe); // Fleshshiver
    SetLocalInt(OBJECT_SELF, "SFPacked1_1026", 0x02007546); // Lively Step
    SetLocalInt(OBJECT_SELF, "SFPacked1_1027", 0x14207ed6); // Corrosive Grasp
    SetLocalInt(OBJECT_SELF, "SFPacked1_1028", 0x040074b6); // Shadow Well
    SetLocalInt(OBJECT_SELF, "SFPacked1_1029", 0x14807eae); // Memory Rot
    SetLocalInt(OBJECT_SELF, "SFPacked1_103", 0x560000ce); // Magic Circle against Chaos
    SetLocalInt(OBJECT_SELF, "SFPacked1_1030", 0x56007f46); // Mass Bulls Strength
    SetLocalInt(OBJECT_SELF, "SFPacked1_1031", 0x56007f46); // Mass Cats Grace
    SetLocalInt(OBJECT_SELF, "SFPacked1_1032", 0x56007f46); // Mass Eagle Splendor
    SetLocalInt(OBJECT_SELF, "SFPacked1_1033", 0x56007f46); // Mass Endurance
    SetLocalInt(OBJECT_SELF, "SFPacked1_1034", 0x56007f46); // Mass Foxs Cunning
    SetLocalInt(OBJECT_SELF, "SFPacked1_1035", 0x56007f46); // Mass Owls Wisdom
    SetLocalInt(OBJECT_SELF, "SFPacked1_1036", 0x0400010e); // Atonement
    SetLocalInt(OBJECT_SELF, "SFPacked1_1037", 0x02007546); // Longstrider
    SetLocalInt(OBJECT_SELF, "SFPacked1_1038", 0x020074ce); // Nondetection
    SetLocalInt(OBJECT_SELF, "SFPacked1_1039", 0x04207106); // Rusting grasp
    SetLocalInt(OBJECT_SELF, "SFPacked1_104", 0x560074ce); // Magic Circle against Evil
    SetLocalInt(OBJECT_SELF, "SFPacked1_1040", 0x02007112); // Word of recall
    SetLocalInt(OBJECT_SELF, "SFPacked1_1041", 0x04007afe); // Blight
    SetLocalInt(OBJECT_SELF, "SFPacked1_1043", 0x04000080); // Leadership
    SetLocalInt(OBJECT_SELF, "SFPacked1_1045", 0x080074ae); // Spiritual Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked1_1047", 0x5c00002d); // Darkness
    SetLocalInt(OBJECT_SELF, "SFPacked1_105", 0x560074ce); // Magic Circle against Good
    SetLocalInt(OBJECT_SELF, "SFPacked1_1050", 0x4400006d); // Eldritch Chain
    SetLocalInt(OBJECT_SELF, "SFPacked1_1051", 0x0c0000ad); // Eldritch Cone
    SetLocalInt(OBJECT_SELF, "SFPacked1_1052", 0x4400002d); // Eldritch Spear
    SetLocalInt(OBJECT_SELF, "SFPacked1_1053", 0x0200012d); // Eldritch Doom
    SetLocalInt(OBJECT_SELF, "SFPacked1_1054", 0x040000ed); // Hideous Blow
    SetLocalInt(OBJECT_SELF, "SFPacked1_1055", 0x02000100); // Frightful Blast
    SetLocalInt(OBJECT_SELF, "SFPacked1_1056", 0x02000100); // Sickening Blast
    SetLocalInt(OBJECT_SELF, "SFPacked1_1057", 0x02000100); // Brimstone Blast
    SetLocalInt(OBJECT_SELF, "SFPacked1_1058", 0x02000100); // Hellrime Blast
    SetLocalInt(OBJECT_SELF, "SFPacked1_1059", 0x02000100); // Vitriolic Blast
    SetLocalInt(OBJECT_SELF, "SFPacked1_106", 0x560000ce); // Magic Circle against Law
    SetLocalInt(OBJECT_SELF, "SFPacked1_1060", 0x02000100); // Bewitching Blast
    SetLocalInt(OBJECT_SELF, "SFPacked1_1061", 0x02000100); // Utterdark Blast
    SetLocalInt(OBJECT_SELF, "SFPacked1_1062", 0x02000100); // Repelling Blast
    SetLocalInt(OBJECT_SELF, "SFPacked1_1063", 0x08000030); // Flee The Scene
    SetLocalInt(OBJECT_SELF, "SFPacked1_1064", 0x02000130); // Path Of Shadow
    SetLocalInt(OBJECT_SELF, "SFPacked1_107", 0x74007a2e); // Magic Missile
    SetLocalInt(OBJECT_SELF, "SFPacked1_1070", 0x66287aae); // Orb Lsr Acid
    SetLocalInt(OBJECT_SELF, "SFPacked1_1071", 0x66487aae); // Orb Lsr Cold
    SetLocalInt(OBJECT_SELF, "SFPacked1_1072", 0x67087aae); // Orb Lsr Elec
    SetLocalInt(OBJECT_SELF, "SFPacked1_1073", 0x66e87aae); // Orb Lsr Fire
    SetLocalInt(OBJECT_SELF, "SFPacked1_1074", 0x67a87aae); // Orb Lsr Sonic
    SetLocalInt(OBJECT_SELF, "SFPacked1_108", 0x50000106); // Magic Vestment
    SetLocalInt(OBJECT_SELF, "SFPacked1_109", 0x50000106); // Magic Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked1_11", 0x7d007a2e); // Call Lightning
    SetLocalInt(OBJECT_SELF, "SFPacked1_110", 0x5c107476); // Mass Blindness and Deafness
    SetLocalInt(OBJECT_SELF, "SFPacked1_111", 0x5d3034a2); // Mass Charm
    SetLocalInt(OBJECT_SELF, "SFPacked1_112", 0x5d300066); // Mass Domination
    SetLocalInt(OBJECT_SELF, "SFPacked1_113", 0x5e1074a6); // Mass Haste
    SetLocalInt(OBJECT_SELF, "SFPacked1_114", 0x5f6070fe); // Mass Heal
    SetLocalInt(OBJECT_SELF, "SFPacked1_115", 0x74247a16); // Melfs Acid Arrow
    SetLocalInt(OBJECT_SELF, "SFPacked1_116", 0x1ae07b2e); // Meteor Swarm
    SetLocalInt(OBJECT_SELF, "SFPacked1_117", 0x5e10748e); // Mind Blank
    SetLocalInt(OBJECT_SELF, "SFPacked1_118", 0x5d307426); // Mind Fog
    SetLocalInt(OBJECT_SELF, "SFPacked1_119", 0x1200750e); // Minor Globe of Invulnerability
    SetLocalInt(OBJECT_SELF, "SFPacked1_12", 0x5d200066); // Calm Emotions
    SetLocalInt(OBJECT_SELF, "SFPacked1_120", 0x12007536); // Ghostly Visage
    SetLocalInt(OBJECT_SELF, "SFPacked1_121", 0x12007534); // Ethereal Visage
    SetLocalInt(OBJECT_SELF, "SFPacked1_122", 0x5e04704a); // Mordenkainens Disjunction
    SetLocalInt(OBJECT_SELF, "SFPacked1_123", 0x580064c6); // Mordenkainens Sword
    SetLocalInt(OBJECT_SELF, "SFPacked1_124", 0x13607ac6); // Natures Balance
    SetLocalInt(OBJECT_SELF, "SFPacked1_125", 0x560074ce); // Negative Energy Protection
    SetLocalInt(OBJECT_SELF, "SFPacked1_126", 0x560070d6); // Neutralize Poison
    SetLocalInt(OBJECT_SELF, "SFPacked1_127", 0x14d07a76); // Phantasmal Killer
    SetLocalInt(OBJECT_SELF, "SFPacked1_128", 0x5c007496); // Planar Binding
    SetLocalInt(OBJECT_SELF, "SFPacked1_129", 0x558070fe); // Poison
    SetLocalInt(OBJECT_SELF, "SFPacked1_13", 0x56007f06); // Cats Grace
    SetLocalInt(OBJECT_SELF, "SFPacked1_130", 0x12003542); // Polymorph Self
    SetLocalInt(OBJECT_SELF, "SFPacked1_131", 0x5c702092); // Power Word Kill
    SetLocalInt(OBJECT_SELF, "SFPacked1_132", 0x55302092); // Power Word Stun
    SetLocalInt(OBJECT_SELF, "SFPacked1_133", 0x5e007516); // Prayer
    SetLocalInt(OBJECT_SELF, "SFPacked1_134", 0x120074de); // Premonition
    SetLocalInt(OBJECT_SELF, "SFPacked1_135", 0x5c0470ae); // Prismatic Spray
    SetLocalInt(OBJECT_SELF, "SFPacked1_136", 0x560074ce); // Protection from Chaos
    SetLocalInt(OBJECT_SELF, "SFPacked1_137", 0x560074ce); // Protection from Elements
    SetLocalInt(OBJECT_SELF, "SFPacked1_138", 0x560074ce); // Protection from Evil
    SetLocalInt(OBJECT_SELF, "SFPacked1_139", 0x560074ce); // Protection from Good
    SetLocalInt(OBJECT_SELF, "SFPacked1_14", 0x75187a2e); // Chain Lightning
    SetLocalInt(OBJECT_SELF, "SFPacked1_140", 0x560074ce); // Protection from Law
    SetLocalInt(OBJECT_SELF, "SFPacked1_141", 0x5e007526); // Protection from Spells
    SetLocalInt(OBJECT_SELF, "SFPacked1_142", 0x540070fe); // Raise Dead
    SetLocalInt(OBJECT_SELF, "SFPacked1_143", 0x54187ebc); // Ray of Enfeeblement
    SetLocalInt(OBJECT_SELF, "SFPacked1_144", 0x74407a6e); // Ray of Frost
    SetLocalInt(OBJECT_SELF, "SFPacked1_145", 0x5e00709e); // Remove Blindness and Deafness
    SetLocalInt(OBJECT_SELF, "SFPacked1_146", 0x760070ce); // Remove Curse
    SetLocalInt(OBJECT_SELF, "SFPacked1_147", 0x560070d6); // Remove Disease
    SetLocalInt(OBJECT_SELF, "SFPacked1_148", 0x5e10748e); // Remove Fear
    SetLocalInt(OBJECT_SELF, "SFPacked1_149", 0x5e107096); // Remove Paralysis
    SetLocalInt(OBJECT_SELF, "SFPacked1_15", 0x553074a6); // Charm Monster
    SetLocalInt(OBJECT_SELF, "SFPacked1_150", 0x560074ce); // Resist Elements
    SetLocalInt(OBJECT_SELF, "SFPacked1_151", 0x560074ce); // Resistance
    SetLocalInt(OBJECT_SELF, "SFPacked1_152", 0x560070d6); // Restoration
    SetLocalInt(OBJECT_SELF, "SFPacked1_153", 0x540070fe); // Resurrection
    SetLocalInt(OBJECT_SELF, "SFPacked1_154", 0x560074ce); // Sanctuary
    SetLocalInt(OBJECT_SELF, "SFPacked1_155", 0x54c054be); // Scare
    SetLocalInt(OBJECT_SELF, "SFPacked1_156", 0x54047a6e); // Searing Light
    SetLocalInt(OBJECT_SELF, "SFPacked1_157", 0x5600751e); // See Invisibility
    SetLocalInt(OBJECT_SELF, "SFPacked1_158", 0x5e0060b6); // Shades
    SetLocalInt(OBJECT_SELF, "SFPacked1_159", 0x5e0060b6); // Shadow Conjuration
    SetLocalInt(OBJECT_SELF, "SFPacked1_16", 0x553074a6); // Charm Person
    SetLocalInt(OBJECT_SELF, "SFPacked1_160", 0x12007536); // Shadow Shield
    SetLocalInt(OBJECT_SELF, "SFPacked1_161", 0x12007546); // Shapechange
    SetLocalInt(OBJECT_SELF, "SFPacked1_162", 0x1200750e); // Shield of Law
    SetLocalInt(OBJECT_SELF, "SFPacked1_163", 0x56007436); // Silence
    SetLocalInt(OBJECT_SELF, "SFPacked1_164", 0x15407afe); // Slay Living
    SetLocalInt(OBJECT_SELF, "SFPacked1_165", 0x5d307e66); // Sleep
    SetLocalInt(OBJECT_SELF, "SFPacked1_166", 0x5c1074c6); // Slow
    SetLocalInt(OBJECT_SELF, "SFPacked1_167", 0x5db0782e); // Sound Burst
    SetLocalInt(OBJECT_SELF, "SFPacked1_168", 0x560074ce); // Spell Resistance
    SetLocalInt(OBJECT_SELF, "SFPacked1_169", 0x12007f0e); // Spell Mantle
    SetLocalInt(OBJECT_SELF, "SFPacked1_17", 0x553074a6); // Charm Person or Animal
    SetLocalInt(OBJECT_SELF, "SFPacked1_170", 0x5c040086); // Sphere of Chaos
    SetLocalInt(OBJECT_SELF, "SFPacked1_171", 0x5d847456); // Stinking Cloud
    SetLocalInt(OBJECT_SELF, "SFPacked1_172", 0x560074ce); // Stoneskin
    SetLocalInt(OBJECT_SELF, "SFPacked1_173", 0x0b007b16); // Storm of Vengeance
    SetLocalInt(OBJECT_SELF, "SFPacked1_174", 0x58007496); // Summon Creature I
    SetLocalInt(OBJECT_SELF, "SFPacked1_175", 0x58007496); // Summon Creature II
    SetLocalInt(OBJECT_SELF, "SFPacked1_176", 0x58007496); // Summon Creature III
    SetLocalInt(OBJECT_SELF, "SFPacked1_177", 0x58007496); // Summon Creature IV
    SetLocalInt(OBJECT_SELF, "SFPacked1_178", 0x58007496); // Summon Creature IX
    SetLocalInt(OBJECT_SELF, "SFPacked1_179", 0x58007496); // Summon Creature V
    SetLocalInt(OBJECT_SELF, "SFPacked1_18", 0x5c707a7e); // Circle of Death
    SetLocalInt(OBJECT_SELF, "SFPacked1_180", 0x58007496); // Summon Creature VI
    SetLocalInt(OBJECT_SELF, "SFPacked1_181", 0x58007496); // Summon Creature VII
    SetLocalInt(OBJECT_SELF, "SFPacked1_182", 0x58007496); // Summon Creature VIII
    SetLocalInt(OBJECT_SELF, "SFPacked1_183", 0x5ca0786e); // Sunbeam
    SetLocalInt(OBJECT_SELF, "SFPacked1_184", 0x12007f46); // Tensers Transformation
    SetLocalInt(OBJECT_SELF, "SFPacked1_185", 0x12007542); // Time Stop
    SetLocalInt(OBJECT_SELF, "SFPacked1_186", 0x560074de); // True Seeing
    SetLocalInt(OBJECT_SELF, "SFPacked1_187", 0x1200750e); // Unholy Aura
    SetLocalInt(OBJECT_SELF, "SFPacked1_188", 0x15407afe); // Vampiric Touch
    SetLocalInt(OBJECT_SELF, "SFPacked1_189", 0x56007506); // Virtue
    SetLocalInt(OBJECT_SELF, "SFPacked1_19", 0x5d507a7e); // Circle of Doom
    SetLocalInt(OBJECT_SELF, "SFPacked1_190", 0x5db030ba); // Wail of the Banshee
    SetLocalInt(OBJECT_SELF, "SFPacked1_191", 0x5ce07e6e); // Wall of Fire
    SetLocalInt(OBJECT_SELF, "SFPacked1_192", 0x5c047456); // Web
    SetLocalInt(OBJECT_SELF, "SFPacked1_193", 0x5cd07ab6); // Weird
    SetLocalInt(OBJECT_SELF, "SFPacked1_194", 0x5cb0706a); // Word of Faith
    SetLocalInt(OBJECT_SELF, "SFPacked1_195", 0x13200129); // AURA BLINDING
    SetLocalInt(OBJECT_SELF, "SFPacked1_196", 0x12400129); // Aura Cold
    SetLocalInt(OBJECT_SELF, "SFPacked1_197", 0x13000129); // Aura Electricity
    SetLocalInt(OBJECT_SELF, "SFPacked1_198", 0x12c00129); // Aura Fear
    SetLocalInt(OBJECT_SELF, "SFPacked1_199", 0x12e00129); // Aura Fire
    SetLocalInt(OBJECT_SELF, "SFPacked1_2", 0x580074be); // Animate Dead
    SetLocalInt(OBJECT_SELF, "SFPacked1_20", 0x5600751e); // Clairaudience and Clairvoyance
    SetLocalInt(OBJECT_SELF, "SFPacked1_200", 0x13200129); // Aura Menace
    SetLocalInt(OBJECT_SELF, "SFPacked1_201", 0x12000129); // Aura Protection
    SetLocalInt(OBJECT_SELF, "SFPacked1_202", 0x13200129); // Aura Stun
    SetLocalInt(OBJECT_SELF, "SFPacked1_203", 0x13200129); // Aura Unearthly Visage
    SetLocalInt(OBJECT_SELF, "SFPacked1_204", 0x13200129); // Aura Unnatural
    SetLocalInt(OBJECT_SELF, "SFPacked1_205", 0x5d50006d); // Bolt Ability Drain Charisma
    SetLocalInt(OBJECT_SELF, "SFPacked1_206", 0x5d50006d); // Bolt Ability Drain Constitution
    SetLocalInt(OBJECT_SELF, "SFPacked1_207", 0x5d50006d); // Bolt Ability Drain Dexterity
    SetLocalInt(OBJECT_SELF, "SFPacked1_208", 0x5d50006d); // Bolt Ability Drain Intelligence
    SetLocalInt(OBJECT_SELF, "SFPacked1_209", 0x5d50006d); // Bolt Ability Drain Strength
    SetLocalInt(OBJECT_SELF, "SFPacked1_21", 0x5600544c); // Clarity
    SetLocalInt(OBJECT_SELF, "SFPacked1_210", 0x5d50006d); // Bolt Ability Drain Wisdom
    SetLocalInt(OBJECT_SELF, "SFPacked1_211", 0x7c30006d); // Bolt Acid
    SetLocalInt(OBJECT_SELF, "SFPacked1_212", 0x5d30006d); // Bolt Charm
    SetLocalInt(OBJECT_SELF, "SFPacked1_213", 0x5c50006d); // Bolt Cold
    SetLocalInt(OBJECT_SELF, "SFPacked1_214", 0x5d30006d); // Bolt Confuse
    SetLocalInt(OBJECT_SELF, "SFPacked1_215", 0x5d30006d); // Bolt Daze
    SetLocalInt(OBJECT_SELF, "SFPacked1_216", 0x5d50006d); // Bolt Death
    SetLocalInt(OBJECT_SELF, "SFPacked1_217", 0x5c90006d); // Bolt Disease
    SetLocalInt(OBJECT_SELF, "SFPacked1_218", 0x5d30006d); // Bolt Dominate
    SetLocalInt(OBJECT_SELF, "SFPacked1_219", 0x7cf0006d); // Bolt Fire
    SetLocalInt(OBJECT_SELF, "SFPacked1_22", 0x1200010e); // Cloak of Chaos
    SetLocalInt(OBJECT_SELF, "SFPacked1_220", 0x5c10006d); // Bolt Knockdown
    SetLocalInt(OBJECT_SELF, "SFPacked1_221", 0x5d50006d); // Bolt Level Drain
    SetLocalInt(OBJECT_SELF, "SFPacked1_222", 0x7d00006d); // Bolt Lightning
    SetLocalInt(OBJECT_SELF, "SFPacked1_223", 0x5c10006d); // Bolt Paralyze
    SetLocalInt(OBJECT_SELF, "SFPacked1_224", 0x5d90006d); // Bolt Poison
    SetLocalInt(OBJECT_SELF, "SFPacked1_225", 0x5c10006d); // Bolt Shards
    SetLocalInt(OBJECT_SELF, "SFPacked1_226", 0x5c10006d); // Bolt Slow
    SetLocalInt(OBJECT_SELF, "SFPacked1_227", 0x5d30006d); // Bolt Stun
    SetLocalInt(OBJECT_SELF, "SFPacked1_228", 0x5c10006d); // Bolt Web
    SetLocalInt(OBJECT_SELF, "SFPacked1_229", 0x7c2000ad); // Cone Acid
    SetLocalInt(OBJECT_SELF, "SFPacked1_23", 0x5d847e16); // Cloudkill
    SetLocalInt(OBJECT_SELF, "SFPacked1_230", 0x7c4000ad); // Cone Cold
    SetLocalInt(OBJECT_SELF, "SFPacked1_2306", 0x02000101); // VAA Anim1
    SetLocalInt(OBJECT_SELF, "SFPacked1_2307", 0x02000101); // VAA Anim2
    SetLocalInt(OBJECT_SELF, "SFPacked1_2308", 0x02000101); // VAA Anim3
    SetLocalInt(OBJECT_SELF, "SFPacked1_2309", 0x02000101); // VAA Anim4
    SetLocalInt(OBJECT_SELF, "SFPacked1_231", 0x5c8000ad); // Cone Disease
    SetLocalInt(OBJECT_SELF, "SFPacked1_2310", 0x02000101); // VAA Anim5
    SetLocalInt(OBJECT_SELF, "SFPacked1_2312", 0x02000101); // VAA Anim6
    SetLocalInt(OBJECT_SELF, "SFPacked1_2313", 0x02000101); // VAA Anim7
    SetLocalInt(OBJECT_SELF, "SFPacked1_2314", 0x02000101); // VAA Anim8
    SetLocalInt(OBJECT_SELF, "SFPacked1_2315", 0x02000101); // VAA Anim9
    SetLocalInt(OBJECT_SELF, "SFPacked1_2316", 0x02000101); // VAA Anim10
    SetLocalInt(OBJECT_SELF, "SFPacked1_232", 0x7ce000ad); // Cone Fire
    SetLocalInt(OBJECT_SELF, "SFPacked1_233", 0x7d0000ad); // Cone Lightning
    SetLocalInt(OBJECT_SELF, "SFPacked1_234", 0x7d8000ad); // Cone Poison
    SetLocalInt(OBJECT_SELF, "SFPacked1_235", 0x7da000ad); // Cone Sonic
    SetLocalInt(OBJECT_SELF, "SFPacked1_236", 0x7c2000ed); // Dragon Breath Acid
    SetLocalInt(OBJECT_SELF, "SFPacked1_237", 0x7c4000ed); // Dragon Breath Cold
    SetLocalInt(OBJECT_SELF, "SFPacked1_238", 0x7cc000ed); // Dragon Breath Fear
    SetLocalInt(OBJECT_SELF, "SFPacked1_239", 0x7ce000ed); // Dragon Breath Fire
    SetLocalInt(OBJECT_SELF, "SFPacked1_24", 0x5d207ab6); // Color Spray
    SetLocalInt(OBJECT_SELF, "SFPacked1_240", 0x7c2000ed); // Dragon Breath Gas
    SetLocalInt(OBJECT_SELF, "SFPacked1_241", 0x7d0000ed); // Dragon Breath Lightning
    SetLocalInt(OBJECT_SELF, "SFPacked1_242", 0x7c0000ed); // Dragon Breath Paralyze
    SetLocalInt(OBJECT_SELF, "SFPacked1_243", 0x7d2000ed); // Dragon Breath Sleep
    SetLocalInt(OBJECT_SELF, "SFPacked1_244", 0x7c0000ed); // Dragon Breath Slow
    SetLocalInt(OBJECT_SELF, "SFPacked1_245", 0x7d4000ed); // Dragon Breath Weaken
    SetLocalInt(OBJECT_SELF, "SFPacked1_246", 0x540000ed); // Dragon Wing Buffet
    SetLocalInt(OBJECT_SELF, "SFPacked1_247", 0x5200012d); // Ferocity 1
    SetLocalInt(OBJECT_SELF, "SFPacked1_248", 0x5200012d); // Ferocity 2
    SetLocalInt(OBJECT_SELF, "SFPacked1_249", 0x5200012d); // Ferocity 3
    SetLocalInt(OBJECT_SELF, "SFPacked1_25", 0x7c407aae); // Cone of Cold
    SetLocalInt(OBJECT_SELF, "SFPacked1_250", 0x552000ad); // Gaze Charm
    SetLocalInt(OBJECT_SELF, "SFPacked1_251", 0x552000ad); // Gaze Confusion
    SetLocalInt(OBJECT_SELF, "SFPacked1_252", 0x552000ad); // Gaze Daze
    SetLocalInt(OBJECT_SELF, "SFPacked1_253", 0x554000ad); // Gaze Death
    SetLocalInt(OBJECT_SELF, "SFPacked1_254", 0x540000ad); // Gaze Destroy Chaos
    SetLocalInt(OBJECT_SELF, "SFPacked1_255", 0x540000ad); // Gaze Destroy Evil
    SetLocalInt(OBJECT_SELF, "SFPacked1_256", 0x540000ad); // Gaze Destroy Good
    SetLocalInt(OBJECT_SELF, "SFPacked1_257", 0x540000ad); // Gaze Destroy Law
    SetLocalInt(OBJECT_SELF, "SFPacked1_258", 0x552000ad); // Gaze Dominate
    SetLocalInt(OBJECT_SELF, "SFPacked1_259", 0x540000ad); // Gaze Doom
    SetLocalInt(OBJECT_SELF, "SFPacked1_26", 0x5d307466); // Confusion
    SetLocalInt(OBJECT_SELF, "SFPacked1_260", 0x54c000ad); // Gaze Fear
    SetLocalInt(OBJECT_SELF, "SFPacked1_261", 0x552000ad); // Gaze Paralysis
    SetLocalInt(OBJECT_SELF, "SFPacked1_262", 0x552000ad); // Gaze Stunned
    SetLocalInt(OBJECT_SELF, "SFPacked1_263", 0x158000ad); // Golem Breath Gas
    SetLocalInt(OBJECT_SELF, "SFPacked1_264", 0x7ce000ad); // Hell Hound Firebreath
    SetLocalInt(OBJECT_SELF, "SFPacked1_265", 0x55a000ab); // Howl Confuse
    SetLocalInt(OBJECT_SELF, "SFPacked1_266", 0x552000ab); // Howl Daze
    SetLocalInt(OBJECT_SELF, "SFPacked1_267", 0x55a000ab); // Howl Death
    SetLocalInt(OBJECT_SELF, "SFPacked1_268", 0x55a000ab); // Howl Doom
    SetLocalInt(OBJECT_SELF, "SFPacked1_269", 0x55a000ab); // Howl Fear
    SetLocalInt(OBJECT_SELF, "SFPacked1_27", 0x548070fe); // Contagion
    SetLocalInt(OBJECT_SELF, "SFPacked1_270", 0x55a000ab); // Howl Paralysis
    SetLocalInt(OBJECT_SELF, "SFPacked1_271", 0x55a000ab); // Howl Sonic
    SetLocalInt(OBJECT_SELF, "SFPacked1_272", 0x55a000ab); // Howl Stun
    SetLocalInt(OBJECT_SELF, "SFPacked1_273", 0x5200012d); // Intensity 1
    SetLocalInt(OBJECT_SELF, "SFPacked1_274", 0x5200012d); // Intensity 2
    SetLocalInt(OBJECT_SELF, "SFPacked1_275", 0x5200012d); // Intensity 3
    SetLocalInt(OBJECT_SELF, "SFPacked1_276", 0x54c000ad); // Krenshar Scare
    SetLocalInt(OBJECT_SELF, "SFPacked1_277", 0x1200012d); // Lesser Body Adjustment
    SetLocalInt(OBJECT_SELF, "SFPacked1_278", 0x5410006d); // Mephit Salt Breath
    SetLocalInt(OBJECT_SELF, "SFPacked1_279", 0x5410006d); // Mephit Steam Breath
    SetLocalInt(OBJECT_SELF, "SFPacked1_28", 0x541074be); // Control Undead
    SetLocalInt(OBJECT_SELF, "SFPacked1_280", 0x120000ed); // Mummy Bolster Undead
    SetLocalInt(OBJECT_SELF, "SFPacked1_281", 0x120000ef); // Pulse Drown
    SetLocalInt(OBJECT_SELF, "SFPacked1_282", 0x5e8000ef); // Pulse Spores
    SetLocalInt(OBJECT_SELF, "SFPacked1_283", 0x120000ef); // Pulse Whirlwind
    SetLocalInt(OBJECT_SELF, "SFPacked1_284", 0x5ee000ef); // Pulse Fire
    SetLocalInt(OBJECT_SELF, "SFPacked1_285", 0x5f0000ef); // Pulse Lightning
    SetLocalInt(OBJECT_SELF, "SFPacked1_286", 0x5e4000ef); // Pulse Cold
    SetLocalInt(OBJECT_SELF, "SFPacked1_287", 0x5f4000ef); // Pulse Negative
    SetLocalInt(OBJECT_SELF, "SFPacked1_288", 0x5ea000ef); // Pulse Holy
    SetLocalInt(OBJECT_SELF, "SFPacked1_289", 0x5f4000ef); // Pulse Death
    SetLocalInt(OBJECT_SELF, "SFPacked1_29", 0x580074be); // Create Greater Undead
    SetLocalInt(OBJECT_SELF, "SFPacked1_290", 0x5f4000ef); // Pulse Level Drain
    SetLocalInt(OBJECT_SELF, "SFPacked1_291", 0x5f4000ef); // Pulse Ability Drain Intelligence
    SetLocalInt(OBJECT_SELF, "SFPacked1_292", 0x5f4000ef); // Pulse Ability Drain Charisma
    SetLocalInt(OBJECT_SELF, "SFPacked1_293", 0x5f4000ef); // Pulse Ability Drain Constitution
    SetLocalInt(OBJECT_SELF, "SFPacked1_294", 0x5f4000ef); // Pulse Ability Drain Dexterity
    SetLocalInt(OBJECT_SELF, "SFPacked1_295", 0x5f4000ef); // Pulse Ability Drain Strength
    SetLocalInt(OBJECT_SELF, "SFPacked1_296", 0x5f4000ef); // Pulse Ability Drain Wisdom
    SetLocalInt(OBJECT_SELF, "SFPacked1_297", 0x5f8000ef); // Pulse Poison
    SetLocalInt(OBJECT_SELF, "SFPacked1_298", 0x5e8000ef); // Pulse Disease
    SetLocalInt(OBJECT_SELF, "SFPacked1_299", 0x5200012d); // Rage 3
    SetLocalInt(OBJECT_SELF, "SFPacked1_3", 0x56007506); // Barkskin
    SetLocalInt(OBJECT_SELF, "SFPacked1_30", 0x580074be); // Create Undead
    SetLocalInt(OBJECT_SELF, "SFPacked1_300", 0x5200012d); // Rage 4
    SetLocalInt(OBJECT_SELF, "SFPacked1_301", 0x5200012d); // Rage 5
    SetLocalInt(OBJECT_SELF, "SFPacked1_302", 0x540000ec); // Smoke Claw
    SetLocalInt(OBJECT_SELF, "SFPacked1_303", 0x5800002e); // Summon Slaad
    SetLocalInt(OBJECT_SELF, "SFPacked1_304", 0x5800002e); // Summon Tanarri
    SetLocalInt(OBJECT_SELF, "SFPacked1_305", 0x55a0002c); // Trumpet Blast
    SetLocalInt(OBJECT_SELF, "SFPacked1_306", 0x5580012d); // Tyrant Fog Mist
    SetLocalInt(OBJECT_SELF, "SFPacked1_307", 0x1200012d); // BARBARIAN RAGE
    SetLocalInt(OBJECT_SELF, "SFPacked1_308", 0x12a0006d); // Turn Undead
    SetLocalInt(OBJECT_SELF, "SFPacked1_309", 0x1200012d); // Wholeness of Body
    SetLocalInt(OBJECT_SELF, "SFPacked1_31", 0x57607afe); // Cure Critical Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked1_310", 0x140000ed); // Quivering Palm
    SetLocalInt(OBJECT_SELF, "SFPacked1_311", 0x1200012d); // Empty Body
    SetLocalInt(OBJECT_SELF, "SFPacked1_312", 0x1e00006c); // Detect Evil
    SetLocalInt(OBJECT_SELF, "SFPacked1_313", 0x060000ed); // Lay On Hands
    SetLocalInt(OBJECT_SELF, "SFPacked1_314", 0x1200012c); // Aura Of Courage
    SetLocalInt(OBJECT_SELF, "SFPacked1_315", 0x1400012d); // Smite Evil
    SetLocalInt(OBJECT_SELF, "SFPacked1_316", 0x160000ed); // Remove Disease
    SetLocalInt(OBJECT_SELF, "SFPacked1_317", 0x180000ad); // Summon Animal Companion
    SetLocalInt(OBJECT_SELF, "SFPacked1_318", 0x180000ad); // Summon Familiar
    SetLocalInt(OBJECT_SELF, "SFPacked1_319", 0x1200012d); // Elemental Shape
    SetLocalInt(OBJECT_SELF, "SFPacked1_32", 0x57607afe); // Cure Light Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked1_320", 0x0200012d); // Wild Shape
    SetLocalInt(OBJECT_SELF, "SFPacked1_321", 0x560074ce); // PROTECTION FROM ALIGNMENT
    SetLocalInt(OBJECT_SELF, "SFPacked1_322", 0x560074ce); // Magic Circle against Alignment
    SetLocalInt(OBJECT_SELF, "SFPacked1_323", 0x52007f0f); // Aura versus Alignment
    SetLocalInt(OBJECT_SELF, "SFPacked1_324", 0x58006096); // SHADES Summon Shadow
    SetLocalInt(OBJECT_SELF, "SFPacked1_325", 0x560000ce); // DELETED PRO Cold
    SetLocalInt(OBJECT_SELF, "SFPacked1_326", 0x560000ce); // DELETED PRO Fire
    SetLocalInt(OBJECT_SELF, "SFPacked1_327", 0x560000ce); // DELETED PRO Acid
    SetLocalInt(OBJECT_SELF, "SFPacked1_328", 0x560000ce); // DELETED PRO Sonic
    SetLocalInt(OBJECT_SELF, "SFPacked1_329", 0x560000ce); // DELETED PRO Elec
    SetLocalInt(OBJECT_SELF, "SFPacked1_33", 0x576070fe); // Cure Minor Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked1_330", 0x560000ce); // DELETED END Cold
    SetLocalInt(OBJECT_SELF, "SFPacked1_331", 0x560000ce); // DELETED END Fire
    SetLocalInt(OBJECT_SELF, "SFPacked1_332", 0x560000ce); // DELETED END Acid
    SetLocalInt(OBJECT_SELF, "SFPacked1_333", 0x560000ce); // DELETED END Sonic
    SetLocalInt(OBJECT_SELF, "SFPacked1_334", 0x560000ce); // DELETED END Elec
    SetLocalInt(OBJECT_SELF, "SFPacked1_335", 0x560000ce); // DELETED RES Cold
    SetLocalInt(OBJECT_SELF, "SFPacked1_336", 0x560000ce); // DELETED RES Fire
    SetLocalInt(OBJECT_SELF, "SFPacked1_337", 0x560000ce); // DELETED RES Acid
    SetLocalInt(OBJECT_SELF, "SFPacked1_338", 0x560000ce); // DELETED RES Sonic
    SetLocalInt(OBJECT_SELF, "SFPacked1_339", 0x560000ce); // DELETED RES Elec
    SetLocalInt(OBJECT_SELF, "SFPacked1_34", 0x57607afe); // Cure Moderate Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked1_340", 0x7c506076); // SHADES Cone of Cold
    SetLocalInt(OBJECT_SELF, "SFPacked1_341", 0x7ce46036); // SHADES Fireball
    SetLocalInt(OBJECT_SELF, "SFPacked1_342", 0x560060f6); // SHADES Stoneskin
    SetLocalInt(OBJECT_SELF, "SFPacked1_343", 0x5ce06076); // SHADES Wall of Fire
    SetLocalInt(OBJECT_SELF, "SFPacked1_344", 0x580060b6); // SHADOW CON Summon Shadow
    SetLocalInt(OBJECT_SELF, "SFPacked1_345", 0x5e006036); // SHADOW CON Darkness
    SetLocalInt(OBJECT_SELF, "SFPacked1_346", 0x560060f6); // SHADOW CON Inivsibility
    SetLocalInt(OBJECT_SELF, "SFPacked1_347", 0x560060f6); // SHADOW CON Mage Armor
    SetLocalInt(OBJECT_SELF, "SFPacked1_348", 0x74006036); // SHADOW CON Magic Missile
    SetLocalInt(OBJECT_SELF, "SFPacked1_349", 0x580060b6); // GR SHADOW CON Summon Shadow
    SetLocalInt(OBJECT_SELF, "SFPacked1_35", 0x57607afe); // Cure Serious Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked1_350", 0x54206036); // GR SHADOW CON Acid Arrow
    SetLocalInt(OBJECT_SELF, "SFPacked1_351", 0x52006136); // GR SHADOW CON Ghostly Visage
    SetLocalInt(OBJECT_SELF, "SFPacked1_352", 0x5c046076); // GR SHADOW CON Web
    SetLocalInt(OBJECT_SELF, "SFPacked1_353", 0x52006136); // GR SHADOW CON Minor Globe
    SetLocalInt(OBJECT_SELF, "SFPacked1_354", 0x56007f06); // Eagle Splendor
    SetLocalInt(OBJECT_SELF, "SFPacked1_355", 0x56007f06); // Owls Wisdom
    SetLocalInt(OBJECT_SELF, "SFPacked1_356", 0x56007f06); // Foxs Cunning
    SetLocalInt(OBJECT_SELF, "SFPacked1_357", 0x56007f06); // Greater Eagle Splendor
    SetLocalInt(OBJECT_SELF, "SFPacked1_358", 0x56007f06); // Greater Owls Wisdom
    SetLocalInt(OBJECT_SELF, "SFPacked1_359", 0x56007f06); // Greater Foxs Cunning
    SetLocalInt(OBJECT_SELF, "SFPacked1_36", 0x5e00342a); // Darkness
    SetLocalInt(OBJECT_SELF, "SFPacked1_360", 0x56007f06); // Greater Bulls Strength
    SetLocalInt(OBJECT_SELF, "SFPacked1_361", 0x56007f06); // Greater Cats Grace
    SetLocalInt(OBJECT_SELF, "SFPacked1_362", 0x56007f06); // Greater Endurance
    SetLocalInt(OBJECT_SELF, "SFPacked1_363", 0x54007b06); // Awaken
    SetLocalInt(OBJECT_SELF, "SFPacked1_364", 0x7e047456); // Creeping Doom
    SetLocalInt(OBJECT_SELF, "SFPacked1_365", 0x16006506); // Ultravision
    SetLocalInt(OBJECT_SELF, "SFPacked1_366", 0x540470be); // Destruction
    SetLocalInt(OBJECT_SELF, "SFPacked1_367", 0x5c047a3e); // Horrid Wilting
    SetLocalInt(OBJECT_SELF, "SFPacked1_368", 0x7c007a2e); // Ice Storm
    SetLocalInt(OBJECT_SELF, "SFPacked1_369", 0x1200750e); // Energy Buffer
    SetLocalInt(OBJECT_SELF, "SFPacked1_37", 0x55247426); // Daze
    SetLocalInt(OBJECT_SELF, "SFPacked1_370", 0x5c047a7e); // Negative Energy Burst
    SetLocalInt(OBJECT_SELF, "SFPacked1_371", 0x54007a7e); // Negative Energy Ray
    SetLocalInt(OBJECT_SELF, "SFPacked1_372", 0x5e007506); // Aura of Vitality
    SetLocalInt(OBJECT_SELF, "SFPacked1_373", 0x12007526); // War Cry
    SetLocalInt(OBJECT_SELF, "SFPacked1_374", 0x560074fe); // Regenerate
    SetLocalInt(OBJECT_SELF, "SFPacked1_375", 0x7c047e56); // Evards Black Tentacles
    SetLocalInt(OBJECT_SELF, "SFPacked1_376", 0x1200751e); // Legend Lore
    SetLocalInt(OBJECT_SELF, "SFPacked1_377", 0x1200751e); // Find Traps
    SetLocalInt(OBJECT_SELF, "SFPacked1_378", 0x58040096); // Summon Mephit
    SetLocalInt(OBJECT_SELF, "SFPacked1_379", 0x58040296); // Summon Celestial
    SetLocalInt(OBJECT_SELF, "SFPacked1_38", 0x560074fe); // Death Ward
    SetLocalInt(OBJECT_SELF, "SFPacked1_380", 0x02000517); // Battle Mastery Spell
    SetLocalInt(OBJECT_SELF, "SFPacked1_381", 0x02000717); // Divine Strength
    SetLocalInt(OBJECT_SELF, "SFPacked1_382", 0x02000917); // Divine Protection
    SetLocalInt(OBJECT_SELF, "SFPacked1_383", 0x02000b17); // Negative Plane Avatar
    SetLocalInt(OBJECT_SELF, "SFPacked1_384", 0x02000d17); // Divine Trickery
    SetLocalInt(OBJECT_SELF, "SFPacked1_385", 0x02000f16); // Rogues Cunning
    SetLocalInt(OBJECT_SELF, "SFPacked1_386", 0xfe001091); // ACTIVATE ITEM
    SetLocalInt(OBJECT_SELF, "SFPacked1_387", 0x12000142); // Polymorph SwordSpider
    SetLocalInt(OBJECT_SELF, "SFPacked1_388", 0x12000142); // Polymorph Ogre
    SetLocalInt(OBJECT_SELF, "SFPacked1_389", 0x12000142); // Polymorph UMBER HULK
    SetLocalInt(OBJECT_SELF, "SFPacked1_39", 0x7ce47e6e); // Delayed Blast Fireball
    SetLocalInt(OBJECT_SELF, "SFPacked1_390", 0x12000142); // Polymorph Satyr
    SetLocalInt(OBJECT_SELF, "SFPacked1_391", 0x12000142); // Polymorph Ooze
    SetLocalInt(OBJECT_SELF, "SFPacked1_392", 0x12000142); // Shapechange RED DRAGON
    SetLocalInt(OBJECT_SELF, "SFPacked1_393", 0x12000142); // Shapechange FIRE GIANT
    SetLocalInt(OBJECT_SELF, "SFPacked1_394", 0x12000142); // Shapechange BALOR
    SetLocalInt(OBJECT_SELF, "SFPacked1_395", 0x12000142); // Shapechange DEATH SLAAD
    SetLocalInt(OBJECT_SELF, "SFPacked1_396", 0x12000142); // Shapechange IRON GOLEM
    SetLocalInt(OBJECT_SELF, "SFPacked1_397", 0x02000141); // Elemental Shape FIRE
    SetLocalInt(OBJECT_SELF, "SFPacked1_398", 0x02000141); // Elemental Shape WATER
    SetLocalInt(OBJECT_SELF, "SFPacked1_399", 0x02000141); // Elemental Shape EARTH
    SetLocalInt(OBJECT_SELF, "SFPacked1_4", 0x54007106); // Bestow Curse
    SetLocalInt(OBJECT_SELF, "SFPacked1_40", 0x5c00708e); // Dismissal
    SetLocalInt(OBJECT_SELF, "SFPacked1_400", 0x02000141); // Elemental Shape AIR
    SetLocalInt(OBJECT_SELF, "SFPacked1_401", 0x02000141); // Wild Shape BROWN BEAR
    SetLocalInt(OBJECT_SELF, "SFPacked1_402", 0x02000141); // Wild Shape PANTHER
    SetLocalInt(OBJECT_SELF, "SFPacked1_403", 0x02000141); // Wild Shape WOLF
    SetLocalInt(OBJECT_SELF, "SFPacked1_404", 0x02000141); // Wild Shape BOAR
    SetLocalInt(OBJECT_SELF, "SFPacked1_405", 0x02000141); // Wild Shape BADGER
    SetLocalInt(OBJECT_SELF, "SFPacked1_406", 0x02000145); // Special Alcohol Beer
    SetLocalInt(OBJECT_SELF, "SFPacked1_407", 0x02000145); // Special Alcohol Wine
    SetLocalInt(OBJECT_SELF, "SFPacked1_408", 0x02000145); // Special Alcohol Spirits
    SetLocalInt(OBJECT_SELF, "SFPacked1_409", 0x02000145); // Special Herb Belladonna
    SetLocalInt(OBJECT_SELF, "SFPacked1_41", 0x5e10704e); // Dispel Magic
    SetLocalInt(OBJECT_SELF, "SFPacked1_410", 0x02000145); // Special Herb Garlic
    SetLocalInt(OBJECT_SELF, "SFPacked1_411", 0x0240012b); // Bards Song
    SetLocalInt(OBJECT_SELF, "SFPacked1_412", 0x02c00129); // Aura Fear Dragon
    SetLocalInt(OBJECT_SELF, "SFPacked1_413", 0x02001091); // ACTIVATE ITEM SELF
    SetLocalInt(OBJECT_SELF, "SFPacked1_414", 0x1330752e); // Divine Favor
    SetLocalInt(OBJECT_SELF, "SFPacked1_415", 0x1330311a); // True Strike
    SetLocalInt(OBJECT_SELF, "SFPacked1_416", 0x7440346a); // Flare
    SetLocalInt(OBJECT_SELF, "SFPacked1_417", 0x1200750e); // Shield
    SetLocalInt(OBJECT_SELF, "SFPacked1_418", 0x1200750e); // Entropic Shield
    SetLocalInt(OBJECT_SELF, "SFPacked1_419", 0x500070ee); // Continual Flame
    SetLocalInt(OBJECT_SELF, "SFPacked1_42", 0x1200752e); // Divine Power
    SetLocalInt(OBJECT_SELF, "SFPacked1_420", 0x12007546); // One With The Land
    SetLocalInt(OBJECT_SELF, "SFPacked1_421", 0x12007546); // Camoflage
    SetLocalInt(OBJECT_SELF, "SFPacked1_422", 0x12007546); // Blood Frenzy
    SetLocalInt(OBJECT_SELF, "SFPacked1_423", 0x7c007a16); // Bombardment
    SetLocalInt(OBJECT_SELF, "SFPacked1_424", 0x74307a56); // Acid Splash
    SetLocalInt(OBJECT_SELF, "SFPacked1_425", 0x74307ac6); // Quillfire
    SetLocalInt(OBJECT_SELF, "SFPacked1_426", 0x12007a2e); // Earthquake
    SetLocalInt(OBJECT_SELF, "SFPacked1_427", 0x7ca07a6e); // Sunburst
    SetLocalInt(OBJECT_SELF, "SFPacked1_428", 0x12001091); // ACTIVATE ITEM SELF2
    SetLocalInt(OBJECT_SELF, "SFPacked1_429", 0x13307546); // AuraOfGlory
    SetLocalInt(OBJECT_SELF, "SFPacked1_43", 0x55307466); // Dominate Animal
    SetLocalInt(OBJECT_SELF, "SFPacked1_430", 0x5c00708e); // Banishment
    SetLocalInt(OBJECT_SELF, "SFPacked1_431", 0x774070fe); // Inflict Minor Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked1_432", 0x77407afe); // Inflict Light Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked1_433", 0x77407afe); // Inflict Moderate Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked1_434", 0x77407afe); // Inflict Serious Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked1_435", 0x77407afe); // Inflict Critical Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked1_436", 0x12007146); // BalagarnsIronHorn
    SetLocalInt(OBJECT_SELF, "SFPacked1_437", 0x141070c6); // Drown
    SetLocalInt(OBJECT_SELF, "SFPacked1_438", 0x56007506); // Owls Insight
    SetLocalInt(OBJECT_SELF, "SFPacked1_439", 0x75007a6e); // Electric Jolt
    SetLocalInt(OBJECT_SELF, "SFPacked1_44", 0x55307466); // Dominate Monster
    SetLocalInt(OBJECT_SELF, "SFPacked1_440", 0x7ce07a6e); // Firebrand
    SetLocalInt(OBJECT_SELF, "SFPacked1_441", 0x13a07f0e); // Wounding Whispers
    SetLocalInt(OBJECT_SELF, "SFPacked1_442", 0x56007506); // Amplify
    SetLocalInt(OBJECT_SELF, "SFPacked1_443", 0x12007506); // Etherealness
    SetLocalInt(OBJECT_SELF, "SFPacked1_444", 0x5f30740e); // Undeaths Eternal Foe
    SetLocalInt(OBJECT_SELF, "SFPacked1_445", 0x1224742e); // Dirge
    SetLocalInt(OBJECT_SELF, "SFPacked1_446", 0x74e47ec6); // Inferno
    SetLocalInt(OBJECT_SELF, "SFPacked1_447", 0x3c007a2e); // Isaacs Lesser Missile Storm
    SetLocalInt(OBJECT_SELF, "SFPacked1_448", 0x3c007a2e); // Isaacs Greater Missile Storm
    SetLocalInt(OBJECT_SELF, "SFPacked1_449", 0x5f307426); // Bane
    SetLocalInt(OBJECT_SELF, "SFPacked1_45", 0x55307466); // Dominate Person
    SetLocalInt(OBJECT_SELF, "SFPacked1_450", 0x560074ce); // Shield of Faith
    SetLocalInt(OBJECT_SELF, "SFPacked1_451", 0x5c007496); // Planar Ally
    SetLocalInt(OBJECT_SELF, "SFPacked1_452", 0x120074d6); // Magic Fang
    SetLocalInt(OBJECT_SELF, "SFPacked1_453", 0x120074d6); // Greater Magic Fang
    SetLocalInt(OBJECT_SELF, "SFPacked1_454", 0x5c047446); // Spike Growth
    SetLocalInt(OBJECT_SELF, "SFPacked1_455", 0x5f307446); // Mass Camoflage
    SetLocalInt(OBJECT_SELF, "SFPacked1_456", 0x12007546); // Expeditious Retreat
    SetLocalInt(OBJECT_SELF, "SFPacked1_457", 0x74007ea6); // Tashas Hideous Laughter
    SetLocalInt(OBJECT_SELF, "SFPacked1_458", 0x560034f2); // Displacement
    SetLocalInt(OBJECT_SELF, "SFPacked1_459", 0x7404742e); // Bigbys Interposing Hand
    SetLocalInt(OBJECT_SELF, "SFPacked1_46", 0x55307466); // Doom
    SetLocalInt(OBJECT_SELF, "SFPacked1_460", 0x7404742e); // Bigbys Forceful Hand
    SetLocalInt(OBJECT_SELF, "SFPacked1_461", 0x7404742e); // Bigbys Grasping Hand
    SetLocalInt(OBJECT_SELF, "SFPacked1_462", 0x74047e2e); // Bigbys Clenched Fist
    SetLocalInt(OBJECT_SELF, "SFPacked1_463", 0x7405fe2e); // Bigbys Crushing Hand
    SetLocalInt(OBJECT_SELF, "SFPacked1_464", 0x7cfc0085); // Grenade Fire
    SetLocalInt(OBJECT_SELF, "SFPacked1_465", 0x741c0085); // Grenade Tangle
    SetLocalInt(OBJECT_SELF, "SFPacked1_466", 0x7cbc0085); // Grenade Holy
    SetLocalInt(OBJECT_SELF, "SFPacked1_467", 0x7c1c0085); // Grenade Choking
    SetLocalInt(OBJECT_SELF, "SFPacked1_468", 0x7c1c0085); // Grenade Thunderstone
    SetLocalInt(OBJECT_SELF, "SFPacked1_469", 0x7c3c0085); // Grenade Acid
    SetLocalInt(OBJECT_SELF, "SFPacked1_47", 0x12e0752e); // Elemental Shield
    SetLocalInt(OBJECT_SELF, "SFPacked1_470", 0x7c1c0085); // Grenade Chicken
    SetLocalInt(OBJECT_SELF, "SFPacked1_471", 0x7c1c00c5); // Grenade Caltrops
    SetLocalInt(OBJECT_SELF, "SFPacked1_472", 0x02000091); // ACTIVATE ITEM PORTAL
    SetLocalInt(OBJECT_SELF, "SFPacked1_473", 0x1200006b); // Divine Might
    SetLocalInt(OBJECT_SELF, "SFPacked1_474", 0x1200006b); // Divine Shield
    SetLocalInt(OBJECT_SELF, "SFPacked1_475", 0x55240035); // SHADOW DAZE
    SetLocalInt(OBJECT_SELF, "SFPacked1_476", 0x580000b5); // SUMMON SHADOW
    SetLocalInt(OBJECT_SELF, "SFPacked1_477", 0x12000145); // SHADOW EVADE
    SetLocalInt(OBJECT_SELF, "SFPacked1_478", 0x120000e7); // TYMORAS SMILE
    SetLocalInt(OBJECT_SELF, "SFPacked1_479", 0x120000e7); // CRAFT HARPER ITEM
    SetLocalInt(OBJECT_SELF, "SFPacked1_48", 0x12107456); // Elemental Swarm
    SetLocalInt(OBJECT_SELF, "SFPacked1_480", 0x5d300067); // Sleep
    SetLocalInt(OBJECT_SELF, "SFPacked1_481", 0x56000107); // Cats Grace
    SetLocalInt(OBJECT_SELF, "SFPacked1_482", 0x56000107); // Eagle Splendor
    SetLocalInt(OBJECT_SELF, "SFPacked1_483", 0x560000f7); // Invisibility
    SetLocalInt(OBJECT_SELF, "SFPacked1_485", 0x14107486); // Flesh to stone
    SetLocalInt(OBJECT_SELF, "SFPacked1_486", 0x56007486); // Stone to flesh
    SetLocalInt(OBJECT_SELF, "SFPacked1_487", 0x74187a69); // Trap Arrow
    SetLocalInt(OBJECT_SELF, "SFPacked1_488", 0x74187a69); // Trap Bolt
    SetLocalInt(OBJECT_SELF, "SFPacked1_49", 0x56007f06); // Endurance
    SetLocalInt(OBJECT_SELF, "SFPacked1_493", 0x74187a69); // Trap Dart
    SetLocalInt(OBJECT_SELF, "SFPacked1_494", 0x74187a69); // Trap Shuriken
    SetLocalInt(OBJECT_SELF, "SFPacked1_495", 0x7c0000a9); // Breath Petrify
    SetLocalInt(OBJECT_SELF, "SFPacked1_496", 0x740000e9); // Touch Petrify
    SetLocalInt(OBJECT_SELF, "SFPacked1_497", 0x54000069); // Gaze Petrify
    SetLocalInt(OBJECT_SELF, "SFPacked1_498", 0x5c00006d); // Manticore Spikes
    SetLocalInt(OBJECT_SELF, "SFPacked1_499", 0x7400006d); // RodOfWonder
    SetLocalInt(OBJECT_SELF, "SFPacked1_5", 0x5c107e6e); // Blade Barrier
    SetLocalInt(OBJECT_SELF, "SFPacked1_50", 0x560074ce); // Endure Elements
    SetLocalInt(OBJECT_SELF, "SFPacked1_500", 0x1200002d); // DeckOfManyThings
    SetLocalInt(OBJECT_SELF, "SFPacked1_502", 0x1800006c); // ElementalSummoningItem
    SetLocalInt(OBJECT_SELF, "SFPacked1_503", 0x1200006c); // DeckAvatar
    SetLocalInt(OBJECT_SELF, "SFPacked1_504", 0x7400006c); // Gem Spray
    SetLocalInt(OBJECT_SELF, "SFPacked1_505", 0x7400006c); // Butterfly Spray
    SetLocalInt(OBJECT_SELF, "SFPacked1_507", 0x12001091); // PowerStone
    SetLocalInt(OBJECT_SELF, "SFPacked1_508", 0x12001091); // Spellstaff
    SetLocalInt(OBJECT_SELF, "SFPacked1_509", 0x100000a1); // Charger
    SetLocalInt(OBJECT_SELF, "SFPacked1_51", 0x55447abe); // Energy Drain
    SetLocalInt(OBJECT_SELF, "SFPacked1_510", 0x100000a1); // Decharger
    SetLocalInt(OBJECT_SELF, "SFPacked1_511", 0x7c080045); // Kobold Jump
    SetLocalInt(OBJECT_SELF, "SFPacked1_512", 0x74007a86); // Crumble
    SetLocalInt(OBJECT_SELF, "SFPacked1_513", 0x14807efe); // Infestation of Maggots
    SetLocalInt(OBJECT_SELF, "SFPacked1_514", 0x55407afe); // Healing Sting
    SetLocalInt(OBJECT_SELF, "SFPacked1_515", 0x7da4706e); // Great Thunderclap
    SetLocalInt(OBJECT_SELF, "SFPacked1_516", 0x75047a6e); // Ball Lightning
    SetLocalInt(OBJECT_SELF, "SFPacked1_517", 0x13247546); // Battletide
    SetLocalInt(OBJECT_SELF, "SFPacked1_518", 0x54e07aee); // Combust
    SetLocalInt(OBJECT_SELF, "SFPacked1_519", 0x1200753e); // Death Armor
    SetLocalInt(OBJECT_SELF, "SFPacked1_52", 0x55447abe); // Enervation
    SetLocalInt(OBJECT_SELF, "SFPacked1_520", 0x1d187aae); // Gedlees Electric Loop
    SetLocalInt(OBJECT_SELF, "SFPacked1_521", 0x75b07aae); // Horizikauls Boom
    SetLocalInt(OBJECT_SELF, "SFPacked1_522", 0x560074ce); // Ironguts
    SetLocalInt(OBJECT_SELF, "SFPacked1_523", 0x7c207a96); // Mestils Acid Breath
    SetLocalInt(OBJECT_SELF, "SFPacked1_524", 0x12207516); // Mestils Acid Sheath
    SetLocalInt(OBJECT_SELF, "SFPacked1_525", 0x160074d6); // Monstrous Regeneration
    SetLocalInt(OBJECT_SELF, "SFPacked1_526", 0x7d047a6e); // Scintillating Sphere
    SetLocalInt(OBJECT_SELF, "SFPacked1_527", 0x56007506); // Stone Bones
    SetLocalInt(OBJECT_SELF, "SFPacked1_528", 0x7c107a7e); // Undeath to Death
    SetLocalInt(OBJECT_SELF, "SFPacked1_529", 0x5e007456); // Vine Mine
    SetLocalInt(OBJECT_SELF, "SFPacked1_53", 0x5c047446); // Entangle
    SetLocalInt(OBJECT_SELF, "SFPacked1_530", 0x5e047486); // Vine Mine Entangle
    SetLocalInt(OBJECT_SELF, "SFPacked1_531", 0x5e047456); // Vine Mine Hamper Movement
    SetLocalInt(OBJECT_SELF, "SFPacked1_532", 0x5e007456); // Vine Mine Camouflage
    SetLocalInt(OBJECT_SELF, "SFPacked1_533", 0x58007496); // Black Blade of Disaster
    SetLocalInt(OBJECT_SELF, "SFPacked1_534", 0x580072ae); // Shelgarns Persistent Blade
    SetLocalInt(OBJECT_SELF, "SFPacked1_535", 0x16007506); // Blade Thirst
    SetLocalInt(OBJECT_SELF, "SFPacked1_536", 0x16007506); // Deafening Clang
    SetLocalInt(OBJECT_SELF, "SFPacked1_537", 0x16007506); // Bless Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked1_538", 0x160074ee); // Holy Sword
    SetLocalInt(OBJECT_SELF, "SFPacked1_539", 0x16007506); // Keen Edge
    SetLocalInt(OBJECT_SELF, "SFPacked1_54", 0x5cc4747e); // Fear
    SetLocalInt(OBJECT_SELF, "SFPacked1_541", 0x16007506); // Blackstaff
    SetLocalInt(OBJECT_SELF, "SFPacked1_542", 0x160074ee); // Flame Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked1_543", 0x74447aae); // Ice Dagger
    SetLocalInt(OBJECT_SELF, "SFPacked1_544", 0x16007506); // Magic Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked1_545", 0x16007506); // Greater Magic Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked1_546", 0x16007506); // Magic Vestment
    SetLocalInt(OBJECT_SELF, "SFPacked1_547", 0x5d247e56); // Stonehold
    SetLocalInt(OBJECT_SELF, "SFPacked1_548", 0x160074ee); // Darkfire
    SetLocalInt(OBJECT_SELF, "SFPacked1_549", 0x7da47e8e); // Glyph of Warding
    SetLocalInt(OBJECT_SELF, "SFPacked1_55", 0x55387e5e); // Feeblemind
    SetLocalInt(OBJECT_SELF, "SFPacked1_551", 0x7c0000ad); // MONSTER MindBlast
    SetLocalInt(OBJECT_SELF, "SFPacked1_552", 0x141000a6); // MONSTER CharmMonster
    SetLocalInt(OBJECT_SELF, "SFPacked1_553", 0x7ce4002e); // Goblin Ballista Fireball
    SetLocalInt(OBJECT_SELF, "SFPacked1_554", 0x020000ce); // Ioun Stone Dusty Rose
    SetLocalInt(OBJECT_SELF, "SFPacked1_555", 0x020000ce); // Ioun Stone Pale Blue
    SetLocalInt(OBJECT_SELF, "SFPacked1_556", 0x020000ce); // Ioun Stone Scarlet Blue
    SetLocalInt(OBJECT_SELF, "SFPacked1_557", 0x020000ce); // Ioun Stone Blue
    SetLocalInt(OBJECT_SELF, "SFPacked1_558", 0x020000ce); // Ioun Stone Deep Red
    SetLocalInt(OBJECT_SELF, "SFPacked1_559", 0x020000ce); // Ioun Stone Pink
    SetLocalInt(OBJECT_SELF, "SFPacked1_56", 0x14647abe); // Finger of Death
    SetLocalInt(OBJECT_SELF, "SFPacked1_560", 0x020000ce); // Ioun Stone Pink Green
    SetLocalInt(OBJECT_SELF, "SFPacked1_561", 0x0200012d); // Whirlwind
    SetLocalInt(OBJECT_SELF, "SFPacked1_562", 0x03300146); // AuraOfGlory X2
    SetLocalInt(OBJECT_SELF, "SFPacked1_563", 0x561000c6); // Haste Slow X2
    SetLocalInt(OBJECT_SELF, "SFPacked1_564", 0x580000be); // Summon Shadow X2
    SetLocalInt(OBJECT_SELF, "SFPacked1_565", 0x7c003b2a); // Tide of Battle
    SetLocalInt(OBJECT_SELF, "SFPacked1_566", 0x1c043082); // Evil Blight
    SetLocalInt(OBJECT_SELF, "SFPacked1_567", 0x57607ad6); // Cure Critical Wounds Others
    SetLocalInt(OBJECT_SELF, "SFPacked1_568", 0x560070d6); // Restoration Others
    SetLocalInt(OBJECT_SELF, "SFPacked1_569", 0x5d8474ae); // Cloud of Bewilderment
    SetLocalInt(OBJECT_SELF, "SFPacked1_57", 0x0ae07b2e); // Fire Storm
    SetLocalInt(OBJECT_SELF, "SFPacked1_58", 0x7ce47a2e); // Fireball
    SetLocalInt(OBJECT_SELF, "SFPacked1_59", 0x74e07a16); // Flame Arrow
    SetLocalInt(OBJECT_SELF, "SFPacked1_595", 0x75400097); // BGSummonLesserFiend
    SetLocalInt(OBJECT_SELF, "SFPacked1_596", 0x75400097); // BGSummonGreaterFiend
    SetLocalInt(OBJECT_SELF, "SFPacked1_597", 0x5d400097); // BGNightmare
    SetLocalInt(OBJECT_SELF, "SFPacked1_6", 0x5f307426); // Bless
    SetLocalInt(OBJECT_SELF, "SFPacked1_60", 0x74e07aae); // Flame Lash
    SetLocalInt(OBJECT_SELF, "SFPacked1_600", 0x0200012f); // ARImbueArrow
    SetLocalInt(OBJECT_SELF, "SFPacked1_601", 0x7414002f); // ARSeekerArrow
    SetLocalInt(OBJECT_SELF, "SFPacked1_602", 0x7414002f); // ARSeekerArrow2
    SetLocalInt(OBJECT_SELF, "SFPacked1_603", 0x12000147); // ARHailOfArrows
    SetLocalInt(OBJECT_SELF, "SFPacked1_604", 0x7404002f); // ARArrowOfDeath
    SetLocalInt(OBJECT_SELF, "SFPacked1_605", 0x12000137); // ASGhostlyVisage
    SetLocalInt(OBJECT_SELF, "SFPacked1_606", 0x5e00002b); // ASDarkness
    SetLocalInt(OBJECT_SELF, "SFPacked1_607", 0x560000f7); // ASInvisibility
    SetLocalInt(OBJECT_SELF, "SFPacked1_608", 0x560000f7); // ASImprovedInvisibility
    SetLocalInt(OBJECT_SELF, "SFPacked1_609", 0x580000bf); // BGCreateDead
    SetLocalInt(OBJECT_SELF, "SFPacked1_61", 0x7ce07a6e); // Flame Strike
    SetLocalInt(OBJECT_SELF, "SFPacked1_610", 0x5d407497); // BGFiendish
    SetLocalInt(OBJECT_SELF, "SFPacked1_611", 0x754000ff); // BGInflictSerious
    SetLocalInt(OBJECT_SELF, "SFPacked1_612", 0x754000ff); // BGInflictCritical
    SetLocalInt(OBJECT_SELF, "SFPacked1_613", 0x548000ff); // BK Contagion
    SetLocalInt(OBJECT_SELF, "SFPacked1_614", 0x56000107); // BK BullsStrength
    SetLocalInt(OBJECT_SELF, "SFPacked1_615", 0x1200008d); // Twinfists
    SetLocalInt(OBJECT_SELF, "SFPacked1_616", 0x0200008d); // LichLyrics
    SetLocalInt(OBJECT_SELF, "SFPacked1_617", 0x5400008d); // Iceberry
    SetLocalInt(OBJECT_SELF, "SFPacked1_618", 0x5400008d); // Flameberry
    SetLocalInt(OBJECT_SELF, "SFPacked1_619", 0x1000008d); // PrayerBox
    SetLocalInt(OBJECT_SELF, "SFPacked1_62", 0x7600744e); // Freedom of Movement
    SetLocalInt(OBJECT_SELF, "SFPacked1_620", 0x7c080045); // Flying Debris
    SetLocalInt(OBJECT_SELF, "SFPacked1_622", 0x02000147); // DC Divine Wrath
    SetLocalInt(OBJECT_SELF, "SFPacked1_623", 0x580000bf); // PM Animate Dead
    SetLocalInt(OBJECT_SELF, "SFPacked1_624", 0x58000097); // PM Summon Undead
    SetLocalInt(OBJECT_SELF, "SFPacked1_625", 0x052000ef); // PM Undead Graft1
    SetLocalInt(OBJECT_SELF, "SFPacked1_626", 0x052000ef); // PM Undead Graft2
    SetLocalInt(OBJECT_SELF, "SFPacked1_627", 0x58000097); // PM Summon Greater Undead
    SetLocalInt(OBJECT_SELF, "SFPacked1_628", 0x046000ef); // PM Deathless Master Touch
    SetLocalInt(OBJECT_SELF, "SFPacked1_63", 0x58007456); // Gate
    SetLocalInt(OBJECT_SELF, "SFPacked1_636", 0x7c147e6f); // Hellball
    SetLocalInt(OBJECT_SELF, "SFPacked1_637", 0x0a007e97); // Mummy Dust
    SetLocalInt(OBJECT_SELF, "SFPacked1_638", 0x0a007e97); // Dragon Knight
    SetLocalInt(OBJECT_SELF, "SFPacked1_639", 0x02007f3f); // Epic Mage Armor
    SetLocalInt(OBJECT_SELF, "SFPacked1_64", 0x558074fe); // Ghoul Touch
    SetLocalInt(OBJECT_SELF, "SFPacked1_640", 0x64007e6f); // Ruin
    SetLocalInt(OBJECT_SELF, "SFPacked1_641", 0x02007f2d); // DWDEF Defensive Stance
    SetLocalInt(OBJECT_SELF, "SFPacked1_642", 0x02007f45); // Mighty Rage
    SetLocalInt(OBJECT_SELF, "SFPacked1_643", 0x02a07e6d); // PlanarTurning
    SetLocalInt(OBJECT_SELF, "SFPacked1_644", 0x02a07f2b); // Curse Song
    SetLocalInt(OBJECT_SELF, "SFPacked1_645", 0x02007f2d); // Improved Whirlwind
    SetLocalInt(OBJECT_SELF, "SFPacked1_646", 0x02000141); // Greater Wild Shape 1
    SetLocalInt(OBJECT_SELF, "SFPacked1_647", 0x0200012d); // Epic Blinding speed
    SetLocalInt(OBJECT_SELF, "SFPacked1_648", 0x100000e6); // Dye Armor cloth1
    SetLocalInt(OBJECT_SELF, "SFPacked1_649", 0x100000e6); // Dye Armor Cloth2
    SetLocalInt(OBJECT_SELF, "SFPacked1_65", 0x1200750e); // Globe of Invulnerability
    SetLocalInt(OBJECT_SELF, "SFPacked1_650", 0x100000e6); // Dye Armor Leather1
    SetLocalInt(OBJECT_SELF, "SFPacked1_651", 0x100000e6); // Dye Armor Leather2
    SetLocalInt(OBJECT_SELF, "SFPacked1_652", 0x100000e6); // Dye Armor Metal1
    SetLocalInt(OBJECT_SELF, "SFPacked1_653", 0x100000e6); // Dye Armor Metal2
    SetLocalInt(OBJECT_SELF, "SFPacked1_654", 0x100000e6); // Add Item Property
    SetLocalInt(OBJECT_SELF, "SFPacked1_655", 0x100000e7); // Poison Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked1_656", 0x100000e7); // Craft Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked1_657", 0x100000e7); // Craft Armor
    SetLocalInt(OBJECT_SELF, "SFPacked1_658", 0x02000141); // Greater Wild Shape Wyrmling Red
    SetLocalInt(OBJECT_SELF, "SFPacked1_659", 0x02000141); // Greater Wild Shape Wyrmling Blue
    SetLocalInt(OBJECT_SELF, "SFPacked1_66", 0x5c047416); // Grease
    SetLocalInt(OBJECT_SELF, "SFPacked1_660", 0x02000141); // Greater Wild Shape Wyrmling Black
    SetLocalInt(OBJECT_SELF, "SFPacked1_661", 0x02000141); // Greater Wild Shape Wyrmling White
    SetLocalInt(OBJECT_SELF, "SFPacked1_662", 0x02000141); // Greater Wild Shape Wyrmling Green
    SetLocalInt(OBJECT_SELF, "SFPacked1_663", 0x7c407eed); // WyrmlingPCBreathCold
    SetLocalInt(OBJECT_SELF, "SFPacked1_664", 0x7c207eed); // WyrmlingPCBreathAcid
    SetLocalInt(OBJECT_SELF, "SFPacked1_665", 0x7ce07eed); // WyrmlingPCBreathFire
    SetLocalInt(OBJECT_SELF, "SFPacked1_666", 0x7c207eed); // WyrmlingPCBreathGas
    SetLocalInt(OBJECT_SELF, "SFPacked1_667", 0x7d007eed); // WyrmlingPCBreathLightning
    SetLocalInt(OBJECT_SELF, "SFPacked1_668", 0x16007eec); // ITEM Teleport
    SetLocalInt(OBJECT_SELF, "SFPacked1_669", 0x16007eec); // ITEM Chaos Shield
    SetLocalInt(OBJECT_SELF, "SFPacked1_67", 0x5e04704e); // Greater Dispelling
    SetLocalInt(OBJECT_SELF, "SFPacked1_670", 0x02000141); // Greater Wild Shape Basilisk
    SetLocalInt(OBJECT_SELF, "SFPacked1_671", 0x02000141); // Greater Wild Shape Beholder
    SetLocalInt(OBJECT_SELF, "SFPacked1_672", 0x02000141); // Greater Wild Shape Harpy
    SetLocalInt(OBJECT_SELF, "SFPacked1_673", 0x02000141); // Greater Wild Shape Drider
    SetLocalInt(OBJECT_SELF, "SFPacked1_674", 0x02000141); // Greater Wild Shape Manticore
    SetLocalInt(OBJECT_SELF, "SFPacked1_675", 0x02000141); // Greater Wild Shape 2
    SetLocalInt(OBJECT_SELF, "SFPacked1_676", 0x02000141); // Greater Wild Shape 3
    SetLocalInt(OBJECT_SELF, "SFPacked1_677", 0x02000141); // Greater Wild Shape 4
    SetLocalInt(OBJECT_SELF, "SFPacked1_678", 0x02000141); // Greater Wild Shape Gargoyle
    SetLocalInt(OBJECT_SELF, "SFPacked1_679", 0x02000141); // Greater Wild Shape Medusa
    SetLocalInt(OBJECT_SELF, "SFPacked1_68", 0x500000c6); // Greater Magic Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked1_680", 0x02000141); // Greater Wild Shape Minotaur
    SetLocalInt(OBJECT_SELF, "SFPacked1_681", 0x02000141); // Humanoid Shape
    SetLocalInt(OBJECT_SELF, "SFPacked1_682", 0x02000141); // Humanoid Shape Drow
    SetLocalInt(OBJECT_SELF, "SFPacked1_683", 0x02000141); // Humanoid Shape Lizardfolk
    SetLocalInt(OBJECT_SELF, "SFPacked1_684", 0x02000141); // Humanoid Shape KoboldAssa
    SetLocalInt(OBJECT_SELF, "SFPacked1_685", 0x02000141); // Undead shape
    SetLocalInt(OBJECT_SELF, "SFPacked1_686", 0x03a07eab); // Harpysong
    SetLocalInt(OBJECT_SELF, "SFPacked1_687", 0x1400006d); // GWildShape Stonegaze
    SetLocalInt(OBJECT_SELF, "SFPacked1_688", 0x5e00002a); // GWildShape DriderDarkness
    SetLocalInt(OBJECT_SELF, "SFPacked1_689", 0x160000ec); // SlayRakshasa
    SetLocalInt(OBJECT_SELF, "SFPacked1_69", 0x5c007496); // Greater Planar Binding
    SetLocalInt(OBJECT_SELF, "SFPacked1_690", 0x7ce07eed); // RedDragonDiscipleBreath
    SetLocalInt(OBJECT_SELF, "SFPacked1_691", 0x02000141); // Greater Wild Shape Mindflayer
    SetLocalInt(OBJECT_SELF, "SFPacked1_692", 0x5c00006d); // Greater Wild Shape Spikes
    SetLocalInt(OBJECT_SELF, "SFPacked1_693", 0x7c0000ad); // GWildShape Mindblast
    SetLocalInt(OBJECT_SELF, "SFPacked1_694", 0x02000141); // Greater Wild Shape DireTiger
    SetLocalInt(OBJECT_SELF, "SFPacked1_695", 0x0204006f); // Epic Warding
    SetLocalInt(OBJECT_SELF, "SFPacked1_696", 0x74400068); // OnHitFireDamage
    SetLocalInt(OBJECT_SELF, "SFPacked1_697", 0xfe000011); // ACTIVATE ITEM L
    SetLocalInt(OBJECT_SELF, "SFPacked1_698", 0x7d4000ed); // Dragon Breath Negative
    SetLocalInt(OBJECT_SELF, "SFPacked1_7", 0x50000106); // Bless Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked1_70", 0x560070fe); // Greater Restoration
    SetLocalInt(OBJECT_SELF, "SFPacked1_700", 0xfe000091); // ACTIVATE ITEM ONHITSPELLCAST
    SetLocalInt(OBJECT_SELF, "SFPacked1_701", 0x5800002e); // Summon Baatezu
    SetLocalInt(OBJECT_SELF, "SFPacked1_702", 0x7440006a); // OnHitPlanarRift
    SetLocalInt(OBJECT_SELF, "SFPacked1_703", 0x7440006a); // OnHitDarkfire
    SetLocalInt(OBJECT_SELF, "SFPacked1_704", 0x02000141); // Undead Shape risen lord
    SetLocalInt(OBJECT_SELF, "SFPacked1_705", 0x02000141); // Undead Shape Vampire
    SetLocalInt(OBJECT_SELF, "SFPacked1_706", 0x02000141); // Undead Shape Spectre
    SetLocalInt(OBJECT_SELF, "SFPacked1_707", 0x02000141); // Greater Wild Shape Red dragon
    SetLocalInt(OBJECT_SELF, "SFPacked1_708", 0x02000141); // Greater Wild Shape Blue dragon
    SetLocalInt(OBJECT_SELF, "SFPacked1_709", 0x02000141); // Greater Wild Shape Green dragon
    SetLocalInt(OBJECT_SELF, "SFPacked1_71", 0x5e0060b6); // Greater Shadow Conjuration
    SetLocalInt(OBJECT_SELF, "SFPacked1_710", 0x5d30006d); // EyeballRay0
    SetLocalInt(OBJECT_SELF, "SFPacked1_711", 0x5d30006d); // EyeballRay1
    SetLocalInt(OBJECT_SELF, "SFPacked1_712", 0x5d30006d); // EyeballRay2
    SetLocalInt(OBJECT_SELF, "SFPacked1_713", 0x02000123); // Mindflayer Mindblast 10
    SetLocalInt(OBJECT_SELF, "SFPacked1_715", 0x7404002e); // Golem Ranged Slam
    SetLocalInt(OBJECT_SELF, "SFPacked1_716", 0x5600008f); // SuckBrain
    SetLocalInt(OBJECT_SELF, "SFPacked1_717", 0x02000091); // ACTIVATE ITEM SEQUENCER 1
    SetLocalInt(OBJECT_SELF, "SFPacked1_718", 0x02000091); // ACTIVATE ITEM SEQUENCER 2
    SetLocalInt(OBJECT_SELF, "SFPacked1_719", 0x02000091); // ACTIVATE ITEM SEQUENCER 3
    SetLocalInt(OBJECT_SELF, "SFPacked1_72", 0x5404704e); // Greater Spell Breach
    SetLocalInt(OBJECT_SELF, "SFPacked1_720", 0x02000091); // CLEAR SEQUENCER
    SetLocalInt(OBJECT_SELF, "SFPacked1_721", 0xfe000090); // OnHitFlamingSkin
    SetLocalInt(OBJECT_SELF, "SFPacked1_722", 0x7c080045); // Mimic Eat
    SetLocalInt(OBJECT_SELF, "SFPacked1_724", 0x02003503); // Etherealness
    SetLocalInt(OBJECT_SELF, "SFPacked1_725", 0x02000141); // Dragon Shape
    SetLocalInt(OBJECT_SELF, "SFPacked1_726", 0x7c080045); // Mimic Eat Enemy
    SetLocalInt(OBJECT_SELF, "SFPacked1_727", 0x7c00006c); // Beholder Anti Magic Cone
    SetLocalInt(OBJECT_SELF, "SFPacked1_729", 0x7c080045); // Mimic Steal armor
    SetLocalInt(OBJECT_SELF, "SFPacked1_73", 0x1200710e); // Greater Spell Mantle
    SetLocalInt(OBJECT_SELF, "SFPacked1_731", 0x5c10002d); // Bebelith Web
    SetLocalInt(OBJECT_SELF, "SFPacked1_732", 0x02000141); // Outsider Shape
    SetLocalInt(OBJECT_SELF, "SFPacked1_733", 0x02000141); // Outsider Shape Azer
    SetLocalInt(OBJECT_SELF, "SFPacked1_734", 0x02000141); // Outsider Shape Rakshasa
    SetLocalInt(OBJECT_SELF, "SFPacked1_735", 0x02000141); // Outsider Shape DeathSlaad
    SetLocalInt(OBJECT_SELF, "SFPacked1_736", 0x04000023); // Beholder Special Spell AI
    SetLocalInt(OBJECT_SELF, "SFPacked1_737", 0x02000141); // Construct Shape
    SetLocalInt(OBJECT_SELF, "SFPacked1_738", 0x02000141); // Construct Shape StoneGolem
    SetLocalInt(OBJECT_SELF, "SFPacked1_739", 0x02000141); // Construct Shape DemonFleshGolem
    SetLocalInt(OBJECT_SELF, "SFPacked1_74", 0x12007506); // Greater Stoneskin
    SetLocalInt(OBJECT_SELF, "SFPacked1_740", 0x02000141); // Construct Shape IronGolem
    SetLocalInt(OBJECT_SELF, "SFPacked1_741", 0x020000d5); // Psionic Inertial Barrier
    SetLocalInt(OBJECT_SELF, "SFPacked1_742", 0x020000e7); // Craft Weapon Component
    SetLocalInt(OBJECT_SELF, "SFPacked1_743", 0x020000e7); // Craft Armor Component
    SetLocalInt(OBJECT_SELF, "SFPacked1_744", 0x7cfc0085); // Grenade FireBomb
    SetLocalInt(OBJECT_SELF, "SFPacked1_745", 0x7c3c0085); // Grenade AcidBomb
    SetLocalInt(OBJECT_SELF, "SFPacked1_75", 0x7c10706e); // Gust of Wind
    SetLocalInt(OBJECT_SELF, "SFPacked1_756", 0xfe007ed0); // OnHitBebilithAttack
    SetLocalInt(OBJECT_SELF, "SFPacked1_757", 0x3e007e91); // ShadowBlend
    SetLocalInt(OBJECT_SELF, "SFPacked1_758", 0xfe007ed0); // OnHitDemilichTouch
    SetLocalInt(OBJECT_SELF, "SFPacked1_759", 0x036070fe); // UndeadSelfHarm
    SetLocalInt(OBJECT_SELF, "SFPacked1_76", 0x7ca07a6e); // Hammer of the Gods
    SetLocalInt(OBJECT_SELF, "SFPacked1_760", 0xfe007ed0); // OnHitDracolichTouch
    SetLocalInt(OBJECT_SELF, "SFPacked1_761", 0x12e07f2e); // Aura of Hellfire
    SetLocalInt(OBJECT_SELF, "SFPacked1_762", 0x74e47ec6); // Hell Inferno
    SetLocalInt(OBJECT_SELF, "SFPacked1_763", 0x7c047e6d); // Psionic Mass Concussion
    SetLocalInt(OBJECT_SELF, "SFPacked1_764", 0x5db07e2e); // GlyphOfWardingDefault
    SetLocalInt(OBJECT_SELF, "SFPacked1_767", 0x02007e91); // Intelligent Weapon Talk
    SetLocalInt(OBJECT_SELF, "SFPacked1_768", 0xfe007e90); // Intelligent Weapon OnHit
    SetLocalInt(OBJECT_SELF, "SFPacked1_769", 0x74007eff); // Shadow Attack
    SetLocalInt(OBJECT_SELF, "SFPacked1_77", 0x774070fe); // Harm
    SetLocalInt(OBJECT_SELF, "SFPacked1_770", 0x7c307e6d); // Slaad Chaos Spittle
    SetLocalInt(OBJECT_SELF, "SFPacked1_771", 0x5d207eaf); // Dragon Breath Prismatic
    SetLocalInt(OBJECT_SELF, "SFPacked1_772", 0x7cf47e2e); // Spiral Fireball
    SetLocalInt(OBJECT_SELF, "SFPacked1_773", 0x7c080044); // Battle Boulder Toss
    SetLocalInt(OBJECT_SELF, "SFPacked1_774", 0x020000d1); // Deflecting Force
    SetLocalInt(OBJECT_SELF, "SFPacked1_775", 0x7c080045); // Giant hurl rock
    SetLocalInt(OBJECT_SELF, "SFPacked1_776", 0x04100023); // Beholder Node 1
    SetLocalInt(OBJECT_SELF, "SFPacked1_777", 0x04100023); // Beholder Node 2
    SetLocalInt(OBJECT_SELF, "SFPacked1_778", 0x04100023); // Beholder Node 3
    SetLocalInt(OBJECT_SELF, "SFPacked1_779", 0x04100023); // Beholder Node 4
    SetLocalInt(OBJECT_SELF, "SFPacked1_78", 0x561074c6); // Haste
    SetLocalInt(OBJECT_SELF, "SFPacked1_780", 0x04100023); // Beholder Node 5
    SetLocalInt(OBJECT_SELF, "SFPacked1_783", 0x04100023); // Beholder Node 6
    SetLocalInt(OBJECT_SELF, "SFPacked1_784", 0x04100023); // Beholder Node 7
    SetLocalInt(OBJECT_SELF, "SFPacked1_785", 0x04100023); // Beholder Node 8
    SetLocalInt(OBJECT_SELF, "SFPacked1_786", 0x04100023); // Beholder Node 9
    SetLocalInt(OBJECT_SELF, "SFPacked1_787", 0x04100023); // Beholder Node 10
    SetLocalInt(OBJECT_SELF, "SFPacked1_788", 0xfe007e90); // OnHitParalyze
    SetLocalInt(OBJECT_SELF, "SFPacked1_789", 0x7c007ead); // Illithid Mindblast
    SetLocalInt(OBJECT_SELF, "SFPacked1_79", 0x576070fe); // Heal
    SetLocalInt(OBJECT_SELF, "SFPacked1_790", 0xfe007e90); // OnHitDeafenClang
    SetLocalInt(OBJECT_SELF, "SFPacked1_791", 0xfe007e90); // OnHitKnockDown
    SetLocalInt(OBJECT_SELF, "SFPacked1_792", 0xfe007e90); // OnHitFreeze
    SetLocalInt(OBJECT_SELF, "SFPacked1_793", 0x7c040045); // Demonic Grappling Hand
    SetLocalInt(OBJECT_SELF, "SFPacked1_794", 0x7c087e2e); // Ballista Bolt
    SetLocalInt(OBJECT_SELF, "SFPacked1_795", 0xfe0000d1); // ACTIVATE ITEM T
    SetLocalInt(OBJECT_SELF, "SFPacked1_796", 0x7d007eed); // Dragon Breath Lightning
    SetLocalInt(OBJECT_SELF, "SFPacked1_797", 0x7ce07eed); // Dragon Breath Fire
    SetLocalInt(OBJECT_SELF, "SFPacked1_798", 0x7c207eed); // Dragon Breath Gas
    SetLocalInt(OBJECT_SELF, "SFPacked1_799", 0x02007f36); // Vampire Invisibility
    SetLocalInt(OBJECT_SELF, "SFPacked1_8", 0x54103462); // Blindness and Deafness
    SetLocalInt(OBJECT_SELF, "SFPacked1_80", 0x0b607b3e); // Healing Circle
    SetLocalInt(OBJECT_SELF, "SFPacked1_800", 0x05207ead); // Vampire DominationGaze
    SetLocalInt(OBJECT_SELF, "SFPacked1_801", 0x04e07e6d); // Azer Fire Blast
    SetLocalInt(OBJECT_SELF, "SFPacked1_802", 0x04007eff); // Shifter Spectre Attack
    SetLocalInt(OBJECT_SELF, "SFPacked1_803", 0x04007ead); // SeaHag EvilEye
    SetLocalInt(OBJECT_SELF, "SFPacked1_804", 0x12000129); // Aura HorrificAppearance
    SetLocalInt(OBJECT_SELF, "SFPacked1_805", 0x5580012d); // Troglodyte Stench
    SetLocalInt(OBJECT_SELF, "SFPacked1_806", 0x0240012b); // PDK RallyingCry
    SetLocalInt(OBJECT_SELF, "SFPacked1_807", 0x02000101); // PDK Shield
    SetLocalInt(OBJECT_SELF, "SFPacked1_808", 0x5cc4007f); // PDK Fear
    SetLocalInt(OBJECT_SELF, "SFPacked1_809", 0x1464001f); // PDK OathOfWrath
    SetLocalInt(OBJECT_SELF, "SFPacked1_81", 0x15307466); // Hold Animal
    SetLocalInt(OBJECT_SELF, "SFPacked1_810", 0x0240012b); // PDK FinalStand
    SetLocalInt(OBJECT_SELF, "SFPacked1_811", 0x0240012b); // PDK InspireCourage
    SetLocalInt(OBJECT_SELF, "SFPacked1_813", 0xfe0000d1); // Horse Mount
    SetLocalInt(OBJECT_SELF, "SFPacked1_814", 0xfe0000d1); // Horse Dismount
    SetLocalInt(OBJECT_SELF, "SFPacked1_815", 0x54000111); // Horse Party Mount
    SetLocalInt(OBJECT_SELF, "SFPacked1_816", 0x54000111); // Horse Party Dismount
    SetLocalInt(OBJECT_SELF, "SFPacked1_817", 0xfe0000d1); // Horse Assign Mount
    SetLocalInt(OBJECT_SELF, "SFPacked1_818", 0x58000095); // Paladin Summon Mount
    SetLocalInt(OBJECT_SELF, "SFPacked1_819", 0x5400012d); // Nightmare Smoke
    SetLocalInt(OBJECT_SELF, "SFPacked1_82", 0x55307466); // Hold Monster
    SetLocalInt(OBJECT_SELF, "SFPacked1_820", 0xfe000029); // DM TOOL 01
    SetLocalInt(OBJECT_SELF, "SFPacked1_821", 0xfe000029); // DM TOOL 02
    SetLocalInt(OBJECT_SELF, "SFPacked1_822", 0xfe000029); // DM TOOL 03
    SetLocalInt(OBJECT_SELF, "SFPacked1_823", 0xfe000029); // DM TOOL 04
    SetLocalInt(OBJECT_SELF, "SFPacked1_824", 0xfe000029); // DM TOOL 05
    SetLocalInt(OBJECT_SELF, "SFPacked1_825", 0xfe000029); // DM TOOL 06
    SetLocalInt(OBJECT_SELF, "SFPacked1_826", 0xfe000029); // DM TOOL 07
    SetLocalInt(OBJECT_SELF, "SFPacked1_827", 0xfe000029); // DM TOOL 08
    SetLocalInt(OBJECT_SELF, "SFPacked1_828", 0xfe000029); // DM TOOL 09
    SetLocalInt(OBJECT_SELF, "SFPacked1_829", 0xfe000029); // DM TOOL 10
    SetLocalInt(OBJECT_SELF, "SFPacked1_83", 0x55307466); // Hold Person
    SetLocalInt(OBJECT_SELF, "SFPacked1_830", 0x16000129); // EXAMINE
    SetLocalInt(OBJECT_SELF, "SFPacked1_831", 0x02000129); // DEBUFF
    SetLocalInt(OBJECT_SELF, "SFPacked1_832", 0x02000029); // PLAYER TOOL 03
    SetLocalInt(OBJECT_SELF, "SFPacked1_833", 0xfe000029); // PLAYER TOOL 04
    SetLocalInt(OBJECT_SELF, "SFPacked1_834", 0xfe000029); // PLAYER TOOL 05
    SetLocalInt(OBJECT_SELF, "SFPacked1_835", 0xfe000029); // PLAYER TOOL 06
    SetLocalInt(OBJECT_SELF, "SFPacked1_836", 0xfe000029); // PLAYER TOOL 07
    SetLocalInt(OBJECT_SELF, "SFPacked1_837", 0xfe000029); // PLAYER TOOL 08
    SetLocalInt(OBJECT_SELF, "SFPacked1_838", 0xfe000029); // PLAYER TOOL 09
    SetLocalInt(OBJECT_SELF, "SFPacked1_839", 0xfe000029); // PLAYER TOOL 10
    SetLocalInt(OBJECT_SELF, "SFPacked1_84", 0x1200750e); // Holy Aura
    SetLocalInt(OBJECT_SELF, "SFPacked1_842", 0x040000e9); // Smite Infidel
    SetLocalInt(OBJECT_SELF, "SFPacked1_844", 0x0200013e); // Plague
    SetLocalInt(OBJECT_SELF, "SFPacked1_845", 0x080000be); // Summon Undead Animal
    SetLocalInt(OBJECT_SELF, "SFPacked1_846", 0x0200012e); // Blightfire
    SetLocalInt(OBJECT_SELF, "SFPacked1_848", 0x02000140); // Background NatLycan Transform
    SetLocalInt(OBJECT_SELF, "SFPacked1_85", 0x500000ee); // Holy Sword
    SetLocalInt(OBJECT_SELF, "SFPacked1_850", 0x02000105); // Artificer Assistant
    SetLocalInt(OBJECT_SELF, "SFPacked1_851", 0x0c0070c5); // Baleful Utterance
    SetLocalInt(OBJECT_SELF, "SFPacked1_852", 0x02000105); // Beguiling Influence
    SetLocalInt(OBJECT_SELF, "SFPacked1_853", 0x02000105); // Dark Ones Own Luck
    SetLocalInt(OBJECT_SELF, "SFPacked1_854", 0x5c00002d); // Darkness
    SetLocalInt(OBJECT_SELF, "SFPacked1_855", 0x02000145); // Ultravision
    SetLocalInt(OBJECT_SELF, "SFPacked1_856", 0x0200010d); // Entropic Shield
    SetLocalInt(OBJECT_SELF, "SFPacked1_857", 0x02000005); // Leaps And Bounds
    SetLocalInt(OBJECT_SELF, "SFPacked1_858", 0x0200011d); // See Invisibility
    SetLocalInt(OBJECT_SELF, "SFPacked1_859", 0x02000105); // All Seeing Eyes
    SetLocalInt(OBJECT_SELF, "SFPacked1_86", 0x120074de); // Identify
    SetLocalInt(OBJECT_SELF, "SFPacked1_861", 0x02000105); // Dark Arcana
    SetLocalInt(OBJECT_SELF, "SFPacked1_862", 0x02000105); // Cloak Of Shadows
    SetLocalInt(OBJECT_SELF, "SFPacked1_863", 0x02000105); // Shrouding Transformation
    SetLocalInt(OBJECT_SELF, "SFPacked1_865", 0x54000105); // Bestow Curse
    SetLocalInt(OBJECT_SELF, "SFPacked1_866", 0x580000bd); // Create Undead
    SetLocalInt(OBJECT_SELF, "SFPacked1_867", 0x1200013d); // Death Armor
    SetLocalInt(OBJECT_SELF, "SFPacked1_868", 0x55300065); // Dominate Person
    SetLocalInt(OBJECT_SELF, "SFPacked1_869", 0x5e10004d); // Dispel Magic
    SetLocalInt(OBJECT_SELF, "SFPacked1_87", 0x7c0470ae); // Implosion
    SetLocalInt(OBJECT_SELF, "SFPacked1_870", 0x0200010d); // Eldritch Ward
    SetLocalInt(OBJECT_SELF, "SFPacked1_871", 0x0200010d); // Endure Elements
    SetLocalInt(OBJECT_SELF, "SFPacked1_872", 0x02000145); // Expeditious Retreat
    SetLocalInt(OBJECT_SELF, "SFPacked1_873", 0x02000135); // Invisibility
    SetLocalInt(OBJECT_SELF, "SFPacked1_875", 0x580000bd); // Create Greater Undead
    SetLocalInt(OBJECT_SELF, "SFPacked1_876", 0x7c040055); // Evards Black Tentacles
    SetLocalInt(OBJECT_SELF, "SFPacked1_877", 0x5e04004d); // Greater Dispelling
    SetLocalInt(OBJECT_SELF, "SFPacked1_878", 0x02000135); // Improved Invisibility
    SetLocalInt(OBJECT_SELF, "SFPacked1_879", 0x5404004d); // Greater Spell Breach
    SetLocalInt(OBJECT_SELF, "SFPacked1_88", 0x560074f6); // Improved Invisibility
    SetLocalInt(OBJECT_SELF, "SFPacked1_881", 0x5c70007d); // Circle of Death
    SetLocalInt(OBJECT_SELF, "SFPacked1_882", 0x55300065); // Dominate Monster
    SetLocalInt(OBJECT_SELF, "SFPacked1_883", 0x02000145); // Etherealness
    SetLocalInt(OBJECT_SELF, "SFPacked1_884", 0x146400bd); // Finger of Death
    SetLocalInt(OBJECT_SELF, "SFPacked1_885", 0x58000055); // Gate
    SetLocalInt(OBJECT_SELF, "SFPacked1_886", 0x02000145); // FiendishPolymorph
    SetLocalInt(OBJECT_SELF, "SFPacked1_89", 0x5ce47e2e); // Incendiary Cloud
    SetLocalInt(OBJECT_SELF, "SFPacked1_890", 0x08000097); // FEAT CALLFIENDS
    SetLocalInt(OBJECT_SELF, "SFPacked1_892", 0x08007496); // SummonUndead1
    SetLocalInt(OBJECT_SELF, "SFPacked1_893", 0x08007496); // SummonUndead2
    SetLocalInt(OBJECT_SELF, "SFPacked1_894", 0x08007496); // SummonUndead3
    SetLocalInt(OBJECT_SELF, "SFPacked1_895", 0x08007496); // SummonUndead4
    SetLocalInt(OBJECT_SELF, "SFPacked1_896", 0x08007496); // SummonUndead5
    SetLocalInt(OBJECT_SELF, "SFPacked1_899", 0x762000a9); // Eldritch Blast Acid
    SetLocalInt(OBJECT_SELF, "SFPacked1_9", 0x56007f06); // Bulls Strength
    SetLocalInt(OBJECT_SELF, "SFPacked1_90", 0x560074f6); // Invisibility
    SetLocalInt(OBJECT_SELF, "SFPacked1_900", 0x764000a9); // Eldritch Blast Cold
    SetLocalInt(OBJECT_SELF, "SFPacked1_901", 0x76e000a9); // Eldritch Blast Fire
    SetLocalInt(OBJECT_SELF, "SFPacked1_902", 0x760000a9); // Eldritch Blast Magic
    SetLocalInt(OBJECT_SELF, "SFPacked1_903", 0x774000a9); // Eldritch Blast Negative
    SetLocalInt(OBJECT_SELF, "SFPacked1_905", 0x76200029); // Eldritch Blast EMP Acid
    SetLocalInt(OBJECT_SELF, "SFPacked1_906", 0x76400029); // Eldritch Blast EMP Cold
    SetLocalInt(OBJECT_SELF, "SFPacked1_907", 0x76e00029); // Eldritch Blast EMP Fire
    SetLocalInt(OBJECT_SELF, "SFPacked1_908", 0x76000029); // Eldritch Blast EMP Magic
    SetLocalInt(OBJECT_SELF, "SFPacked1_909", 0x77400029); // Eldritch Blast EMP Negative
    SetLocalInt(OBJECT_SELF, "SFPacked1_91", 0x0a00752e); // Invisibility Purge
    SetLocalInt(OBJECT_SELF, "SFPacked1_911", 0x76000069); // Spellfire Blast
    SetLocalInt(OBJECT_SELF, "SFPacked1_912", 0x02000109); // Spellfire Absorb
    SetLocalInt(OBJECT_SELF, "SFPacked1_913", 0x060000e9); // Spellfire Heal T
    SetLocalInt(OBJECT_SELF, "SFPacked1_914", 0x100000e9); // Spellfire Destroy
    SetLocalInt(OBJECT_SELF, "SFPacked1_915", 0x06000069); // Spellfire Heal R
    SetLocalInt(OBJECT_SELF, "SFPacked1_916", 0x64000069); // Spellfire Burst
    SetLocalInt(OBJECT_SELF, "SFPacked1_917", 0x02100141); // Spellfire Haste
    SetLocalInt(OBJECT_SELF, "SFPacked1_918", 0x02000129); // Spellfire Crown
    SetLocalInt(OBJECT_SELF, "SFPacked1_919", 0x02000129); // Spellfire Maelstrom
    SetLocalInt(OBJECT_SELF, "SFPacked1_92", 0x12007536); // Invisibility Sphere
    SetLocalInt(OBJECT_SELF, "SFPacked1_922", 0x0200012d); // Wild Shape Mammal
    SetLocalInt(OBJECT_SELF, "SFPacked1_923", 0x02000141); // Wild Shape BROWN BEAR
    SetLocalInt(OBJECT_SELF, "SFPacked1_924", 0x02000141); // Wild Shape PANTHER
    SetLocalInt(OBJECT_SELF, "SFPacked1_925", 0x02000141); // Wild Shape WOLF
    SetLocalInt(OBJECT_SELF, "SFPacked1_926", 0x02000141); // Wild Shape BOAR
    SetLocalInt(OBJECT_SELF, "SFPacked1_927", 0x02000141); // Wild Shape BADGER
    SetLocalInt(OBJECT_SELF, "SFPacked1_928", 0x0200012d); // Wild Shape Reptile
    SetLocalInt(OBJECT_SELF, "SFPacked1_929", 0x02000141); // Wild Shape VIPER
    SetLocalInt(OBJECT_SELF, "SFPacked1_93", 0x12045082); // Knock
    SetLocalInt(OBJECT_SELF, "SFPacked1_930", 0x02000141); // Wild Shape COBRA
    SetLocalInt(OBJECT_SELF, "SFPacked1_931", 0x02000141); // Wild Shape TORTOISE
    SetLocalInt(OBJECT_SELF, "SFPacked1_932", 0x02000141); // Wild Shape SALT CROC
    SetLocalInt(OBJECT_SELF, "SFPacked1_933", 0x02000141); // Wild Shape GIANT
    SetLocalInt(OBJECT_SELF, "SFPacked1_934", 0x0200012d); // Wild Shape Avian
    SetLocalInt(OBJECT_SELF, "SFPacked1_935", 0x02000141); // Wild Shape Falcon
    SetLocalInt(OBJECT_SELF, "SFPacked1_936", 0x02000141); // Wild Shape Crane
    SetLocalInt(OBJECT_SELF, "SFPacked1_937", 0x02000141); // Wild Shape Raven
    SetLocalInt(OBJECT_SELF, "SFPacked1_938", 0x02000141); // Wild Shape Owl
    SetLocalInt(OBJECT_SELF, "SFPacked1_939", 0x02000141); // Wild Shape Sparrow
    SetLocalInt(OBJECT_SELF, "SFPacked1_94", 0x5e04604c); // Lesser Dispel
    SetLocalInt(OBJECT_SELF, "SFPacked1_941", 0x08001056); // Dimension Door
    SetLocalInt(OBJECT_SELF, "SFPacked1_943", 0x75407e6e); // DARK BOLT
    SetLocalInt(OBJECT_SELF, "SFPacked1_944", 0x02000d16); // CHARM DOMAIN POWER
    SetLocalInt(OBJECT_SELF, "SFPacked1_945", 0x02000d16); // ILLUSION DOMAIN POWER
    SetLocalInt(OBJECT_SELF, "SFPacked1_946", 0x02000d16); // MAGIC DOMAIN POWER
    SetLocalInt(OBJECT_SELF, "SFPacked1_948", 0x08007096); // Teleport
    SetLocalInt(OBJECT_SELF, "SFPacked1_949", 0x08007456); // SUMMON SHAMBLING MOUND
    SetLocalInt(OBJECT_SELF, "SFPacked1_95", 0x5610748e); // Lesser Mind Blank
    SetLocalInt(OBJECT_SELF, "SFPacked1_950", 0x08007496); // Plane Shift
    SetLocalInt(OBJECT_SELF, "SFPacked1_953", 0x02000116); // Tree Stride
    SetLocalInt(OBJECT_SELF, "SFPacked1_954", 0x0200012d); // Wild Shape PLANT
    SetLocalInt(OBJECT_SELF, "SFPacked1_955", 0x02000141); // WILD SHAPE ASS VINE
    SetLocalInt(OBJECT_SELF, "SFPacked1_956", 0x02000141); // WILD SHAPE TREANT
    SetLocalInt(OBJECT_SELF, "SFPacked1_957", 0x02000141); // WILD SHAPE Shambling
    SetLocalInt(OBJECT_SELF, "SFPacked1_958", 0x08000030); // Shadow Jump
    SetLocalInt(OBJECT_SELF, "SFPacked1_959", 0x02000130); // Shadow Knife
    SetLocalInt(OBJECT_SELF, "SFPacked1_96", 0x5c107496); // Lesser Planar Binding
    SetLocalInt(OBJECT_SELF, "SFPacked1_960", 0x02000130); // Shadow Mastery
    SetLocalInt(OBJECT_SELF, "SFPacked1_961", 0x02000130); // Shadow Walk
    SetLocalInt(OBJECT_SELF, "SFPacked1_964", 0x02000100); // BS SWORD STYLE
    SetLocalInt(OBJECT_SELF, "SFPacked1_965", 0x040000c0); // BS ARCANE STRIKE
    SetLocalInt(OBJECT_SELF, "SFPacked1_967", 0x02000130); // Shield of Shadows
    SetLocalInt(OBJECT_SELF, "SFPacked1_97", 0x560070d6); // Lesser Restoration
    SetLocalInt(OBJECT_SELF, "SFPacked1_970", 0x060000ce); // Spell Ward
    SetLocalInt(OBJECT_SELF, "SFPacked1_971", 0x02000126); // Apothecary and arsenal
    SetLocalInt(OBJECT_SELF, "SFPacked1_972", 0x02000146); // Eyes of the order
    SetLocalInt(OBJECT_SELF, "SFPacked1_973", 0x1e00006c); // Detect Evil
    SetLocalInt(OBJECT_SELF, "SFPacked1_974", 0x02000128); // Control Weather
    SetLocalInt(OBJECT_SELF, "SFPacked1_975", 0x02000128); // Research New Spell
    SetLocalInt(OBJECT_SELF, "SFPacked1_976", 0x02000140); // Spellfire Purge
    SetLocalInt(OBJECT_SELF, "SFPacked1_977", 0x040000f8); // Blood Drain
    SetLocalInt(OBJECT_SELF, "SFPacked1_978", 0x0e000050); // ChildrenOfTheNight
    SetLocalInt(OBJECT_SELF, "SFPacked1_979", 0x053000a0); // Dominate Person
    SetLocalInt(OBJECT_SELF, "SFPacked1_98", 0x5404704e); // Lesser Spell Breach
    SetLocalInt(OBJECT_SELF, "SFPacked1_980", 0x02000140); // Mist Form
    SetLocalInt(OBJECT_SELF, "SFPacked1_981", 0x02000140); // Bat Form
    SetLocalInt(OBJECT_SELF, "SFPacked1_982", 0x02000140); // Wolf Form
    SetLocalInt(OBJECT_SELF, "SFPacked1_984", 0x1e007e96); // Summon Mount
    SetLocalInt(OBJECT_SELF, "SFPacked1_985", 0x16007ee6); // Heroism
    SetLocalInt(OBJECT_SELF, "SFPacked1_986", 0x16007ee6); // Heroism Greater
    SetLocalInt(OBJECT_SELF, "SFPacked1_987", 0x19305e66); // Lullaby
    SetLocalInt(OBJECT_SELF, "SFPacked1_988", 0x16007ee6); // Rage
    SetLocalInt(OBJECT_SELF, "SFPacked1_989", 0x13007f2e); // Call Lightning Storm
    SetLocalInt(OBJECT_SELF, "SFPacked1_99", 0x12007f0e); // Lesser Spell Mantle
    SetLocalInt(OBJECT_SELF, "SFPacked1_990", 0x1c007f36); // Claws Of Darkness
    SetLocalInt(OBJECT_SELF, "SFPacked1_991", 0x14407aae); // Polar Ray
    SetLocalInt(OBJECT_SELF, "SFPacked1_992", 0x14e07aae); // Scorching Ray
    SetLocalInt(OBJECT_SELF, "SFPacked1_993", 0x16007ef2); // Blur
    SetLocalInt(OBJECT_SELF, "SFPacked1_994", 0x03207f22); // Verrakeths Shadow Crown
    SetLocalInt(OBJECT_SELF, "SFPacked1_995", 0x02000100); // EschewMaterialToggle
    SetLocalInt(OBJECT_SELF, "SFPacked1_998", 0x060074ce); // Protection From Arrows
    SetLocalInt(OBJECT_SELF, "SFPacked2_0", 0x17000007); // Acid Fog
    SetLocalInt(OBJECT_SELF, "SFPacked2_1", 0x00430303); // Aid
    SetLocalInt(OBJECT_SELF, "SFPacked2_10", 0x12000002); // Burning Hands
    SetLocalInt(OBJECT_SELF, "SFPacked2_100", 0x01001111); // Light
    SetLocalInt(OBJECT_SELF, "SFPacked2_1000", 0x00000808); // Undeath After Death
    SetLocalInt(OBJECT_SELF, "SFPacked2_1002", 0x00000808); // Blasphemy
    SetLocalInt(OBJECT_SELF, "SFPacked2_1005", 0x10000003); // Cold Fire
    SetLocalInt(OBJECT_SELF, "SFPacked2_1006", 0x10000003); // Paralyzing touch
    SetLocalInt(OBJECT_SELF, "SFPacked2_1007", 0x04044444); // Daylight
    SetLocalInt(OBJECT_SELF, "SFPacked2_1008", 0x12000002); // Chill Touch
    SetLocalInt(OBJECT_SELF, "SFPacked2_1009", 0x13000003); // Command Undead
    SetLocalInt(OBJECT_SELF, "SFPacked2_101", 0x14000004); // Lightning Bolt
    SetLocalInt(OBJECT_SELF, "SFPacked2_1010", 0x13000003); // Aganazzer FlameWave
    SetLocalInt(OBJECT_SELF, "SFPacked2_1011", 0x03000003); // False Life
    SetLocalInt(OBJECT_SELF, "SFPacked2_1012", 0x14000004); // Halt Undead
    SetLocalInt(OBJECT_SELF, "SFPacked2_1013", 0x14000044); // Deep Slumber
    SetLocalInt(OBJECT_SELF, "SFPacked2_1014", 0x13000003); // Shadow Spray
    SetLocalInt(OBJECT_SELF, "SFPacked2_1015", 0x17000007); // Disintegrate
    SetLocalInt(OBJECT_SELF, "SFPacked2_1016", 0x11000001); // Disrupt Undead
    SetLocalInt(OBJECT_SELF, "SFPacked2_1017", 0x00000044); // Glibness
    SetLocalInt(OBJECT_SELF, "SFPacked2_1018", 0x15000044); // Crushing Despair
    SetLocalInt(OBJECT_SELF, "SFPacked2_1019", 0x00000044); // Good Hope
    SetLocalInt(OBJECT_SELF, "SFPacked2_102", 0x02000022); // Mage Armor
    SetLocalInt(OBJECT_SELF, "SFPacked2_1020", 0x15004404); // Affliction
    SetLocalInt(OBJECT_SELF, "SFPacked2_1021", 0x00050005); // Aspect Of The Deity
    SetLocalInt(OBJECT_SELF, "SFPacked2_1022", 0x00050505); // Blood Of Martyr
    SetLocalInt(OBJECT_SELF, "SFPacked2_1023", 0x00020002); // Divine Sacrifice
    SetLocalInt(OBJECT_SELF, "SFPacked2_1024", 0x12020202); // Lantern Light
    SetLocalInt(OBJECT_SELF, "SFPacked2_1025", 0x16000006); // Fleshshiver
    SetLocalInt(OBJECT_SELF, "SFPacked2_1026", 0x03000033); // Lively Step
    SetLocalInt(OBJECT_SELF, "SFPacked2_1027", 0x12000002); // Corrosive Grasp
    SetLocalInt(OBJECT_SELF, "SFPacked2_1028", 0x15000005); // Shadow Well
    SetLocalInt(OBJECT_SELF, "SFPacked2_1029", 0x10006006); // Memory Rot
    SetLocalInt(OBJECT_SELF, "SFPacked2_103", 0x00000004); // Magic Circle against Chaos
    SetLocalInt(OBJECT_SELF, "SFPacked2_1030", 0x07077707); // Mass Bulls Strength
    SetLocalInt(OBJECT_SELF, "SFPacked2_1031", 0x07707077); // Mass Cats Grace
    SetLocalInt(OBJECT_SELF, "SFPacked2_1032", 0x07070777); // Mass Eagle Splendor
    SetLocalInt(OBJECT_SELF, "SFPacked2_1033", 0x07707707); // Mass Endurance
    SetLocalInt(OBJECT_SELF, "SFPacked2_1034", 0x07000777); // Mass Foxs Cunning
    SetLocalInt(OBJECT_SELF, "SFPacked2_1035", 0x07007777); // Mass Owls Wisdom
    SetLocalInt(OBJECT_SELF, "SFPacked2_1036", 0x00006606); // Atonement
    SetLocalInt(OBJECT_SELF, "SFPacked2_1037", 0x00202022); // Longstrider
    SetLocalInt(OBJECT_SELF, "SFPacked2_1038", 0x04500004); // Nondetection
    SetLocalInt(OBJECT_SELF, "SFPacked2_1039", 0x10005005); // Rusting grasp
    SetLocalInt(OBJECT_SELF, "SFPacked2_104", 0x04040444); // Magic Circle against Evil
    SetLocalInt(OBJECT_SELF, "SFPacked2_1040", 0x00009707); // Word of recall
    SetLocalInt(OBJECT_SELF, "SFPacked2_1041", 0x16005005); // Blight
    SetLocalInt(OBJECT_SELF, "SFPacked2_1045", 0x00000303); // Spiritual Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked2_1047", 0x00000003); // Darkness
    SetLocalInt(OBJECT_SELF, "SFPacked2_105", 0x04040444); // Magic Circle against Good
    SetLocalInt(OBJECT_SELF, "SFPacked2_1050", 0x10000005); // Eldritch Chain
    SetLocalInt(OBJECT_SELF, "SFPacked2_1051", 0x10000006); // Eldritch Cone
    SetLocalInt(OBJECT_SELF, "SFPacked2_1052", 0x10000003); // Eldritch Spear
    SetLocalInt(OBJECT_SELF, "SFPacked2_1053", 0x10000009); // Eldritch Doom
    SetLocalInt(OBJECT_SELF, "SFPacked2_1054", 0x10000003); // Hideous Blow
    SetLocalInt(OBJECT_SELF, "SFPacked2_1055", 0x00000002); // Frightful Blast
    SetLocalInt(OBJECT_SELF, "SFPacked2_1056", 0x00000002); // Sickening Blast
    SetLocalInt(OBJECT_SELF, "SFPacked2_1057", 0x00000002); // Brimstone Blast
    SetLocalInt(OBJECT_SELF, "SFPacked2_1058", 0x00000002); // Hellrime Blast
    SetLocalInt(OBJECT_SELF, "SFPacked2_1059", 0x00000002); // Vitriolic Blast
    SetLocalInt(OBJECT_SELF, "SFPacked2_106", 0x00000004); // Magic Circle against Law
    SetLocalInt(OBJECT_SELF, "SFPacked2_1060", 0x00000002); // Bewitching Blast
    SetLocalInt(OBJECT_SELF, "SFPacked2_1061", 0x00000002); // Utterdark Blast
    SetLocalInt(OBJECT_SELF, "SFPacked2_1062", 0x00000002); // Repelling Blast
    SetLocalInt(OBJECT_SELF, "SFPacked2_1063", 0x00000006); // Flee The Scene
    SetLocalInt(OBJECT_SELF, "SFPacked2_107", 0x12000002); // Magic Missile
    SetLocalInt(OBJECT_SELF, "SFPacked2_1070", 0x12000002); // Orb Lsr Acid
    SetLocalInt(OBJECT_SELF, "SFPacked2_1071", 0x12000002); // Orb Lsr Cold
    SetLocalInt(OBJECT_SELF, "SFPacked2_1072", 0x12000002); // Orb Lsr Elec
    SetLocalInt(OBJECT_SELF, "SFPacked2_1073", 0x12000002); // Orb Lsr Fire
    SetLocalInt(OBJECT_SELF, "SFPacked2_1074", 0x12000002); // Orb Lsr Sonic
    SetLocalInt(OBJECT_SELF, "SFPacked2_108", 0x00000004); // Magic Vestment
    SetLocalInt(OBJECT_SELF, "SFPacked2_109", 0x00000002); // Magic Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked2_11", 0x10004004); // Call Lightning
    SetLocalInt(OBJECT_SELF, "SFPacked2_110", 0x19000009); // Mass Blindness and Deafness
    SetLocalInt(OBJECT_SELF, "SFPacked2_111", 0x19000009); // Mass Charm
    SetLocalInt(OBJECT_SELF, "SFPacked2_112", 0x1000000a); // Mass Domination
    SetLocalInt(OBJECT_SELF, "SFPacked2_113", 0x07000077); // Mass Haste
    SetLocalInt(OBJECT_SELF, "SFPacked2_114", 0x0000a909); // Mass Heal
    SetLocalInt(OBJECT_SELF, "SFPacked2_115", 0x13000003); // Melfs Acid Arrow
    SetLocalInt(OBJECT_SELF, "SFPacked2_116", 0x1a00000a); // Meteor Swarm
    SetLocalInt(OBJECT_SELF, "SFPacked2_117", 0x09000009); // Mind Blank
    SetLocalInt(OBJECT_SELF, "SFPacked2_118", 0x16000066); // Mind Fog
    SetLocalInt(OBJECT_SELF, "SFPacked2_119", 0x05000005); // Minor Globe of Invulnerability
    SetLocalInt(OBJECT_SELF, "SFPacked2_12", 0x10000002); // Calm Emotions
    SetLocalInt(OBJECT_SELF, "SFPacked2_121", 0x07000066); // Ethereal Visage
    SetLocalInt(OBJECT_SELF, "SFPacked2_122", 0x0a00000a); // Mordenkainens Disjunction
    SetLocalInt(OBJECT_SELF, "SFPacked2_123", 0x08000008); // Mordenkainens Sword
    SetLocalInt(OBJECT_SELF, "SFPacked2_124", 0x00009009); // Natures Balance
    SetLocalInt(OBJECT_SELF, "SFPacked2_125", 0x00000404); // Negative Energy Protection
    SetLocalInt(OBJECT_SELF, "SFPacked2_126", 0x00454554); // Neutralize Poison
    SetLocalInt(OBJECT_SELF, "SFPacked2_127", 0x15000005); // Phantasmal Killer
    SetLocalInt(OBJECT_SELF, "SFPacked2_128", 0x07000007); // Planar Binding
    SetLocalInt(OBJECT_SELF, "SFPacked2_129", 0x10004504); // Poison
    SetLocalInt(OBJECT_SELF, "SFPacked2_13", 0x03303033); // Cats Grace
    SetLocalInt(OBJECT_SELF, "SFPacked2_130", 0x05500005); // Polymorph Self
    SetLocalInt(OBJECT_SELF, "SFPacked2_131", 0x1a00000a); // Power Word Kill
    SetLocalInt(OBJECT_SELF, "SFPacked2_132", 0x18000008); // Power Word Stun
    SetLocalInt(OBJECT_SELF, "SFPacked2_133", 0x00040404); // Prayer
    SetLocalInt(OBJECT_SELF, "SFPacked2_134", 0x09009009); // Premonition
    SetLocalInt(OBJECT_SELF, "SFPacked2_135", 0x18000008); // Prismatic Spray
    SetLocalInt(OBJECT_SELF, "SFPacked2_136", 0x02020202); // Protection from Chaos
    SetLocalInt(OBJECT_SELF, "SFPacked2_137", 0x04304404); // Protection from Elements
    SetLocalInt(OBJECT_SELF, "SFPacked2_138", 0x02020202); // Protection from Evil
    SetLocalInt(OBJECT_SELF, "SFPacked2_139", 0x02020202); // Protection from Good
    SetLocalInt(OBJECT_SELF, "SFPacked2_14", 0x17000007); // Chain Lightning
    SetLocalInt(OBJECT_SELF, "SFPacked2_140", 0x02020202); // Protection from Law
    SetLocalInt(OBJECT_SELF, "SFPacked2_141", 0x08000008); // Protection from Spells
    SetLocalInt(OBJECT_SELF, "SFPacked2_142", 0x00000606); // Raise Dead
    SetLocalInt(OBJECT_SELF, "SFPacked2_143", 0x12000002); // Ray of Enfeeblement
    SetLocalInt(OBJECT_SELF, "SFPacked2_144", 0x11000001); // Ray of Frost
    SetLocalInt(OBJECT_SELF, "SFPacked2_145", 0x05040404); // Remove Blindness and Deafness
    SetLocalInt(OBJECT_SELF, "SFPacked2_146", 0x05000444); // Remove Curse
    SetLocalInt(OBJECT_SELF, "SFPacked2_147", 0x00404444); // Remove Disease
    SetLocalInt(OBJECT_SELF, "SFPacked2_148", 0x00000202); // Remove Fear
    SetLocalInt(OBJECT_SELF, "SFPacked2_149", 0x00030303); // Remove Paralysis
    SetLocalInt(OBJECT_SELF, "SFPacked2_15", 0x15000044); // Charm Monster
    SetLocalInt(OBJECT_SELF, "SFPacked2_150", 0x03233303); // Resist Elements
    SetLocalInt(OBJECT_SELF, "SFPacked2_151", 0x01021112); // Resistance
    SetLocalInt(OBJECT_SELF, "SFPacked2_152", 0x00005505); // Restoration
    SetLocalInt(OBJECT_SELF, "SFPacked2_153", 0x00000808); // Resurrection
    SetLocalInt(OBJECT_SELF, "SFPacked2_154", 0x00000202); // Sanctuary
    SetLocalInt(OBJECT_SELF, "SFPacked2_155", 0x12000222); // Scare
    SetLocalInt(OBJECT_SELF, "SFPacked2_156", 0x10000404); // Searing Light
    SetLocalInt(OBJECT_SELF, "SFPacked2_157", 0x03000033); // See Invisibility
    SetLocalInt(OBJECT_SELF, "SFPacked2_158", 0x17000007); // Shades
    SetLocalInt(OBJECT_SELF, "SFPacked2_159", 0x15000005); // Shadow Conjuration
    SetLocalInt(OBJECT_SELF, "SFPacked2_16", 0x12000022); // Charm Person
    SetLocalInt(OBJECT_SELF, "SFPacked2_160", 0x08000008); // Shadow Shield
    SetLocalInt(OBJECT_SELF, "SFPacked2_161", 0x0a00a00a); // Shapechange
    SetLocalInt(OBJECT_SELF, "SFPacked2_162", 0x00000009); // Shield of Law
    SetLocalInt(OBJECT_SELF, "SFPacked2_163", 0x00000333); // Silence
    SetLocalInt(OBJECT_SELF, "SFPacked2_164", 0x10006606); // Slay Living
    SetLocalInt(OBJECT_SELF, "SFPacked2_165", 0x12302022); // Sleep
    SetLocalInt(OBJECT_SELF, "SFPacked2_166", 0x14000044); // Slow
    SetLocalInt(OBJECT_SELF, "SFPacked2_167", 0x10000333); // Sound Burst
    SetLocalInt(OBJECT_SELF, "SFPacked2_168", 0x00006606); // Spell Resistance
    SetLocalInt(OBJECT_SELF, "SFPacked2_169", 0x08000008); // Spell Mantle
    SetLocalInt(OBJECT_SELF, "SFPacked2_17", 0x10003003); // Charm Person or Animal
    SetLocalInt(OBJECT_SELF, "SFPacked2_170", 0x10000006); // Sphere of Chaos
    SetLocalInt(OBJECT_SELF, "SFPacked2_171", 0x14000004); // Stinking Cloud
    SetLocalInt(OBJECT_SELF, "SFPacked2_172", 0x05005005); // Stoneskin
    SetLocalInt(OBJECT_SELF, "SFPacked2_173", 0x1000aa0a); // Storm of Vengeance
    SetLocalInt(OBJECT_SELF, "SFPacked2_174", 0x02202022); // Summon Creature I
    SetLocalInt(OBJECT_SELF, "SFPacked2_175", 0x03303033); // Summon Creature II
    SetLocalInt(OBJECT_SELF, "SFPacked2_176", 0x04404044); // Summon Creature III
    SetLocalInt(OBJECT_SELF, "SFPacked2_177", 0x05505055); // Summon Creature IV
    SetLocalInt(OBJECT_SELF, "SFPacked2_178", 0x0000000a); // Summon Creature IX
    SetLocalInt(OBJECT_SELF, "SFPacked2_179", 0x06006066); // Summon Creature V
    SetLocalInt(OBJECT_SELF, "SFPacked2_18", 0x17000007); // Circle of Death
    SetLocalInt(OBJECT_SELF, "SFPacked2_180", 0x07007077); // Summon Creature VI
    SetLocalInt(OBJECT_SELF, "SFPacked2_181", 0x08008008); // Summon Creature VII
    SetLocalInt(OBJECT_SELF, "SFPacked2_182", 0x09009009); // Summon Creature VIII
    SetLocalInt(OBJECT_SELF, "SFPacked2_183", 0x10009908); // Sunbeam
    SetLocalInt(OBJECT_SELF, "SFPacked2_184", 0x07000007); // Tensers Transformation
    SetLocalInt(OBJECT_SELF, "SFPacked2_185", 0x0a00000a); // Time Stop
    SetLocalInt(OBJECT_SELF, "SFPacked2_186", 0x07008606); // True Seeing
    SetLocalInt(OBJECT_SELF, "SFPacked2_187", 0x00000009); // Unholy Aura
    SetLocalInt(OBJECT_SELF, "SFPacked2_188", 0x14000004); // Vampiric Touch
    SetLocalInt(OBJECT_SELF, "SFPacked2_189", 0x00021101); // Virtue
    SetLocalInt(OBJECT_SELF, "SFPacked2_19", 0x10000606); // Circle of Doom
    SetLocalInt(OBJECT_SELF, "SFPacked2_190", 0x1a00000a); // Wail of the Banshee
    SetLocalInt(OBJECT_SELF, "SFPacked2_191", 0x15006005); // Wall of Fire
    SetLocalInt(OBJECT_SELF, "SFPacked2_192", 0x13000003); // Web
    SetLocalInt(OBJECT_SELF, "SFPacked2_193", 0x1a00000a); // Weird
    SetLocalInt(OBJECT_SELF, "SFPacked2_194", 0x10000808); // Word of Faith
    SetLocalInt(OBJECT_SELF, "SFPacked2_195", 0x10000006); // AURA BLINDING
    SetLocalInt(OBJECT_SELF, "SFPacked2_196", 0x10000005); // Aura Cold
    SetLocalInt(OBJECT_SELF, "SFPacked2_197", 0x10000005); // Aura Electricity
    SetLocalInt(OBJECT_SELF, "SFPacked2_198", 0x10000005); // Aura Fear
    SetLocalInt(OBJECT_SELF, "SFPacked2_199", 0x10000005); // Aura Fire
    SetLocalInt(OBJECT_SELF, "SFPacked2_2", 0x06000404); // Animate Dead
    SetLocalInt(OBJECT_SELF, "SFPacked2_20", 0x04000044); // Clairaudience and Clairvoyance
    SetLocalInt(OBJECT_SELF, "SFPacked2_200", 0x10000004); // Aura Menace
    SetLocalInt(OBJECT_SELF, "SFPacked2_201", 0x00000005); // Aura Protection
    SetLocalInt(OBJECT_SELF, "SFPacked2_202", 0x10000006); // Aura Stun
    SetLocalInt(OBJECT_SELF, "SFPacked2_203", 0x10000008); // Aura Unearthly Visage
    SetLocalInt(OBJECT_SELF, "SFPacked2_204", 0x10000004); // Aura Unnatural
    SetLocalInt(OBJECT_SELF, "SFPacked2_205", 0x10000005); // Bolt Ability Drain Charisma
    SetLocalInt(OBJECT_SELF, "SFPacked2_206", 0x10000005); // Bolt Ability Drain Constitution
    SetLocalInt(OBJECT_SELF, "SFPacked2_207", 0x10000005); // Bolt Ability Drain Dexterity
    SetLocalInt(OBJECT_SELF, "SFPacked2_208", 0x10000005); // Bolt Ability Drain Intelligence
    SetLocalInt(OBJECT_SELF, "SFPacked2_209", 0x10000005); // Bolt Ability Drain Strength
    SetLocalInt(OBJECT_SELF, "SFPacked2_21", 0x04000433); // Clarity
    SetLocalInt(OBJECT_SELF, "SFPacked2_210", 0x10000005); // Bolt Ability Drain Wisdom
    SetLocalInt(OBJECT_SELF, "SFPacked2_211", 0x10000005); // Bolt Acid
    SetLocalInt(OBJECT_SELF, "SFPacked2_212", 0x10000005); // Bolt Charm
    SetLocalInt(OBJECT_SELF, "SFPacked2_213", 0x10000005); // Bolt Cold
    SetLocalInt(OBJECT_SELF, "SFPacked2_214", 0x10000005); // Bolt Confuse
    SetLocalInt(OBJECT_SELF, "SFPacked2_215", 0x10000006); // Bolt Daze
    SetLocalInt(OBJECT_SELF, "SFPacked2_216", 0x10000006); // Bolt Death
    SetLocalInt(OBJECT_SELF, "SFPacked2_217", 0x10000005); // Bolt Disease
    SetLocalInt(OBJECT_SELF, "SFPacked2_218", 0x10000007); // Bolt Dominate
    SetLocalInt(OBJECT_SELF, "SFPacked2_219", 0x10000005); // Bolt Fire
    SetLocalInt(OBJECT_SELF, "SFPacked2_22", 0x00000009); // Cloak of Chaos
    SetLocalInt(OBJECT_SELF, "SFPacked2_220", 0x10000004); // Bolt Knockdown
    SetLocalInt(OBJECT_SELF, "SFPacked2_221", 0x10000007); // Bolt Level Drain
    SetLocalInt(OBJECT_SELF, "SFPacked2_222", 0x10000005); // Bolt Lightning
    SetLocalInt(OBJECT_SELF, "SFPacked2_223", 0x10000006); // Bolt Paralyze
    SetLocalInt(OBJECT_SELF, "SFPacked2_224", 0x10000006); // Bolt Poison
    SetLocalInt(OBJECT_SELF, "SFPacked2_225", 0x10000005); // Bolt Shards
    SetLocalInt(OBJECT_SELF, "SFPacked2_226", 0x10000005); // Bolt Slow
    SetLocalInt(OBJECT_SELF, "SFPacked2_227", 0x10000006); // Bolt Stun
    SetLocalInt(OBJECT_SELF, "SFPacked2_228", 0x10000005); // Bolt Web
    SetLocalInt(OBJECT_SELF, "SFPacked2_229", 0x10000006); // Cone Acid
    SetLocalInt(OBJECT_SELF, "SFPacked2_23", 0x16000006); // Cloudkill
    SetLocalInt(OBJECT_SELF, "SFPacked2_230", 0x10000006); // Cone Cold
    SetLocalInt(OBJECT_SELF, "SFPacked2_2306", 0x00000001); // VAA Anim1
    SetLocalInt(OBJECT_SELF, "SFPacked2_2307", 0x00000001); // VAA Anim2
    SetLocalInt(OBJECT_SELF, "SFPacked2_2308", 0x00000001); // VAA Anim3
    SetLocalInt(OBJECT_SELF, "SFPacked2_2309", 0x00000001); // VAA Anim4
    SetLocalInt(OBJECT_SELF, "SFPacked2_231", 0x10000006); // Cone Disease
    SetLocalInt(OBJECT_SELF, "SFPacked2_2310", 0x00000001); // VAA Anim5
    SetLocalInt(OBJECT_SELF, "SFPacked2_2312", 0x00000001); // VAA Anim6
    SetLocalInt(OBJECT_SELF, "SFPacked2_2313", 0x00000001); // VAA Anim7
    SetLocalInt(OBJECT_SELF, "SFPacked2_2314", 0x00000001); // VAA Anim8
    SetLocalInt(OBJECT_SELF, "SFPacked2_2315", 0x00000001); // VAA Anim9
    SetLocalInt(OBJECT_SELF, "SFPacked2_2316", 0x00000001); // VAA Anim10
    SetLocalInt(OBJECT_SELF, "SFPacked2_232", 0x10000006); // Cone Fire
    SetLocalInt(OBJECT_SELF, "SFPacked2_233", 0x10000006); // Cone Lightning
    SetLocalInt(OBJECT_SELF, "SFPacked2_234", 0x10000007); // Cone Poison
    SetLocalInt(OBJECT_SELF, "SFPacked2_235", 0x10000006); // Cone Sonic
    SetLocalInt(OBJECT_SELF, "SFPacked2_236", 0x1000000a); // Dragon Breath Acid
    SetLocalInt(OBJECT_SELF, "SFPacked2_237", 0x1000000a); // Dragon Breath Cold
    SetLocalInt(OBJECT_SELF, "SFPacked2_238", 0x1000000a); // Dragon Breath Fear
    SetLocalInt(OBJECT_SELF, "SFPacked2_239", 0x1000000a); // Dragon Breath Fire
    SetLocalInt(OBJECT_SELF, "SFPacked2_24", 0x12000002); // Color Spray
    SetLocalInt(OBJECT_SELF, "SFPacked2_240", 0x1000000a); // Dragon Breath Gas
    SetLocalInt(OBJECT_SELF, "SFPacked2_241", 0x1000000a); // Dragon Breath Lightning
    SetLocalInt(OBJECT_SELF, "SFPacked2_242", 0x1000000a); // Dragon Breath Paralyze
    SetLocalInt(OBJECT_SELF, "SFPacked2_243", 0x1000000a); // Dragon Breath Sleep
    SetLocalInt(OBJECT_SELF, "SFPacked2_244", 0x1000000a); // Dragon Breath Slow
    SetLocalInt(OBJECT_SELF, "SFPacked2_245", 0x1000000a); // Dragon Breath Weaken
    SetLocalInt(OBJECT_SELF, "SFPacked2_246", 0x10000008); // Dragon Wing Buffet
    SetLocalInt(OBJECT_SELF, "SFPacked2_247", 0x00000004); // Ferocity 1
    SetLocalInt(OBJECT_SELF, "SFPacked2_248", 0x00000005); // Ferocity 2
    SetLocalInt(OBJECT_SELF, "SFPacked2_249", 0x00000006); // Ferocity 3
    SetLocalInt(OBJECT_SELF, "SFPacked2_25", 0x16000006); // Cone of Cold
    SetLocalInt(OBJECT_SELF, "SFPacked2_250", 0x10000006); // Gaze Charm
    SetLocalInt(OBJECT_SELF, "SFPacked2_251", 0x10000006); // Gaze Confusion
    SetLocalInt(OBJECT_SELF, "SFPacked2_252", 0x10000005); // Gaze Daze
    SetLocalInt(OBJECT_SELF, "SFPacked2_253", 0x10000007); // Gaze Death
    SetLocalInt(OBJECT_SELF, "SFPacked2_254", 0x10000006); // Gaze Destroy Chaos
    SetLocalInt(OBJECT_SELF, "SFPacked2_255", 0x10000006); // Gaze Destroy Evil
    SetLocalInt(OBJECT_SELF, "SFPacked2_256", 0x10000006); // Gaze Destroy Good
    SetLocalInt(OBJECT_SELF, "SFPacked2_257", 0x10000006); // Gaze Destroy Law
    SetLocalInt(OBJECT_SELF, "SFPacked2_258", 0x10000007); // Gaze Dominate
    SetLocalInt(OBJECT_SELF, "SFPacked2_259", 0x10000005); // Gaze Doom
    SetLocalInt(OBJECT_SELF, "SFPacked2_26", 0x15000044); // Confusion
    SetLocalInt(OBJECT_SELF, "SFPacked2_260", 0x10000006); // Gaze Fear
    SetLocalInt(OBJECT_SELF, "SFPacked2_261", 0x10000006); // Gaze Paralysis
    SetLocalInt(OBJECT_SELF, "SFPacked2_262", 0x10000006); // Gaze Stunned
    SetLocalInt(OBJECT_SELF, "SFPacked2_263", 0x10000006); // Golem Breath Gas
    SetLocalInt(OBJECT_SELF, "SFPacked2_264", 0x10000002); // Hell Hound Firebreath
    SetLocalInt(OBJECT_SELF, "SFPacked2_265", 0x10000007); // Howl Confuse
    SetLocalInt(OBJECT_SELF, "SFPacked2_266", 0x10000005); // Howl Daze
    SetLocalInt(OBJECT_SELF, "SFPacked2_267", 0x10000008); // Howl Death
    SetLocalInt(OBJECT_SELF, "SFPacked2_268", 0x10000005); // Howl Doom
    SetLocalInt(OBJECT_SELF, "SFPacked2_269", 0x10000006); // Howl Fear
    SetLocalInt(OBJECT_SELF, "SFPacked2_27", 0x15004404); // Contagion
    SetLocalInt(OBJECT_SELF, "SFPacked2_270", 0x10000006); // Howl Paralysis
    SetLocalInt(OBJECT_SELF, "SFPacked2_271", 0x10000006); // Howl Sonic
    SetLocalInt(OBJECT_SELF, "SFPacked2_272", 0x10000007); // Howl Stun
    SetLocalInt(OBJECT_SELF, "SFPacked2_273", 0x00000004); // Intensity 1
    SetLocalInt(OBJECT_SELF, "SFPacked2_274", 0x00000005); // Intensity 2
    SetLocalInt(OBJECT_SELF, "SFPacked2_275", 0x00000006); // Intensity 3
    SetLocalInt(OBJECT_SELF, "SFPacked2_276", 0x10000003); // Krenshar Scare
    SetLocalInt(OBJECT_SELF, "SFPacked2_277", 0x00000003); // Lesser Body Adjustment
    SetLocalInt(OBJECT_SELF, "SFPacked2_278", 0x10000004); // Mephit Salt Breath
    SetLocalInt(OBJECT_SELF, "SFPacked2_279", 0x10000004); // Mephit Steam Breath
    SetLocalInt(OBJECT_SELF, "SFPacked2_28", 0x18000708); // Control Undead
    SetLocalInt(OBJECT_SELF, "SFPacked2_280", 0x10000006); // Mummy Bolster Undead
    SetLocalInt(OBJECT_SELF, "SFPacked2_281", 0x10000005); // Pulse Drown
    SetLocalInt(OBJECT_SELF, "SFPacked2_282", 0x10000005); // Pulse Spores
    SetLocalInt(OBJECT_SELF, "SFPacked2_283", 0x10000005); // Pulse Whirlwind
    SetLocalInt(OBJECT_SELF, "SFPacked2_284", 0x10000006); // Pulse Fire
    SetLocalInt(OBJECT_SELF, "SFPacked2_285", 0x10000006); // Pulse Lightning
    SetLocalInt(OBJECT_SELF, "SFPacked2_286", 0x10000006); // Pulse Cold
    SetLocalInt(OBJECT_SELF, "SFPacked2_287", 0x10000006); // Pulse Negative
    SetLocalInt(OBJECT_SELF, "SFPacked2_288", 0x10000006); // Pulse Holy
    SetLocalInt(OBJECT_SELF, "SFPacked2_289", 0x10000008); // Pulse Death
    SetLocalInt(OBJECT_SELF, "SFPacked2_29", 0x09000909); // Create Greater Undead
    SetLocalInt(OBJECT_SELF, "SFPacked2_290", 0x10000008); // Pulse Level Drain
    SetLocalInt(OBJECT_SELF, "SFPacked2_291", 0x10000007); // Pulse Ability Drain Intelligence
    SetLocalInt(OBJECT_SELF, "SFPacked2_292", 0x10000007); // Pulse Ability Drain Charisma
    SetLocalInt(OBJECT_SELF, "SFPacked2_293", 0x10000007); // Pulse Ability Drain Constitution
    SetLocalInt(OBJECT_SELF, "SFPacked2_294", 0x10000007); // Pulse Ability Drain Dexterity
    SetLocalInt(OBJECT_SELF, "SFPacked2_295", 0x10000007); // Pulse Ability Drain Strength
    SetLocalInt(OBJECT_SELF, "SFPacked2_296", 0x10000007); // Pulse Ability Drain Wisdom
    SetLocalInt(OBJECT_SELF, "SFPacked2_297", 0x10000006); // Pulse Poison
    SetLocalInt(OBJECT_SELF, "SFPacked2_298", 0x10000006); // Pulse Disease
    SetLocalInt(OBJECT_SELF, "SFPacked2_299", 0x00000004); // Rage 3
    SetLocalInt(OBJECT_SELF, "SFPacked2_3", 0x00303003); // Barkskin
    SetLocalInt(OBJECT_SELF, "SFPacked2_30", 0x09000707); // Create Undead
    SetLocalInt(OBJECT_SELF, "SFPacked2_300", 0x00000005); // Rage 4
    SetLocalInt(OBJECT_SELF, "SFPacked2_301", 0x00000006); // Rage 5
    SetLocalInt(OBJECT_SELF, "SFPacked2_302", 0x10000004); // Smoke Claw
    SetLocalInt(OBJECT_SELF, "SFPacked2_303", 0x10000006); // Summon Slaad
    SetLocalInt(OBJECT_SELF, "SFPacked2_304", 0x10000006); // Summon Tanarri
    SetLocalInt(OBJECT_SELF, "SFPacked2_305", 0x10000006); // Trumpet Blast
    SetLocalInt(OBJECT_SELF, "SFPacked2_306", 0x10000004); // Tyrant Fog Mist
    SetLocalInt(OBJECT_SELF, "SFPacked2_307", 0x00000002); // BARBARIAN RAGE
    SetLocalInt(OBJECT_SELF, "SFPacked2_308", 0x10000002); // Turn Undead
    SetLocalInt(OBJECT_SELF, "SFPacked2_309", 0x00000002); // Wholeness of Body
    SetLocalInt(OBJECT_SELF, "SFPacked2_31", 0x00006555); // Cure Critical Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked2_310", 0x10000002); // Quivering Palm
    SetLocalInt(OBJECT_SELF, "SFPacked2_311", 0x00000002); // Empty Body
    SetLocalInt(OBJECT_SELF, "SFPacked2_312", 0x00000002); // Detect Evil
    SetLocalInt(OBJECT_SELF, "SFPacked2_313", 0x00000002); // Lay On Hands
    SetLocalInt(OBJECT_SELF, "SFPacked2_314", 0x00000002); // Aura Of Courage
    SetLocalInt(OBJECT_SELF, "SFPacked2_315", 0x10000002); // Smite Evil
    SetLocalInt(OBJECT_SELF, "SFPacked2_316", 0x00000002); // Remove Disease
    SetLocalInt(OBJECT_SELF, "SFPacked2_317", 0x00000002); // Summon Animal Companion
    SetLocalInt(OBJECT_SELF, "SFPacked2_318", 0x00000002); // Summon Familiar
    SetLocalInt(OBJECT_SELF, "SFPacked2_319", 0x00000002); // Elemental Shape
    SetLocalInt(OBJECT_SELF, "SFPacked2_32", 0x00222222); // Cure Light Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked2_320", 0x00000002); // Wild Shape
    SetLocalInt(OBJECT_SELF, "SFPacked2_321", 0x02020202); // PROTECTION FROM ALIGNMENT
    SetLocalInt(OBJECT_SELF, "SFPacked2_322", 0x04040444); // Magic Circle against Alignment
    SetLocalInt(OBJECT_SELF, "SFPacked2_323", 0x00000909); // Aura versus Alignment
    SetLocalInt(OBJECT_SELF, "SFPacked2_324", 0x07000005); // SHADES Summon Shadow
    SetLocalInt(OBJECT_SELF, "SFPacked2_33", 0x00001111); // Cure Minor Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked2_34", 0x00444333); // Cure Moderate Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked2_340", 0x17000006); // SHADES Cone of Cold
    SetLocalInt(OBJECT_SELF, "SFPacked2_341", 0x17000004); // SHADES Fireball
    SetLocalInt(OBJECT_SELF, "SFPacked2_342", 0x07000005); // SHADES Stoneskin
    SetLocalInt(OBJECT_SELF, "SFPacked2_343", 0x17000005); // SHADES Wall of Fire
    SetLocalInt(OBJECT_SELF, "SFPacked2_344", 0x05000005); // SHADOW CON Summon Shadow
    SetLocalInt(OBJECT_SELF, "SFPacked2_345", 0x05000003); // SHADOW CON Darkness
    SetLocalInt(OBJECT_SELF, "SFPacked2_346", 0x05000003); // SHADOW CON Inivsibility
    SetLocalInt(OBJECT_SELF, "SFPacked2_347", 0x05000002); // SHADOW CON Mage Armor
    SetLocalInt(OBJECT_SELF, "SFPacked2_348", 0x15000002); // SHADOW CON Magic Missile
    SetLocalInt(OBJECT_SELF, "SFPacked2_349", 0x06000005); // GR SHADOW CON Summon Shadow
    SetLocalInt(OBJECT_SELF, "SFPacked2_35", 0x00555444); // Cure Serious Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked2_350", 0x16000003); // GR SHADOW CON Acid Arrow
    SetLocalInt(OBJECT_SELF, "SFPacked2_351", 0x06000003); // GR SHADOW CON Ghostly Visage
    SetLocalInt(OBJECT_SELF, "SFPacked2_352", 0x16000003); // GR SHADOW CON Web
    SetLocalInt(OBJECT_SELF, "SFPacked2_353", 0x06000005); // GR SHADOW CON Minor Globe
    SetLocalInt(OBJECT_SELF, "SFPacked2_354", 0x03030333); // Eagle Splendor
    SetLocalInt(OBJECT_SELF, "SFPacked2_355", 0x03003333); // Owls Wisdom
    SetLocalInt(OBJECT_SELF, "SFPacked2_356", 0x03000333); // Foxs Cunning
    SetLocalInt(OBJECT_SELF, "SFPacked2_357", 0x00000007); // Greater Eagle Splendor
    SetLocalInt(OBJECT_SELF, "SFPacked2_358", 0x00000007); // Greater Owls Wisdom
    SetLocalInt(OBJECT_SELF, "SFPacked2_359", 0x00000007); // Greater Foxs Cunning
    SetLocalInt(OBJECT_SELF, "SFPacked2_36", 0x03000333); // Darkness
    SetLocalInt(OBJECT_SELF, "SFPacked2_360", 0x00000007); // Greater Bulls Strength
    SetLocalInt(OBJECT_SELF, "SFPacked2_361", 0x00000007); // Greater Cats Grace
    SetLocalInt(OBJECT_SELF, "SFPacked2_362", 0x00000007); // Greater Endurance
    SetLocalInt(OBJECT_SELF, "SFPacked2_363", 0x00006006); // Awaken
    SetLocalInt(OBJECT_SELF, "SFPacked2_364", 0x10008008); // Creeping Doom
    SetLocalInt(OBJECT_SELF, "SFPacked2_365", 0x03202333); // Ultravision
    SetLocalInt(OBJECT_SELF, "SFPacked2_366", 0x10000808); // Destruction
    SetLocalInt(OBJECT_SELF, "SFPacked2_367", 0x19000009); // Horrid Wilting
    SetLocalInt(OBJECT_SELF, "SFPacked2_368", 0x15006075); // Ice Storm
    SetLocalInt(OBJECT_SELF, "SFPacked2_369", 0x06007076); // Energy Buffer
    SetLocalInt(OBJECT_SELF, "SFPacked2_37", 0x11000011); // Daze
    SetLocalInt(OBJECT_SELF, "SFPacked2_370", 0x14000004); // Negative Energy Burst
    SetLocalInt(OBJECT_SELF, "SFPacked2_371", 0x12000302); // Negative Energy Ray
    SetLocalInt(OBJECT_SELF, "SFPacked2_372", 0x00008008); // Aura of Vitality
    SetLocalInt(OBJECT_SELF, "SFPacked2_373", 0x00000055); // War Cry
    SetLocalInt(OBJECT_SELF, "SFPacked2_374", 0x00007808); // Regenerate
    SetLocalInt(OBJECT_SELF, "SFPacked2_375", 0x15000005); // Evards Black Tentacles
    SetLocalInt(OBJECT_SELF, "SFPacked2_376", 0x07000056); // Legend Lore
    SetLocalInt(OBJECT_SELF, "SFPacked2_377", 0x00000344); // Find Traps
    SetLocalInt(OBJECT_SELF, "SFPacked2_378", 0x00000006); // Summon Mephit
    SetLocalInt(OBJECT_SELF, "SFPacked2_379", 0x00000006); // Summon Celestial
    SetLocalInt(OBJECT_SELF, "SFPacked2_38", 0x00056505); // Death Ward
    SetLocalInt(OBJECT_SELF, "SFPacked2_380", 0x00000002); // Battle Mastery Spell
    SetLocalInt(OBJECT_SELF, "SFPacked2_381", 0x00000002); // Divine Strength
    SetLocalInt(OBJECT_SELF, "SFPacked2_382", 0x00000002); // Divine Protection
    SetLocalInt(OBJECT_SELF, "SFPacked2_383", 0x00000002); // Negative Plane Avatar
    SetLocalInt(OBJECT_SELF, "SFPacked2_384", 0x00000002); // Divine Trickery
    SetLocalInt(OBJECT_SELF, "SFPacked2_385", 0x00000004); // Rogues Cunning
    SetLocalInt(OBJECT_SELF, "SFPacked2_386", 0x00000002); // ACTIVATE ITEM
    SetLocalInt(OBJECT_SELF, "SFPacked2_387", 0x05500004); // Polymorph SwordSpider
    SetLocalInt(OBJECT_SELF, "SFPacked2_388", 0x05500004); // Polymorph Ogre
    SetLocalInt(OBJECT_SELF, "SFPacked2_389", 0x05500004); // Polymorph UMBER HULK
    SetLocalInt(OBJECT_SELF, "SFPacked2_39", 0x18000008); // Delayed Blast Fireball
    SetLocalInt(OBJECT_SELF, "SFPacked2_390", 0x05500004); // Polymorph Satyr
    SetLocalInt(OBJECT_SELF, "SFPacked2_391", 0x05500004); // Polymorph Ooze
    SetLocalInt(OBJECT_SELF, "SFPacked2_392", 0x0a00a00a); // Shapechange RED DRAGON
    SetLocalInt(OBJECT_SELF, "SFPacked2_393", 0x0a00a00a); // Shapechange FIRE GIANT
    SetLocalInt(OBJECT_SELF, "SFPacked2_394", 0x0a00a00a); // Shapechange BALOR
    SetLocalInt(OBJECT_SELF, "SFPacked2_395", 0x0a00a00a); // Shapechange DEATH SLAAD
    SetLocalInt(OBJECT_SELF, "SFPacked2_396", 0x0a00a00a); // Shapechange IRON GOLEM
    SetLocalInt(OBJECT_SELF, "SFPacked2_397", 0x00000004); // Elemental Shape FIRE
    SetLocalInt(OBJECT_SELF, "SFPacked2_398", 0x00000004); // Elemental Shape WATER
    SetLocalInt(OBJECT_SELF, "SFPacked2_399", 0x00000004); // Elemental Shape EARTH
    SetLocalInt(OBJECT_SELF, "SFPacked2_4", 0x15000444); // Bestow Curse
    SetLocalInt(OBJECT_SELF, "SFPacked2_40", 0x16000555); // Dismissal
    SetLocalInt(OBJECT_SELF, "SFPacked2_400", 0x00000004); // Elemental Shape AIR
    SetLocalInt(OBJECT_SELF, "SFPacked2_401", 0x00000004); // Wild Shape BROWN BEAR
    SetLocalInt(OBJECT_SELF, "SFPacked2_402", 0x00000004); // Wild Shape PANTHER
    SetLocalInt(OBJECT_SELF, "SFPacked2_403", 0x00000004); // Wild Shape WOLF
    SetLocalInt(OBJECT_SELF, "SFPacked2_404", 0x00000004); // Wild Shape BOAR
    SetLocalInt(OBJECT_SELF, "SFPacked2_405", 0x00000004); // Wild Shape BADGER
    SetLocalInt(OBJECT_SELF, "SFPacked2_406", 0x00000004); // Special Alcohol Beer
    SetLocalInt(OBJECT_SELF, "SFPacked2_407", 0x00000004); // Special Alcohol Wine
    SetLocalInt(OBJECT_SELF, "SFPacked2_408", 0x00000004); // Special Alcohol Spirits
    SetLocalInt(OBJECT_SELF, "SFPacked2_409", 0x00000004); // Special Herb Belladonna
    SetLocalInt(OBJECT_SELF, "SFPacked2_41", 0x04045444); // Dispel Magic
    SetLocalInt(OBJECT_SELF, "SFPacked2_410", 0x00000004); // Special Herb Garlic
    SetLocalInt(OBJECT_SELF, "SFPacked2_411", 0x00000002); // Bards Song
    SetLocalInt(OBJECT_SELF, "SFPacked2_412", 0x10000008); // Aura Fear Dragon
    SetLocalInt(OBJECT_SELF, "SFPacked2_413", 0x00000002); // ACTIVATE ITEM SELF
    SetLocalInt(OBJECT_SELF, "SFPacked2_414", 0x00020202); // Divine Favor
    SetLocalInt(OBJECT_SELF, "SFPacked2_415", 0x02000002); // True Strike
    SetLocalInt(OBJECT_SELF, "SFPacked2_416", 0x11001011); // Flare
    SetLocalInt(OBJECT_SELF, "SFPacked2_417", 0x02000002); // Shield
    SetLocalInt(OBJECT_SELF, "SFPacked2_418", 0x00000202); // Entropic Shield
    SetLocalInt(OBJECT_SELF, "SFPacked2_419", 0x03000403); // Continual Flame
    SetLocalInt(OBJECT_SELF, "SFPacked2_42", 0x00000505); // Divine Power
    SetLocalInt(OBJECT_SELF, "SFPacked2_420", 0x00303003); // One With The Land
    SetLocalInt(OBJECT_SELF, "SFPacked2_421", 0x00202002); // Camoflage
    SetLocalInt(OBJECT_SELF, "SFPacked2_422", 0x00003003); // Blood Frenzy
    SetLocalInt(OBJECT_SELF, "SFPacked2_423", 0x10009009); // Bombardment
    SetLocalInt(OBJECT_SELF, "SFPacked2_424", 0x11000001); // Acid Splash
    SetLocalInt(OBJECT_SELF, "SFPacked2_425", 0x10004004); // Quillfire
    SetLocalInt(OBJECT_SELF, "SFPacked2_426", 0x1000a909); // Earthquake
    SetLocalInt(OBJECT_SELF, "SFPacked2_427", 0x19009009); // Sunburst
    SetLocalInt(OBJECT_SELF, "SFPacked2_428", 0x00000002); // ACTIVATE ITEM SELF2
    SetLocalInt(OBJECT_SELF, "SFPacked2_429", 0x00030003); // AuraOfGlory
    SetLocalInt(OBJECT_SELF, "SFPacked2_43", 0x10004004); // Dominate Animal
    SetLocalInt(OBJECT_SELF, "SFPacked2_430", 0x18000707); // Banishment
    SetLocalInt(OBJECT_SELF, "SFPacked2_431", 0x10001101); // Inflict Minor Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked2_432", 0x10002202); // Inflict Light Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked2_433", 0x10004303); // Inflict Moderate Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked2_434", 0x10005404); // Inflict Serious Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked2_435", 0x10006505); // Inflict Critical Wounds
    SetLocalInt(OBJECT_SELF, "SFPacked2_436", 0x03000023); // BalagarnsIronHorn
    SetLocalInt(OBJECT_SELF, "SFPacked2_437", 0x10007007); // Drown
    SetLocalInt(OBJECT_SELF, "SFPacked2_438", 0x00006006); // Owls Insight
    SetLocalInt(OBJECT_SELF, "SFPacked2_439", 0x11000001); // Electric Jolt
    SetLocalInt(OBJECT_SELF, "SFPacked2_44", 0x1a00000a); // Dominate Monster
    SetLocalInt(OBJECT_SELF, "SFPacked2_440", 0x16000006); // Firebrand
    SetLocalInt(OBJECT_SELF, "SFPacked2_441", 0x00000044); // Wounding Whispers
    SetLocalInt(OBJECT_SELF, "SFPacked2_442", 0x00000022); // Amplify
    SetLocalInt(OBJECT_SELF, "SFPacked2_443", 0x09000708); // Etherealness
    SetLocalInt(OBJECT_SELF, "SFPacked2_444", 0x00000a0a); // Undeaths Eternal Foe
    SetLocalInt(OBJECT_SELF, "SFPacked2_445", 0x10000077); // Dirge
    SetLocalInt(OBJECT_SELF, "SFPacked2_446", 0x10006006); // Inferno
    SetLocalInt(OBJECT_SELF, "SFPacked2_447", 0x15000005); // Isaacs Lesser Missile Storm
    SetLocalInt(OBJECT_SELF, "SFPacked2_448", 0x17000007); // Isaacs Greater Missile Storm
    SetLocalInt(OBJECT_SELF, "SFPacked2_449", 0x10000202); // Bane
    SetLocalInt(OBJECT_SELF, "SFPacked2_45", 0x16000055); // Dominate Person
    SetLocalInt(OBJECT_SELF, "SFPacked2_450", 0x00000202); // Shield of Faith
    SetLocalInt(OBJECT_SELF, "SFPacked2_451", 0x00000707); // Planar Ally
    SetLocalInt(OBJECT_SELF, "SFPacked2_452", 0x00202002); // Magic Fang
    SetLocalInt(OBJECT_SELF, "SFPacked2_453", 0x00404004); // Greater Magic Fang
    SetLocalInt(OBJECT_SELF, "SFPacked2_454", 0x10304004); // Spike Growth
    SetLocalInt(OBJECT_SELF, "SFPacked2_455", 0x00505005); // Mass Camoflage
    SetLocalInt(OBJECT_SELF, "SFPacked2_456", 0x02000022); // Expeditious Retreat
    SetLocalInt(OBJECT_SELF, "SFPacked2_457", 0x13000033); // Tashas Hideous Laughter
    SetLocalInt(OBJECT_SELF, "SFPacked2_458", 0x04000044); // Displacement
    SetLocalInt(OBJECT_SELF, "SFPacked2_459", 0x06000006); // Bigbys Interposing Hand
    SetLocalInt(OBJECT_SELF, "SFPacked2_46", 0x10000202); // Doom
    SetLocalInt(OBJECT_SELF, "SFPacked2_460", 0x17000007); // Bigbys Forceful Hand
    SetLocalInt(OBJECT_SELF, "SFPacked2_461", 0x18000008); // Bigbys Grasping Hand
    SetLocalInt(OBJECT_SELF, "SFPacked2_462", 0x19000009); // Bigbys Clenched Fist
    SetLocalInt(OBJECT_SELF, "SFPacked2_463", 0x1a00000a); // Bigbys Crushing Hand
    SetLocalInt(OBJECT_SELF, "SFPacked2_464", 0x10000004); // Grenade Fire
    SetLocalInt(OBJECT_SELF, "SFPacked2_465", 0x10000004); // Grenade Tangle
    SetLocalInt(OBJECT_SELF, "SFPacked2_466", 0x10000004); // Grenade Holy
    SetLocalInt(OBJECT_SELF, "SFPacked2_467", 0x10000004); // Grenade Choking
    SetLocalInt(OBJECT_SELF, "SFPacked2_468", 0x10000004); // Grenade Thunderstone
    SetLocalInt(OBJECT_SELF, "SFPacked2_469", 0x10000004); // Grenade Acid
    SetLocalInt(OBJECT_SELF, "SFPacked2_47", 0x05000005); // Elemental Shield
    SetLocalInt(OBJECT_SELF, "SFPacked2_470", 0x10000004); // Grenade Chicken
    SetLocalInt(OBJECT_SELF, "SFPacked2_471", 0x10000004); // Grenade Caltrops
    SetLocalInt(OBJECT_SELF, "SFPacked2_472", 0x00000002); // ACTIVATE ITEM PORTAL
    SetLocalInt(OBJECT_SELF, "SFPacked2_473", 0x00000002); // Divine Might
    SetLocalInt(OBJECT_SELF, "SFPacked2_474", 0x00000002); // Divine Shield
    SetLocalInt(OBJECT_SELF, "SFPacked2_475", 0x10000000); // SHADOW DAZE
    SetLocalInt(OBJECT_SELF, "SFPacked2_476", 0x10000000); // SUMMON SHADOW
    SetLocalInt(OBJECT_SELF, "SFPacked2_479", 0x00000002); // CRAFT HARPER ITEM
    SetLocalInt(OBJECT_SELF, "SFPacked2_48", 0x0000a00a); // Elemental Swarm
    SetLocalInt(OBJECT_SELF, "SFPacked2_480", 0x10000002); // Sleep
    SetLocalInt(OBJECT_SELF, "SFPacked2_481", 0x00000003); // Cats Grace
    SetLocalInt(OBJECT_SELF, "SFPacked2_482", 0x00000003); // Eagle Splendor
    SetLocalInt(OBJECT_SELF, "SFPacked2_483", 0x00000003); // Invisibility
    SetLocalInt(OBJECT_SELF, "SFPacked2_485", 0x17000007); // Flesh to stone
    SetLocalInt(OBJECT_SELF, "SFPacked2_486", 0x07000007); // Stone to flesh
    SetLocalInt(OBJECT_SELF, "SFPacked2_487", 0x10000006); // Trap Arrow
    SetLocalInt(OBJECT_SELF, "SFPacked2_488", 0x10000006); // Trap Bolt
    SetLocalInt(OBJECT_SELF, "SFPacked2_49", 0x03303303); // Endurance
    SetLocalInt(OBJECT_SELF, "SFPacked2_493", 0x10000006); // Trap Dart
    SetLocalInt(OBJECT_SELF, "SFPacked2_494", 0x10000006); // Trap Shuriken
    SetLocalInt(OBJECT_SELF, "SFPacked2_495", 0x10000006); // Breath Petrify
    SetLocalInt(OBJECT_SELF, "SFPacked2_496", 0x10000006); // Touch Petrify
    SetLocalInt(OBJECT_SELF, "SFPacked2_497", 0x10000006); // Gaze Petrify
    SetLocalInt(OBJECT_SELF, "SFPacked2_498", 0x10000006); // Manticore Spikes
    SetLocalInt(OBJECT_SELF, "SFPacked2_499", 0x1000000b); // RodOfWonder
    SetLocalInt(OBJECT_SELF, "SFPacked2_5", 0x10000707); // Blade Barrier
    SetLocalInt(OBJECT_SELF, "SFPacked2_50", 0x02022202); // Endure Elements
    SetLocalInt(OBJECT_SELF, "SFPacked2_500", 0x0000000b); // DeckOfManyThings
    SetLocalInt(OBJECT_SELF, "SFPacked2_502", 0x00000006); // ElementalSummoningItem
    SetLocalInt(OBJECT_SELF, "SFPacked2_503", 0x0000000b); // DeckAvatar
    SetLocalInt(OBJECT_SELF, "SFPacked2_504", 0x10000006); // Gem Spray
    SetLocalInt(OBJECT_SELF, "SFPacked2_505", 0x10000006); // Butterfly Spray
    SetLocalInt(OBJECT_SELF, "SFPacked2_507", 0x00000002); // PowerStone
    SetLocalInt(OBJECT_SELF, "SFPacked2_508", 0x00000002); // Spellstaff
    SetLocalInt(OBJECT_SELF, "SFPacked2_509", 0x00000002); // Charger
    SetLocalInt(OBJECT_SELF, "SFPacked2_51", 0x1a000a0a); // Energy Drain
    SetLocalInt(OBJECT_SELF, "SFPacked2_510", 0x00000002); // Decharger
    SetLocalInt(OBJECT_SELF, "SFPacked2_511", 0x00000004); // Kobold Jump
    SetLocalInt(OBJECT_SELF, "SFPacked2_512", 0x10007007); // Crumble
    SetLocalInt(OBJECT_SELF, "SFPacked2_513", 0x10004004); // Infestation of Maggots
    SetLocalInt(OBJECT_SELF, "SFPacked2_514", 0x10004004); // Healing Sting
    SetLocalInt(OBJECT_SELF, "SFPacked2_515", 0x18000008); // Great Thunderclap
    SetLocalInt(OBJECT_SELF, "SFPacked2_516", 0x16000006); // Ball Lightning
    SetLocalInt(OBJECT_SELF, "SFPacked2_517", 0x10000606); // Battletide
    SetLocalInt(OBJECT_SELF, "SFPacked2_518", 0x13000003); // Combust
    SetLocalInt(OBJECT_SELF, "SFPacked2_519", 0x03000003); // Death Armor
    SetLocalInt(OBJECT_SELF, "SFPacked2_52", 0x15000005); // Enervation
    SetLocalInt(OBJECT_SELF, "SFPacked2_520", 0x13000003); // Gedlees Electric Loop
    SetLocalInt(OBJECT_SELF, "SFPacked2_521", 0x12000002); // Horizikauls Boom
    SetLocalInt(OBJECT_SELF, "SFPacked2_522", 0x02000002); // Ironguts
    SetLocalInt(OBJECT_SELF, "SFPacked2_523", 0x14000004); // Mestils Acid Breath
    SetLocalInt(OBJECT_SELF, "SFPacked2_524", 0x06000006); // Mestils Acid Sheath
    SetLocalInt(OBJECT_SELF, "SFPacked2_525", 0x00006606); // Monstrous Regeneration
    SetLocalInt(OBJECT_SELF, "SFPacked2_526", 0x14000004); // Scintillating Sphere
    SetLocalInt(OBJECT_SELF, "SFPacked2_527", 0x03000303); // Stone Bones
    SetLocalInt(OBJECT_SELF, "SFPacked2_528", 0x17000707); // Undeath to Death
    SetLocalInt(OBJECT_SELF, "SFPacked2_529", 0x10406006); // Vine Mine
    SetLocalInt(OBJECT_SELF, "SFPacked2_53", 0x10202002); // Entangle
    SetLocalInt(OBJECT_SELF, "SFPacked2_530", 0x10406002); // Vine Mine Entangle
    SetLocalInt(OBJECT_SELF, "SFPacked2_531", 0x10406002); // Vine Mine Hamper Movement
    SetLocalInt(OBJECT_SELF, "SFPacked2_532", 0x00406002); // Vine Mine Camouflage
    SetLocalInt(OBJECT_SELF, "SFPacked2_533", 0x0a00000a); // Black Blade of Disaster
    SetLocalInt(OBJECT_SELF, "SFPacked2_534", 0x02000002); // Shelgarns Persistent Blade
    SetLocalInt(OBJECT_SELF, "SFPacked2_535", 0x00400004); // Blade Thirst
    SetLocalInt(OBJECT_SELF, "SFPacked2_536", 0x00020002); // Deafening Clang
    SetLocalInt(OBJECT_SELF, "SFPacked2_537", 0x00020002); // Bless Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked2_539", 0x04000044); // Keen Edge
    SetLocalInt(OBJECT_SELF, "SFPacked2_54", 0x15000044); // Fear
    SetLocalInt(OBJECT_SELF, "SFPacked2_541", 0x09000009); // Blackstaff
    SetLocalInt(OBJECT_SELF, "SFPacked2_542", 0x03000003); // Flame Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked2_543", 0x12000002); // Ice Dagger
    SetLocalInt(OBJECT_SELF, "SFPacked2_544", 0x02020222); // Magic Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked2_545", 0x04000544); // Greater Magic Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked2_546", 0x00000404); // Magic Vestment
    SetLocalInt(OBJECT_SELF, "SFPacked2_547", 0x10007007); // Stonehold
    SetLocalInt(OBJECT_SELF, "SFPacked2_548", 0x00000404); // Darkfire
    SetLocalInt(OBJECT_SELF, "SFPacked2_549", 0x10000404); // Glyph of Warding
    SetLocalInt(OBJECT_SELF, "SFPacked2_55", 0x16000006); // Feeblemind
    SetLocalInt(OBJECT_SELF, "SFPacked2_551", 0x10000006); // MONSTER MindBlast
    SetLocalInt(OBJECT_SELF, "SFPacked2_552", 0x10000004); // MONSTER CharmMonster
    SetLocalInt(OBJECT_SELF, "SFPacked2_553", 0x10000004); // Goblin Ballista Fireball
    SetLocalInt(OBJECT_SELF, "SFPacked2_554", 0x00000004); // Ioun Stone Dusty Rose
    SetLocalInt(OBJECT_SELF, "SFPacked2_555", 0x00000004); // Ioun Stone Pale Blue
    SetLocalInt(OBJECT_SELF, "SFPacked2_556", 0x00000004); // Ioun Stone Scarlet Blue
    SetLocalInt(OBJECT_SELF, "SFPacked2_557", 0x00000004); // Ioun Stone Blue
    SetLocalInt(OBJECT_SELF, "SFPacked2_558", 0x00000004); // Ioun Stone Deep Red
    SetLocalInt(OBJECT_SELF, "SFPacked2_559", 0x00000004); // Ioun Stone Pink
    SetLocalInt(OBJECT_SELF, "SFPacked2_56", 0x18009008); // Finger of Death
    SetLocalInt(OBJECT_SELF, "SFPacked2_560", 0x00000004); // Ioun Stone Pink Green
    SetLocalInt(OBJECT_SELF, "SFPacked2_561", 0x00000002); // Whirlwind
    SetLocalInt(OBJECT_SELF, "SFPacked2_562", 0x00000003); // AuraOfGlory X2
    SetLocalInt(OBJECT_SELF, "SFPacked2_563", 0x00000004); // Haste Slow X2
    SetLocalInt(OBJECT_SELF, "SFPacked2_564", 0x00000007); // Summon Shadow X2
    SetLocalInt(OBJECT_SELF, "SFPacked2_565", 0x0000000a); // Tide of Battle
    SetLocalInt(OBJECT_SELF, "SFPacked2_566", 0x00000006); // Evil Blight
    SetLocalInt(OBJECT_SELF, "SFPacked2_567", 0x00000005); // Cure Critical Wounds Others
    SetLocalInt(OBJECT_SELF, "SFPacked2_568", 0x00000005); // Restoration Others
    SetLocalInt(OBJECT_SELF, "SFPacked2_569", 0x13003033); // Cloud of Bewilderment
    SetLocalInt(OBJECT_SELF, "SFPacked2_57", 0x10008908); // Fire Storm
    SetLocalInt(OBJECT_SELF, "SFPacked2_58", 0x14000004); // Fireball
    SetLocalInt(OBJECT_SELF, "SFPacked2_59", 0x14000004); // Flame Arrow
    SetLocalInt(OBJECT_SELF, "SFPacked2_595", 0x10000006); // BGSummonLesserFiend
    SetLocalInt(OBJECT_SELF, "SFPacked2_596", 0x10000006); // BGSummonGreaterFiend
    SetLocalInt(OBJECT_SELF, "SFPacked2_597", 0x10000006); // BGNightmare
    SetLocalInt(OBJECT_SELF, "SFPacked2_6", 0x00020202); // Bless
    SetLocalInt(OBJECT_SELF, "SFPacked2_60", 0x10003003); // Flame Lash
    SetLocalInt(OBJECT_SELF, "SFPacked2_600", 0x00000002); // ARImbueArrow
    SetLocalInt(OBJECT_SELF, "SFPacked2_601", 0x10000002); // ARSeekerArrow
    SetLocalInt(OBJECT_SELF, "SFPacked2_602", 0x10000002); // ARSeekerArrow2
    SetLocalInt(OBJECT_SELF, "SFPacked2_603", 0x10000002); // ARHailOfArrows
    SetLocalInt(OBJECT_SELF, "SFPacked2_604", 0x10000002); // ARArrowOfDeath
    SetLocalInt(OBJECT_SELF, "SFPacked2_609", 0x10000002); // BGCreateDead
    SetLocalInt(OBJECT_SELF, "SFPacked2_61", 0x10005605); // Flame Strike
    SetLocalInt(OBJECT_SELF, "SFPacked2_610", 0x10000006); // BGFiendish
    SetLocalInt(OBJECT_SELF, "SFPacked2_611", 0x10000004); // BGInflictSerious
    SetLocalInt(OBJECT_SELF, "SFPacked2_612", 0x10000005); // BGInflictCritical
    SetLocalInt(OBJECT_SELF, "SFPacked2_613", 0x10000004); // BK Contagion
    SetLocalInt(OBJECT_SELF, "SFPacked2_614", 0x00000003); // BK BullsStrength
    SetLocalInt(OBJECT_SELF, "SFPacked2_615", 0x00000002); // Twinfists
    SetLocalInt(OBJECT_SELF, "SFPacked2_616", 0x00000002); // LichLyrics
    SetLocalInt(OBJECT_SELF, "SFPacked2_617", 0x00000002); // Iceberry
    SetLocalInt(OBJECT_SELF, "SFPacked2_618", 0x00000002); // Flameberry
    SetLocalInt(OBJECT_SELF, "SFPacked2_619", 0x00000002); // PrayerBox
    SetLocalInt(OBJECT_SELF, "SFPacked2_62", 0x00555505); // Freedom of Movement
    SetLocalInt(OBJECT_SELF, "SFPacked2_620", 0x00000004); // Flying Debris
    SetLocalInt(OBJECT_SELF, "SFPacked2_623", 0x00000003); // PM Animate Dead
    SetLocalInt(OBJECT_SELF, "SFPacked2_624", 0x00000005); // PM Summon Undead
    SetLocalInt(OBJECT_SELF, "SFPacked2_625", 0x10000007); // PM Undead Graft1
    SetLocalInt(OBJECT_SELF, "SFPacked2_626", 0x10000007); // PM Undead Graft2
    SetLocalInt(OBJECT_SELF, "SFPacked2_627", 0x0000000a); // PM Summon Greater Undead
    SetLocalInt(OBJECT_SELF, "SFPacked2_628", 0x1000000b); // PM Deathless Master Touch
    SetLocalInt(OBJECT_SELF, "SFPacked2_63", 0x0a000a0a); // Gate
    SetLocalInt(OBJECT_SELF, "SFPacked2_636", 0x1000000b); // Hellball
    SetLocalInt(OBJECT_SELF, "SFPacked2_637", 0x0000000b); // Mummy Dust
    SetLocalInt(OBJECT_SELF, "SFPacked2_638", 0x0000000b); // Dragon Knight
    SetLocalInt(OBJECT_SELF, "SFPacked2_639", 0x0000000b); // Epic Mage Armor
    SetLocalInt(OBJECT_SELF, "SFPacked2_64", 0x13000003); // Ghoul Touch
    SetLocalInt(OBJECT_SELF, "SFPacked2_640", 0x1000000b); // Ruin
    SetLocalInt(OBJECT_SELF, "SFPacked2_641", 0x00000002); // DWDEF Defensive Stance
    SetLocalInt(OBJECT_SELF, "SFPacked2_642", 0x00000002); // Mighty Rage
    SetLocalInt(OBJECT_SELF, "SFPacked2_643", 0x10000002); // PlanarTurning
    SetLocalInt(OBJECT_SELF, "SFPacked2_644", 0x00000002); // Curse Song
    SetLocalInt(OBJECT_SELF, "SFPacked2_645", 0x00000002); // Improved Whirlwind
    SetLocalInt(OBJECT_SELF, "SFPacked2_646", 0x00000002); // Greater Wild Shape 1
    SetLocalInt(OBJECT_SELF, "SFPacked2_647", 0x00000004); // Epic Blinding speed
    SetLocalInt(OBJECT_SELF, "SFPacked2_648", 0x00000002); // Dye Armor cloth1
    SetLocalInt(OBJECT_SELF, "SFPacked2_649", 0x00000002); // Dye Armor Cloth2
    SetLocalInt(OBJECT_SELF, "SFPacked2_65", 0x07000007); // Globe of Invulnerability
    SetLocalInt(OBJECT_SELF, "SFPacked2_650", 0x00000002); // Dye Armor Leather1
    SetLocalInt(OBJECT_SELF, "SFPacked2_651", 0x00000002); // Dye Armor Leather2
    SetLocalInt(OBJECT_SELF, "SFPacked2_652", 0x00000002); // Dye Armor Metal1
    SetLocalInt(OBJECT_SELF, "SFPacked2_653", 0x00000002); // Dye Armor Metal2
    SetLocalInt(OBJECT_SELF, "SFPacked2_654", 0x00000002); // Add Item Property
    SetLocalInt(OBJECT_SELF, "SFPacked2_655", 0x00000002); // Poison Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked2_656", 0x00000002); // Craft Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked2_657", 0x00000002); // Craft Armor
    SetLocalInt(OBJECT_SELF, "SFPacked2_658", 0x00000004); // Greater Wild Shape Wyrmling Red
    SetLocalInt(OBJECT_SELF, "SFPacked2_659", 0x00000004); // Greater Wild Shape Wyrmling Blue
    SetLocalInt(OBJECT_SELF, "SFPacked2_66", 0x12202022); // Grease
    SetLocalInt(OBJECT_SELF, "SFPacked2_660", 0x00000004); // Greater Wild Shape Wyrmling Black
    SetLocalInt(OBJECT_SELF, "SFPacked2_661", 0x00000004); // Greater Wild Shape Wyrmling White
    SetLocalInt(OBJECT_SELF, "SFPacked2_662", 0x00000004); // Greater Wild Shape Wyrmling Green
    SetLocalInt(OBJECT_SELF, "SFPacked2_663", 0x1000000a); // WyrmlingPCBreathCold
    SetLocalInt(OBJECT_SELF, "SFPacked2_664", 0x1000000a); // WyrmlingPCBreathAcid
    SetLocalInt(OBJECT_SELF, "SFPacked2_665", 0x1000000a); // WyrmlingPCBreathFire
    SetLocalInt(OBJECT_SELF, "SFPacked2_666", 0x1000000a); // WyrmlingPCBreathGas
    SetLocalInt(OBJECT_SELF, "SFPacked2_667", 0x1000000a); // WyrmlingPCBreathLightning
    SetLocalInt(OBJECT_SELF, "SFPacked2_67", 0x07007766); // Greater Dispelling
    SetLocalInt(OBJECT_SELF, "SFPacked2_670", 0x00000004); // Greater Wild Shape Basilisk
    SetLocalInt(OBJECT_SELF, "SFPacked2_671", 0x00000004); // Greater Wild Shape Beholder
    SetLocalInt(OBJECT_SELF, "SFPacked2_672", 0x00000004); // Greater Wild Shape Harpy
    SetLocalInt(OBJECT_SELF, "SFPacked2_673", 0x00000004); // Greater Wild Shape Drider
    SetLocalInt(OBJECT_SELF, "SFPacked2_674", 0x00000004); // Greater Wild Shape Manticore
    SetLocalInt(OBJECT_SELF, "SFPacked2_675", 0x00000002); // Greater Wild Shape 2
    SetLocalInt(OBJECT_SELF, "SFPacked2_676", 0x00000002); // Greater Wild Shape 3
    SetLocalInt(OBJECT_SELF, "SFPacked2_677", 0x00000002); // Greater Wild Shape 4
    SetLocalInt(OBJECT_SELF, "SFPacked2_678", 0x00000004); // Greater Wild Shape Gargoyle
    SetLocalInt(OBJECT_SELF, "SFPacked2_679", 0x00000004); // Greater Wild Shape Medusa
    SetLocalInt(OBJECT_SELF, "SFPacked2_68", 0x00000004); // Greater Magic Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked2_680", 0x00000004); // Greater Wild Shape Minotaur
    SetLocalInt(OBJECT_SELF, "SFPacked2_681", 0x00000002); // Humanoid Shape
    SetLocalInt(OBJECT_SELF, "SFPacked2_682", 0x00000004); // Humanoid Shape Drow
    SetLocalInt(OBJECT_SELF, "SFPacked2_683", 0x00000004); // Humanoid Shape Lizardfolk
    SetLocalInt(OBJECT_SELF, "SFPacked2_684", 0x00000004); // Humanoid Shape KoboldAssa
    SetLocalInt(OBJECT_SELF, "SFPacked2_685", 0x00000002); // Undead shape
    SetLocalInt(OBJECT_SELF, "SFPacked2_686", 0x10000005); // Harpysong
    SetLocalInt(OBJECT_SELF, "SFPacked2_687", 0x10000006); // GWildShape Stonegaze
    SetLocalInt(OBJECT_SELF, "SFPacked2_688", 0x00000003); // GWildShape DriderDarkness
    SetLocalInt(OBJECT_SELF, "SFPacked2_69", 0x09000009); // Greater Planar Binding
    SetLocalInt(OBJECT_SELF, "SFPacked2_690", 0x1000000a); // RedDragonDiscipleBreath
    SetLocalInt(OBJECT_SELF, "SFPacked2_691", 0x00000004); // Greater Wild Shape Mindflayer
    SetLocalInt(OBJECT_SELF, "SFPacked2_692", 0x10000006); // Greater Wild Shape Spikes
    SetLocalInt(OBJECT_SELF, "SFPacked2_693", 0x10000006); // GWildShape Mindblast
    SetLocalInt(OBJECT_SELF, "SFPacked2_694", 0x00000004); // Greater Wild Shape DireTiger
    SetLocalInt(OBJECT_SELF, "SFPacked2_695", 0x1000000b); // Epic Warding
    SetLocalInt(OBJECT_SELF, "SFPacked2_696", 0x10000004); // OnHitFireDamage
    SetLocalInt(OBJECT_SELF, "SFPacked2_697", 0x00000002); // ACTIVATE ITEM L
    SetLocalInt(OBJECT_SELF, "SFPacked2_698", 0x1000000a); // Dragon Breath Negative
    SetLocalInt(OBJECT_SELF, "SFPacked2_7", 0x00000002); // Bless Weapon
    SetLocalInt(OBJECT_SELF, "SFPacked2_70", 0x00000808); // Greater Restoration
    SetLocalInt(OBJECT_SELF, "SFPacked2_700", 0x00000002); // ACTIVATE ITEM ONHITSPELLCAST
    SetLocalInt(OBJECT_SELF, "SFPacked2_701", 0x10000006); // Summon Baatezu
    SetLocalInt(OBJECT_SELF, "SFPacked2_702", 0x10000004); // OnHitPlanarRift
    SetLocalInt(OBJECT_SELF, "SFPacked2_703", 0x10000004); // OnHitDarkfire
    SetLocalInt(OBJECT_SELF, "SFPacked2_704", 0x00000004); // Undead Shape risen lord
    SetLocalInt(OBJECT_SELF, "SFPacked2_705", 0x00000004); // Undead Shape Vampire
    SetLocalInt(OBJECT_SELF, "SFPacked2_706", 0x00000004); // Undead Shape Spectre
    SetLocalInt(OBJECT_SELF, "SFPacked2_707", 0x00000004); // Greater Wild Shape Red dragon
    SetLocalInt(OBJECT_SELF, "SFPacked2_708", 0x00000004); // Greater Wild Shape Blue dragon
    SetLocalInt(OBJECT_SELF, "SFPacked2_709", 0x00000004); // Greater Wild Shape Green dragon
    SetLocalInt(OBJECT_SELF, "SFPacked2_71", 0x16000006); // Greater Shadow Conjuration
    SetLocalInt(OBJECT_SELF, "SFPacked2_710", 0x10000002); // EyeballRay0
    SetLocalInt(OBJECT_SELF, "SFPacked2_711", 0x10000002); // EyeballRay1
    SetLocalInt(OBJECT_SELF, "SFPacked2_712", 0x10000002); // EyeballRay2
    SetLocalInt(OBJECT_SELF, "SFPacked2_713", 0x10000009); // Mindflayer Mindblast 10
    SetLocalInt(OBJECT_SELF, "SFPacked2_715", 0x10000007); // Golem Ranged Slam
    SetLocalInt(OBJECT_SELF, "SFPacked2_717", 0x00000002); // ACTIVATE ITEM SEQUENCER 1
    SetLocalInt(OBJECT_SELF, "SFPacked2_718", 0x00000002); // ACTIVATE ITEM SEQUENCER 2
    SetLocalInt(OBJECT_SELF, "SFPacked2_719", 0x00000002); // ACTIVATE ITEM SEQUENCER 3
    SetLocalInt(OBJECT_SELF, "SFPacked2_72", 0x17000007); // Greater Spell Breach
    SetLocalInt(OBJECT_SELF, "SFPacked2_720", 0x00000002); // CLEAR SEQUENCER
    SetLocalInt(OBJECT_SELF, "SFPacked2_721", 0x00000002); // OnHitFlamingSkin
    SetLocalInt(OBJECT_SELF, "SFPacked2_722", 0x00000004); // Mimic Eat
    SetLocalInt(OBJECT_SELF, "SFPacked2_724", 0x00000008); // Etherealness
    SetLocalInt(OBJECT_SELF, "SFPacked2_725", 0x00000002); // Dragon Shape
    SetLocalInt(OBJECT_SELF, "SFPacked2_726", 0x00000004); // Mimic Eat Enemy
    SetLocalInt(OBJECT_SELF, "SFPacked2_727", 0x00000006); // Beholder Anti Magic Cone
    SetLocalInt(OBJECT_SELF, "SFPacked2_729", 0x00000004); // Mimic Steal armor
    SetLocalInt(OBJECT_SELF, "SFPacked2_73", 0x0a00000a); // Greater Spell Mantle
    SetLocalInt(OBJECT_SELF, "SFPacked2_731", 0x1000000a); // Bebelith Web
    SetLocalInt(OBJECT_SELF, "SFPacked2_732", 0x00000002); // Outsider Shape
    SetLocalInt(OBJECT_SELF, "SFPacked2_733", 0x00000004); // Outsider Shape Azer
    SetLocalInt(OBJECT_SELF, "SFPacked2_734", 0x00000004); // Outsider Shape Rakshasa
    SetLocalInt(OBJECT_SELF, "SFPacked2_735", 0x00000004); // Outsider Shape DeathSlaad
    SetLocalInt(OBJECT_SELF, "SFPacked2_736", 0x10000006); // Beholder Special Spell AI
    SetLocalInt(OBJECT_SELF, "SFPacked2_737", 0x00000002); // Construct Shape
    SetLocalInt(OBJECT_SELF, "SFPacked2_738", 0x00000004); // Construct Shape StoneGolem
    SetLocalInt(OBJECT_SELF, "SFPacked2_739", 0x00000004); // Construct Shape DemonFleshGolem
    SetLocalInt(OBJECT_SELF, "SFPacked2_74", 0x07007007); // Greater Stoneskin
    SetLocalInt(OBJECT_SELF, "SFPacked2_740", 0x00000004); // Construct Shape IronGolem
    SetLocalInt(OBJECT_SELF, "SFPacked2_741", 0x00000005); // Psionic Inertial Barrier
    SetLocalInt(OBJECT_SELF, "SFPacked2_742", 0x00000002); // Craft Weapon Component
    SetLocalInt(OBJECT_SELF, "SFPacked2_743", 0x00000002); // Craft Armor Component
    SetLocalInt(OBJECT_SELF, "SFPacked2_744", 0x10000004); // Grenade FireBomb
    SetLocalInt(OBJECT_SELF, "SFPacked2_745", 0x10000004); // Grenade AcidBomb
    SetLocalInt(OBJECT_SELF, "SFPacked2_75", 0x14003044); // Gust of Wind
    SetLocalInt(OBJECT_SELF, "SFPacked2_756", 0x10000002); // OnHitBebilithAttack
    SetLocalInt(OBJECT_SELF, "SFPacked2_757", 0x00000009); // ShadowBlend
    SetLocalInt(OBJECT_SELF, "SFPacked2_758", 0x10000002); // OnHitDemilichTouch
    SetLocalInt(OBJECT_SELF, "SFPacked2_759", 0x00000007); // UndeadSelfHarm
    SetLocalInt(OBJECT_SELF, "SFPacked2_76", 0x10050505); // Hammer of the Gods
    SetLocalInt(OBJECT_SELF, "SFPacked2_760", 0x10000002); // OnHitDracolichTouch
    SetLocalInt(OBJECT_SELF, "SFPacked2_761", 0x1000000a); // Aura of Hellfire
    SetLocalInt(OBJECT_SELF, "SFPacked2_762", 0x1000000a); // Hell Inferno
    SetLocalInt(OBJECT_SELF, "SFPacked2_763", 0x10000006); // Psionic Mass Concussion
    SetLocalInt(OBJECT_SELF, "SFPacked2_764", 0x10000003); // GlyphOfWardingDefault
    SetLocalInt(OBJECT_SELF, "SFPacked2_767", 0x00000002); // Intelligent Weapon Talk
    SetLocalInt(OBJECT_SELF, "SFPacked2_768", 0x10000002); // Intelligent Weapon OnHit
    SetLocalInt(OBJECT_SELF, "SFPacked2_769", 0x10000000); // Shadow Attack
    SetLocalInt(OBJECT_SELF, "SFPacked2_77", 0x10008707); // Harm
    SetLocalInt(OBJECT_SELF, "SFPacked2_770", 0x10000005); // Slaad Chaos Spittle
    SetLocalInt(OBJECT_SELF, "SFPacked2_771", 0x1000000a); // Dragon Breath Prismatic
    SetLocalInt(OBJECT_SELF, "SFPacked2_772", 0x10000004); // Spiral Fireball
    SetLocalInt(OBJECT_SELF, "SFPacked2_773", 0x00000004); // Battle Boulder Toss
    SetLocalInt(OBJECT_SELF, "SFPacked2_774", 0x00000007); // Deflecting Force
    SetLocalInt(OBJECT_SELF, "SFPacked2_775", 0x10000005); // Giant hurl rock
    SetLocalInt(OBJECT_SELF, "SFPacked2_776", 0x10000009); // Beholder Node 1
    SetLocalInt(OBJECT_SELF, "SFPacked2_777", 0x10000009); // Beholder Node 2
    SetLocalInt(OBJECT_SELF, "SFPacked2_778", 0x10000009); // Beholder Node 3
    SetLocalInt(OBJECT_SELF, "SFPacked2_779", 0x10000009); // Beholder Node 4
    SetLocalInt(OBJECT_SELF, "SFPacked2_78", 0x04000044); // Haste
    SetLocalInt(OBJECT_SELF, "SFPacked2_780", 0x10000009); // Beholder Node 5
    SetLocalInt(OBJECT_SELF, "SFPacked2_783", 0x10000009); // Beholder Node 6
    SetLocalInt(OBJECT_SELF, "SFPacked2_784", 0x10000009); // Beholder Node 7
    SetLocalInt(OBJECT_SELF, "SFPacked2_785", 0x10000009); // Beholder Node 8
    SetLocalInt(OBJECT_SELF, "SFPacked2_786", 0x10000009); // Beholder Node 9
    SetLocalInt(OBJECT_SELF, "SFPacked2_787", 0x10000009); // Beholder Node 10
    SetLocalInt(OBJECT_SELF, "SFPacked2_788", 0x10000002); // OnHitParalyze
    SetLocalInt(OBJECT_SELF, "SFPacked2_789", 0x10000006); // Illithid Mindblast
    SetLocalInt(OBJECT_SELF, "SFPacked2_79", 0x00008707); // Heal
    SetLocalInt(OBJECT_SELF, "SFPacked2_790", 0x10000002); // OnHitDeafenClang
    SetLocalInt(OBJECT_SELF, "SFPacked2_791", 0x00000002); // OnHitKnockDown
    SetLocalInt(OBJECT_SELF, "SFPacked2_792", 0x00000002); // OnHitFreeze
    SetLocalInt(OBJECT_SELF, "SFPacked2_793", 0x00000004); // Demonic Grappling Hand
    SetLocalInt(OBJECT_SELF, "SFPacked2_794", 0x10000002); // Ballista Bolt
    SetLocalInt(OBJECT_SELF, "SFPacked2_795", 0x00000002); // ACTIVATE ITEM T
    SetLocalInt(OBJECT_SELF, "SFPacked2_796", 0x1000000a); // Dragon Breath Lightning
    SetLocalInt(OBJECT_SELF, "SFPacked2_797", 0x1000000a); // Dragon Breath Fire
    SetLocalInt(OBJECT_SELF, "SFPacked2_798", 0x1000000a); // Dragon Breath Gas
    SetLocalInt(OBJECT_SELF, "SFPacked2_799", 0x00000005); // Vampire Invisibility
    SetLocalInt(OBJECT_SELF, "SFPacked2_8", 0x13000433); // Blindness and Deafness
    SetLocalInt(OBJECT_SELF, "SFPacked2_80", 0x00007666); // Healing Circle
    SetLocalInt(OBJECT_SELF, "SFPacked2_800", 0x10000007); // Vampire DominationGaze
    SetLocalInt(OBJECT_SELF, "SFPacked2_801", 0x10000005); // Azer Fire Blast
    SetLocalInt(OBJECT_SELF, "SFPacked2_802", 0x10000000); // Shifter Spectre Attack
    SetLocalInt(OBJECT_SELF, "SFPacked2_803", 0x10000007); // SeaHag EvilEye
    SetLocalInt(OBJECT_SELF, "SFPacked2_804", 0x10000006); // Aura HorrificAppearance
    SetLocalInt(OBJECT_SELF, "SFPacked2_805", 0x10000004); // Troglodyte Stench
    SetLocalInt(OBJECT_SELF, "SFPacked2_806", 0x00000002); // PDK RallyingCry
    SetLocalInt(OBJECT_SELF, "SFPacked2_807", 0x0000000a); // PDK Shield
    SetLocalInt(OBJECT_SELF, "SFPacked2_808", 0x10000004); // PDK Fear
    SetLocalInt(OBJECT_SELF, "SFPacked2_809", 0x00000008); // PDK OathOfWrath
    SetLocalInt(OBJECT_SELF, "SFPacked2_81", 0x10303003); // Hold Animal
    SetLocalInt(OBJECT_SELF, "SFPacked2_810", 0x00000002); // PDK FinalStand
    SetLocalInt(OBJECT_SELF, "SFPacked2_811", 0x00000002); // PDK InspireCourage
    SetLocalInt(OBJECT_SELF, "SFPacked2_813", 0x00000002); // Horse Mount
    SetLocalInt(OBJECT_SELF, "SFPacked2_814", 0x00000002); // Horse Dismount
    SetLocalInt(OBJECT_SELF, "SFPacked2_815", 0x00000002); // Horse Party Mount
    SetLocalInt(OBJECT_SELF, "SFPacked2_816", 0x00000002); // Horse Party Dismount
    SetLocalInt(OBJECT_SELF, "SFPacked2_817", 0x00000002); // Horse Assign Mount
    SetLocalInt(OBJECT_SELF, "SFPacked2_819", 0x10000004); // Nightmare Smoke
    SetLocalInt(OBJECT_SELF, "SFPacked2_82", 0x16005055); // Hold Monster
    SetLocalInt(OBJECT_SELF, "SFPacked2_820", 0x00000002); // DM TOOL 01
    SetLocalInt(OBJECT_SELF, "SFPacked2_821", 0x00000002); // DM TOOL 02
    SetLocalInt(OBJECT_SELF, "SFPacked2_822", 0x00000002); // DM TOOL 03
    SetLocalInt(OBJECT_SELF, "SFPacked2_823", 0x00000002); // DM TOOL 04
    SetLocalInt(OBJECT_SELF, "SFPacked2_824", 0x00000002); // DM TOOL 05
    SetLocalInt(OBJECT_SELF, "SFPacked2_825", 0x00000002); // DM TOOL 06
    SetLocalInt(OBJECT_SELF, "SFPacked2_826", 0x00000002); // DM TOOL 07
    SetLocalInt(OBJECT_SELF, "SFPacked2_827", 0x00000002); // DM TOOL 08
    SetLocalInt(OBJECT_SELF, "SFPacked2_828", 0x00000002); // DM TOOL 09
    SetLocalInt(OBJECT_SELF, "SFPacked2_829", 0x00000002); // DM TOOL 10
    SetLocalInt(OBJECT_SELF, "SFPacked2_83", 0x14000333); // Hold Person
    SetLocalInt(OBJECT_SELF, "SFPacked2_830", 0x00000002); // EXAMINE
    SetLocalInt(OBJECT_SELF, "SFPacked2_831", 0x00000002); // DEBUFF
    SetLocalInt(OBJECT_SELF, "SFPacked2_832", 0x00000002); // PLAYER TOOL 03
    SetLocalInt(OBJECT_SELF, "SFPacked2_833", 0x00000002); // PLAYER TOOL 04
    SetLocalInt(OBJECT_SELF, "SFPacked2_834", 0x00000002); // PLAYER TOOL 05
    SetLocalInt(OBJECT_SELF, "SFPacked2_835", 0x00000002); // PLAYER TOOL 06
    SetLocalInt(OBJECT_SELF, "SFPacked2_836", 0x00000002); // PLAYER TOOL 07
    SetLocalInt(OBJECT_SELF, "SFPacked2_837", 0x00000002); // PLAYER TOOL 08
    SetLocalInt(OBJECT_SELF, "SFPacked2_838", 0x00000002); // PLAYER TOOL 09
    SetLocalInt(OBJECT_SELF, "SFPacked2_839", 0x00000002); // PLAYER TOOL 10
    SetLocalInt(OBJECT_SELF, "SFPacked2_84", 0x00000009); // Holy Aura
    SetLocalInt(OBJECT_SELF, "SFPacked2_842", 0x10000005); // Smite Infidel
    SetLocalInt(OBJECT_SELF, "SFPacked2_844", 0x00000006); // Plague
    SetLocalInt(OBJECT_SELF, "SFPacked2_845", 0x00000003); // Summon Undead Animal
    SetLocalInt(OBJECT_SELF, "SFPacked2_846", 0x00000002); // Blightfire
    SetLocalInt(OBJECT_SELF, "SFPacked2_85", 0x00000005); // Holy Sword
    SetLocalInt(OBJECT_SELF, "SFPacked2_850", 0x00000002); // Artificer Assistant
    SetLocalInt(OBJECT_SELF, "SFPacked2_851", 0x10000002); // Baleful Utterance
    SetLocalInt(OBJECT_SELF, "SFPacked2_852", 0x00000002); // Beguiling Influence
    SetLocalInt(OBJECT_SELF, "SFPacked2_853", 0x00000002); // Dark Ones Own Luck
    SetLocalInt(OBJECT_SELF, "SFPacked2_854", 0x00000003); // Darkness
    SetLocalInt(OBJECT_SELF, "SFPacked2_855", 0x00000002); // Ultravision
    SetLocalInt(OBJECT_SELF, "SFPacked2_856", 0x00000002); // Entropic Shield
    SetLocalInt(OBJECT_SELF, "SFPacked2_857", 0x00000002); // Leaps And Bounds
    SetLocalInt(OBJECT_SELF, "SFPacked2_858", 0x00000002); // See Invisibility
    SetLocalInt(OBJECT_SELF, "SFPacked2_859", 0x00000002); // All Seeing Eyes
    SetLocalInt(OBJECT_SELF, "SFPacked2_86", 0x02000023); // Identify
    SetLocalInt(OBJECT_SELF, "SFPacked2_861", 0x00000002); // Dark Arcana
    SetLocalInt(OBJECT_SELF, "SFPacked2_862", 0x00000002); // Cloak Of Shadows
    SetLocalInt(OBJECT_SELF, "SFPacked2_863", 0x00000002); // Shrouding Transformation
    SetLocalInt(OBJECT_SELF, "SFPacked2_865", 0x10000008); // Bestow Curse
    SetLocalInt(OBJECT_SELF, "SFPacked2_866", 0x00000008); // Create Undead
    SetLocalInt(OBJECT_SELF, "SFPacked2_867", 0x00000008); // Death Armor
    SetLocalInt(OBJECT_SELF, "SFPacked2_868", 0x10000008); // Dominate Person
    SetLocalInt(OBJECT_SELF, "SFPacked2_869", 0x00000008); // Dispel Magic
    SetLocalInt(OBJECT_SELF, "SFPacked2_87", 0x10000a0a); // Implosion
    SetLocalInt(OBJECT_SELF, "SFPacked2_870", 0x00000008); // Eldritch Ward
    SetLocalInt(OBJECT_SELF, "SFPacked2_871", 0x00000008); // Endure Elements
    SetLocalInt(OBJECT_SELF, "SFPacked2_872", 0x00000008); // Expeditious Retreat
    SetLocalInt(OBJECT_SELF, "SFPacked2_873", 0x00000008); // Invisibility
    SetLocalInt(OBJECT_SELF, "SFPacked2_875", 0x0000000d); // Create Greater Undead
    SetLocalInt(OBJECT_SELF, "SFPacked2_876", 0x1000000d); // Evards Black Tentacles
    SetLocalInt(OBJECT_SELF, "SFPacked2_877", 0x0000000d); // Greater Dispelling
    SetLocalInt(OBJECT_SELF, "SFPacked2_878", 0x0000000d); // Improved Invisibility
    SetLocalInt(OBJECT_SELF, "SFPacked2_879", 0x1000000d); // Greater Spell Breach
    SetLocalInt(OBJECT_SELF, "SFPacked2_88", 0x05000055); // Improved Invisibility
    SetLocalInt(OBJECT_SELF, "SFPacked2_881", 0x10000012); // Circle of Death
    SetLocalInt(OBJECT_SELF, "SFPacked2_882", 0x10000012); // Dominate Monster
    SetLocalInt(OBJECT_SELF, "SFPacked2_883", 0x00000012); // Etherealness
    SetLocalInt(OBJECT_SELF, "SFPacked2_884", 0x10000012); // Finger of Death
    SetLocalInt(OBJECT_SELF, "SFPacked2_885", 0x00000012); // Gate
    SetLocalInt(OBJECT_SELF, "SFPacked2_886", 0x00000012); // FiendishPolymorph
    SetLocalInt(OBJECT_SELF, "SFPacked2_89", 0x19000009); // Incendiary Cloud
    SetLocalInt(OBJECT_SELF, "SFPacked2_890", 0x00000005); // FEAT CALLFIENDS
    SetLocalInt(OBJECT_SELF, "SFPacked2_892", 0x02000202); // SummonUndead1
    SetLocalInt(OBJECT_SELF, "SFPacked2_893", 0x03000303); // SummonUndead2
    SetLocalInt(OBJECT_SELF, "SFPacked2_894", 0x04000404); // SummonUndead3
    SetLocalInt(OBJECT_SELF, "SFPacked2_895", 0x05000505); // SummonUndead4
    SetLocalInt(OBJECT_SELF, "SFPacked2_896", 0x06000606); // SummonUndead5
    SetLocalInt(OBJECT_SELF, "SFPacked2_899", 0x00000002); // Eldritch Blast Acid
    SetLocalInt(OBJECT_SELF, "SFPacked2_9", 0x03033303); // Bulls Strength
    SetLocalInt(OBJECT_SELF, "SFPacked2_90", 0x03000033); // Invisibility
    SetLocalInt(OBJECT_SELF, "SFPacked2_900", 0x00000002); // Eldritch Blast Cold
    SetLocalInt(OBJECT_SELF, "SFPacked2_901", 0x00000002); // Eldritch Blast Fire
    SetLocalInt(OBJECT_SELF, "SFPacked2_902", 0x00000002); // Eldritch Blast Magic
    SetLocalInt(OBJECT_SELF, "SFPacked2_903", 0x00000002); // Eldritch Blast Negative
    SetLocalInt(OBJECT_SELF, "SFPacked2_905", 0x10000002); // Eldritch Blast EMP Acid
    SetLocalInt(OBJECT_SELF, "SFPacked2_906", 0x10000002); // Eldritch Blast EMP Cold
    SetLocalInt(OBJECT_SELF, "SFPacked2_907", 0x10000002); // Eldritch Blast EMP Fire
    SetLocalInt(OBJECT_SELF, "SFPacked2_908", 0x10000002); // Eldritch Blast EMP Magic
    SetLocalInt(OBJECT_SELF, "SFPacked2_909", 0x10000002); // Eldritch Blast EMP Negative
    SetLocalInt(OBJECT_SELF, "SFPacked2_91", 0x10400404); // Invisibility Purge
    SetLocalInt(OBJECT_SELF, "SFPacked2_911", 0x1000000b); // Spellfire Blast
    SetLocalInt(OBJECT_SELF, "SFPacked2_912", 0x0000000b); // Spellfire Absorb
    SetLocalInt(OBJECT_SELF, "SFPacked2_913", 0x0000000b); // Spellfire Heal T
    SetLocalInt(OBJECT_SELF, "SFPacked2_914", 0x1000000b); // Spellfire Destroy
    SetLocalInt(OBJECT_SELF, "SFPacked2_915", 0x0000000b); // Spellfire Heal R
    SetLocalInt(OBJECT_SELF, "SFPacked2_916", 0x1000000b); // Spellfire Burst
    SetLocalInt(OBJECT_SELF, "SFPacked2_917", 0x00000002); // Spellfire Haste
    SetLocalInt(OBJECT_SELF, "SFPacked2_918", 0x0000000b); // Spellfire Crown
    SetLocalInt(OBJECT_SELF, "SFPacked2_919", 0x1000000b); // Spellfire Maelstrom
    SetLocalInt(OBJECT_SELF, "SFPacked2_92", 0x04000044); // Invisibility Sphere
    SetLocalInt(OBJECT_SELF, "SFPacked2_922", 0x00000002); // Wild Shape Mammal
    SetLocalInt(OBJECT_SELF, "SFPacked2_923", 0x00000004); // Wild Shape BROWN BEAR
    SetLocalInt(OBJECT_SELF, "SFPacked2_924", 0x00000004); // Wild Shape PANTHER
    SetLocalInt(OBJECT_SELF, "SFPacked2_925", 0x00000004); // Wild Shape WOLF
    SetLocalInt(OBJECT_SELF, "SFPacked2_926", 0x00000004); // Wild Shape BOAR
    SetLocalInt(OBJECT_SELF, "SFPacked2_927", 0x00000004); // Wild Shape BADGER
    SetLocalInt(OBJECT_SELF, "SFPacked2_928", 0x00000002); // Wild Shape Reptile
    SetLocalInt(OBJECT_SELF, "SFPacked2_929", 0x00000004); // Wild Shape VIPER
    SetLocalInt(OBJECT_SELF, "SFPacked2_93", 0x03000003); // Knock
    SetLocalInt(OBJECT_SELF, "SFPacked2_930", 0x00000004); // Wild Shape COBRA
    SetLocalInt(OBJECT_SELF, "SFPacked2_931", 0x00000004); // Wild Shape TORTOISE
    SetLocalInt(OBJECT_SELF, "SFPacked2_932", 0x00000004); // Wild Shape SALT CROC
    SetLocalInt(OBJECT_SELF, "SFPacked2_933", 0x00000004); // Wild Shape GIANT
    SetLocalInt(OBJECT_SELF, "SFPacked2_934", 0x00000002); // Wild Shape Avian
    SetLocalInt(OBJECT_SELF, "SFPacked2_935", 0x00000004); // Wild Shape Falcon
    SetLocalInt(OBJECT_SELF, "SFPacked2_936", 0x00000004); // Wild Shape Crane
    SetLocalInt(OBJECT_SELF, "SFPacked2_937", 0x00000004); // Wild Shape Raven
    SetLocalInt(OBJECT_SELF, "SFPacked2_938", 0x00000004); // Wild Shape Owl
    SetLocalInt(OBJECT_SELF, "SFPacked2_939", 0x00000004); // Wild Shape Sparrow
    SetLocalInt(OBJECT_SELF, "SFPacked2_94", 0x03003323); // Lesser Dispel
    SetLocalInt(OBJECT_SELF, "SFPacked2_941", 0x05000055); // Dimension Door
    SetLocalInt(OBJECT_SELF, "SFPacked2_943", 0x10000004); // DARK BOLT
    SetLocalInt(OBJECT_SELF, "SFPacked2_944", 0x00000002); // CHARM DOMAIN POWER
    SetLocalInt(OBJECT_SELF, "SFPacked2_945", 0x00000002); // ILLUSION DOMAIN POWER
    SetLocalInt(OBJECT_SELF, "SFPacked2_946", 0x00000002); // MAGIC DOMAIN POWER
    SetLocalInt(OBJECT_SELF, "SFPacked2_948", 0x06000006); // Teleport
    SetLocalInt(OBJECT_SELF, "SFPacked2_949", 0x0000a00a); // SUMMON SHAMBLING MOUND
    SetLocalInt(OBJECT_SELF, "SFPacked2_95", 0x06000006); // Lesser Mind Blank
    SetLocalInt(OBJECT_SELF, "SFPacked2_950", 0x0000000a); // Plane Shift
    SetLocalInt(OBJECT_SELF, "SFPacked2_953", 0x00506006); // Tree Stride
    SetLocalInt(OBJECT_SELF, "SFPacked2_954", 0x00000002); // Wild Shape PLANT
    SetLocalInt(OBJECT_SELF, "SFPacked2_955", 0x00000004); // WILD SHAPE ASS VINE
    SetLocalInt(OBJECT_SELF, "SFPacked2_956", 0x00000004); // WILD SHAPE TREANT
    SetLocalInt(OBJECT_SELF, "SFPacked2_957", 0x00000004); // WILD SHAPE Shambling
    SetLocalInt(OBJECT_SELF, "SFPacked2_958", 0x00000066); // Shadow Jump
    SetLocalInt(OBJECT_SELF, "SFPacked2_959", 0x00000005); // Shadow Knife
    SetLocalInt(OBJECT_SELF, "SFPacked2_96", 0x06000006); // Lesser Planar Binding
    SetLocalInt(OBJECT_SELF, "SFPacked2_960", 0x00000008); // Shadow Mastery
    SetLocalInt(OBJECT_SELF, "SFPacked2_961", 0x07000066); // Shadow Walk
    SetLocalInt(OBJECT_SELF, "SFPacked2_964", 0x00000004); // BS SWORD STYLE
    SetLocalInt(OBJECT_SELF, "SFPacked2_965", 0x10000004); // BS ARCANE STRIKE
    SetLocalInt(OBJECT_SELF, "SFPacked2_967", 0x00000003); // Shield of Shadows
    SetLocalInt(OBJECT_SELF, "SFPacked2_97", 0x00003303); // Lesser Restoration
    SetLocalInt(OBJECT_SELF, "SFPacked2_970", 0x00000006); // Spell Ward
    SetLocalInt(OBJECT_SELF, "SFPacked2_971", 0x00000006); // Apothecary and arsenal
    SetLocalInt(OBJECT_SELF, "SFPacked2_972", 0x00000006); // Eyes of the order
    SetLocalInt(OBJECT_SELF, "SFPacked2_973", 0x02000202); // Detect Evil
    SetLocalInt(OBJECT_SELF, "SFPacked2_977", 0x00000002); // Blood Drain
    SetLocalInt(OBJECT_SELF, "SFPacked2_978", 0x00000002); // ChildrenOfTheNight
    SetLocalInt(OBJECT_SELF, "SFPacked2_979", 0x00000002); // Dominate Person
    SetLocalInt(OBJECT_SELF, "SFPacked2_98", 0x15000005); // Lesser Spell Breach
    SetLocalInt(OBJECT_SELF, "SFPacked2_980", 0x00000002); // Mist Form
    SetLocalInt(OBJECT_SELF, "SFPacked2_981", 0x00000002); // Bat Form
    SetLocalInt(OBJECT_SELF, "SFPacked2_982", 0x00000002); // Wolf Form
    SetLocalInt(OBJECT_SELF, "SFPacked2_984", 0x02000022); // Summon Mount
    SetLocalInt(OBJECT_SELF, "SFPacked2_985", 0x04000032); // Heroism
    SetLocalInt(OBJECT_SELF, "SFPacked2_986", 0x07000066); // Heroism Greater
    SetLocalInt(OBJECT_SELF, "SFPacked2_987", 0x10000011); // Lullaby
    SetLocalInt(OBJECT_SELF, "SFPacked2_988", 0x04000033); // Rage
    SetLocalInt(OBJECT_SELF, "SFPacked2_989", 0x10006006); // Call Lightning Storm
    SetLocalInt(OBJECT_SELF, "SFPacked2_99", 0x06000006); // Lesser Spell Mantle
    SetLocalInt(OBJECT_SELF, "SFPacked2_990", 0x03000003); // Claws Of Darkness
    SetLocalInt(OBJECT_SELF, "SFPacked2_991", 0x19000009); // Polar Ray
    SetLocalInt(OBJECT_SELF, "SFPacked2_992", 0x13000003); // Scorching Ray
    SetLocalInt(OBJECT_SELF, "SFPacked2_993", 0x03000033); // Blur
    SetLocalInt(OBJECT_SELF, "SFPacked2_994", 0x00000044); // Verrakeths Shadow Crown
    SetLocalInt(OBJECT_SELF, "SFPacked2_995", 0x00000002); // EschewMaterialToggle
    SetLocalInt(OBJECT_SELF, "SFPacked2_998", 0x03000003); // Protection From Arrows
}
