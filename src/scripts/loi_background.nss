#include "nw_i0_plot"

const int BACKGROUND_LOWER = 1150;
const int BACKGROUND_MIDDLE = 1151;
const int BACKGROUND_UPPER = 1152;

const int BACKGROUND_AFFLUENCE = 1153;
const int BACKGROUND_BRAWLER = 1154;
const int BACKGROUND_COSMOPOLITAN = 1155;
const int BACKGROUND_CRUSADER = 1156;
const int BACKGROUND_DUELIST = 1157;
const int BACKGROUND_EVANGELIST = 1158;
const int BACKGROUND_FORESTER = 1159;
const int BACKGROUND_HARD_LABORER = 1160;
const int BACKGROUND_HEALER = 1161;
const int BACKGROUND_KNIGHT = 1162;
const int BACKGROUND_HEDGEMAGE = 1163;
const int BACKGROUND_MENDICANT = 1164;
const int BACKGROUND_MERCHANT = 1165;
const int BACKGROUND_METALSMITH = 1166;
const int BACKGROUND_MINSTREL = 1167;
const int BACKGROUND_OCCULTIST = 1168;
const int BACKGROUND_SABOTEUR = 1169;
const int BACKGROUND_SCOUT = 1170;
const int BACKGROUND_SNEAK = 1171;
const int BACKGROUND_SOLDIER = 1172;
const int BACKGROUND_TRAVELER = 1173;
const int BACKGROUND_SPELLFIRE = 1174;
const int BACKGROUND_NAT_LYCAN = 1175;
const int BACKGROUND_SHADOW = 1176;
const int BACKGROUND_COPPER_ELF = 1177;
const int BACKGROUND_GREEN_ELF = 1178;
const int BACKGROUND_DARK_ELF = 1179;
const int BACKGROUND_SILVER_ELF = 1180;
const int BACKGROUND_GOLD_ELF = 1181;
const int BACKGROUND_GOLD_DWARF = 1182;
const int BACKGROUND_GREY_DWARF = 1183;
const int BACKGROUND_SHIELD_DWARF = 1184;
const int BACKGROUND_OUTSIDER = 1185;
const int BACKGROUND_AASIMAR = 1186;
const int BACKGROUND_TIEFLING = 1187;
const int BACKGROUND_AMN_TRAINED = 1389;
const int BACKGROUND_CALISHITE_TRAINED = 1390;
const int BACKGROUND_CHURCH_ACOLYTE = 1392;
const int BACKGROUND_CARAVANNER = 1391;
const int BACKGROUND_CIRCLE_BORN = 1393;
const int BACKGROUND_ENLIGHTENED_STUDENT = 1394;
const int BACKGROUND_HAREM_TRAINED = 1395;
const int BACKGROUND_HARPER = 1396;
const int BACKGROUND_KNIGHT_SQUIRE = 1397;
const int BACKGROUND_TALFIRIAN = 1398;
const int BACKGROUND_THEOCRAT = 1399;
const int BACKGROUND_WARD_TRIAD = 1400;
const int BACKGROUND_ZHENTARIM = 1401;
const int BACKGROUND_ELDRETH = 1460;
const int BACKGROUND_ELMANESSE = 1461;
const int BACKGROUND_SULDUSK = 1462;
const int BACKGROUND_DUKES_WARBAND = 1463;
const int BACKGROUND_CALISHITE_SLAVE = 1464;
const int BACKGROUND_SELDARINE_PRIEST = 1465;
const int BACKGROUND_HIGH_MAGE = 1466;
const int BACKGROUND_UNDERDARK_EXILE = 1467;
const int BACKGROUND_THUNDER_TWIN = 1468;
const int BACKGROUND_HEIR = 1469;
const int BACKGROUND_MORDINS_PRIEST = 1470;
const int BACKGROUND_WARY_SWORDKNIGHT = 1471;

// Must be less than a world year
const int STIPEND_INTERVAL_WORLD_DAYS = 30;



// Returns the stipend for a given PC    
int CalculateStipend(object oPC);

// Determines based on world dates stored in the PC data object whether they are due a stipend
void PossiblyPayStipend(object oPC);

// Awards the player their stipend
void AwardStipend(object oPC);

// Returns the starting gold for a given PC    
void AwardStartingGold(object oPC);



int CalculateStipend(object oPC)
{
    //Faction Standing based on Class Standing
    float fSocialClass = 0.0;
    if (GetHasFeat(BACKGROUND_LOWER, oPC) == TRUE)
    {
        fSocialClass = 0.9;
    }
    else if (GetHasFeat(BACKGROUND_MIDDLE, oPC) == TRUE)
    {
        fSocialClass = 1.0;
    }
    else if (GetHasFeat(BACKGROUND_UPPER, oPC) == TRUE)
    {
        fSocialClass = 1.2;
    }

    //Stipend base value for each background
    int iStipend = 0;
    if (GetHasFeat(BACKGROUND_AFFLUENCE,oPC) == TRUE)
    {
        iStipend = 1000;
    }
    else if (GetHasFeat(BACKGROUND_BRAWLER,oPC) == TRUE)
    {
        iStipend = 25;
    }
    else if (GetHasFeat(BACKGROUND_COSMOPOLITAN,oPC) == TRUE)
    {
        iStipend = 100;
    }
    else if (GetHasFeat(BACKGROUND_CRUSADER,oPC) == TRUE)
    {
        iStipend = 200;
    }
    else if (GetHasFeat(BACKGROUND_DUELIST,oPC) == TRUE)
    {
        iStipend = 50;
    }
    else if (GetHasFeat(BACKGROUND_EVANGELIST,oPC) == TRUE)
    {
        iStipend = 75;
    }
    else if (GetHasFeat(BACKGROUND_FORESTER,oPC) == TRUE)
    {
        iStipend = 35;
    }
    else if (GetHasFeat(BACKGROUND_HARD_LABORER,oPC) == TRUE)
    {
        iStipend = 25;
    }
    else if (GetHasFeat(BACKGROUND_HEALER,oPC) == TRUE)
    {
        iStipend = 125;
    }
    else if (GetHasFeat(BACKGROUND_KNIGHT,oPC) == TRUE)
    {
        iStipend = 500;
    }
    else if (GetHasFeat(BACKGROUND_HEDGEMAGE,oPC) == TRUE)
    {
        iStipend = 50;
    }
    else if (GetHasFeat(BACKGROUND_METALSMITH ,oPC) == TRUE)
    {
        iStipend = 200;
    }
    else if (GetHasFeat(BACKGROUND_MENDICANT,oPC) == TRUE)
    {
        iStipend = 0;
    }
    else if (GetHasFeat(BACKGROUND_MERCHANT,oPC) == TRUE)
    {
        iStipend = 250;
    }
    else if (GetHasFeat(BACKGROUND_MINSTREL,oPC) == TRUE)
    {
        iStipend = 100;
    }
    else if (GetHasFeat(BACKGROUND_OCCULTIST,oPC) == TRUE)
    {
        iStipend = 50;
    }
    else if (GetHasFeat(BACKGROUND_SABOTEUR,oPC) == TRUE)
    {
        iStipend = 75;
    }
    else if (GetHasFeat(BACKGROUND_SCOUT,oPC) == TRUE)
    {
        iStipend = 75;
    }
    else if (GetHasFeat(BACKGROUND_SNEAK,oPC) == TRUE)
    {
        iStipend = 50;
    }
    else if (GetHasFeat(BACKGROUND_SOLDIER,oPC) == TRUE)
    {
        iStipend = 300;
    }
    else if (GetHasFeat(BACKGROUND_TRAVELER,oPC) == TRUE)
    {
        iStipend = 25;
    }
    else if (GetHasFeat(BACKGROUND_SPELLFIRE,oPC) == TRUE)
    {
        iStipend = 50;
    }
    else if (GetHasFeat(BACKGROUND_NAT_LYCAN,oPC) == TRUE)
    {
        iStipend = 50;
    }
    else if (GetHasFeat(BACKGROUND_SHADOW,oPC) == TRUE)
    {
        iStipend = 50;
    }
    else if (GetHasFeat(BACKGROUND_COPPER_ELF,oPC) == TRUE)
    {
        iStipend = 50;
    }
    else if (GetHasFeat(BACKGROUND_GREEN_ELF,oPC) == TRUE)
    {
        iStipend = 50;
    }
    else if (GetHasFeat(BACKGROUND_DARK_ELF,oPC) == TRUE)
    {
        iStipend = 50;
    }
    else if (GetHasFeat(BACKGROUND_SILVER_ELF,oPC) == TRUE)
    {
        iStipend = 50;
    }
    else if (GetHasFeat(BACKGROUND_GOLD_ELF,oPC) == TRUE)
    {
        iStipend = 50;
    }
    else if (GetHasFeat(BACKGROUND_GOLD_DWARF,oPC) == TRUE)
    {
        iStipend = 150;
    }
    else if (GetHasFeat(BACKGROUND_GREY_DWARF,oPC) == TRUE)
    {
        iStipend = 150;
    }
    else if (GetHasFeat(BACKGROUND_SHIELD_DWARF,oPC) == TRUE)
    {
        iStipend = 150;
    }
    else if (GetHasFeat(BACKGROUND_OUTSIDER,oPC) == TRUE)
    {
        iStipend = 50;
    }
    else if (GetHasFeat(BACKGROUND_SHIELD_DWARF,oPC) == TRUE)
    {
        iStipend = 50;
    }
    else if (GetHasFeat(BACKGROUND_OUTSIDER,oPC) == TRUE)
    {
        iStipend = 50;
    }
    else if (GetHasFeat(BACKGROUND_CARAVANNER, oPC) == TRUE)
    {
        iStipend = 250;
    }
    else if (GetHasFeat(BACKGROUND_CHURCH_ACOLYTE, oPC) == TRUE)
    {
        iStipend = 100;
    }
    else if (GetHasFeat(BACKGROUND_CIRCLE_BORN, oPC) == TRUE)
    {
        iStipend = 50;
    }
    else if (GetHasFeat(BACKGROUND_ENLIGHTENED_STUDENT, oPC) == TRUE)
    {
        iStipend = 150;
    }
    else if (GetHasFeat(BACKGROUND_HAREM_TRAINED, oPC) == TRUE)
    {
        iStipend = 300;
    }
    else if (GetHasFeat(BACKGROUND_HARPER, oPC) == TRUE)
    {
        iStipend = 300;
    }
    else if (GetHasFeat(BACKGROUND_KNIGHT_SQUIRE, oPC) == TRUE)
    {
        iStipend = 250;
    }
    else if (GetHasFeat(BACKGROUND_TALFIRIAN, oPC) == TRUE)
    {
        iStipend = 200;
    }
    else if (GetHasFeat(BACKGROUND_THEOCRAT, oPC) == TRUE)
    {
        iStipend = 350;
    }
    else if (GetHasFeat(BACKGROUND_WARD_TRIAD, oPC) == TRUE)
    {
        iStipend = 100;
    }
    else if (GetHasFeat(BACKGROUND_ZHENTARIM, oPC) == TRUE)
    {
        iStipend = 750;
    }
    else if (GetHasFeat(BACKGROUND_ELDRETH, oPC) == TRUE)
    {
        iStipend = 35;
    }
    else if (GetHasFeat(BACKGROUND_ELMANESSE, oPC) == TRUE)
    {
        iStipend = 35;
    }
    else if (GetHasFeat(BACKGROUND_SULDUSK, oPC) == TRUE)
    {
        iStipend = 20;
    }
    else if (GetHasFeat(BACKGROUND_DUKES_WARBAND, oPC) == TRUE)
    {
        iStipend = 200;
    }
    else if (GetHasFeat(BACKGROUND_CALISHITE_SLAVE, oPC) == TRUE)
    {
        iStipend = 0;
    }
    else if (GetHasFeat(BACKGROUND_SELDARINE_PRIEST, oPC) == TRUE)
    {
        iStipend = 35;
    }
    else if (GetHasFeat(BACKGROUND_HIGH_MAGE, oPC) == TRUE)
    {
        iStipend = 35;
    }
    else if (GetHasFeat(BACKGROUND_UNDERDARK_EXILE, oPC) == TRUE)
    {
        iStipend = 0;
    }
    else if (GetHasFeat(BACKGROUND_THUNDER_TWIN, oPC) == TRUE)
    {
        iStipend = 100;
    }
    else if (GetHasFeat(BACKGROUND_HEIR, oPC) == TRUE)
    {
        iStipend = 250;
    }
    else if (GetHasFeat(BACKGROUND_MORDINS_PRIEST, oPC) == TRUE)
    {
        iStipend = 100;
    }
    else if (GetHasFeat(BACKGROUND_WARY_SWORDKNIGHT, oPC) == TRUE)
    {
        iStipend = 150;
    }

    return FloatToInt(iStipend * fSocialClass);
}

void PossiblyPayStipend(object oPC)
{
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    int nLastPayoutYear = GetLocalInt(oItem, "last_stipend_payout_year");
    int nThisYear  = GetCalendarYear();
    int nInterval = nThisYear - nLastPayoutYear;

    if (nInterval > 1) //more than a year between stipends
    {
        AwardStipend(oPC);
    }
    else if (nInterval >= 0) //interval is 0 or 1, further calculations necessary
    {
        int nLastPayoutMonth = GetLocalInt(oItem, "last_stipend_payout_month");
        int nLastPayoutDay   = GetLocalInt(oItem, "last_stipend_payout_day");
        int nThisMonth = GetCalendarMonth();
        int nThisDay   = GetCalendarDay();

        int nLastPayout = nLastPayoutMonth * 30 + nLastPayoutDay;
        int nThis = nInterval * 12 * 30 + nThisMonth * 30 + nThisDay;

        if (nThis - nLastPayout > STIPEND_INTERVAL_WORLD_DAYS)
        {
            AwardStipend(oPC);
        }
    }
    // else weird backwards time so do nothing
}

void AwardStipend(object oPC)
{
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    int nStipend = CalculateStipend(oPC);

    string sQual = "no";
    if (nStipend > 200)
        sQual = "a lavish";
    else if (nStipend > 50)
        sQual = "a moderate";
    else if (nStipend > 1)
        sQual = "a meagre";
    SendMessageToPC(oPC, "Your background affords you " + sQual + " stipend.");

    RewardGP(nStipend, oPC, FALSE);
    SetLocalInt(oItem, "last_stipend_payout_year",  GetCalendarYear());
    SetLocalInt(oItem, "last_stipend_payout_month", GetCalendarMonth());
    SetLocalInt(oItem, "last_stipend_payout_day",   GetCalendarDay());
}

void AwardStartingGold(object oPC)
{
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");

    int nStartingGold = 3 * CalculateStipend(oPC);

    RewardGP(nStartingGold, oPC, FALSE);
    SetLocalInt(oItem, "last_stipend_payout_year",  GetCalendarYear());
    SetLocalInt(oItem, "last_stipend_payout_month", GetCalendarMonth());
    SetLocalInt(oItem, "last_stipend_payout_day",   GetCalendarDay());
}