// For some reason, this has bloated to include constants.
// This should be split over time.


const int CLASS_TYPE_WARLOCK = 47;
const int CLASS_TYPE_SHADOW_CHANNELER = 48;
const int CLASS_TYPE_SPELLFIRE = 49;
const int CLASS_TYPE_BLIGHTER = 50;
const int CLASS_TYPE_BLACKCOAT = 51;
const int CLASS_TYPE_WARMAGE = 52;
const int CLASS_TYPE_BLADESINGER = 53;
const int CLASS_TYPE_SHADOW_ADEPT = 54;
const int CLASS_TYPE_ELDKNIGHT = 55;
const int CLASS_TYPE_MYSTICKNIGHT = 56;
const int CLASS_TYPE_ARTIFICER = 57;
const int CLASS_TYPE_MAGE_BREAKER = 58;

const int DEITY_Akadi = 1304;
const int DEITY_Auril = 1305;
const int DEITY_Azuth = 1306;
const int DEITY_Beshaba = 1307;
const int DEITY_Cyric = 1308;
const int DEITY_Deneir = 1309;
const int DEITY_Gond = 1310;
const int DEITY_Grumbar = 1311;
const int DEITY_Helm = 1312;
const int DEITY_Ibrandul = 1313;
const int DEITY_Ilmater = 1314;
const int DEITY_Ishtisha = 1315;
const int DEITY_Xvim = 1316;
const int DEITY_Kelemvor = 1317;
const int DEITY_Kossuth = 1318;
const int DEITY_Lathander = 1319;
const int DEITY_Leira = 1320;
const int DEITY_Lliira = 1321;
const int DEITY_Loviatar = 1322;
const int DEITY_Malar = 1323;
const int DEITY_Mask = 1324;
const int DEITY_Milil = 1325;
const int DEITY_Mystra = 1326;
const int DEITY_Oghma = 1327;
const int DEITY_Selune = 1328;
const int DEITY_Shar = 1329;
const int DEITY_Shaundakul = 1330;
const int DEITY_Sune = 1331;
const int DEITY_Talona = 1332;
const int DEITY_Talos = 1333;
const int DEITY_Tempus = 1334;
const int DEITY_Torm = 1335;
const int DEITY_Tymora = 1336;
const int DEITY_Tyr = 1337;
const int DEITY_Umberlee = 1338;
const int DEITY_Finder_Wyvernspur = 1339;
const int DEITY_Garagos = 1340;
const int DEITY_Gargauth = 1341;
const int DEITY_Gwaeron_Windstrom = 1342;
const int DEITY_Hoar = 1343;
const int DEITY_Lurue = 1344;
const int DEITY_Nobanion = 1345;
const int DEITY_Red_Knight = 1346;
const int DEITY_Savras = 1347;
const int DEITY_Sharess = 1348;
const int DEITY_Siamorphe = 1349;
const int DEITY_Valkur = 1350;
const int DEITY_Velsharoon = 1351;
const int DEITY_Chauntea = 1352;
const int DEITY_Silvanus = 1353;
const int DEITY_Mielikki = 1354;
const int DEITY_Eldath = 1355;
const int DEITY_Shiallia = 1356;
const int DEITY_Elven_Powers = 1357;
const int DEITY_Underdark_Powers = 1358;
const int DEITY_Dwarven_Powers = 1359;
const int DEITY_Halfling_Powers = 1360;
const int DEITY_Gnomish_Powers = 1361;
const int DEITY_Orcish_Powers = 1362;
const int DEITY_Amaunator = 1363;
const int DEITY_Bane = 1364;
const int DEITY_Bhaal = 1365;
const int DEITY_Jergal = 1366;
const int DEITY_Karsus = 1367;
const int DEITY_Moander = 1368;
const int DEITY_Myrkul = 1369;
const int DEITY_Ulutiu = 1370;
const int DEITY_Waukeen = 1371;

const int ETHNICITY_CALISHITE        = 1381;
const int ETHNICITY_CHONDATHAN       = 1382;
const int ETHNICITY_DAMARAN          = 1383;
const int ETHNICITY_ILLUSKAN         = 1384;
const int ETHNICITY_MULAN            = 1385;
const int ETHNICITY_RASHEMI          = 1386;
const int ETHNICITY_TETHYRIAN        = 1387;
const int ETHNICITY_OTHER            = 1388;

const int PROFICIENCY_HISTORY        = 1426;
const int PROFICIENCY_ASTROLOGY      = 1427;
const int PROFICIENCY_DECIPHER       = 1428;
const int PROFICIENCY_SIEGE          = 1429;
const int PROFICIENCY_FIRE           = 1430;
const int PROFICIENCY_HERBALISM      = 1431;
const int PROFICIENCY_ARMORING       = 1432;
const int PROFICIENCY_CARPENTRY      = 1433;
const int PROFICIENCY_TAILORING      = 1434;
const int PROFICIENCY_MASONRY        = 1435;
const int PROFICIENCY_MINING         = 1436;
const int PROFICIENCY_HUNTING        = 1437;
const int PROFICIENCY_WOOD_GATHERING = 1438;
const int PROFICIENCY_TRACKING       = 1439;
const int PROFICIENCY_ANATOMY        = 1480;
const int PROFICIENCY_ALCHEMY        = 1481;
const int PROFICIENCY_DISGUISE       = 1482;
const int PROFICIENCY_GUNSMITHING    = 1483;
const int PROFICIENCY_OBSERVATION    = 1484;
const int PROFICIENCY_SMELTING       = 1485;

#include "loi_functions"
#include "loi_background"
//Apply Affliction Skins/Tools
//oPC - Target PC
//  None = 0, Werewolf = 1, Vampire Thrall 2,
//  Vampire = 3, Vampire Drider = 4, Revenant = 5
//  Drider = 6, Lich = 7 Vampiric Mist = 8
void Affliction_Items(object oPC, int nAffliction);

//Checks if target is immune to vampirism.
//oPC - Target PC
int GetIfImmuneVampirism(object oPC);

//Calculates  the ECL of a target and returns.
int Calc_ECL(object oPC);

//Returns module variable associated with XP gains.
int DetermineXPRate(int iXPRate);

//Gets the XP bonus associated with being a certain class.
int GetXPBonus(object oPC);

// Returns the caster level taking into account all of a PC's
// Spellcasting levels.
// Counts: Assassin, Bard, Blackcoat, Cleric, Druid, Paladin,
//        Palemaster, Shadow Adept, Sorcerer, Warlock, Wizard
int GetAllCasterLevel(object oPC);

//Returns whether a target creature is undead or not.
int GetIsUndead(object oPC);

//Pulls appropriate faction information from PC to determine
//what NPC groups should be hostile or not to them.
//
void TE_Faction_Fix(object oPC);


void Affliction_Items(object oPC, int nAffliction)
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    DestroyObject(oSkin,0.0f);

    SetPCAffliction(oPC, nAffliction);
    object oItem;
        if (GetItemPossessedBy(oPC, "te_item_8042") != OBJECT_INVALID)
        {
            DestroyObject(GetItemPossessedBy(oPC, "te_item_8042"),0.0f);}
        if (GetItemPossessedBy(oPC, "te_item_8043") != OBJECT_INVALID)
        {
            DestroyObject(GetItemPossessedBy(oPC, "te_item_8043"),0.0f);}
        if (GetItemPossessedBy(oPC, "te_item_8044") != OBJECT_INVALID)
        {
            DestroyObject(GetItemPossessedBy(oPC, "te_item_8044"),0.0f);}
        if (GetItemPossessedBy(oPC, "te_item_8045") != OBJECT_INVALID)
        {
            DestroyObject(GetItemPossessedBy(oPC, "te_item_8045"),0.0f);}
        if (GetItemPossessedBy(oPC, "te_item_8046") != OBJECT_INVALID)
        {
            DestroyObject(GetItemPossessedBy(oPC, "te_item_8046"),0.0f);}
        if (GetItemPossessedBy(oPC, "te_item_8047") != OBJECT_INVALID)
        {
            DestroyObject(GetItemPossessedBy(oPC, "te_item_8047"),0.0f);}
        if (GetItemPossessedBy(oPC, "te_item_8048") != OBJECT_INVALID)
        {
            DestroyObject(GetItemPossessedBy(oPC, "te_item_8048"),0.0f);}
        if (GetItemPossessedBy(oPC, "te_item_8049") != OBJECT_INVALID)
        {
            DestroyObject(GetItemPossessedBy(oPC, "te_item_8049"),0.0f);}
        if (GetItemPossessedBy(oPC, "te_crims_hide") != OBJECT_INVALID)
        {
            DestroyObject(GetItemPossessedBy(oPC, "te_crims_hide"),0.0f);}
        if (GetItemPossessedBy(oPC, "te_driderskin") != OBJECT_INVALID)
        {
            DestroyObject(GetItemPossessedBy(oPC, "te_driderskin"),0.0f);}
        if (GetItemPossessedBy(oPC, "te_dridervskin") != OBJECT_INVALID)
        {
            DestroyObject(GetItemPossessedBy(oPC, "te_dridervskin"),0.0f);}


    if (nAffliction == 2)
    {
        object oItem = CreateItemOnObject("te_item_8042",oPC);
        AssignCommand(oPC,ClearAllActions(TRUE));
        SetIdentified(oItem,TRUE);
        DelayCommand(0.1f,AssignCommand(oPC, ActionEquipItem (oItem, INVENTORY_SLOT_CARMOUR)));
    }
    if (nAffliction == 3)
    {
        object oItem = CreateItemOnObject("te_item_8043",oPC);
        AssignCommand(oPC,ClearAllActions(TRUE));
        SetIdentified(oItem,TRUE);
        DelayCommand(0.1f,AssignCommand(oPC, ActionEquipItem (oItem, INVENTORY_SLOT_CARMOUR)));
    }
    if (nAffliction == 4)
    {
        object oItem = CreateItemOnObject("te_dridervskin",oPC);
        AssignCommand(oPC,ClearAllActions(TRUE));
        SetIdentified(oItem,TRUE);
        DelayCommand(0.1f,AssignCommand(oPC, ActionEquipItem (oItem, INVENTORY_SLOT_CARMOUR)));
    }
    if (nAffliction == 5)
    {
        object oItem = CreateItemOnObject("te_item_8045",oPC);
        AssignCommand(oPC,ClearAllActions(TRUE));
        SetIdentified(oItem,TRUE);
        DelayCommand(0.1f,AssignCommand(oPC, ActionEquipItem (oItem, INVENTORY_SLOT_CARMOUR)));
    }
    if (nAffliction == 6)
    {
        object oItem = CreateItemOnObject("te_driderskin",oPC);
        AssignCommand(oPC,ClearAllActions(TRUE));
        SetIdentified(oItem,TRUE);
        DelayCommand(0.1f,AssignCommand(oPC, ActionEquipItem (oItem, INVENTORY_SLOT_CARMOUR)));
    }
    if (nAffliction == 7)
    {
        object oItem = CreateItemOnObject("te_item_8049",oPC);
        AssignCommand(oPC,ClearAllActions(TRUE));
        SetIdentified(oItem,TRUE);
        DelayCommand(0.1f,AssignCommand(oPC, ActionEquipItem (oItem, INVENTORY_SLOT_CARMOUR)));
    }
    if (nAffliction == 8)
    {
        object oItem = CreateItemOnObject("te_crims_hide",oPC);
        AssignCommand(oPC,ClearAllActions(TRUE));
        SetIdentified(oItem,TRUE);
        DelayCommand(0.1f,AssignCommand(oPC, ActionEquipItem (oItem, INVENTORY_SLOT_CARMOUR)));
    }
}

int GetIfImmuneVampirism(object oPC)
{
    if (GetHasFeat(1175, oPC) == TRUE)
    {
        return TRUE;}
    else if (GetLevelByClass(CLASS_TYPE_PALADIN, oPC) >= 1)
    {
        return TRUE;}
    else
    {
        return FALSE;}
}

int Calc_ECL(object oPC)
{
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    int iECL1 = GetLocalInt(oItem, "PC_ECL");
    int iECL2 = GetLocalInt(oItem, "PC_ECL2");

    return iECL1+iECL2;
}

int DetermineXPRate(int iXPRate)
{
    int i;
    switch(iXPRate)
    {
        case 1: //Deserts
        {
            i = GetLocalInt(GetModule(),"iDesertXP");
            break;
        }
        case 2: //Plains
        {
            i = GetLocalInt(GetModule(),"iPlainXP");
            break;
        }
        case 3: //Hills
        {
            i = GetLocalInt(GetModule(),"iHillXP");
            break;
        }
        case 4: //Marshes
        {
            i = GetLocalInt(GetModule(),"iMarshXP" );
            break;
        }
        case 5: //Forests
        {
            i = GetLocalInt(GetModule(),"iForestXP");
            break;
        }
        case 6: //Crypts
        {
            i = GetLocalInt(GetModule(),"iCryptXP");
            break;
        }
        case 7: //Roads
        {
            i = GetLocalInt(GetModule(),"iRoadXP");
            break;
        }
        case 8: //Towns
        {
            i = GetLocalInt(GetModule(),"iTownXP");
            break;
        }
        case 9: //Temples
        {
            i = GetLocalInt(GetModule(),"iTempleXP");
            break;
        }
        case 10: //Secret Areas
        {
            i = GetLocalInt(GetModule(),"iSecretXP");
            break;
        }
        case 11: //Taverns
        {
            i = GetLocalInt(GetModule(),"iTavernXP");
            break;
        }
        case 12: //Keeps
        {
            i = GetLocalInt(GetModule(),"iKeepXP");
            break;
        }
        case 13: //Low Gain Magical
        {
            i = GetLocalInt(GetModule(),"iMagicXP");
            break;
        }
        default:
        {
            i = GetLocalInt(GetModule(),"iDefXP");
            break;
        }
   }
   return i;
}

int GetXPBonus(object oPC)
{
    int returnval = 0;
    if (GetHasFeat(BACKGROUND_COSMOPOLITAN, oPC) == TRUE)
    {
        returnval += 5;
    }
    else if (GetHasFeat(BACKGROUND_EVANGELIST, oPC) == TRUE)
    {
        returnval += 5;
    }
    else if (GetHasFeat(BACKGROUND_MENDICANT,oPC) == TRUE)
    {
        returnval += 5;
    }
    else if (GetHasFeat(BACKGROUND_MINSTREL,oPC) == TRUE)
    {
        returnval += 5;
    }
    else if (GetHasFeat(BACKGROUND_OCCULTIST,oPC) == TRUE)
    {
        returnval += 5;
    }
    else if (GetLevelByClass(1, oPC) >= 3)//
    {
        returnval += 5;
    }
    else if (GetHasFeat(2000, oPC) == TRUE)
    {
        returnval += 5;
    }
    return returnval;
}

int GetAllCasterLevel(object oPC)
{
    int nCasterLevel = 0;

    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_ASSASSIN,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_BARD,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_BLACKGUARD,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_CLERIC,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_DRUID,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_HARPER,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_PALADIN,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_PALE_MASTER,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_RANGER,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_SORCERER,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_WIZARD,oPC);
        nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_BLACKCOAT,oPC);
        nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_BLADESINGER,oPC);
        nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_BLIGHTER,oPC);
        nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT,oPC);
        nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_SPELLFIRE,oPC);
        nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_WARMAGE,oPC);
        nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_WARLOCK,oPC);

    return nCasterLevel;
}

//Returns whether a target creature is undead or not.
int GetIsUndead(object oPC)
{
    if( (GetRacialType(oPC) == RACIAL_TYPE_UNDEAD)||(GetLevelByClass(CLASS_TYPE_UNDEAD,oPC) >= 1)||(GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"), "iUndead") == 1))
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

