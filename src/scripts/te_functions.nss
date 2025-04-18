#include "inc_spell_func"
#include "te_afflic_func"
#include "loi_const_feats"
// used for generate new location
#include "X0_I0_POSITION"
// persistent vars on pc's skin
#include "x3_inc_skin"
// Natural Bioware Database Extension
#include "nbde_inc"
#include "x0_i0_spawncond"
#include "zdlg_include_i"
#include "colors_inc"


const string FACTION_GROVE_SPIRE     = "A_GroveSpire";
const string FACTION_GROVE_MARSH     = "A_GroveMarsh";
const string FACTION_GROVE_LAKE      = "A_GroveLake";
const string FACTION_GROVE_ELF       = "A_GroveElf";
const string FACTION_GROVE_OAK       = "A_GroveOak";
const string FACTION_GROVE_TEJARN    = "A_GroveTejarn";
const string FACTION_KEEP_BROSTCOM   = "K_BrostCom";
const string FACTION_KEEP_BROSTDEF   = "K_BrostDef";
const string FACTION_KEEP_LOCKCOM    = "K_LockwoodCom";
const string FACTION_KEEP_LOCKDEF    = "K_LockwoodDef";
const string FACTION_KEEP_SOUTHCOM   = "K_SouthSpireCom";
const string FACTION_KEEP_SOUTHDEF   = "K_SouthSpireDef";
const string FACTION_KEEP_SWAMPCOM   = "K_SwampriseCom";
const string FACTION_KEEP_SWAMPDEF   = "K_SwampriseDef";
const string FACTION_KEEP_TEJARNCOM  = "K_TejarnCom";
const string FACTION_KEEP_TEJARNDEF  = "K_TejarnDef";
const string FACTION_KEEP_GOLDCOM    = "K_GoldLionCom";
const string FACTION_KEEP_GOLDDEF    = "K_GoldLionDef";
const string FACTION_KEEP_WHAVENCOM  = "K_WHavenCom";
const string FACTION_KEEP_WHAVENDEF  = "K_WHavenDef";

const string FACTION_INDI_MERC1      = "I_Merc1";
const string FACTION_INDI_MERC2      = "I_Merc2";
const string FACTION_INDI_MERC3      = "I_Merc3";
const string FACTION_INDI_MERC4      = "I_Merc4";
const string FACTION_INDI_MERC5      = "I_Merc5";

const string FACTION_ARMY_TETHYR     = "I_TethyrArmy";
const string FACTION_ARMY_AMN        = "I_AmnArmy";
const string FACTION_ARMY_AGIS       = "I_AgisKnight";

const string FACTION_ROYAL           = "I_Royal";
const string FACTION_DUKE            = "I_Duke";

const string FACTION_RESTUNDEAD      = "I_RestUndead";
const string FACTION_HUNGUNDEAD      = "I_HungUndead";

const string FACTION_SUMMONS         = "H_Summons";

const string FACTION_HELL            = "I_Hell";
const string FACTION_ABYSS           = "I_Abyss";
const string FACTION_GENIE           = "I_Genie";
const string FACTION_EFFRIT          = "I_Effrit";
const string FACTION_ANGEL           = "I_Angel";

const string FACTION_INDI_VELUTHRA   = "I_Veluthra";
const string FACTION_INDI_OUTLAW0    = "I_Outlaw0";
const string FACTION_INDI_OUTLAW1    = "I_Outlaw1";
const string FACTION_INDI_OUTLAW2    = "I_Outlaw2";

const string FACTION_BLIGHTER        = "I_Blighter";

const string FACTION_DRAG_RED        = "I_DragRed";
const string FACTION_DRAG_BLUE       = "I_DragBlue";
const string FACTION_DRAG_GREEN      = "I_DragGreen";
const string FACTION_DRAG_BLACK      = "I_DragBlack";

const string FACTION_ELF_WILD        = "I_WildElves";
const string FACTION_ELF_DARK        = "I_DarkElves";

const string FACTION_INDI_CYRIC      = "I_Cyric";
const string FACTION_INDI_ZHENTARIM  = "I_Zhentarim";
const string FACTION_INDI_SHAR       = "I_Shar";
const string FACTION_INDI_LOVIATARAN = "I_Loviataran";

const string FACTION_HOSTILE_ANIMAL  = "I_HostAnimal";
// NAME OF THE CAMPAIGN -- persistence
// used by both NWNX and NBDE (BioDB) for data specific to a campaign (isolating it from character specific data)
const string CAMPAIGN_NAME      = "Tethyr_Database";
const string WILD_MAGIC = "Wild_Magic";
// TIME ------------------------------------------------------------------------
// adjust this number based on module time settings (duration of game hours in minutes)
// 30 for each game hour lasts 2 minutes
// 3 for each game hour lasts 20 minutes

// TIME
// adjust to your module's time settings
// 30 assumes the typical module setting of 2 minutes per game hour
const int IGMINUTES_PER_RLMINUTE    = 2;

// USER ADDED VALUES (OR EXAMPLES OF SUCH)

// Test 1 of RestRequirements() determines whether enough time has passed since the last rest by this PC
// See GetIsTimeToRest() this value is used in ResterFinishesRest() to establish when the PC can rest again
// 1+ = minutes required between rests OR  0 = no required time between rests
int GAME_MINUTES_BETWEEN_RESTS   = IGMINUTES_PER_RLMINUTE * 30; // the number is REAL MINUTES.

// SILENT SHOUTS
const string SHOUT_ALERT                = "!ALERT!";
const string SHOUT_FLEE                 = "!FLEE!";
const string SHOUT_PLACEABLE_ATTACKED   = "!BASHED!";
const string SHOUT_PLACEABLE_DESTROYED  = "!DESTROYED!";
const string SHOUT_SUBDUAL_DEAD         = "!SUBDUED!";
const string SHOUT_SUBDUAL_ATTACK       = "!FUN BRAWL!";

// USER DEFINED EVENTS ---------------------------------------------------------
// Custom
const int EVENT_BARDSONG                    = 9875;
const int EVENT_SPELLCAST                   = 9876;
const int EVENT_BLOCKED                     = 9900;
const int EVENT_RESTED                      = 9901;
const int EVENT_ALERTED                     = 9902;
//const int EVENT_PREPARE                     = 9903;
const int EVENT_COMMIT_OBJECT_TO_DB         = 9904;
const int EVENT_GARBAGE_COLLECTION          = 9905;


// indicate time denomination
//const int TIME_MILLISECONDS = 1; // not a good one.
const int TIME_SECONDS              = 2;
const int TIME_MINUTES              = 3;
const int TIME_HOURS                = 4;
const int TIME_DAYS                 = 5;
const int TIME_MONTHS               = 6;
const int TIME_YEARS                = 7;
// Record names of time values tracked in campaign db.         * DO NOT TOUCH *
const string CAMPAIGN_YEAR          = "iYear";          // int
const string CAMPAIGN_MONTH         = "iMonth";         // int
const string CAMPAIGN_DAY           = "iDay";           // int
const string CAMPAIGN_HOUR          = "iHour";          // int
const string CAMPAIGN_MINUTE        = "iMinute";        // int
// EPOCH - game time when the campaign is initialized
// these are established by module time at start of campaigns first module load event
// see NWNX_RestoreGameTime  in v2_inc_time
int CAMPAIGN_YEAR_BASE          = GetLocalInt(GetModule(),"EPOCH_YEAR");
int CAMPAIGN_MONTH_BASE         = GetLocalInt(GetModule(),"EPOCH_MONTH");
int CAMPAIGN_DAY_BASE           = GetLocalInt(GetModule(),"EPOCH_DAY");
int CAMPAIGN_HOUR_BASE          = GetLocalInt(GetModule(),"EPOCH_HOUR");
// LOOT ------------------------------------------------------------------------
int LOOT_PERIOD_MINUTES         = IGMINUTES_PER_RLMINUTE*30; // real life minutes is the second number
                                                             // period of time between loot respawns
// SPECIAL WAY POINT TAGS USED IN MODULE
// tag of waypoint for fall back start location in game
const string WP_DEFAULT_START   = "dst_start_default";
// tag of waypoint for fall back start location in game
const string WP_DEVELOPMENT     = "dst_development";
// tag of waypoint for persistent inventory mule
const string WP_INVENTORY       = "wp_inventory_persist";
//const string WP_INVENTORY       = "test_inventory";

// Module wide special characters
string BR                       = "\n";
string Q                        = "'";

// COLORS
string WHITE      = ColorTokenDialog(); // talk
string GREY       = ColorTokenWhisper(); // whisper
string LIGHTGREY  = ColorTokenWhisper();
string SANDY      = ColorTokenShout(); // shout

string RED        = ColorTokenRed();
string DARKRED    = ColorTokenRed();
string PINK       = ColorTokenPink();
string LIGHTPINK  = ColorTokenPink();

string ORANGE     = ColorTokenOrange();

string LEMON      = ColorTokenYellow();
string YELLOW     = ColorTokenYellow();

string NEONGREEN  = ColorTokenTell(); // tell
string GREEN      = ColorTokenGreen(); // name preceding description
string LIME       = ColorTokenGreen(); // description
string LIGHTGREEN = ColorTokenGreen();

string BLUE       = ColorTokenDialogReply(); // player name in dialog
string PERIWINKLE = ColorToken(199, 200, 222); // for emotes
string DARKBLUE   = ColorToken(118, 120, 159); // for whispered emotes
string CYAN       = ColorTokenSkillCheck(); // saving throw

string LIGHTBLUE  = ColorTokenDM(); // DM chat
string DMBLUE     = ColorTokenDM(); // DM chat
string PALEBLUE   = ColorTokenSkillCheck(); // name in skill check/saving throw

string VIOLET     = ColorTokenLightPurple();
string PURPLE     = ColorTokenPurple();

string COLOR_END  = ColorTokenEnd();

string COLOR_ACTION       = RED;
string COLOR_OBJECT       = ORANGE;
string COLOR_DESCRIPTION  = LIGHTGREY;
string COLOR_MESSAGE      = LIGHTGREY;
string COLOR_WHITE        = WHITE;
string COLOR_DUMPHEADER   = WHITE;
string COLOR_VARNAME      = LIGHTGREY;

// LIGHT SYSTEM ----------------------------------------------------------------
const string LIGHT_COLOR    = "LIGHT_COLOR";
const string LIGHT_VALUE    = "LIGHT_VALUE";


////////////////////////////////////////////////////////////////////////////////
///////////CORPSES
// corpse type
const int   CORPSE_TYPE_PERSISTENT  = 2;
const int   CORPSE_TYPE_SKINNABLE   = 4;
const int   CORPSE_TYPE_RAISEABLE   = 8;
const int   CORPSE_TYPE_ANIMATEABLE = 16;
const int   CORPSE_TYPE_PC          = 32;


////////////////////////////////////////////////////////////////////////////////
// CAMPAIGN DATABASEs                     * COORDINATE NAMES WITH SERVER ADMIN *
// DEVELOPMENT mode uses NBDE DB in which the following values are like "table names" for the database

// name of the database. contains list of Players by player name.
const string PLAYER_DATA = "PlayerData";
// TRACKS (for each pc): last campaign played, cpc status, elemental prefs, rebuke/turn undead, etc...
const string CHARACTER_DATA     = "CharacterData";

// NAMES OF RECORDS IN THE NBDE CAMPAIGN DATABASE //
// Character locations in campaign.                             * DO NOT TOUCH *
const string PC_LASTLOC         = "PCLoc"; // location
const string PC_HP              = "CurrentHP"  ;        // int

//Add Scent/Tracking Feats
const int FEAT_SCENT = 0;
const int FEAT_TRACK = 0;

// Spell Foci
const string SPELLFOCUS_RESREF      = "spellfocus"; // resref of spellfocus item
const int SPELLFOCUS_ONE_USE        = TRUE;     // if TRUE all spell focuses are destroyed when used successfully

const string SPELLFOCUS_SINGLEPPLAYER_ONLY = "SPFOC_NONPW"; // special flag for a spell focus which would not function after a server reset
const string SPELLFOCUS_USE         = "SPFOC_USE";  // TRUE or FALSE
const string SPELLFOCUS_OBJECT      = "SPFOC_OBJ";  // pointer to spell focus being used
const string SPELLFOCUS_TYPE        = "SPFOC_TYP";  // type. 1=location, 2=NPC, 3=PC
const string SPELLFOCUS_CREATURE    = "SPFOC_CRE";  // creature target (PC or NPC) is stored here
const string SPELLFOCUS_LOCATION_TAG= "SPFOC_LOCT"; // location area tag
const string SPELLFOCUS_LOCATION_X  = "SPFOC_LOCX"; // location X position
const string SPELLFOCUS_LOCATION_Y  = "SPFOC_LOCY"; // location Y position
const string SPELLFOCUS_LOCATION_Z  = "SPFOC_LOCZ"; // location Z position
const string SPELLFOCUS_LOCATION_F  = "SPFOC_LOCF"; // location facing

//if target is flatfooted and fail awarness check and dont have premonition spell active and is within 30feet
// get extra damage and apply that to regular damage of spell.
int TE_getThirtyFeetExtraSpellDamage(object Caster, int nIsAware);

// DECLARATIONS
int TE_GetSpellSchool(int nSpell);

int TE_GetDeity(object oPC);

// -- INTERFACE --
// Commits PC state to Data (typically on heartbeat) - [FILE: _inc_data]
void Data_SavePC(object oPC, int export_characters_now=FALSE);
// Returns last stored HP total for PC. - [FILE: _inc_data]
int Data_GetPCHitPoints(object oPC);
// Stores current HP total for PC. - [FILE: _inc_data]
void Data_SetPCHitPoints(object oPC);
// Returns a backup location for the PC when LastLocation fails. - [FILE: _inc_data]
location Data_GetPCBackupLocation(object oPC, string pcid="-1");
// Returns last saved location of the PC. - [FILE: _inc_data]
location Data_GetLocation(string sType, object oPC=OBJECT_INVALID, string pcid="-1");
// Stores a location in the DB for the PC. - [FILE: _inc_data]
void Data_SetLocation(string sType, location lLoc, object oPC=OBJECT_INVALID, string pcid="-1");
// Stores a campaign object to the database - [FILE: _inc_data]
void Data_SaveCampaignObject(object oObject, object oPC=OBJECT_INVALID);
// Retrieves a campaign object from the database - [FILE: _inc_data]
object Data_RetrieveCampaignObject(string sLabel, location lLoc, object oOwner = OBJECT_INVALID, object oPC=OBJECT_INVALID, string character_id="-1", int object_type=OBJECT_TYPE_CREATURE);
// Stores a campaign string to the database - [FILE: _inc_data]
void Data_SetCampaignString(string sLabel, string sValue, object character=OBJECT_INVALID, string character_id="-1");
// Retrieves a campaign string to the database - [FILE: _inc_data]
string Data_GetCampaignString(string sLabel, object character=OBJECT_INVALID, string character_id="-1");
// Stores a NPC object to the database - [FILE: _inc_data]
void Data_SaveNPC(object oObject);
// Retrieves an NPC object from the database - [FILE: _inc_data]
object Data_RetrieveNPC(string character_id, location lLoc);

// -- COMMON utility functions ---

// Returns a unique string identifying the PC - [FILE: _inc_util]
string GetPCID(object oPC);
// utility - return the area object with sAreaID    - [FILE: _inc_data]
object GetAreaFromID(string sAreaID);
// utility - return the area_id from oArea          - [FILE: _inc_data]
string GetIDFromArea(object oArea=OBJECT_SELF);
// replaces ' with ~                                - [FILE: _inc_data]
// the character ' will create problems for SQL
string EncodeSpecialChars(string sString);
// replaces ~ with '                                - [FILE: _inc_data]
string DecodeSpecialChars(string sString);

// Standard Listening patterns for module   [File: _inc_util]
void CreatureSetCommonListeningPatterns(object oCreature = OBJECT_SELF);

// returns item type general name.
// Scroll, Item, Gem, Potion, Weapon, Shield, Ammo, Ranged, Jewelry, Staff, Wand, Cloak, Bracer, Boots, Belt, Amulet
string GetItemTypeGeneralName(object oItem);



// Returns PC Object if PC is in game. PCID is a unique string identifier. - [FILE: _inc_util]
// TEMPORARY UNTIL WE SYNCH - NWNX_GetCharacterID(object oCharacter)
object GetPCByPCID(string PCID);
// Returns the first prefix of a tag, without the underscore - [FILE: _inc_util]
string GetTagPrefix(string sTag);
// returns TRUE if oPC has been flagged as a spell abuser - [FILE: _inc_util]
int PCGetIsSpellAbuser(object oPC);
// sets the SPELL_ABUSER status of oPC as TRUE by default (but FALSE can be passed) - [FILE: _inc_util]
void PCSetIsSpellAbuser(object oPC, int bSpellAbuser=TRUE);
// Used by _s2_playtool when a PC likes another PC's roleplay - [FILE: _inc_util]
void PCLikesTargetsRP(object oTarget, object oPC=OBJECT_SELF);
// sets oPC's current hitpoints to value of nHP - [FILE: _inc_util]
//void SetHitPoints(object oPC, int nHP);
// PC's bonus to stabilize while dying - [FILE: _inc_util]
// MAGUS DEATH SYSTEM
int GetStabilizeBonus(object oPC);
//Returns the number of henchmen oPC has employed - [FILE: _inc_util]
//Returns -1 if oPC isn't a valid PC
int GetNumHenchmen(object oPC);
// Places pointer to DM on DM possessed Creature   - [FILE: _inc_util]
void TrackDMPossession(object oDM, object oCreature);
//Drops items held by oCreature - [FILE: _inc_util]
void DropItems(object oCreature);
//Drops corpses held by oCreature - [FILE: _inc_util]
void DropCorpses(object oCreature);
// applies temporary strength damage. - [FILE: _inc_util]
void GivePCFatigue(object oPC=OBJECT_SELF);
// checks whether oWeapon does slashing damage. - [FILE: _inc_util]
int GetIsSlashingWeapon(object oWeapon);
// Checks oPC equipped items for a slashing weapon - [FILE: _inc_util]
int GetIsWieldingSlashingWeapon(object oPC);
// Checks oPC equipped items for a flame (torch or flaming weapon) - [FILE: _inc_util]
int GetIsWieldingFlame(object oPC);
// Checks oPC equipped items for an Axe-like tool - [FILE: _inc_util]
int GetIsWieldingAxe(object oPC);
// Checks oPC equipped items for an Hammer-like tool - [FILE: _inc_util]
int GetIsWieldingHammer(object oPC);
// Checks oPC equipped items for a Knife-like tool - [FILE: _inc_util]
int GetIsWieldingKnife(object oPC);
// Moves equipped items from oSource to oTarget - [FILE: _inc_util]
// if oSource is not a creature, it does nothing.
// if oTarget is a creature, oTarget equips the items
int MoveEquippedItems(object oSource, object oTarget, int copy=FALSE);
// Moves all of inventory from oSource to oTarget - [FILE: _inc_util]
// returns number of items moved
int MoveInventory(object oSource, object oTarget, int copy=FALSE);
// Deletes all items and gold from inventory of oTarget - [FILE: _inc_util]
void StripInventory(object oTarget, int strip_inventory=TRUE, int strip_gold=TRUE, int strip_equipped=TRUE, int is_npc=FALSE);
// Creates a creature which will store source_inventory's inventory in the DB - [FILE: _inc_util]
// clones the inventory of source_inventory
void CreatePersistentInventory(string inventory_tag, object source_inventory, string pcid="TBD", int store_in_db=TRUE, int clone_inventory=TRUE);
// finds or retrieves from DB persistent inventory holder - [FILE: _inc_util]
// establishes connection between holder and target, and clones inventory from holder to target
void RetrievePersistentInventory(string inventory_tag, object target_inventory, string pcid="0");
// returns the inventory object, even if it must spawn and recall it from DB - [FILE: _inc_util]
object GetPersistentInventory(string inventory_tag, string pcid="0");
// an ability check. if bVerbose=TRUE, ability check is broadcast - [FILE: _inc_util]
int GetAbilityCheck(object oPC, int nAbility, int nDC, int bVerbose=FALSE);
// maps the ability id to a string value
string AbilityToString(int nAbility);
// a skill check. if bVerbose=TRUE, ability check is broadcast - [FILE: _inc_util]
// return value is measure of success greater than DC +1. 0 = failure, 1 = minimal success, 2 = 1 greater than minimal etc...
int H_DoSkillCheck(object oPC, int nSkill, int nDC, int bVerbose=FALSE);

struct ENCUMBRANCE
{
    int low;
    int med;
    int high;
};
//returns a struct with low, med, high weight allowances in tenth pounds - [FILE: _inc_util]
struct ENCUMBRANCE GetWeightAllowance(object oCreature);
// returns a (negative) penalty based on how encumbered the creature is - [FILE: _inc_util]
int GetEncumbrancePenalty(object oCreature);
// applies a weight increase to an item - [FILE: _inc_util]
void ItemIncreaseWeight(int increase_weight, object oItem=OBJECT_SELF);
// returns a (negative) penalty based on the players equipped shield and armor. - [FILE: _inc_util]
// see armor.2da for armor check penalties.
int GetArmorCheckPenalty(object oCreature);
// determines whether the PC could be running   [File: _inc_util]
// checks - stealth, detection, encumbrance
int GetCanRun(object oPC);

/* Removed due to incompatibility with skills. Can revisit later.
// a grapple check. oTarget = creature defending, nDC = grapple difficulty - [FILE: _inc_util]
int GetIsGrappled(object oTarget, int nDC);
*/
//returns oPC's favored enemy bonus versus oNPC - [FILE: _inc_util]
int GetFavoredEnemyBonus(object oPC, object oNPC, int nRace=RACIAL_TYPE_INVALID);
// removes effects of effect_type. - [FILE: _inc_util]
// if effect_type = -1, all effects stripped
void RemoveEffectsByType(object target, int effect_type=-1);

// transfers variables expected on an NPC from oFrom to oTo - [FILE: _inc_util]
void SpawnTransferVariables(object oFrom, object oTo);
// sets up an NPC name on Spawn - [FILE: _inc_util]
void SpawnInitializeName(object npc=OBJECT_SELF);
// Returns the location state of the creature's stored in the database   [File: _inc_util]
int GetCreatureLocationState(string sNPCID,object oCreature=OBJECT_INVALID);
// Sets the location state of the creature's stored in the database   [File: _inc_util]
void SetCreatureLocationState(string sNPCID, int nState,object oCreature=OBJECT_INVALID);
// Returns the time stamp for when location state of the creature was last changed in the database   [File: _inc_util]
string GetCreatureLocationStateTimeStamp(string sNPCID,object oCreature=OBJECT_INVALID);
// Returns number of meetings. - [FILE: _inc_util]
int GetMeetings(object oPC, object oNPC);
// Increases number of meetings by 1 - [FILE: _inc_util]
void CreaturesMeet(object oPC, object oMPC);
// Attempts to start a conversation   [File: _inc_util]
// If creature is DM Possesssed it will not start a convo   (return FALSE)
// if creature has a zdlg convo it will try that            (return TRUE)
// otherwise it tries ActionStartConversation               (return FALSE)
// oSpeaksWith = PC attempting to speak with oCreature
int DetermineConversation(object oCreature, object oSpeaksWith, int bPrivate=FALSE, int bPlayHello=FALSE, int bZoom=TRUE);

// QUEST functions

// returns TRUE if pc has quest named quest_name [File: _inc_util]
int GetPCHasQuest(object pc, string quest_name);
// PC has the quest of quest_name if has_quest is TRUE [File: _inc_util]
void SetPCHasQuest(object pc, string quest_name, int has_quest=TRUE);
// returns TRUE if pc has completed the quest named quest_name [File: _inc_util]
int GetPCCompletedQuest(object pc, string quest_name);
// PC has completed the quest of quest_name if completed_quest is TRUE [File: _inc_util]
void SetPCCompletedQuest(object pc, string quest_name, int completed_quest=TRUE);
// returns pc's progress in the quest named quest_name [File: _inc_util]
int GetPCQuestState(object pc, string quest_name);
// set the pc's progress to quest_state in the quest named quest_name [File: _inc_util]
void SetPCQuestState(object pc, string quest_name, int quest_state);

// CORPSES -----
struct CORPSE
{
    int type;
    string pcid;
    string name;
    string description;
    string body_bones;
    string resref;
    int race;
    int gender;
    int appearance;
    int phenotype;
    int wings;
    int tail;
};
// transfers local vars and loads up the struct - [FILE: _inc_util]
struct CORPSE TransferCorpseData(object source, object target);
// module load event for persistent corpses - [FILE: _inc_util]
void CorpsesOnLoad();
//Sets corpse flags on corpse (persistent, raisable, animateable, skinnable) - [FILE: _inc_util]
int CreatureGetCorpseType(object oCreature);
//Drop corpse item - [FILE: _inc_util]
void CorpseItemDropped(object oLoser, object oCorpseItem, location lLoc);
// creates the corpse node where a PC respawns or where the carryable PC corpse is dropped [File: _inc_util]
object CreateCorpseNodeFromBody(object oBody, location lDeath, string node_ref="invis_corpse_obj");
// creates the corpse item on the PC picking up the body [File: _inc_util]
object CreateCorpseItemFromCorpseNode(object oCorpseNode, object oTaker);
// when all you want to do is make a doppelganger of the corpse's body [File: _inc_util]
object GetPrettyBodyFromCorpse(object corpse_object, string corpse_resref, location lBody, string corpse_tag="");
// creates the body to dress up when a PC corpse is on ground   [File: _inc_util]
void CreateCorpseFromCorpseNode(object oCorpseNode, location lDeath, int kill=TRUE, int dress=TRUE);
// used by CreateCorpseFromCorpseNode to dress up the body with equipped items   [File: _inc_util]
void CorpseDress(object oCorpse, object oCorpseNode, int corpse_equip=TRUE);
// check the PC for corpses, if no longer the "holder", destroy [File: _inc_util]
void PCLoginCorpseCheck(object oPC=OBJECT_SELF);
// casting of a raise spell on a corpseNode (plc) or corpseItem (item) [File: _inc_util]
// resurrect, raisedead... potentially other types as well
// returns FALSE on failure
int SpellRaiseCorpse(object oCorpse, int spell_id, location loc_raise, object spell_caster=OBJECT_INVALID);
// clear effects and jump the character to their desired location [File: _inc_util]
void PrepPCForRespawn(object oPC, location loc_raise);
// final step of raising a corpse from the dead [File: _inc_util]
void CharacterRaiseCompletes(location loc_raise, string status);
// corpse garbage collection [File: _inc_util]
void DestroyCorpse(string pcid, int strip_corpse=FALSE);
// DEATH -----
// Garbage collection of killer data,   [File: _inc_util]
void WipeKillerDataFromVictim(object victim);
// Record the killer on the victim when dying starts,   [File: _inc_util]
void StoreKillerDataOnVictim(object victim, object killer);
// status can be integer of game day of death, "0" for alive,   [File: _inc_util]
// "RAISED", or "RESURRECTED" indicate the process of being raised
string GetPCDeathStatus(string pcid);
// records the full death event, and sets "status" of death to current game day,   [File: _inc_util]
void RecordPCDeath(object oPC);
// cancels a death with a status of 0 for alive   [File: _inc_util]
// RAISED and RESURRECTED can be used to indicate the PC will be raised or resurrected on next log in
void ClearPCDeath(string pcid, string status="0");


// STRING Manipulations taken from AID -------

// DoColorize - wrapper for all ColorStringManip() calls [file: _inc_util]
string DoColorize(string sText, int bDescription=FALSE);
// ColorStringManip - replaces all instances of sChar from sText with sColor [file: _inc_util]
string ColorStringManip(string sText, string sChar, string sColor);

// CREATURES
// Returns the creature's natural phenotype  - [FILE: _inc_util]
int CreatureGetNaturalPhenoType(object oCreature);
// Returns the creature size modifier based on the size of oPC.  - [FILE: _inc_util]
// NOTE: Bioware hasn't fully implemented the CREATURE_SIZE_* constants so this is a reduced list.
int GetCreatureSizeModifier(object oCreature);
// Returns the creature's weight in pounds, using size and equipment  - [FILE: _inc_util]
int GetCreatureWeight(object oCreature);
// Returns the creature's height in feet, using appearance 2da  - [FILE: _inc_util]
int GetCreatureHeight(object oCreature, int bMeters=FALSE);
// Determines whether oCreature passes for animal. - [FILE: _inc_util]
int CreatureGetIsAnimal(object oCreature=OBJECT_SELF);
// Determines whether oCreature passes for humanoid. - [FILE: _inc_util]
int CreatureGetIsHumanoid(object oCreature=OBJECT_SELF);
// Determines if the creature qualifies as a spider - [FILE: _inc_util]
int CreatureGetIsSpider(object oCreature=OBJECT_SELF);
// Determines whether oCreature is a fungus creature. - [FILE: _inc_util]
int CreatureGetIsFungus(object oCreature=OBJECT_SELF);
// Returns TRUE if the creature has hands (based on appearance) - [FILE: _inc_util]
// this is useful in determining whether a creature can open/close object or manipulate devices
int CreatureGetHasHands(object oCreature=OBJECT_SELF);
// Determines if the creature is aquatic (breathes in water/swims) - [FILE: _inc_util]
int CreatureGetIsAquatic(object oCreature=OBJECT_SELF);
// Determines if the creature is softbodied (can fit through tiny openings) - [FILE: _inc_util]
int CreatureGetIsSoftBodied(object oCreature=OBJECT_SELF);
// oCreature responds to someone sitting in their seat   [File: _inc_util]
// return value is the seat (to give the creature the opportunity to forget about it)
object CreatureGetResponseToSitterInSeat(object oCreature , object oSeat);
// Returns TRUE if the creature is executing an action or in conversation or combat - [FILE: _inc_util]
// The following actions are NOT considered "busy": ACTION_RANDOMWALK, ACTION_WAIT, ACTION_SIT
// Function will also accept one more action that it will ignore as busy with nIgnoreAction
int CreatureGetIsBusy(object oCreature=OBJECT_SELF, int nIgnoreAction=ACTION_INVALID, int nIgnoreCombat=FALSE, int nIgnoreConversation=FALSE);
// Determines if this is heard   [File: _inc_util]
int GetIsShoutHeard(object oShouter);
// Determines whether oCreature is civilized. - [FILE: _inc_util]
int CreatureGetIsCivilized(object oCreature=OBJECT_SELF);
// Determines whether oCreature is eaten by oPredator - [FILE: _inc_util]
int GetIsPrey(object oCreature, object oPredator=OBJECT_SELF);
// Range of oCreature's scent range - [FILE: _inc_util]
float GetScentRange(object oCreature);
// Friendly 2, Hostile 1, Neutral 0 - [FILE: _inc_util]
int GetReputationReactionType(object oTarget, object oSource=OBJECT_SELF, int bSharesGroup=FALSE);
// AREAS and SubAreas (triggers)

// Returns the area description as observed by oPC - [FILE: _inc_util]
string AreaGetDescription(object oPC, object oArea=OBJECT_SELF, int bEntry=FALSE, int nEntries=0);
// Returns true if oPC knows the entire area - [FILE: _inc_util]
int AreaGetIsMappedByPC(object oPC, object oArea=OBJECT_SELF);
// Returns TRUE if the trigger description can continue for oPC - [FILE: _inc_util]
int GetDescriptionCanContinue(object oPC, object oTrigger=OBJECT_SELF);

// SPELLS

//Fixes faction stuff
void TE_Faction_Fix(object oPC);
// Checks whether specified spell compents (v, s, vs) are required by the spell - [FILE: _inc_util]
int GetSpellComponent(string sComponent, int nSpellID);
// Clears self of Overrides used in the Community Patch - [FILE: _inc_util]
void CasterClearsSpellOverrides();
// Self must maintain concentration to sustain oConcentrate's existence - [FILE: _inc_util]
void CasterSetConcentration(object oConcentrate, string sScript="");
// Dispel a magical object - [FILE: _inc_util]
// returns TRUE on success FALSE on failure
int DispelObject(int nSpellID, int nLevel, int nDC, int bAutoDispel=FALSE);
// OBJECT_SELF is a familiar. - [FILE: _inc_util]
// nMax is the total spellfoci the creature can carry
// we assume that the familiar is about to pick up a spellfocus, and destroy all that are extra
void FamiliarDestroyExtraSpellFocus(int nMax=1);
// Create a tag for a spell focus (to eliminate stacking problem). - [FILE: _inc_util]
string GetSpellFocusTag(int nType, location lTarget, object oTarget=OBJECT_INVALID);
// Returns TRUE if spell cast on focus succeeds. - [FILE: _inc_util]
// OBJECT_SELF is Spell Caster
int GetIsSpellFocusSuccessful(object oFocus, int nSpellID);
// Returns a location stored on a spell focus. - [FILE: _inc_util]
location GetSpellFocusLocation(object oFocus);
// Stores a location on a spell focus. - [FILE: _inc_util]
void StoreSpellFocusLocation(object oFocus, location lLoc);
// Helps track creator of AOE - [FILE: _inc_util]
// Pointer to Caster is set in module variable.
// Save AOE Index according to spellid on caster
void SetAOECaster(int nSpellId, object oCaster);
// Scry related functions.....

// Checks to see if a target is warded from scrying - [FILE: _inc_util]
int GetIsScryTargetWarded(location lTarget, object oTarget);
// Garbage collection for the clairaudience spell - [FILE: _inc_util]
void ClairaudienceEnd(object oCreator);
// Garbage collection for the clairaudience spell - [FILE: _inc_util]
void EndScrying(object oPC);

// Determines whether the caller can control another weapon - [file: _inc_util]
// nLevel = GetCasterLevel
// IF TRUE, increment the count and return TRUE, ELSE return FALSE
int IncrementAnimatedWeaponCount(int nLevel);
// decreases master's animate weapon count- [file: _inc_util]
// Executes on the Animated Weapon
void DecrementAnimatedWeaponCount();
// Destroys wielder, drops weapon, cleans up data, calls DecrementAnim... - [file: _inc_util]
// Executes on the Animated Weapon
void CancelDancingWeapon(int nDispel=FALSE);
// Determines if the PC has apropriate spellmastery for the relevant spell level
int getHasSpellmastery(object oPC, int nSpell, string sSpaceCase = "");
//gets the level of spellmastery a PC has with the school
int getSpellmastery(object oPC, int nSpell, string sSpecCase = "");
//gets the spellmastery static effect based on character spellmastery level
int getSpellmasteryEffect(object oPC, int nSpell, string sSpecCase = "");
//help function to find the proper school name to use in the spell mastery system
string getSpellShool(int nSpell);


// LIGHT SYSTEM

// Returns a light VFX using two local vars - LIGHT_COLOR and LIGHT_BRIGHTNESS - [FILE: _inc_util]
int GetLightColor(object oLight=OBJECT_SELF);
// Initializes consumable lightsources. - [FILE: _inc_util]
// see equip module event
void InitializeTorch(object oItem, string sType);
// Returns the brightness of the brightest wielded light - [FILE: _inc_util]
int GetBrightestLightWielded(object oPC, object oSkipped);
// oPC is able to light oSconce - [FILE: _inc_util]
int PCCanLight(object oSconce, object oPC);
// PC's light is destroyed or loses light property. Reset light flags - [FILE: _inc_util]
void PCLostLight(object oPC, object oLostLight);


// TIME
struct DATETIME
{
    int year, month, day, hour, minute, second;
};

// Return current IG time measured since the epoch - [FILE: _inc_util]
// default time returned is minutes, also works for seconds, hours and days
int GetTimeCumulative(int nTime=TIME_MINUTES);
// Return game seconds to elapse over real seconds - [FILE: _inc_util]
int ConvertRealSecondsToGameSeconds(int nRealSeconds);
// Return DATETIME from sTimeStamp  [FILE: _inc_util]
// if this is REAL TIME - set gametime to FALSE
struct DATETIME ConvertTimeStampToDateTime(string sTimeStamp, int gametime=TRUE);
// Return timestamp from DATETIME  [FILE: _inc_util]
// if this is REAL TIME - set gametime to FALSE
string ConvertDateTimeToTimeStamp(struct DATETIME time, int gametime=TRUE);
// Sets up object to fade in time. - [FILE: _inc_util]
void InitializeFade(object oObject);
// Fade objects in the area. - [FILE: _inc_util]
void ObjectsFade(object oArea);

// XP
// Returns the XP needed by PC to gain a level - [FILE: _inc_util]
// in bNext = FALSE, returns how much total XP is needed for PC's current level
int XPGetPCNeedsToLevel(object oPC, int bNext = TRUE);

// Returns if the class integer is a PRC or not.
int GetIsClassPRC(int nClass);

//Determins if caster has special gestalting pre requisites
// returns 1 for has PreReq
// returns 0 for has not PreReq
int TE_hasGestaltPrec(object oPc);

//Gets faction creature and adjusts reputation.
void ChangeFactionReputation(object oPC, string sFaction, int nReputation);

void Data_SavePC(object oPC, int export_characters_now=FALSE)
{
    // do not record critical PC data in out of character areas or if we have isolated the PC
    if(     GetIsDM(oPC)
        ||  (GetLocalInt(GetArea(oPC),"OUT_OF_CHARACTER") || GetLocalInt(oPC,"OUT_OF_CHARACTER"))
        ||  !GetIsObjectValid(GetArea(oPC))
      )
    {
        // do nothing
    }
    else
    {

        // branches between NWNX and NDBE
        Data_SetLocation("LAST", GetLocation(oPC), oPC);

        // Pesistant GP
        //SetSkinInt(oPC, PC_GP, GetGold(oPC));

        // Pesistant HP
        if(     !GetLocalInt(oPC,"RESTORE_HP")
            &&  GetLocalInt(oPC,"RESTORE_HP_INIT")
          )
        {
            Data_SetPCHitPoints(oPC);
        }

        if(export_characters_now)
            ExecuteScript("fox_export_chars",oPC);
    }

}

int Data_GetPCHitPoints(object oPC)
{
    return (StringToInt(
                        Data_GetCampaignString("HIT_POINTS", oPC, GetPCID(oPC))
                       )
           );
}

void Data_SetPCHitPoints(object oPC)
{
    int nHP = GetCurrentHitPoints(oPC);
    Data_SetCampaignString("HIT_POINTS", IntToString(nHP), oPC, GetPCID(oPC));
}

location Data_GetPCBackupLocation(object oPC, string pcid="-1")
{
    // value to return
    location lLocation;

    // home
    lLocation   = Data_GetLocation("HOME", oPC, pcid);

    // else look up last known region for PC ... and start them at a safe place there

    // when all else fails, PC returns to the default starting way point
    if(!GetIsObjectValid(GetAreaFromLocation(lLocation)))
        lLocation   = GetStartingLocation();

    return lLocation;
}

location Data_GetLocation(string sType, object oPC=OBJECT_INVALID, string pcid="-1")
{
    // value to return
    location lLocation;

        // adjust the label for the pc
        string loc_label;
        if(pcid=="-1")
        {
            if(GetIsObjectValid(oPC))
                pcid = GetPCID(oPC);
            else
                pcid = "0";
        }
        if(pcid!="0")
            loc_label   = pcid+sType;

        // location string in database
        string sLoc     = NBDE_GetCampaignString(CAMPAIGN_NAME, loc_label, OBJECT_INVALID);

        // convert location string to location
        object oArea    = GetAreaFromID(GetStringRight(sLoc,48));
        vector vVec;
               vVec.x   = StringToFloat(GetStringLeft(sLoc,5)) / 100;
               vVec.y   = StringToFloat(GetSubString(sLoc,5,5)) / 100;
               vVec.z   = StringToFloat(GetSubString(sLoc,10,5)) / 100;
        lLocation       = Location(oArea, vVec, StringToFloat(GetSubString(sLoc,15,5)) / 100);

    return lLocation;
}

void Data_SetLocation(string sType, location lLoc, object oPC=OBJECT_INVALID, string pcid="-1")
{
        // adjust the label for the pc
        string loc_label;
        if(pcid=="-1")
        {
            if(GetIsObjectValid(oPC))
                pcid = GetPCID(oPC);
            else
                pcid = "0";
        }
        if(pcid!="0")
            loc_label   = pcid+sType;

        object oArea    = GetAreaFromLocation(lLoc);
        vector vPos     = GetPositionFromLocation(lLoc);
        float fFacing   = GetFacingFromLocation(lLoc);
        string sLoc; // the value stored in the DB
        //set X pos
        sLoc    = IntToString(FloatToInt(vPos.x*100));
        sLoc    = (GetStringLength(sLoc) < 5)  ? sLoc + GetStringLeft("     ", 5-GetStringLength(sLoc))  : GetStringLeft(sLoc,5);
        //set Y pos
        sLoc   += IntToString(FloatToInt(vPos.y*100));
        sLoc    = (GetStringLength(sLoc) < 10) ? sLoc + GetStringLeft("     ", 10-GetStringLength(sLoc)) : GetStringLeft(sLoc,10);
        //set Z pos
        sLoc   += IntToString(FloatToInt(vPos.z*100));
        sLoc    = (GetStringLength(sLoc) < 15) ? sLoc + GetStringLeft("     ", 15-GetStringLength(sLoc)) : GetStringLeft(sLoc,15);
        //set facing
        sLoc   += IntToString(FloatToInt(fFacing*100));
        sLoc    = (GetStringLength(sLoc) < 20) ? sLoc + GetStringLeft("     ", 20-GetStringLength(sLoc)) : GetStringLeft(sLoc,20);
        //set area id
        sLoc   += GetIDFromArea(oArea);

        NBDE_SetCampaignString(CAMPAIGN_NAME, loc_label, sLoc, oPC);
}

void Data_SaveCampaignObject(object oObject, object oPC=OBJECT_INVALID)
{
    // ctored campaign objects need unique tags
    string sLabel       = GetTag(oObject);

    StoreCampaignObject(CAMPAIGN_NAME, sLabel, oObject, oPC);
}

object Data_RetrieveCampaignObject(string sLabel, location lLoc, object oOwner = OBJECT_INVALID, object oPC=OBJECT_INVALID, string character_id="-1", int object_type=OBJECT_TYPE_CREATURE)
{
    object campaign_object;

    campaign_object = RetrieveCampaignObject(CAMPAIGN_NAME, sLabel, lLoc, oOwner, oPC);


    return campaign_object;
}

void Data_SetCampaignString(string sLabel, string sValue, object character=OBJECT_INVALID, string character_id="-1")
{
    NBDE_SetCampaignString(CAMPAIGN_NAME, sLabel, sValue, character);

}

string Data_GetCampaignString(string sLabel, object character=OBJECT_INVALID, string character_id="-1")
{
    string sValue;

    sValue = NBDE_GetCampaignString(CAMPAIGN_NAME, sLabel, character);


    return sValue;
}

void Data_SaveNPC(object oCharacter)
{
    // only unique NPCs
    if(GetIsPC(oCharacter) || !GetLocalInt(oCharacter,"UNIQUE"))
        return;

    string character_id = GetPCID(oCharacter);

    StoreCampaignObject(CAMPAIGN_NAME, character_id, oCharacter);
}

object Data_RetrieveNPC(string character_id, location lLoc)
{
    object oCharacter;

    oCharacter = RetrieveCampaignObject(CAMPAIGN_NAME, character_id, lLoc);

    return oCharacter;
}

// -- COMMON utility functions ---

string GetPCID(object oPC)
{
    string pcid    = GetLocalString(oPC, "CHARACTER_ID");
    if(pcid!="")
        return pcid;

        if(GetIsPC(oPC))
                pcid = IntToString( NBDE_Hash(GetPCPlayerName(oPC)+"_"+GetName(oPC)) );
            else
                pcid = IntToString( NBDE_Hash(GetResRef(oPC)+"_"+GetTag(oPC)+"_"+GetName(oPC)) );


    SetLocalString(oPC, "CHARACTER_ID", pcid);
    return pcid;
}

string GetIDFromArea(object oArea=OBJECT_SELF)
{
    if(!GetIsObjectValid(oArea)){return "";}

    string sAreaID = GetLocalString(oArea,"AREA_ID");
    if(sAreaID!=""){return sAreaID;}

    string sRef = GetResRef(oArea);
    string sTag = GetTag(oArea);
        // set area tag
    sAreaID +=(GetStringLength(sTag) < 32) ? sTag + GetStringLeft("                                ", 32-GetStringLength(sTag)) : sTag;
    // set area reref
    sAreaID +=(GetStringLength(sRef) < 16) ? sRef + GetStringLeft("                                ", 16-GetStringLength(sRef)) : sRef;

    SetLocalString(oArea,"AREA_ID",sAreaID);

    return sAreaID;
}

object GetAreaFromID(string sAreaID)
{
    string sRef = GetStringRight(sAreaID,16);
    int nPos    = FindSubString(sRef," ");
    if(nPos>0)
        sRef    = GetStringLeft(sRef,nPos);

    string sTag = GetStringLeft(sAreaID,32);
        nPos    = FindSubString(sTag," ");
    if(nPos>0)
        sTag    = GetStringLeft(sTag,nPos);

    int nNth    = 0;
    object oArea= OBJECT_INVALID;
    object oTmp = GetObjectByTag(sTag,nNth);
    while(GetIsObjectValid(oTmp))
    {
        oArea   = oTmp;
        if(GetResRef(oTmp)==sRef)
            break;
        oTmp    = GetObjectByTag(sTag,++nNth);
    }

    return oArea;
}

string EncodeSpecialChars(string sString)
{
    if (FindSubString(sString, "'") == -1) // not found
        return sString;

    int i;
    string sReturn = "";
    string sChar;
    string Quote = GetLocalString(GetModule(), "QUOTE");
    // Loop over every character and replace special characters
    for (i = 0; i < GetStringLength(sString); i++)
    {
        sChar = GetSubString(sString, i, 1);
        if (sChar == "'" || sChar == "`" || sChar == Quote)
            sReturn += "~";
        else
            sReturn += sChar;
    }
    return sReturn;
}

string DecodeSpecialChars(string sString)
{
    if (FindSubString(sString, "~") == -1) // not found
        return sString;

    int i;
    string sReturn = "";
    string sChar;

    // Loop over every character and replace special characters
    for (i = 0; i < GetStringLength(sString); i++)
    {
        sChar = GetSubString(sString, i, 1);
        if (sChar == "~")
            sReturn += "'";
        else
            sReturn += sChar;
    }
    return sReturn;
}

void CreatureSetCommonListeningPatterns(object oCreature = OBJECT_SELF)
{
    //SetListening(OBJECT_SELF, TRUE);
    SetListenPattern(oCreature, SHOUT_PLACEABLE_ATTACKED+"**", 10);
    SetListenPattern(oCreature, SHOUT_PLACEABLE_DESTROYED+"**", 11);
    SetListenPattern(oCreature, SHOUT_ALERT+"**", 12);
    SetListenPattern(oCreature, SHOUT_FLEE+"**", 13);
    SetListenPattern(oCreature, SHOUT_SUBDUAL_DEAD+"**", 14);
    SetListenPattern(oCreature, SHOUT_SUBDUAL_ATTACK+"**", 15);
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//TETHYR CUSTOM FUNCTIONS
////////////////////////////////////////////////////////////////////////////////

// Attempt to get the name of the location. [File: te_functions]
string TE_GetLocationName(string sLoc);

//Returns the modified Arcane Caster Level using all PRCs and base classes. [File: te_functions]
int TE_ArcaneCasterLevel(object oPC);

//Returns the modified Divine Caster Level using all PRCs and base classes. [File: te_functions]
int TE_DivineCasterLevel(object oPC);

//Returns 1 if the class is an Arcane spellcasting class.
//Returns 0 if the class is not an Arcane spellcasting class. [File: te_functions]
int TE_ArcaneCasterClass(int nClass);

//Returns 1 if the class is an Arcane spellcasting class.
//Returns 0 if the class is not an Arcane spellcasting class.[File: te_functions]
int TE_DivineCasterClass(int nClass);

//Returns the gestalt caster level of the caster.
int TE_GetCasterLevel(object oPC, int nClass);

//Returns the spell save DC.
int TE_GetSpellSaveDC(object oPC, int nSpell, int nClass);

//Returns whether a character has a background feat. [File: te_functions]
int GetHasBackground(object oPC);

// IMPLEMENTATIONS

// TEMPORARY
object GetPCByPCID(string PCID)
{
    object oPC  = GetFirstPC();
    while(oPC!=OBJECT_INVALID)
    {
        if(GetPCID(oPC)==PCID)
            return oPC;

        oPC     = GetNextPC();
    }

    return OBJECT_INVALID;
}



string GetTagPrefix(string sTag)
{
    string sTagPrefix   = "";
    int iPos1           = FindSubString(sTag, "_");
    int iPos2;
    int iLastPos        = GetStringLength(sTag)-1;

    if (iPos1 > 0)
    {
        sTagPrefix   = GetStringLeft(sTag, iPos1); // returns prefix without underscores
    }
    else if (iPos1 == 0)
    {
        // we have a leading underscore
        iPos2 = FindSubString(sTag, "_", ++iPos1);// look for a second underscore
        if (iPos2 != -1 && iPos2 != 1 && iPos2 != iLastPos) // ignore: _XXXXX , __XXXX , _XXXX_
        {
            sTagPrefix  = GetSubString(sTag, iPos1, iPos2 - iPos1);
        }
    }

    return GetStringLowerCase(sTagPrefix);
}


int PCGetIsSpellAbuser(object oPC)
{
        return NBDE_GetCampaignInt(CAMPAIGN_NAME, "SPELL_ABUSER", oPC);
}

void PCSetIsSpellAbuser(object oPC, int bSpellAbuser=TRUE)
{
        NBDE_SetCampaignInt(CAMPAIGN_NAME, "SPELL_ABUSER", bSpellAbuser, oPC);
}

void PCLikesTargetsRP(object oTarget, object oPC=OBJECT_SELF)
{
    // target is identified as a PC, is not a DM, and has chat recently
    int nNow        = GetTimeCumulative();
    int nRewardVal  = GetHitDice(oTarget)*10;    // 10 = 1% of total needed to level
    int nFrequency  = IGMINUTES_PER_RLMINUTE*30; // rewards only happen once in a period (number is real world minutes)
    int nLastKudos;

    nLastKudos  = NBDE_GetCampaignInt(CHARACTER_DATA,"PCLIKESROLEPLAY_LIKED_TIMESTAMP",oTarget);


    // does the Targeted PC have an active "liked" flag?
    if(nLastKudos)
    {
        // if so, has enough time passed to give them their reward?
        if((nLastKudos+nFrequency)<=nNow)
        {
            // give 2% of xp needed to level
            SetLocalInt(oTarget,"REWARD_ROLEPLAY_XP", nRewardVal );
            // time stamp the Targeted PC as having roleplayed well enough to get a like
            NBDE_SetCampaignInt(CHARACTER_DATA,"PCLIKESROLEPLAY_LIKED_TIMESTAMP",nNow,oTarget);
        }
    }
    // this is the first like so lets trigger the reward
    else
    {
        // give 2% of xp needed to level
        SetLocalInt(oTarget,"REWARD_ROLEPLAY_XP", nRewardVal );

        // time stamp the Targeted PC as having roleplayed well enough to get a like
        NBDE_SetCampaignInt(CHARACTER_DATA,"PCLIKESROLEPLAY_LIKED_TIMESTAMP",nNow,oTarget);
    }
}
/*
void SetHitPoints(object oPC, int nHP)
{
    if(!GetIsObjectValid(oPC))
        return;

    // non-NWNX solution
    int nMaxHP      = GetMaxHitPoints(oPC);
    int nCurrentHP  = GetCurrentHitPoints(oPC);
    int nChange     = nHP - nCurrentHP;

    if (nHP<1)
    {
        // kill the PC. They logged out near death so they would be dead by now anyway
        nChange = nMaxHP+10;
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nChange, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY), oPC);
    }
    else if (nChange == 0)
        return; // don't need to do anything
    else if (nChange < 0)
    {
        // we need to damage oPC
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(abs(nChange), DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY), oPC);
    }
    else
    {
        // we need to heal oPC
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(abs(nChange)), oPC);
        if(nMaxHP<nHP)
        {
            // We need to give additional temporary hitpoints to the oPC
            nChange = nHP - nMaxHP;
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectTemporaryHitpoints(abs(nChange)), oPC);
        }
    }
}
*/
int GetStabilizeBonus(object oPC)
{
    int StabilizeBonus = 0;

    StabilizeBonus  += GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
    StabilizeBonus  += GetHasFeat(FEAT_STRONGSOUL, oPC);
    StabilizeBonus  += GetHasFeat(FEAT_GREAT_FORTITUDE, oPC);
    StabilizeBonus  += GetHasFeat(FEAT_EPIC_FORTITUDE, oPC);
    StabilizeBonus  += GetHasFeat(FEAT_LUCK_OF_HEROES, oPC);
    StabilizeBonus  += GetHasFeat(FEAT_DEATHLESS_VIGOR, oPC);
    StabilizeBonus  += GetHasFeat(FEAT_DIVINE_GRACE, oPC);

    return StabilizeBonus;
}

int GetNumHenchmen(object oPC)
{
    if (!GetIsPC(oPC)) return -1;

    int nLoop, nCount;
    for (nLoop=1; nLoop<=GetMaxHenchmen(); nLoop++)
    {
        if (GetIsObjectValid(GetHenchman(oPC, nLoop)))
            nCount++;
    }
    return nCount;
}

void TrackDMPossession(object oDM, object oCreature)
{
    DeleteLocalObject(GetLocalObject(oCreature, "DM_POSSESSOR"),"POSSESSED_CREATURE");
    SetLocalObject(oDM,"POSSESSED_CREATURE", oCreature);
    SetLocalObject(oCreature, "DM_POSSESSOR", oDM);
}

void DropItems(object oCreature)
{
    object oItemLeft    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oCreature);
    object oItemRight   = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oCreature);
    object oItemHead    = GetItemInSlot(INVENTORY_SLOT_HEAD,oCreature);
    float fDir          = GetFacing(oCreature);
    location lLocLeft   = GenerateNewLocation(oCreature,
                                DISTANCE_TINY,
                                GetHalfLeftDirection(fDir),
                                fDir);
    location lLocRight  = GenerateNewLocation(oCreature,
                                DISTANCE_TINY,
                                GetHalfRightDirection(fDir),
                                fDir);
    location lLocHead   = GenerateNewLocation(oCreature,
                                DISTANCE_TINY,
                                GetOppositeDirection(fDir),
                                fDir);
    AssignCommand(oCreature, ActionUnequipItem(oItemLeft));
    AssignCommand(oCreature, ActionUnequipItem(oItemRight));
    AssignCommand(oCreature, ActionUnequipItem(oItemHead));
    CopyObject(oItemLeft,lLocLeft);
    CopyObject(oItemRight,lLocRight);
    CopyObject(oItemHead,lLocHead);
    DestroyObject(oItemLeft);
    DestroyObject(oItemRight);
    DestroyObject(oItemHead);
}

void DropCorpses(object oCreature)
{
    object oItem    = GetFirstItemInInventory(oCreature);
    float fDir      = GetFacing(oCreature);
    location lLoc   =  GenerateNewLocation(oCreature,
                                DISTANCE_SHORT,
                                GetOppositeDirection(fDir),
                                fDir);
    while(GetIsObjectValid(oItem))
    {
        if(GetResRef(oItem)=="corpse_pc")
            DelayCommand(0.1, CorpseItemDropped(oCreature, oItem, lLoc));

        oItem       = GetNextItemInInventory(oCreature);
    }
}

void GivePCFatigue(object oPC=OBJECT_SELF)
{
    if((GetAbilityScore(oPC,ABILITY_STRENGTH,TRUE)-GetAbilityScore(oPC,ABILITY_STRENGTH))<6)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityDecrease(ABILITY_STRENGTH,1),
                            oPC,
                            120.0
                            );
    }
    string sPossessive  = "his";
    if(GetGender(oPC)==GENDER_FEMALE)
        sPossessive = "her";
    FloatingTextStringOnCreature(RED+GetName(oPC)+" is fatigued by "+sPossessive+" efforts!", oPC);
}

int GetIsSlashingWeapon(object oWeapon)
{
    int nItemType   = GetBaseItemType(oWeapon);
    if( nItemType==BASE_ITEM_INVALID )
        return FALSE;

    string sDam     = Get2DAString("baseitems", "WeaponType", nItemType);
    int nDam        = StringToInt(sDam);

    if(     nDam==3
        ||  nDam==4
      )
        return TRUE;
    else
        return FALSE;
}

int GetIsWieldingSlashingWeapon(object oPC)
{
    object oLeft    = GetItemInSlot( INVENTORY_SLOT_LEFTHAND,oPC);
    object oRight   = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND,oPC);

    if(     GetIsSlashingWeapon(oLeft)
        ||  GetIsSlashingWeapon(oRight)
      )
        return TRUE;
    else
    {
        int bSuccess;
        itemproperty ip = GetFirstItemProperty(oLeft);
        while( GetIsItemPropertyValid(ip) && bSuccess==FALSE )
        {
            if(ip==ItemPropertyExtraMeleeDamageType(IP_CONST_DAMAGETYPE_SLASHING))
                bSuccess==TRUE;
            ip = GetNextItemProperty(oLeft);
        }
        ip = GetFirstItemProperty(oRight);
        while( GetIsItemPropertyValid(ip) && bSuccess==FALSE )
        {
            if(ip==ItemPropertyExtraMeleeDamageType(IP_CONST_DAMAGETYPE_SLASHING))
                bSuccess==TRUE;
            ip = GetNextItemProperty(oRight);
        }
        return bSuccess;
    }
}

int GetIsWieldingFlame(object oPC)
{
    object oLeft    = GetItemInSlot( INVENTORY_SLOT_LEFTHAND,oPC);
    object oRight   = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND,oPC);
    int nItemTypeL, nItemTypeR;
    if(GetIsObjectValid(oLeft))
        nItemTypeL  = GetBaseItemType(oLeft);

    string sLightType = GetLocalString(oLeft, "LIGHTABLE_TYPE");
    if( nItemTypeL==BASE_ITEM_TORCH && sLightType=="torch" )
        return TRUE;
    else
    {
        if(GetIsObjectValid(oRight))
        {
            itemproperty ipR    = GetFirstItemProperty(oRight);
            while(GetIsItemPropertyValid(ipR))
            {
                if(GetItemPropertyParam1(ipR)==0 && GetItemPropertyParam1Value(ipR)==10)
                    return TRUE;
                ipR = GetNextItemProperty(oRight);
            }
        }
        if(GetIsObjectValid(oLeft))
        {
            itemproperty ipL    = GetFirstItemProperty(oLeft);
            while(GetIsItemPropertyValid(ipL))
            {
                if(GetItemPropertyParam1(ipL)==0 && GetItemPropertyParam1Value(ipL)==10)
                    return TRUE;
                ipL = GetNextItemProperty(oLeft);
            }
        }
    }
    return FALSE;
}

int GetIsWieldingAxe(object oPC)
{
    object oLeft    = GetItemInSlot( INVENTORY_SLOT_LEFTHAND,oPC);
    object oRight   = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND,oPC);

    if(GetIsObjectValid(oLeft))
    {
        int nItemTypeL  = GetBaseItemType(oLeft);
        if(     nItemTypeL==BASE_ITEM_BATTLEAXE
            ||  nItemTypeL==BASE_ITEM_DWARVENWARAXE
            ||  nItemTypeL==BASE_ITEM_GREATAXE
            ||  nItemTypeL==BASE_ITEM_HANDAXE
            ||  nItemTypeL==BASE_ITEM_SCIMITAR
          )
            return TRUE;
    }
    if(GetIsObjectValid(oRight))
    {
        int nItemTypeR  = GetBaseItemType(oRight);
        if(     nItemTypeR==BASE_ITEM_BATTLEAXE
            ||  nItemTypeR==BASE_ITEM_DWARVENWARAXE
            ||  nItemTypeR==BASE_ITEM_GREATAXE
            ||  nItemTypeR==BASE_ITEM_HANDAXE
            ||  nItemTypeR==BASE_ITEM_SCIMITAR
          )
            return TRUE;
    }

    return FALSE;
}

int GetIsWieldingHammer(object oPC)
{
    object oLeft    = GetItemInSlot( INVENTORY_SLOT_LEFTHAND,oPC);
    object oRight   = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND,oPC);

    if(GetIsObjectValid(oLeft))
    {
        int nItemTypeL  = GetBaseItemType(oLeft);
        if(     nItemTypeL==BASE_ITEM_LIGHTHAMMER
            ||  nItemTypeL==BASE_ITEM_LIGHTMACE
            ||  nItemTypeL==BASE_ITEM_WARHAMMER
          )
            return TRUE;
    }
    if(GetIsObjectValid(oRight))
    {
        int nItemTypeR  = GetBaseItemType(oRight);
        if(     nItemTypeR==BASE_ITEM_LIGHTHAMMER
            ||  nItemTypeR==BASE_ITEM_LIGHTMACE
            ||  nItemTypeR==BASE_ITEM_WARHAMMER
          )
            return TRUE;
    }

    return FALSE;

}

int GetIsWieldingKnife(object oPC)
{
    object oLeft    = GetItemInSlot( INVENTORY_SLOT_LEFTHAND,oPC);
    object oRight   = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND,oPC);
    if(GetIsObjectValid(oLeft))
    {
        int nItemTypeL  = GetBaseItemType(oLeft);
        if(     nItemTypeL==BASE_ITEM_DAGGER
            ||  nItemTypeL==BASE_ITEM_KUKRI
            ||  nItemTypeL==309// assassin dagger
            ||  nItemTypeL==310// katar
          )
            return TRUE;
    }
    if(GetIsObjectValid(oRight))
    {
        int nItemTypeR  = GetBaseItemType(oRight);
        if(     nItemTypeR==BASE_ITEM_DAGGER
            ||  nItemTypeR==BASE_ITEM_KUKRI
            ||  nItemTypeR==309// assassin dagger
            ||  nItemTypeR==310// katar
          )
            return TRUE;
    }

    return FALSE;
}

int MoveEquippedItems(object oSource, object oTarget, int copy=FALSE)
{
    // this function is unnecessary, if the source is not a creature
    if(!GetObjectType(oSource)==OBJECT_TYPE_CREATURE)
        return 0;

    object oItem, oCopy; int nCount, nSlot;
    int target_is_creature  = (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE);

    for (nSlot=0; nSlot<14; nSlot++)
    {
        oItem    = GetItemInSlot(nSlot,oSource);
        if( GetIsObjectValid(oItem) && !GetLocalInt(oItem,"COPIED") )
        {
            nCount++;
            oCopy   = CopyItem(oItem, oTarget, TRUE);
            SetLocalInt(oItem,"COPIED",TRUE);
            DelayCommand(0.2,DeleteLocalInt(oItem,"COPIED"));
            SetLocalInt(oCopy,"EQUIPPED_SLOT", nSlot+100);
            if(!copy)
                DestroyObject(oItem, 0.1);
            else
            {
                SetLocalObject(oCopy,"PAIRED",oItem);
                SetLocalObject(oItem,"PAIRED",oCopy);
            }

            if(target_is_creature)
            {
                AssignCommand(oTarget,ActionEquipItem(oCopy,nSlot));
            }

        }
    }

    return nCount;
}

int MoveInventory(object oSource, object oTarget, int copy=FALSE)
{
    object oItem, oCopy; int nCount;

    if(GetObjectType(oSource)==OBJECT_TYPE_CREATURE)
    {
        if(!GetLocalInt(oSource,"GOLD_MOVED"))
        {
            // move gold
            int nGold   = GetGold(oSource);
            if(nGold)
            {
                SetLocalInt(oSource,"GOLD_MOVED",TRUE);
                DelayCommand(0.2, DeleteLocalInt(oSource,"GOLD_MOVED"));
                if(!copy)
                {
                    AssignCommand(oTarget, TakeGoldFromCreature(nGold, oSource,FALSE));
                    DelayCommand(0.1, TakeGoldFromCreature(nGold, oSource,TRUE));
                }
                else
                {
                    if(GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
                        GiveGoldToCreature(oTarget,nGold);
                    else
                        CreateItemOnObject("nw_it_gold001",oTarget,nGold);
                }
                ++nCount;
            }
        }
    }

    // copy containers
    oItem    = GetFirstItemInInventory(oSource);
    while(GetIsObjectValid(oItem))
    {
        if(GetHasInventory(oItem)&&!GetLocalInt(oItem,"COPIED"))
        {
            nCount++;
            // create a copy of the container
            if(GetObjectType(oTarget)!=OBJECT_TYPE_ITEM)
                oCopy   = CreateItemOnObject(GetResRef(oItem), oTarget, 1, GetTag(oItem));
            else
            {
                oCopy   = CreateObject(OBJECT_TYPE_ITEM, GetResRef(oItem), GetLocation(oSource), FALSE, GetTag(oItem));
                AssignCommand(oSource, SpeakString("*"+GetName(oItem)+" falls out*") );
                AssignCommand(oSource, PlaySound("it_genericmedium") );
            }

            SetLocalInt(oItem, "COPIED", TRUE); // mark the original as copied
            DelayCommand(0.1,DeleteLocalInt(oItem,"COPIED"));
            SetName(oCopy, GetName(oItem));
            SetDescription(oCopy, GetDescription(oItem));
            SetIdentified(oCopy, GetIdentified(oItem));
            // copy contents of container
            nCount = MoveInventory(oItem,oCopy,copy);
            if(!copy)
                DestroyObject(oItem, 0.2);
            else
            {
                SetLocalObject(oCopy,"PAIRED",oItem);
                SetLocalObject(oItem,"PAIRED",oCopy);
            }
        }

        oItem   = GetNextItemInInventory(oSource);
    }
    // copy items
    oItem    = GetFirstItemInInventory(oSource);
    while(GetIsObjectValid(oItem))
    {
        if(!GetHasInventory(oItem)&&!GetLocalInt(oItem,"COPIED"))
        {
            nCount++;
            oCopy = CopyItem(oItem, oTarget, TRUE);

            // if the intended target did not receive it, force the current possessor to give it
            object oPossessor = GetItemPossessor(oCopy);
            if( oPossessor!=oTarget )
                AssignCommand(oPossessor, ActionGiveItem(oCopy,oTarget));

            SetLocalInt(oItem, "COPIED", TRUE);
            DelayCommand(0.1,DeleteLocalInt(oItem,"COPIED"));
            if(!copy)
                DestroyObject(oItem, 0.1);
            else
            {
                SetLocalObject(oCopy,"PAIRED",oItem);
                SetLocalObject(oItem,"PAIRED",oCopy);
            }
        }

        oItem   = GetNextItemInInventory(oSource);
    }

    return nCount;
}

void StripInventory(object oTarget, int strip_inventory=TRUE, int strip_gold=TRUE, int strip_equipped=TRUE, int is_npc=FALSE)
{
    DestroyObject(GetItemPossessedBy(oTarget,"x2_it_emptyskin"));

    object oItem;
    if(GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
    {
      if(strip_gold)
      {
        int nGold   = GetGold(oTarget);
        if(nGold)
            TakeGoldFromCreature(nGold, oTarget, TRUE);
      }

      if(strip_equipped)
      {
        int nSlot;
        for (nSlot=0; nSlot<14; nSlot++)
        {
            oItem   = GetItemInSlot(nSlot,oTarget);
            if( GetIsObjectValid(oItem) )
                DestroyObject(oItem);
        }
      }
      if(is_npc)
      {
        int nSlot;
        for (nSlot=14; nSlot<18; nSlot++)
        {
            oItem   = GetItemInSlot(nSlot,oTarget);

            if( GetIsObjectValid(oItem) )
                DestroyObject(oItem);
        }
      }
    }

    if(strip_inventory)
    {
        oItem   = GetFirstItemInInventory(oTarget);
        while(GetIsObjectValid(oItem))
        {
            DestroyObject(oItem);
            oItem   = GetNextItemInInventory(oTarget);
        }
    }
}

void CreatePersistentInventory(string inventory_tag, object source_inventory, string pcid="TBD", int store_in_db=TRUE, int clone_inventory=TRUE)
{
    if(!GetHasInventory(source_inventory))
        return;

    int is_creature = (GetObjectType(source_inventory)==OBJECT_TYPE_CREATURE);

    location lLoc   = GetLocation(GetWaypointByTag(WP_INVENTORY));
    if(pcid=="TBD")
    {
        if( is_creature )
        {
            pcid = GetPCID(source_inventory);
            if(!StringToInt(pcid))
                pcid = "0";
        }
        else
            pcid = "0";
    }

    object oInventory   = CreateObject( OBJECT_TYPE_CREATURE,
                                        "inventory",
                                        lLoc,
                                        FALSE,
                                        inventory_tag
                                      );
    SetLocalString(oInventory,"OWNER_PCID",pcid);
    SetLocalObject(source_inventory,"PERSISTENT_INVENTORY", oInventory);
    SetLocalInt(oInventory,"STORE_IN_DB", store_in_db);

    if(clone_inventory) //------------------ clone the inventory
    {
        if(is_creature)
            MoveEquippedItems(source_inventory, oInventory, TRUE);
        MoveInventory(source_inventory, oInventory, TRUE);
    }
    // let the creature know that it should save itself in the next minute
    //SignalEvent(oInventory, EventUserDefined(EVENT_COMMIT_OBJECT_TO_DB));
}

void RetrievePersistentInventory(string inventory_tag, object target_inventory, string pcid="0")
{
    if(!GetHasInventory(target_inventory))
        return;

    //location lLoc   = GetLocation(GetWaypointByTag(WP_INVENTORY));

    object oInventory   = GetPersistentInventory(inventory_tag, pcid);

    if(GetIsObjectValid(oInventory))
    {
        SetLocalObject(target_inventory,"PERSISTENT_INVENTORY", oInventory);
        // clone the inventory
        MoveEquippedItems(oInventory, target_inventory, TRUE);
        MoveInventory(oInventory, target_inventory, TRUE);

        // this is necessary for tracking when gold is taken from the target
        SetLocalInt(target_inventory, "INVENTORY_GOLD", GetGold(target_inventory));
    }
}

object GetPersistentInventory(string inventory_tag, string pcid="0")
{
    object oInventory   = GetObjectByTag(inventory_tag);
    if(!GetIsObjectValid(oInventory))
    {
        location lLoc= GetLocation(GetWaypointByTag(WP_INVENTORY));
        oInventory   = Data_RetrieveCampaignObject(inventory_tag, lLoc, OBJECT_INVALID, OBJECT_INVALID, pcid);
        if(GetIsObjectValid(oInventory))
        {
            SetLocalInt(oInventory,"STORE_IN_DB",TRUE);
            SetLocalString(oInventory,"OWNER_PCID",pcid);
        }
    }
    SetLocalInt(oInventory, "CANCEL_CLEANUP", TRUE);

    return oInventory;
}

int GetAbilityCheck(object oPC, int nAbility, int nDC, int bVerbose=FALSE)
{
    int bSuccess;
    int nBonus  = GetAbilityModifier(nAbility, oPC);

    int nRoll   = d20();
    if( (nRoll+nBonus)>=nDC)
        bSuccess = TRUE;

    if(bVerbose)
    {
        string sAbility = AbilityToString(nAbility);
        string sResponse, sResult;
        if(bSuccess)
            sResult = "Success";
        else
            sResult = "Failure";

        sResponse   = BLUE+sAbility+CYAN+" check "+BLUE+sResult+CYAN+"! (Roll: "
            +IntToString(nRoll)+" + "+IntToString(nBonus)+" = "+IntToString(nRoll+nBonus)+" DC: "+IntToString(nDC)+")";

        FloatingTextStringOnCreature(sResponse, oPC);
    }

    return bSuccess;
}

string AbilityToString(int nAbility)
{
    string sAbility = "";
    switch(nAbility)
    {
        case ABILITY_CHARISMA: sAbility="cha"; break;
        case ABILITY_CONSTITUTION: sAbility="con"; break;
        case ABILITY_DEXTERITY: sAbility="dex"; break;
        case ABILITY_INTELLIGENCE: sAbility="int"; break;
        case ABILITY_STRENGTH: sAbility="str"; break;
        case ABILITY_WISDOM: sAbility="wis"; break;
    }
    return sAbility;
}

int H_DoSkillCheck(object oPC, int nSkill, int nDC, int bVerbose=FALSE)
{
    // This line ensures the Random function behaves randomly.
    int iRandomize = Random(Random(GetTimeMillisecond()));

    int bSuccess    = FALSE;
    int bUntrained  = StringToInt(Get2DAString("skills", "Untrained", nSkill));
    if(!bUntrained && GetSkillRank(nSkill, oPC, TRUE)<1)
        return FALSE;

    int nBonus  = GetSkillRank(nSkill, oPC);
    int nRoll   = Random(20)+1;

    /*  // need a method for determining take 10 and take 20 rules
    string sChk = "LAST_CHECK_"+IntToString(nSkill)+"_"+IntToString(nDC);
    if(!GetIsInCombat(oPC))
    {
        int nLast   = GetLocalInt(oPC, sChk);
        int nNow    = GetTimeCumulative(TIME_SECONDS);
        SetLocalInt(oPC, sChk, nNow);// record the check
        if(nLast)
        {
            if((nNow-nLast)<=20 && nRoll<10)
                nRoll   = 10; // take 10 if more than one check in 20 seconds
        }
    }
    else
        DeleteLocalInt(oPC, sChk);
    */

    if( (nRoll+nBonus)>=nDC)
        bSuccess = (nRoll+nBonus+1)-nDC;

    if(bVerbose)
    {

        string sResponse, sResult;
        string sSkill   = GetStringByStrRef(StringToInt(Get2DAString("skills","Name",nSkill)));

        if(bSuccess)
            sResult = "Success";
        else
            sResult = "Failure";

        sResponse   = BLUE+sSkill+CYAN+" check "+BLUE+sResult+CYAN+"! (Roll: "
            +IntToString(nRoll)+" + "+IntToString(nBonus)+" = "+IntToString(nRoll+nBonus)+" DC: "+IntToString(nDC)+")";

        FloatingTextStringOnCreature(sResponse, oPC);

    }

    return bSuccess;

}

struct ENCUMBRANCE GetWeightAllowance(object oCreature)
{
    struct ENCUMBRANCE Weight;
    int iLight, iMed, iHigh   = 0;
    int iStr    = GetAbilityScore(oCreature, ABILITY_STRENGTH);
    // Get the encumbrance ranges from the SRD Equipment Basics.
    switch(iStr)
    {
        case 0: iLight = 0; iMed = 0; iHigh = 0; break;
        case 1: iLight = 3; iMed = 6; iHigh = 10; break;
        case 2: iLight = 6; iMed = 13; iHigh = 20; break;
        case 3: iLight = 10; iMed = 20; iHigh = 30; break;
        case 4: iLight = 13; iMed = 26; iHigh = 40; break;
        case 5: iLight = 16; iMed = 33; iHigh = 50; break;
        case 6: iLight = 20; iMed = 40; iHigh = 60; break;
        case 7: iLight = 23; iMed = 46; iHigh = 70; break;
        case 8: iLight = 26; iMed = 53; iHigh = 80; break;
        case 9: iLight = 30; iMed = 60; iHigh = 90; break;
        case 10: iLight = 33; iMed = 66; iHigh = 100; break;
        case 11: iLight = 38; iMed = 76; iHigh = 115; break;
        case 12: iLight = 43; iMed = 86; iHigh = 130; break;
        case 13: iLight = 50; iMed = 10; iHigh = 150; break;
        case 14: iLight = 58; iMed = 116; iHigh = 175; break;
        case 15: iLight = 66; iMed = 133; iHigh = 200; break;
        case 16: iLight = 76; iMed = 153; iHigh = 230; break;
        case 17: iLight = 86; iMed = 173; iHigh = 260; break;
        case 18: iLight = 100; iMed = 200; iHigh = 300; break;
        case 19: iLight = 116; iMed = 233; iHigh = 350; break;
        case 20: iLight = 133; iMed = 266; iHigh = 400; break;
        case 21: iLight = 153; iMed = 306; iHigh = 460; break;
        case 22: iLight = 173; iMed = 346; iHigh = 520; break;
        case 23: iLight = 200; iMed = 400; iHigh = 600; break;
        case 24: iLight = 233; iMed = 466; iHigh = 700; break;
        case 25: iLight = 266; iMed = 533; iHigh = 800; break;
        case 26: iLight = 306; iMed = 613; iHigh = 920; break;
        case 27: iLight = 346; iMed = 693; iHigh = 1040; break;
        case 28: iLight = 400; iMed = 800; iHigh = 1200; break;
        case 29: iLight = 466; iMed = 933; iHigh = 1400; break;
        case 30: iLight = 532; iMed = 1074; iHigh = 1600; break;
        case 31: iLight = 612; iMed = 1224; iHigh = 1840; break;
        case 32: iLight = 692; iMed = 1384; iHigh = 2080; break;
        default:
            // Crap you must be giving your character too much wheaties.
            iLight  = FloatToInt((iStr-28)*4.0*466.0/10.0);
            iMed    = FloatToInt((iStr-28)*4.0*933.0/10.0);
            iHigh   = FloatToInt((iStr-28)*4.0*1400.0/10.0);
        break;
    }
    // convert to lb * 10 to reach parity with get weight
    Weight.low  = iLight*10;
    Weight.med  = iMed*10;
    Weight.high = iHigh*10;

    return Weight;
}

int GetEncumbrancePenalty(object oCreature)
{
    struct ENCUMBRANCE Weight = GetWeightAllowance(oCreature);
    // GetWeight returns the weight in lb * 10 (to handle fractional weights with an int).
    int iEncumbrance = GetWeight(oCreature);
    if (iEncumbrance <= Weight.low)
        return (0);
    else if (iEncumbrance <= Weight.med)
        return (-3);
    else if (iEncumbrance <= Weight.high)
        return (-6);
    else
        return (-50);// Character is immobolized.
}

void ItemIncreaseWeight(int increase_weight, object oItem=OBJECT_SELF)
{
      int pounds = FloatToInt(increase_weight/10.0);
      itemproperty ip;
      while(pounds)
      {
        if(pounds>=750)
        {
            pounds -=750;
            ip = ItemPropertyWeightIncrease(12);
        }
        else if(pounds>=500)
        {
            pounds -=500;
            ip = ItemPropertyWeightIncrease(11);
        }
        else if(pounds>=250)
        {
            pounds -=250;
            ip = ItemPropertyWeightIncrease(10);
        }
        else if(pounds>=100)
        {
            pounds -=100;
            ip = ItemPropertyWeightIncrease(5);
        }
        else if(pounds>=50)
        {
            pounds -=50;
            ip = ItemPropertyWeightIncrease(4);
        }
        else if(pounds>=30)
        {
            pounds -=30;
            ip = ItemPropertyWeightIncrease(3);
        }
        else if(pounds>=15)
        {
            pounds -=15;
            ip = ItemPropertyWeightIncrease(2);
        }
        else if(pounds>=10)
        {
            pounds -=10;
            ip = ItemPropertyWeightIncrease(1);
        }
        else if(pounds>=5)
        {
            pounds -=5;
            ip = ItemPropertyWeightIncrease(0);
        }
        else if(pounds>=4)
        {
            pounds -=4;
            ip = ItemPropertyWeightIncrease(9);
        }
        else if(pounds>=3)
        {
            pounds -=3;
            ip = ItemPropertyWeightIncrease(8);
        }
        else if(pounds>=2)
        {
            pounds -=2;
            ip = ItemPropertyWeightIncrease(7);
        }
        else if(pounds>=1)
        {
            pounds -=1;
            ip = ItemPropertyWeightIncrease(6);
        }
        AddItemProperty(DURATION_TYPE_PERMANENT, ip, oItem);
      }
}

int GetArmorCheckPenalty(object oCreature)
{
    int iPenalty = 0;
    // Check for shield.
    object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
    switch (GetBaseItemType(oItem))
    {
        case BASE_ITEM_SMALLSHIELD:
            iPenalty = -1;
        break;
        case BASE_ITEM_LARGESHIELD:
            iPenalty = -2;
        break;
        case BASE_ITEM_TOWERSHIELD:
            iPenalty = -10;
        break;
        default:
            iPenalty = 0;
        break;
    }

    // Check for Armor.
    oItem   = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
    // Get the ACCHECK Penalty from the 2da
    string sACPenalty   =  Get2DAString("armor", "ACCHECK", GetItemACValue(oItem));
    iPenalty            += StringToInt(sACPenalty);

    return (iPenalty);
}

int GetCanRun(object oPC)
{
    if(     (GetDetectMode(oPC)&&!GetHasFeat(FEAT_KEEN_SENSE,oPC))
        ||  GetStealthMode(oPC)
        ||  (GetEncumbrancePenalty(oPC))
      )
        return FALSE;
    else
        return TRUE;
}

/*
int GetIsGrappled(object oTarget, int nDC)
{
    int bGrappled = FALSE; // is target grappled?

    // target's bonus against bullrush see: GetSizeModifier(object oCreature) file - x0_i0_spells
    int nSizeMod = 0;
    switch (GetCreatureSize(oTarget))
    {
        case CREATURE_SIZE_TINY: nSizeMod = -8;  break;
        case CREATURE_SIZE_SMALL: nSizeMod = -4; break;
        case CREATURE_SIZE_MEDIUM: nSizeMod = 0; break;
        case CREATURE_SIZE_LARGE: nSizeMod = 4;  break;
        case CREATURE_SIZE_HUGE: nSizeMod = 8;   break;
    }

    int nSynergy;   if(GetSkillRank(SKILL_TUMBLE, oTarget, TRUE)>=5){nSynergy=2;}// synergy bonus for tumble skill
    int nACPenalty  = GetArmorCheckPenalty(oTarget);
    int nGrapple    = GetBaseAttackBonus(oTarget)
                        + nSizeMod
                        + GetAbilityModifier(ABILITY_STRENGTH, oTarget);
    int nEscape     = GetSkillRank(SKILL_ESCAPE_ARTIST, oTarget)
                        + nACPenalty
                        - nSizeMod
                        + nSynergy;

    if(nGrapple>nEscape)
    {
        // Grapple vs Grapple
        if( nDC>(d20(1)+nGrapple) )
            bGrappled= TRUE;
    }
    else
    {
        // Grapple vs Escape Artist
        if( !GetIsSkillSuccessful(oTarget, SKILL_ESCAPE_ARTIST, nDC-nACPenalty-nSynergy+nSizeMod) )
            bGrappled= TRUE;
    }

    return bGrappled;
}
*/

int GetFavoredEnemyBonus(object oPC, object oNPC, int nRace=RACIAL_TYPE_INVALID)
{
    int nLevel  = GetLevelByClass(CLASS_TYPE_RANGER ,oPC);
    if(nLevel < 1)
        return 0;

    int nFave   = FloatToInt((nLevel - (nLevel%5))/5.0)+1;
    if(nRace==RACIAL_TYPE_INVALID)
        nRace   = GetRacialType(oNPC);

    int bFeat = FALSE;
    switch (nRace)
    {
        case RACIAL_TYPE_DWARF:
            if(GetHasFeat(261, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_ELF:
            if(GetHasFeat(262, oPC) || GetHasFeat(278, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_GNOME:
            if(GetHasFeat(263, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_HALFLING:
            if(GetHasFeat(264, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_HALFELF:
            if(GetHasFeat(265, oPC) || GetHasFeat(278, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_HALFORC:
            if(GetHasFeat(266, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_HUMAN:
            if(GetHasFeat(267, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_ABERRATION:
            if(GetHasFeat(268, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_ANIMAL:
            if(GetHasFeat(269, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_BEAST:
            if(GetHasFeat(270, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_CONSTRUCT:
            if(GetHasFeat(271, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_DRAGON:
            if(GetHasFeat(272, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_HUMANOID_GOBLINOID:
            if(GetHasFeat(273, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_HUMANOID_MONSTROUS:
            if(GetHasFeat(274, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_HUMANOID_ORC:
            if(GetHasFeat(275, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_HUMANOID_REPTILIAN:
            if(GetHasFeat(276, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_ELEMENTAL:
            if(GetHasFeat(277, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_FEY:
            if(GetHasFeat(278, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_GIANT:
            if(GetHasFeat(279, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_MAGICAL_BEAST:
            if(GetHasFeat(280, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_OUTSIDER:
            if(GetHasFeat(281, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_SHAPECHANGER:
            if(GetHasFeat(284, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_UNDEAD:
            if(GetHasFeat(285, oPC)){bFeat = TRUE;}
        break;
        case RACIAL_TYPE_VERMIN:
            if(GetHasFeat(286, oPC)){bFeat = TRUE;}
        break;
        default:
        bFeat = FALSE;
        break;
    }

    if (bFeat == TRUE)
        return nFave;
    else
        return 0;
}

void RemoveEffectsByType(object target, int effect_type=-1)
{
    // remove effects of type
    effect eEffect = GetFirstEffect(target);
    if(effect_type == -1)
    {
        while(GetIsEffectValid(eEffect))
        {
            RemoveEffect(target,eEffect);

            eEffect = GetNextEffect(target);
        }
    }
    else
    {
        while(GetIsEffectValid(eEffect))
        {
            if( GetEffectType(eEffect) == effect_type )
                RemoveEffect(target,eEffect);

            eEffect = GetNextEffect(target);
        }
    }
}

void SpawnTransferVariables(object oFrom, object oTo)
{
  // LOOT vars
  int nLoot = GetLocalInt(oFrom, "LOOT");
  if(nLoot)
  {
    SetLocalInt(oTo,"LOOT", nLoot);
    int nPer    = GetLocalInt(oFrom,"LOOT_PERIOD");
    if(nPer){SetLocalInt(oTo,"LOOT_PERIOD", nPer);}
    string loottype = GetLocalString(oFrom,"LOOT_TYPE");
    if(loottype!=""){SetLocalString(oTo,"LOOT_TYPE", loottype);}
    int lootmin     = GetLocalInt(oFrom,"LOOT_VALUE_MIN");
    if(lootmin){SetLocalInt(oTo,"LOOT_VALUE_MIN", lootmin);}
    int lootmax     = GetLocalInt(oFrom,"LOOT_VALUE_MAX");
    if(lootmax){SetLocalInt(oTo,"LOOT_VALUE_MAX", lootmax);}
    int lootremain  = GetLocalInt(oFrom,"LOOT_REMAINDER");
    if(lootremain){SetLocalInt(oTo,"LOOT_REMAINDER", lootremain);}
  }

  int nType = GetObjectType(oTo);
  // begin placeables
  if(nType==OBJECT_TYPE_PLACEABLE)
  {
    {// placeable creatures (gargoyle type)
    string sSpawnRef= GetLocalString(oFrom, "PLCSPAWN");
    if(sSpawnRef!="")
        SetLocalString(oTo, "PLCSPAWN", sSpawnRef);
    SetLocalString(oTo, "PLCSPAWN_PLACE", GetResRef(oTo));
    string sSpawnVFX= GetLocalString(oFrom, "PLCSPAWN_VFX");
    if(sSpawnVFX!="")
        SetLocalString(oTo, "PLCSPAWN_VFX", sSpawnVFX);
    int nSpawnVFX   = GetLocalInt(oFrom, "PLCSPAWN_VFX");
    if(nSpawnVFX)
        SetLocalInt(oTo, "PLCSPAWN_VFX", nSpawnVFX);
    int nAOEVFX     = GetLocalInt(oFrom,"PLCSPAWN_VFXPER");
    if(nAOEVFX)
        SetLocalInt(oTo,"PLCSPAWN_VFXPER", nAOEVFX);
    int nSpawnApp   = GetLocalInt(oFrom, "PLCSPAWN_APPEAR");
    if(nSpawnApp)
        SetLocalInt(oTo, "PLCSPAWN_APPEAR", nSpawnApp);
    float fSpawnDist= GetLocalFloat(oFrom, "PLCSPAWN_DISTANCE");
    if(fSpawnDist!=0.0)
        SetLocalFloat(oTo, "PLCSPAWN_DISTANCE", fSpawnDist);
    float fSpawnDela= GetLocalFloat(oFrom, "PLCSPAWN_DELAY");
    if(fSpawnDela!=0.0)
        SetLocalFloat(oTo, "PLCSPAWN_DELAY", fSpawnDela);
    int nHealRate   = GetLocalInt(oFrom, "PLCSPAWN_SECONDS_PER_1HP_HEALED");
    if(nHealRate)
        SetLocalInt(oTo,"PLCSPAWN_SECONDS_PER_1HP_HEALED",nHealRate);
    }// end placeable creatures (gargoyle type)
  }
  // end placeables
  // begin creatures
  else if(nType==OBJECT_TYPE_CREATURE)
  {
    // unique
    if(GetLocalInt(oFrom,"UNIQUE"))
    {
        SetLocalInt(oTo,"UNIQUE",TRUE);
        // may need to do more here..........
    }
    // Assign Group Membership
    string sGroupName   = GetLocalString(oFrom, "GROUP_NAME");
    if(sGroupName!="")
        SetLocalString(oTo, "GROUP_NAME", sGroupName);

    // special cutscene/ghost flag
    if(GetLocalInt(oFrom, "SPAWN_EFFECT_GHOST"))
        SetLocalInt(oTo, "SPAWN_EFFECT_GHOST",1);

    // Assign AI
    if(GetLocalInt(oFrom, "AI_SENTRY"))
        SetLocalInt(oTo, "AI_SENTRY", 1);
    if(GetLocalInt(oFrom, "AI_PACK"))
        SetLocalInt(oTo, "AI_PACK", 1);
    if(GetLocalInt(oFrom, "AI_CIVILIZED"))
        SetLocalInt(oTo, "AI_CIVILIZED", 1);
    if(GetLocalInt(oFrom, "AI_TELEPATHIC"))
        SetLocalInt(oTo, "AI_TELEPATHIC", 1);
    string sFleeDest    = GetLocalString(oFrom,"AI_FLEE_DESTINATION");
    if(sFleeDest!="")
        SetLocalString(oTo, "AI_FLEE_DESTINATION", sFleeDest);
    if(GetLocalInt(oFrom, "AI_COWARD"))
        SetLocalInt(oTo, "AI_COWARD", 1);
    if(GetLocalInt(oFrom, "AI_SIZE_MODIFIER"))
        SetLocalInt(oTo, "AI_SIZE_MODIFIER", GetLocalInt(oFrom, "AI_SIZE_MODIFIER"));
    if(GetLocalInt(oFrom, "AI_NOT_WALKER"))
        SetLocalInt(oTo, "AI_NOT_WALKER", GetLocalInt(oFrom, "AI_NOT_WALKER"));

    // stealth options..............................
    if(GetLocalInt(oFrom, "X2_L_SPAWN_USE_STEALTH"))
        AssignCommand(oTo, SetSpawnInCondition(NW_FLAG_STEALTH));
    else if(GetLocalInt(oFrom, "AI_STEALTHY"))
        SetLocalInt(oTo, "AI_STEALTHY", 1);
    // special combat AI ...........................
    string sSpecialCombatAI   = GetLocalString(oFrom, "X2_SPECIAL_COMBAT_AI_SCRIPT");
    if(sSpecialCombatAI!="")
        SetLocalString(oTo, "X2_SPECIAL_COMBAT_AI_SCRIPT", sSpecialCombatAI);


    int nAppear = GetLocalInt(oFrom,"SET_APPEARANCE");
    if(nAppear>0)
        SetCreatureAppearanceType(oTo, nAppear);

    // equipment variables
    int nEquipType  = GetLocalInt(oFrom,"EQUIPMENT_TYPE");
    if(nEquipType)
        SetLocalInt(oTo, "EQUIPMENT_TYPE", nEquipType);
    int nWeaponCount    = GetLocalInt(oFrom,"EQUIPMENT_WEAPON_COUNT");
    if(nWeaponCount)
        SetLocalInt(oTo, "EQUIPMENT_WEAPON_COUNT", nWeaponCount);
    string sWeapon1     = GetLocalString(oFrom, "EQUIPMENT_WEAPON_1");
    if(sWeapon1!="")
        SetLocalString(oTo, "EQUIPMENT_WEAPON_1", sWeapon1);
    string sWeapon2     = GetLocalString(oFrom, "EQUIPMENT_WEAPON_2");
    if(sWeapon1!="")
        SetLocalString(oTo, "EQUIPMENT_WEAPON_2", sWeapon2);
    string sWeapon3     = GetLocalString(oFrom, "EQUIPMENT_WEAPON_3");
    if(sWeapon1!="")
        SetLocalString(oTo, "EQUIPMENT_WEAPON_3", sWeapon3);
    string sWeapon4     = GetLocalString(oFrom, "EQUIPMENT_WEAPON_4");
    if(sWeapon1!="")
        SetLocalString(oTo, "EQUIPMENT_WEAPON_4", sWeapon4);
    string sWeapon5     = GetLocalString(oFrom, "EQUIPMENT_WEAPON_5");
    if(sWeapon5!="")
        SetLocalString(oTo, "EQUIPMENT_WEAPON_5", sWeapon5);

    // DIALOG VARIABLES
    string sDlgVar = GetLocalString(oFrom, "DIALOG_SCRIPT");
    if(sDlgVar!="")
    {
      SetLocalString(oTo, "DIALOG_SCRIPT",sDlgVar);
      sDlgVar = GetLocalString(oFrom, "DIALOG_GREETING");
      if(sDlgVar!="")
        SetLocalString(oTo, "DIALOG_GREETING",sDlgVar);
      sDlgVar = GetLocalString(oFrom, "DIALOG_INTRODUCTION");
      if(sDlgVar!="")
        SetLocalString(oTo, "DIALOG_INTRODUCTION",sDlgVar);
      sDlgVar = GetLocalString(oFrom, "DIALOG_FAREWELL");
      if(sDlgVar!="")
        SetLocalString(oTo, "DIALOG_FAREWELL",sDlgVar);
      sDlgVar = GetLocalString(oFrom, "DIALOG_WEAPON");
      if(sDlgVar!="")
        SetLocalString(oTo, "DIALOG_WEAPON",sDlgVar);
      sDlgVar = GetLocalString(oFrom, "DIALOG_CONTINUE");
      if(sDlgVar!="")
        SetLocalString(oTo, "DIALOG_CONTINUE",sDlgVar);
      sDlgVar = GetLocalString(oFrom, "DIALOG_BORED");
      if(sDlgVar!="")
        SetLocalString(oTo, "DIALOG_BORED",sDlgVar);
      sDlgVar = GetLocalString(oFrom, "DIALOG_REJECT");
      if(sDlgVar!="")
        SetLocalString(oTo, "DIALOG_REJECT",sDlgVar);
      sDlgVar = GetLocalString(oFrom, "DIALOG_BUSY");
      if(sDlgVar!="")
        SetLocalString(oTo, "DIALOG_BUSY",sDlgVar);
      sDlgVar = GetLocalString(oFrom, "DIALOG_INFO_NONE");
      if(sDlgVar!="")
        SetLocalString(oTo, "DIALOG_INFO_NONE",sDlgVar);
      sDlgVar = GetLocalString(oFrom, "DIALOG_INTIMIDATE_SUCCESS");
      if(sDlgVar!="")
        SetLocalString(oTo, "DIALOG_INTIMIDATE_SUCCESS",sDlgVar);
      sDlgVar = GetLocalString(oFrom, "DIALOG_INTIMIDATE_FAILURE");
      if(sDlgVar!="")
        SetLocalString(oTo, "DIALOG_INTIMIDATE_FAILURE",sDlgVar);


      int nSmallTalk  = GetLocalInt(oFrom,"DIALOG_SMALLTALK_COUNT");
      if(nSmallTalk)
      {
        SetLocalInt(oTo,"DIALOG_SMALLTALK_COUNT",nSmallTalk);
        int nDC = GetLocalInt(oFrom,"DIALOG_SMALLTALK_DC");
        if(nDC)
            SetLocalInt(oTo,"DIALOG_SMALLTALK_DC",nDC);
        string sBored   = GetLocalString(oFrom, "DIALOG_SMALLTALK_BORED");
        if(sBored!="")
            SetLocalString(oTo, "DIALOG_SMALLTALK_BORED",sBored);

        int nIt = 1;
        string sBase    = "DIALOG_SMALLTALK_";
        string sTemp,sVal;
        while(nIt<=nSmallTalk)
        {
            sTemp   = sBase+IntToString(nIt);
            sVal    = GetLocalString(oFrom,sTemp);
            if(sVal!="")
            {
                SetLocalString(oTo,sTemp,sVal);
                SetLocalInt(oTo,sTemp+"_CODE",GetLocalInt(oFrom,sTemp+"_CODE"));
                SetLocalString(oTo,sTemp+"_CODEVAR",GetLocalString(oFrom,sTemp+"_CODEVAR"));
                SetLocalInt(oTo,sTemp+"_ONCE",GetLocalInt(oFrom,sTemp+"_ONCE"));
            }
            ++nIt;
        }
      }
    }
    // MERCHANT VARS
    if(GetLocalInt(oFrom,"MERCH"))
    {
        SetLocalInt(oTo,"MERCH",TRUE);

        if(GetLocalInt(oFrom,"MERCH_STORE1_NOHAGGLE"))
            SetLocalInt(oTo,"MERCH_STORE1_NOHAGGLE",TRUE);

        sDlgVar = GetLocalString(oFrom, "DIALOG_MERCH");
        if(sDlgVar!="")
            SetLocalString(oTo, "DIALOG_MERCH",sDlgVar);
        sDlgVar = GetLocalString(oFrom, "DIALOG_MERCH_DECLINED");
        if(sDlgVar!="")
            SetLocalString(oTo, "DIALOG_MERCH_DECLINED",sDlgVar);
        sDlgVar = GetLocalString(oFrom, "DIALOG_MERCH_SELL");
        if(sDlgVar!="")
            SetLocalString(oTo, "DIALOG_MERCH_SELL",sDlgVar);
        sDlgVar = GetLocalString(oFrom, "DIALOG_MERCH_BUY");
        if(sDlgVar!="")
            SetLocalString(oTo, "DIALOG_MERCH_BUY",sDlgVar);

        string sStore   = GetLocalString(oFrom,"MERCH_STORE1_ID");
        if(sStore!="")
            SetLocalString(oTo,"MERCH_STORE1_ID",sStore);
        else
        {
            string sVarRoot = "MERCH_STORE1_SELL";
            int nIt;
            while(nIt<=1)
            {
                if(nIt)
                    sVarRoot    = "MERCH_STORE1_BUY";

                int nCount      = 1;
                string sCount   = "1";
                string sGood    = GetLocalString(oFrom,sVarRoot+sCount);
                while(sGood!="")
                {
                    SetLocalString(oTo, sVarRoot+sCount, sGood);

                    SetLocalString(oTo, sVarRoot+sCount+"_NAME",
                                    GetLocalString(oFrom, sVarRoot+sCount+"_NAME")
                                  );
                    SetLocalString(oTo, sVarRoot+sCount+"_TAG",
                                    GetLocalString(oFrom, sVarRoot+sCount+"_TAG")
                                  );
                    SetLocalString(oTo, sVarRoot+sCount+"_DESCRIPTION",
                                    GetLocalString(oFrom, sVarRoot+sCount+"_DESCRIPTION")
                                  );
                    SetLocalInt(oTo, sVarRoot+sCount+"_PRICE",
                                    GetLocalInt(oFrom, sVarRoot+sCount+"_PRICE")
                                  );
                    sCount  = IntToString(++nCount);
                    sGood   = GetLocalString(oFrom,sVarRoot+sCount);
                }

                ++nIt;
            }
        }
    }
  } // end creatures
}

void SpawnInitializeName(object npc=OBJECT_SELF)
{
    string name = GetName(npc);

    // a random name or a particular name to set?
    string set_name = GetLocalString(npc,"SET_NAME");
    if(set_name!="")
    {
        if(set_name=="RANDOM")
        {
            ExecuteScript("x3_name_gen",OBJECT_SELF);
            string sName = GetLocalString(OBJECT_SELF,"X3_S_RANDOM_NAME");
            if ( sName == "" )
                sName = RandomName();

            SetName(npc,sName);
        }
        else
        {
            SetName(npc,set_name);
        }

    }
    // strip anything enclosed by parentheses from the name
    else
    {
        int posl    = FindSubString(name,"(");
        int posr    = FindSubString(name,")");
        string temp_name;
        string remainder = name;
        while(posl!=-1)
        {
            if(posr==-1)
            {
                temp_name += GetStringLeft(remainder, posl);
                remainder = "";
                break;
            }
            else if(posr>posl)
            {
                temp_name += GetStringLeft(remainder, posl);
                remainder  = GetStringRight(remainder, GetStringLength(remainder)-(posr+1));
            }
            else
            {
                remainder  = GetStringRight(remainder, GetStringLength(remainder)-(posr+1));
            }


            posl    = FindSubString(remainder,"(");
            posr    = FindSubString(remainder,")",posl);
        }

        if(temp_name!="")
        {
            temp_name += remainder;
            // set the new name
            SetName(npc, temp_name);
        }
    }
}

int GetCreatureLocationState(string sNPCID, object oCreature=OBJECT_INVALID)
{
        return NBDE_GetCampaignInt(CAMPAIGN_NAME,"LOCATION_STATE_"+sNPCID);
}

void SetCreatureLocationState(string sNPCID, int nState, object oCreature=OBJECT_INVALID)
{
        NBDE_SetCampaignInt(CAMPAIGN_NAME,"LOCATION_STATE_"+sNPCID, nState);

        struct DATETIME time;
        time.year   = GetCalendarYear();
        time.month  = GetCalendarMonth();
        time.day    = GetCalendarDay();
        time.hour   = GetTimeHour();
        time.minute = GetTimeMinute();
        time.second = GetTimeSecond();
        string game_time   = ConvertDateTimeToTimeStamp(time);

        NBDE_SetCampaignString(CAMPAIGN_NAME,"LOCATION_STATE_TIMESTAMP_"+sNPCID, game_time);
}

string GetCreatureLocationStateTimeStamp(string sNPCID, object oCreature=OBJECT_INVALID)
{
    return NBDE_GetCampaignString(CAMPAIGN_NAME,"LOCATION_STATE_MINUTE_"+sNPCID);
}

// Returns number of meetings. bPersistent is a flag for checking the database.
int GetMeetings(object oPC, object oNPC)
{
    int nCount;

    if(GetLocalInt(oNPC,"UNIQUE"))
    {
        string sRefMeetings = "NPC_MEET_COUNT_"+GetPCID(oNPC);
        nCount  = NBDE_GetCampaignInt( CAMPAIGN_NAME, sRefMeetings, oPC );
    }
    else
        nCount  = GetLocalInt( oNPC, "NPC_MEET_COUNT_"+GetPCID(oPC));

    return nCount;
}

void CreaturesMeet(object oPC, object oNPC)
{
    int nCount = GetMeetings(oPC, oNPC)+1;

    if(GetLocalInt(oNPC,"UNIQUE"))
    {
        string sRefMeetings = "NPC_MEET_COUNT_"+GetPCID(oNPC);
        NBDE_SetCampaignInt( CAMPAIGN_NAME, sRefMeetings, nCount, oPC );
    }
    else
        SetLocalInt( oNPC, "NPC_MEET_COUNT_"+GetPCID(oPC), nCount);
}

int DetermineConversation(object oCreature, object oSpeaksWith, int bPrivate=FALSE, int bPlayHello=FALSE, int bZoom=TRUE)
{
    int bSuccess;
    if(GetIsDMPossessed(oCreature))
    {
        SendMessageToPC(oSpeaksWith,RED+"Please wait for the DM to respond.");
        SendMessageToPC(oCreature,PALEBLUE+GetName(oSpeaksWith)+DMBLUE+" is trying to speak with "+PALEBLUE+GetName(oCreature)+DMBLUE+".");
        bSuccess=TRUE;
    }
    else
    {
        // look for a Z-dialog script ..........................................
        string sDialog = GetLocalString(oCreature, "DIALOG_SCRIPT");
        if(sDialog!="")
        {
            StartDlg( oSpeaksWith, oCreature, sDialog, bPrivate, bPlayHello, bZoom);
            bSuccess=TRUE;
        }
    }

    if(!bSuccess)
    {
        AssignCommand(oCreature,
                ActionStartConversation(oSpeaksWith, "", bPrivate, bPlayHello)
            );
    }

    return bSuccess;
}

// QUESTS ----------------------------------------------------------------------

// returns TRUE if pc has quest named quest_name [File: _inc_util]
int GetPCHasQuest(object pc, string quest_name)
{
    return (StringToInt( Data_GetCampaignString("QUEST_"+quest_name+"_HAS",pc,GetPCID(pc)) )==TRUE);
}

// PC has the quest of quest_name if has_quest is TRUE [File: _inc_util]
void SetPCHasQuest(object pc, string quest_name, int has_quest=TRUE)
{
    Data_SetCampaignString("QUEST_"+quest_name+"_HAS", IntToString(has_quest), pc, GetPCID(pc));
}

// returns TRUE if pc has completed the quest named quest_name [File: _inc_util]
int GetPCCompletedQuest(object pc, string quest_name)
{
    return (StringToInt( Data_GetCampaignString("QUEST_"+quest_name+"_COMPLETE",pc,GetPCID(pc)) )==TRUE);
}

// PC has completed the quest of quest_name if completed_quest is TRUE [File: _inc_util]
void SetPCCompletedQuest(object pc, string quest_name, int completed_quest=TRUE)
{
    Data_SetCampaignString("QUEST_"+quest_name+"_COMPLETE", IntToString(completed_quest), pc, GetPCID(pc));
}

// returns pc's progress in the quest named quest_name [File: _inc_util]
int GetPCQuestState(object pc, string quest_name)
{
    return StringToInt( Data_GetCampaignString("QUEST_"+quest_name+"_STATE",pc,GetPCID(pc)) );
}

// set the pc's progress to quest_state in the quest named quest_name [File: _inc_util]
void SetPCQuestState(object pc, string quest_name, int quest_state)
{
    Data_SetCampaignString("QUEST_"+quest_name+"_STATE", IntToString(quest_state), pc, GetPCID(pc));
}


// CORPSES ---------------------------------------------------------------------

struct CORPSE TransferCorpseData(object source, object target)
{
    struct CORPSE corpse;
    int type  = GetObjectType(source);
    if(type==OBJECT_TYPE_CREATURE)
    {
        corpse.type         = CreatureGetCorpseType(source);
        corpse.pcid         = GetPCID(source);
        corpse.name         = GetName(source);
        corpse.description  = GetDescription(source);
        corpse.body_bones;  // this is set later
        corpse.resref       = GetResRef(source);
        corpse.race         = GetRacialType(source);
        corpse.gender       = GetGender(source);
        corpse.appearance   = GetAppearanceType(source);
        if(     corpse.appearance<=6
            ||( corpse.appearance==474||corpse.appearance==475)
            ||(corpse.appearance>=1281&&corpse.appearance<=1296)
          )
        {
            corpse.phenotype= GetPhenoType(source);
            int nPart;
            for (nPart=0; nPart<=20; nPart++)
            {
                SetLocalInt(    target,
                                "CORPSE_PART"+IntToString(nPart),
                                GetCreatureBodyPart(nPart,source)
                       );
            }
        }
        int nColor;
        for (nColor=0; nColor<=3; nColor++)
        {
            SetLocalInt(    target,
                            "CORPSE_COLOR"+IntToString(nColor),
                            GetColor(source,nColor)
                       );
        }
        corpse.wings        = GetCreatureWingType(source);
        corpse.tail         = GetCreatureTailType(source);
    }
    else
    {
        corpse.type         = GetLocalInt(source,   "CORPSE");
        corpse.pcid         = GetLocalString(source,"CORPSE_PCID");
        corpse.name         = GetLocalString(source,"CORPSE_NAME");
        corpse.description  = GetLocalString(source,"CORPSE_DESCRIPTION");
        corpse.body_bones   = GetLocalString(source,"CORPSE_BONES");
        corpse.resref       = GetLocalString(source,"CORPSE_BODY_RESREF");
        corpse.race         = GetLocalInt(source,   "CORPSE_RACE");
        corpse.gender       = GetLocalInt(source,   "CORPSE_GENDER");
        corpse.appearance   = GetLocalInt(source,   "CORPSE_APPEARANCE");
        if(     corpse.appearance<=6
            ||( corpse.appearance==474||corpse.appearance==475)
            ||(corpse.appearance>=1281&&corpse.appearance<=1296)
          )
        {
            corpse.phenotype= GetPhenoType(source);
            int nPart;
            for (nPart=0; nPart<=20; nPart++)
            {
                SetLocalInt(    target,
                                "CORPSE_PART"+IntToString(nPart),
                                GetCreatureBodyPart(nPart,source)
                       );
            }
        }
        int nColor;
        for (nColor=0; nColor<=3; nColor++)
        {
            SetLocalInt(    target,
                            "CORPSE_COLOR"+IntToString(nColor),
                            GetColor(source,nColor)
                       );
        }
        corpse.wings        = GetLocalInt(source, "CORPSE_WINGS");
        corpse.tail         = GetLocalInt(source, "CORPSE_TAIL");
    }

    // store struct values on target
    SetLocalInt(target,     "CORPSE",               corpse.type);
    SetLocalString(target,  "CORPSE_PCID",          corpse.pcid );
    SetLocalString(target,  "CORPSE_NAME",          corpse.name );
    SetLocalString(target,  "CORPSE_DESCRIPTION",   corpse.description);
    SetLocalString(target,  "CORPSE_NODE_RESREF",   GetLocalString(source,"CORPSE_NODE_RESREF"));
    SetLocalString(target,  "CORPSE_BONES",         corpse.body_bones);
    SetLocalString(target,  "CORPSE_BODY_RESREF",   corpse.resref);
    SetLocalInt(target,     "CORPSE_RACE",          corpse.race );
    SetLocalInt(target,     "CORPSE_GENDER",        corpse.gender);
    SetLocalInt(target,     "CORPSE_APPEARANCE",    corpse.appearance);

    // these are only local variables since we don't reference them any other way
    SetLocalInt(target,"CORPSE_DECAY", GetLocalInt(source,"CORPSE_DECAY") );
    SetLocalFloat(target,"CorpseDecay", GetLocalFloat(source,"CorpseDecay") );
    // skinning variables
    SetLocalString(target,"CORPSE_BONES",GetLocalString(source,"CORPSE_BONES"));;
    if( corpse.type & CORPSE_TYPE_SKINNABLE )
    {
        // probably need a separate function for transferring skin and meat variables
        SetLocalString(target,"SKIN_TYPE",GetLocalString(source, "SKIN_TYPE"));
        SetLocalInt(target,"SKINNED",GetLocalInt(source, "SKINNED"));
        SetLocalString(target,"SKIN_NAME",GetLocalString(source, "SKIN_NAME"));
        SetLocalString(target,"SKIN_TAG",GetLocalString(source, "SKIN_TAG"));
        //SetLocalInt(target,"SKIN_DAMAGE",GetLocalInt(source, "SKIN_DAMAGE"));
        //SetLocalInt(target,"SKIN_MAXHP",GetLocalInt(source, "SKIN_MAXHP"));
        SetLocalInt(target,"SKIN_MEAT",GetLocalInt(source, "SKIN_MEAT"));
        SetLocalString(target,"SKIN_MEAT_TAG",GetLocalString(source, "SKIN_MEAT_TAG"));
        SetLocalString(target,"SKIN_MEAT_NAME",GetLocalString(source, "SKIN_MEAT_NAME"));
    }

    return corpse;
}

void CorpsesOnLoad()
{
    location location_corpse_store  = GetLocation(GetWaypointByTag("wp_corpse_store"));
    // the corpse store is a persistent storage of all persistent corpses
    object corpse_store = Data_RetrieveCampaignObject("corpse_storage", location_corpse_store, OBJECT_INVALID, OBJECT_INVALID, "0", OBJECT_TYPE_STORE);
    WriteTimestampedLogEntry("Retrieving store("+GetName(corpse_store)+")");
    if(!GetIsObjectValid(corpse_store))
    {
           corpse_store = CreateObject(OBJECT_TYPE_STORE, "store_empty", location_corpse_store, FALSE, "corpse_storage");
        WriteTimestampedLogEntry("Made a store("+GetName(corpse_store)+")");
    }
    // use the corpse store's inventory as a list of all the active corpses
    // iterate over them
    // any persistent corpses which are not
    location where; string pcid;
    object corpse_node;
    object corpse       = GetFirstItemInInventory(corpse_store);
    while(GetIsObjectValid(corpse))
    {
        // is this a persistent corpse?
        if(GetLocalInt(corpse,"CORPSE")&CORPSE_TYPE_PERSISTENT)
        {
            pcid    = GetLocalString(corpse,"CORPSE_PCID");
            // is anyone holding this corpse? (is it in anyone's inventory?)
            if( !StringToInt(Data_GetCampaignString("corpse_holder",OBJECT_INVALID,pcid)) )
            {
                // since no one is holding the corpse, create it at its last known location
                where       = Data_GetLocation("CORPSE",OBJECT_INVALID,pcid);
                if( GetIsObjectValid(GetAreaFromLocation(where)) )
                {
                    corpse_node = CreateCorpseNodeFromBody(corpse, where);
                    DelayCommand(0.2, CreateCorpseFromCorpseNode( corpse_node, where) );
                }
            }
        }
        else
        {
            // if its not a corpse or not a persistent one... destroy it
            DestroyObject(corpse);
        }

        corpse          = GetNextItemInInventory(corpse_store);
    }
}

int CreatureGetCorpseType(object oCreature)
{
    int corpse_type = 1; // this is a corpse
    int racial_type = GetRacialType(oCreature);

    int bPC         = FALSE;
    int bPersist    = FALSE;
    int bRaise      = TRUE;
    int bAnimate    = TRUE;
    int bSkin       = TRUE;

    if(     racial_type==RACIAL_TYPE_ANIMAL
        ||  racial_type==RACIAL_TYPE_BEAST
        ||  racial_type==RACIAL_TYPE_MAGICAL_BEAST
        ||  racial_type==RACIAL_TYPE_DRAGON
        ||  racial_type==RACIAL_TYPE_GIANT
      )
    {
        bAnimate    = FALSE;
    }
    else if(racial_type==RACIAL_TYPE_UNDEAD
        ||  racial_type==RACIAL_TYPE_OUTSIDER
        ||  racial_type==RACIAL_TYPE_OOZE
        ||  racial_type==RACIAL_TYPE_CONSTRUCT
        ||  racial_type==RACIAL_TYPE_ELEMENTAL
        ||  racial_type==RACIAL_TYPE_FEY
        ||  racial_type==RACIAL_TYPE_VERMIN
        ||  racial_type==RACIAL_TYPE_ABERRATION
      )
    {
        bRaise      = FALSE;
        bAnimate    = FALSE;
        bSkin       = FALSE;
    }

    if(GetIsPC(oCreature))
    {
        bPC         = TRUE;
        bPersist    = TRUE;
        bRaise      = TRUE;
    }
    else if(GetLocalInt(oCreature, "UNIQUE"))
    {
        bPersist    = TRUE;
        bRaise      = TRUE;
    }

    if(bPC)
        corpse_type += CORPSE_TYPE_PC;          // special treatment when respawned
    if(bPersist)
        corpse_type += CORPSE_TYPE_PERSISTENT;  // saved to DB and tracked
    if(bRaise)
        corpse_type += CORPSE_TYPE_RAISEABLE;   // can be raised or resurrected
    if(bAnimate)
        corpse_type += CORPSE_TYPE_ANIMATEABLE; // can be made into undead
    if(bSkin)
        corpse_type += CORPSE_TYPE_SKINNABLE;   // can be skinned

    return corpse_type;
}

void CorpseItemDropped(object oLoser, object oCorpseItem, location lLoc)
{
    object oCorpseNode;
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectCutsceneGhost(),oLoser,3.0);
    // create a creature to test the location
    object oTmp = CreateObject(OBJECT_TYPE_CREATURE,"invisible",lLoc);
    lLoc    = GetLocation(oTmp);
    DestroyObject(oTmp);

    // tweak the facing
    float fDir  = GetFacing(oLoser)-(90.0+IntToFloat(Random(13)) );
    if(fDir<0.0)
        fDir += 2.0*fDir;
    lLoc    = Location(GetAreaFromLocation(lLoc),GetPositionFromLocation(lLoc),fDir);

    string pcid         = GetLocalString(oCorpseItem,"CORPSE_PCID");
    object oInventory   = GetPersistentInventory("INV_CORPSE_"+pcid, pcid);
    int nItemsMoved     = MoveInventory(oCorpseItem,oInventory);
    if(nItemsMoved)
        // let the mule know that it should save itself
        //SignalEvent(oInventory, EventUserDefined(EVENT_COMMIT_OBJECT_TO_DB));

    // create corpse
    oCorpseNode = CreateCorpseNodeFromBody(oCorpseItem, lLoc);
    DelayCommand(0.2, CreateCorpseFromCorpseNode( oCorpseNode, lLoc) );

    DestroyObject(oCorpseItem,0.2);
}

object CreateCorpseNodeFromBody(object oBody, location lDeath, string node_ref="invis_corpse_obj")
{
    int body_type  = GetObjectType(oBody);
    // vars we need now
    string corpse_tag, resref;
    if(body_type==OBJECT_TYPE_CREATURE)
    {
        corpse_tag  = "CORPSE_"+GetPCID(oBody);
        resref      = node_ref;
        SetLocalString(oBody,"CORPSE_NODE_RESREF", node_ref);
    }
    else
    {
        corpse_tag  = "CORPSE_"+GetLocalString(oBody, "CORPSE_PCID");
        resref      = GetLocalString(oBody, "CORPSE_NODE_RESREF");
    }

    // create the interactive placeable "corpse node" for the corpse
    object oCorpseNode      = CreateObject( OBJECT_TYPE_PLACEABLE, resref, lDeath, FALSE, corpse_tag );

    struct CORPSE corpse    = TransferCorpseData(oBody, oCorpseNode);

    // update persistent corpse data
    if(corpse.type & CORPSE_TYPE_PERSISTENT)
    {
        // local variables saved
        object corpse_persistent= GetObjectByTag(corpse_tag+"_PERSISTENT");
        if(!GetIsObjectValid(corpse_persistent))
        {
            object corpse_store = GetObjectByTag("corpse_storage");
            corpse_persistent   = CreateItemOnObject("corpse_pc",corpse_store,1,corpse_tag+"_PERSISTENT");
            SetName(corpse_persistent, corpse.name);
            SetDescription(corpse_persistent, corpse.description);
        }
        TransferCorpseData(oCorpseNode, corpse_persistent);

        // store the location for the corpse
        Data_SetLocation("CORPSE", lDeath, OBJECT_INVALID, corpse.pcid);
        // no one is holding this corpse in inventory
        Data_SetCampaignString("corpse_holder", "0", OBJECT_INVALID, corpse.pcid);
    }

    // name
    SetName(oCorpseNode,corpse.name);
    // description
    SetDescription(oCorpseNode,corpse.description);

    SetLocalInt(oCorpseNode,"SUPPRESS_DISTURB",TRUE);   // disturb event unnecessary during init
    DelayCommand(0.1, RetrievePersistentInventory("INV_CORPSE_"+corpse.pcid, oCorpseNode, corpse.pcid));
    DelayCommand(0.2, DeleteLocalInt(oCorpseNode,"SUPPRESS_DISTURB") );     // turn disturb event back on

    return oCorpseNode;
}

object CreateCorpseItemFromCorpseNode(object oCorpseNode, object oTaker)
{
    string corpse_item_resref   = "corpse_pc";
    string corpse_item_tag      = "CORPSE_"+GetLocalString(oCorpseNode,"CORPSE_PCID");

    object oCorpseItem          = CreateItemOnObject(corpse_item_resref,oTaker,1,corpse_item_tag);
    struct CORPSE corpse        = TransferCorpseData(oCorpseNode, oCorpseItem);

    SetName(oCorpseItem, corpse.name);
    SetDescription(oCorpseItem, corpse.description);

    // update persistent corpse data
    if(corpse.type & CORPSE_TYPE_PERSISTENT)
    {
        // local variables saved
        object corpse_persistent= GetObjectByTag(corpse_item_tag+"_PERSISTENT");
        if(!GetIsObjectValid(corpse_persistent))
        {
            object corpse_store = GetObjectByTag("corpse_storage");
            corpse_persistent   = CreateItemOnObject("corpse_pc",corpse_store,1,corpse_item_tag+"_PERSISTENT");
            SetName(corpse_persistent, corpse.name);
            SetDescription(corpse_persistent, corpse.description);
        }
        TransferCorpseData(oCorpseItem, corpse_persistent);

        // store the location for the corpse
        Data_SetLocation("CORPSE", GetLocation(oTaker), OBJECT_INVALID, corpse.pcid);
        // no one is holding this corpse in inventory
        Data_SetCampaignString("corpse_holder", GetPCID(oTaker), OBJECT_INVALID, corpse.pcid);
    }

    // determine how much the corpse should weigh
    int nWeight;
    int nSize   = StringToInt(Get2DAString("appearance","SIZECATEGORY",corpse.appearance));
    switch(nSize)
    {
        case CREATURE_SIZE_TINY:    nWeight=10; break;
        case CREATURE_SIZE_SMALL:   nWeight=500; break;
        case CREATURE_SIZE_MEDIUM:  nWeight=1400; break;
        case CREATURE_SIZE_LARGE:   nWeight=4000; break;
        case CREATURE_SIZE_HUGE:    nWeight=15000; break;
        default:                    nWeight=1350; break;
    }

    if(corpse.phenotype==2)
        nWeight += nWeight;
    if(corpse.body_bones!="")
        nWeight -= FloatToInt(nWeight*(0.90));

    // get equipment weight of equipment
    object oItem    = GetFirstItemInInventory(oCorpseNode);
    while(GetIsObjectValid(oItem))
    {
        nWeight += GetWeight(oItem);
        oItem   = GetNextItemInInventory(oCorpseNode);
    }

    // adjust the weight of the corpseitem
    ItemIncreaseWeight(nWeight, oCorpseItem);

    return oCorpseItem;
}

object GetPrettyBodyFromCorpse(object corpse_object, string corpse_resref, location lBody, string corpse_tag="")
{
    object oBody = CreateObject( OBJECT_TYPE_CREATURE, corpse_resref, lBody, FALSE, corpse_tag);

    // name
    SetName(oBody,GetLocalString(corpse_object,"CORPSE_NAME"));
    SetDescription(oBody,GetLocalString(corpse_object,"CORPSE_DESCRIPTION"));

    // make the corpse look like the PC
    // appearance
    int corpse_appearance = GetLocalInt(corpse_object,"CORPSE_APPEARANCE");
    SetCreatureAppearanceType(oBody, corpse_appearance);
    if(     corpse_appearance<=6
        ||( corpse_appearance==474||corpse_appearance==475)
        ||(corpse_appearance>=1281&&corpse_appearance<=1296)
      )
    {
        // pheno
        SetPhenoType(GetLocalInt(corpse_object,"CORPSE_PHENOTYPE"),oBody);
        // parts
        int nPart;
        for (nPart=0; nPart<=20; nPart++)
        {
            SetCreatureBodyPart(    nPart,
                                    GetLocalInt(corpse_object,"CORPSE_PART"+IntToString(nPart)),
                                    oBody
                               );
        }
    }
    // color
    int nColor;
    for (nColor=0; nColor<=3; nColor++)
    {
        SetColor( oBody, nColor, GetLocalInt(corpse_object,"CORPSE_COLOR"+IntToString(nColor)) );
    }
    // wings
    SetCreatureWingType(GetLocalInt(corpse_object,"CORPSE_WINGS"),oBody);
    // tail
    SetCreatureWingType(GetLocalInt(corpse_object,"CORPSE_TAIL"),oBody);

    return oBody;
}

void CreateCorpseFromCorpseNode(object oCorpseNode, location lDeath, int kill=TRUE, int dress=TRUE)
{
    object oCorpse;
    string corpse_tag           = "CORPSE_BODY_PCID_" + GetLocalString(oCorpseNode,"CORPSE_PCID");
    string corpse_bones         = GetLocalString(oCorpseNode,"CORPSE_BONES");
  if(corpse_bones=="")
  {
    int corpse_gender           = GetLocalInt   (oCorpseNode,"CORPSE_GENDER");

    // dif resref for each gender
    string sRefCorpse   = "corpse_pc";
    if(corpse_gender==GENDER_FEMALE)
        sRefCorpse      = "corpse_pc_f";

    // create the corpse creature
    oCorpse = GetPrettyBodyFromCorpse(oCorpseNode, sRefCorpse, lDeath, corpse_tag);

    SetLootable(oCorpse,FALSE);
    AssignCommand(oCorpse, SetIsDestroyable(FALSE,FALSE,FALSE));

    if(dress)
        // dress/equip the corpse with some of the items
        CorpseDress(oCorpse, oCorpseNode);

    if(kill)
        DelayCommand(0.2,
                     AssignCommand(  GetArea(oCorpseNode),
                                     ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDeath(),oCorpse)
                                  )
                    );
  }
  else
  {
    oCorpse = CreateObject( OBJECT_TYPE_PLACEABLE, corpse_bones, lDeath, FALSE, corpse_tag);
  }

    // body and corpse node point to one another
    SetLocalObject(oCorpseNode, "CORPSE_BODY", oCorpse);
    SetLocalObject(oCorpse, "CORPSE_NODE", oCorpseNode);

    if(GetLocalInt(oCorpseNode,"CORPSE_DECAY"))
    {
        float fCorpseDecay  = GetLocalFloat(oCorpseNode,"CorpseDecay");
        SetLocalFloat(oCorpse,"CorpseDecay",fCorpseDecay);
        // Set Corpse to Decay
        DelayCommand(fCorpseDecay + 0.1, SetLocalInt(oCorpse, "DecayTimerExpired", TRUE));
        DelayCommand(fCorpseDecay + 0.3, ExecuteScript("spawn_corpse_dcy", oCorpse));
    }
}

void CorpseDress(object oCorpse, object oCorpseNode, int corpse_equip=TRUE)
{
    object oDressing; int nSlot;

    object oLoot    = GetFirstItemInInventory(oCorpseNode);
    while(GetIsObjectValid(oLoot))
    {
        nSlot   = GetLocalInt(oLoot,"EQUIPPED_SLOT");
        if(nSlot)
        {
            nSlot -= 100;
            if(     nSlot<=6    // head, chest (boots, arms), lhand, rhand, cloak
                &&  nSlot!=2 && nSlot!=3    // not boots or arms
              )
            {
                if(corpse_equip)
                {
                    oDressing  = CopyItem(oLoot, oCorpse);
                    AssignCommand(oCorpse, ActionEquipItem(oDressing, nSlot) );
                }
                else
                {
                    oDressing   = GetItemInSlot(nSlot,oCorpse);
                }

                SetLocalObject(oLoot,"CORPSE_DRESSING", oDressing);
            }
            else if(!corpse_equip)
            {
                DestroyObject(GetItemInSlot(nSlot,oCorpse));
            }
        }
        oLoot   = GetNextItemInInventory(oCorpseNode);
    }
}

void PCLoginCorpseCheck(object oPC=OBJECT_SELF)
{
    // check DB for notification of corpses to delete from inventory

}

int SpellRaiseCorpse(object oCorpse, int spell_id, location loc_raise, object spell_caster=OBJECT_INVALID)
{
    int success = FALSE;
    // if this object is a CORPSE of CORPSE_TYPE_RAISEABLE, we will proceed
    // else send a failure response
    int corpse_type = GetLocalInt(oCorpse,"CORPSE");
    if( corpse_type & CORPSE_TYPE_RAISEABLE )
    {
        string pcid =  GetLocalString(oCorpse, "CORPSE_PCID");
        // if this PC is no longer dead... exit, or if PC is permadead, Exit faster.
        if(     corpse_type & CORPSE_TYPE_PERSISTENT
            &&  !StringToInt( GetPCDeathStatus(pcid))
            &&  GetLocalInt(GetPCByPCID(pcid),"PermaDeath")==TRUE
          )
        {
            // destroy persistent copy
            object corpse_persistent    = GetObjectByTag("CORPSE_"+pcid+"_PERSISTENT");
            DestroyObject(corpse_persistent);

            // wipe connection of corpse to PC... it can no longer be used to raise them (if they die again)
            SetLocalInt(oCorpse,"CORPSE_DECAY",TRUE); // it will decay, when next moved
            SetLocalFloat(oCorpse,"CorpseDecay",60.0);// it will decay, in 60 seconds
            SetLocalString(oCorpse,"CORPSE_PCID",ObjectToString(oCorpse)); // connected to nothing but itself
            SetLocalInt(oCorpse,"CORPSE", corpse_type - CORPSE_TYPE_RAISEABLE); // can no longer be raised
            SetLocalInt(oCorpse,"CORPSE", corpse_type - CORPSE_TYPE_PERSISTENT); // no longer tied to persistent inventory
            if(GetObjectType(oCorpse)==OBJECT_TYPE_PLACEABLE)
            {
                object oBody    = GetLocalObject(oCorpse, "CORPSE_BODY");
                StripInventory(oCorpse,TRUE,FALSE,FALSE); // inventory stripped
                DelayCommand(59.0, SetLocalInt(oBody, "DecayTimerExpired", TRUE));
                DelayCommand(60.0, ExecuteScript("spawn_corpse_dcy", oBody));
            }
            if(GetLocalInt(GetPCByPCID(pcid),"PermaDeath")==TRUE)
            {
                SendMessageToPC(spell_caster, "The soul of this individual has grown too weak to return. There is nothing to be done short of a miracle.");
            }
            return FALSE;
        }

        // LOCATION ------
        if(!GetIsObjectValid(GetAreaFromLocation(loc_raise)))
        {
            loc_raise   = GetLocation(oCorpse);
            if(!GetIsObjectValid(GetAreaFromLocation(loc_raise)))
            {
              loc_raise = GetLocation(spell_caster);
              if(!GetIsObjectValid(GetAreaFromLocation(loc_raise)))
                return FALSE; // for now consider this a failure
                              // potential for getting a backup location from DB
            }
        }
        // bless the location by trying to put a creature there
        object oTmp = CreateObject(OBJECT_TYPE_CREATURE,"invisible",loc_raise);
        loc_raise   = GetLocation(oTmp);
        DestroyObject(oTmp);

        // TYPE OF RAISE -- and POSIBLE FAILURE --------
        int nVFX; int nHeal; string status;
        // next we need to determine if this is still going to proceed
        // and what effects we apply to the target
        if(GetIsDM(spell_caster))
        {
            status  = "RESURRECTED";
            nVFX    = VFX_IMP_RAISE_DEAD;
            success = TRUE;
        }
        else if(spell_id==SPELL_RAISE_DEAD)
        {
            status  = "RAISED";
            nVFX    = VFX_IMP_RAISE_DEAD;
            success = TRUE;
        }
        else if(spell_id==SPELL_RESURRECTION)
        {
            status  = "RESURRECTED";
            nVFX    = VFX_IMP_RAISE_DEAD;
            success = TRUE;
        }

        // SO FAR SO GOOD SO PROCEED -------------------
        if(success)
        {
            object corpse_raised;
            // gather who we are raising
            if( corpse_type & CORPSE_TYPE_PERSISTENT )
            {
                // PC ------
                if(corpse_type & CORPSE_TYPE_PC)
                {
                    corpse_raised   = GetPCByPCID(pcid);
                    if(GetIsObjectValid(corpse_raised))
                    {
                        // set PC as no longer dead
                        ClearPCDeath(pcid);
                        // PC is online now
                        PrepPCForRespawn(corpse_raised,loc_raise);
                    }
                    else
                    {
                        // pc is not online
                        // set PC to be raised or resurrected when they log in
                        ClearPCDeath(pcid, status);
                    }
                    // location to reappear (just in case the PC crashes)
                    Data_SetLocation("LAST", loc_raise, corpse_raised, pcid);
                }
                // NPC ------
                else
                {
                    // retrieve from DB
                    // set creature as no longer dead
                    ClearPCDeath(pcid);

                    corpse_raised= Data_RetrieveNPC(pcid, loc_raise);
                }
            }
            else
            {
                // bog standard non persistent creature. lets just raise it.
                corpse_raised = GetPrettyBodyFromCorpse( oCorpse, GetLocalString(oCorpse, "CORPSE_BODY_RESREF"), loc_raise );
            }

            // generate the VFX at the location regardless
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nVFX), loc_raise);

            // is the raised going to make an appearance now?
            if(GetIsObjectValid(corpse_raised))
            {
                // this function will iterate until corpse_raised is in the same area as the loc_raise
                AssignCommand(corpse_raised, CharacterRaiseCompletes(loc_raise, status) );
            }
            // PC is not present... so we put on a show, then fade out the automaton
            else
            {


                // this is a doppelganger of a PC
                string sRef   = "corpse_pc";
                if(GetLocalInt(oCorpse,"CORPSE_GENDER")==GENDER_FEMALE)
                    sRef   = "corpse_pc_f";
                corpse_raised = GetPrettyBodyFromCorpse( oCorpse, sRef, loc_raise );
                AssignCommand(corpse_raised, SpeakString("*Player is not online right now, but "+GetName(corpse_raised)+" is now alive.*") );
                AssignCommand(corpse_raised, ActionPlayAnimation(ANIMATION_FIREFORGET_BOW) );
                DestroyObject(corpse_raised, 6.0);
            }

            // Destroy the corpse ---------------------------
            if(GetObjectType(oCorpse)==OBJECT_TYPE_PLACEABLE)
            {
                // corpse node
                SetLocalInt(oCorpse,"CORPSE_DECAY",TRUE);
                object oBody    = GetLocalObject(oCorpse, "CORPSE_BODY");
                StripInventory(oCorpse,TRUE,FALSE,FALSE); // inventory stripped
                DelayCommand(0.1, SetLocalInt(oBody, "DecayTimerExpired", TRUE));
                DelayCommand(1.0, ExecuteScript("spawn_corpse_dcy", oBody));
            }
            else
            {
                // corpse item
                DestroyObject(oCorpse,0.1);
            }
        }
    }

    return success;
}

void PrepPCForRespawn(object oPC, location loc_raise)
{
    if(GetIsDead(oPC))
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oPC);

    // remove all effects -----------
    effect eLoop=GetFirstEffect(oPC);
    while (GetIsEffectValid(eLoop))
    {
        RemoveEffect(oPC, eLoop);
        eLoop=GetNextEffect(oPC);
    }
    // restore personal VFX
    //RestorePersonalVFX(oPC);
    // ------------------------------
    // assure that we can make shit happen
    SetCommandable(TRUE,oPC);
    AssignCommand(oPC,ClearAllActions(TRUE));
    AssignCommand(oPC,ActionJumpToLocation(loc_raise));
}

void CharacterRaiseCompletes(location loc_raise, string status)
{
    // have we arrived?
    object area = GetArea(OBJECT_SELF);
    if(area==GetAreaFromLocation(loc_raise))
    {
        string pcid = GetPCID(OBJECT_SELF);
        FadeFromBlack(OBJECT_SELF);
        SetCommandable(TRUE);
        SetLocalInt(OBJECT_SELF, "IS_DEAD", TRUE);
        object character = OBJECT_SELF;
        DelayCommand(0.6, AssignCommand(area, ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDeath(),character) ) );
        if(status=="RAISED" || status=="RESURRECTED")
        {
            DelayCommand(1.9, ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),OBJECT_SELF) );
            DelayCommand(1.9, ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_RAISE_DEAD),loc_raise) );
            DelayCommand(2.0, SendMessageToPC(OBJECT_SELF, DMBLUE+"You have been raised from the dead!") );
        }
        if(status=="RESURRECTED")
        {
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints()+10),OBJECT_SELF) );
        }

        object oInventory   = GetPersistentInventory("INV_CORPSE_"+pcid,pcid);
        MoveEquippedItems(oInventory,OBJECT_SELF);
        DelayCommand(0.1, SetLocalInt(oInventory,"count",MoveInventory(oInventory,OBJECT_SELF)) );
        SetLocalInt(oInventory,"PERMANENT_DELETION", TRUE);
        //DelayCommand(0.2, SignalEvent(oInventory, EventUserDefined(EVENT_COMMIT_OBJECT_TO_DB)) );

        DelayCommand(2.1, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 6.0) );
        DelayCommand(1.9, DestroyCorpse(pcid, TRUE) );

        DelayCommand(2.0, DeleteLocalInt(OBJECT_SELF, "IS_DEAD"));
    }
    // reiterate until PC arrives at destination
    else
    {
        SetCommandable(FALSE);
        DelayCommand(0.5, CharacterRaiseCompletes(loc_raise, status));
    }

}

void DestroyCorpse(string pcid, int strip_corpse=FALSE)
{
    object oInventory   = GetPersistentInventory("INV_CORPSE_"+pcid, pcid);
    if(!GetLocalInt(oInventory,"STORE_IN_DB"))
        SetLocalInt(oInventory,"PERMANENT_DELETION", TRUE);
    //SignalEvent(oInventory, EventUserDefined(EVENT_GARBAGE_COLLECTION));

    // garbage collection for persistent corpses
    object corpse_persistent= GetObjectByTag("CORPSE_"+pcid+"_PERSISTENT");
    int corpse_type  = GetLocalInt(corpse_persistent,"CORPSE");
    if(corpse_type & CORPSE_TYPE_PERSISTENT)
    {
        DestroyObject(corpse_persistent);

        Data_SetCampaignString("corpse_holder","0",OBJECT_INVALID,pcid);
    }
    // garbage collection for the corpse itself
    int nth; string corpse_tag = "CORPSE_"+pcid;
    object oCorpse  = GetObjectByTag(corpse_tag, nth);
    while(GetIsObjectValid(oCorpse))
    {
      if(GetObjectType(oCorpse)==OBJECT_TYPE_PLACEABLE)
      {
        // clean up for placeable corpse
        DestroyObject(GetLocalObject(oCorpse,"PAIRED"), 12.0); //Delete paired objects - bloodstain

        // Destroy the invis corpse and drop a loot bag (if any loot left)
        SetPlotFlag(oCorpse, FALSE);
        if(strip_corpse)
            StripInventory(oCorpse);
        DestroyObject(oCorpse, 0.1);

        object oBody    = GetLocalObject(oCorpse, "CORPSE_BODY");
        // To avoid potential memory leaks, we clean everything that might be left on the original creatures body
        StripInventory(oBody);
        // Destroy the visible corpse
        AssignCommand(oBody, SetIsDestroyable(TRUE, FALSE, FALSE));
        DestroyObject(oBody, 0.2);
      }
      oCorpse  = GetObjectByTag(corpse_tag, ++nth);
    }
}

// DEATH ----------------------------------------------------------------------
void WipeKillerDataFromVictim(object victim)
{
    DeleteLocalObject(victim,"KILLER");
    DeleteLocalString(victim,"KILLER_TYPE");
    DeleteLocalString(victim,"KILLER_NAME");
    DeleteLocalString(victim,"KILLER_ID");
    DeleteLocalString(victim,"SCRIPT_PC_DEATH");
}

void StoreKillerDataOnVictim(object victim, object killer)
{
    SetLocalObject(victim,"KILLER",killer);

    SetLocalString(victim,"SCRIPT_PC_DEATH",GetLocalString(killer, "SCRIPT_PC_DEATH"));

    int b_fam   = FALSE;
    string killer_type  = "NPC";
    if(GetIsPC(killer))
    {
        if(killer==victim)
            killer_type = "SELF";
        if(GetIsDM(killer))
            killer_type = "DM";
        else if(GetIsDMPossessed(killer))
            killer_type = "DM";
        else if(GetIsPossessedFamiliar(killer))
        {
            b_fam       = TRUE;
            killer_type = "PC";
        }
        else
            killer_type = "PC";
    }
    SetLocalString(victim,"KILLER_TYPE",killer_type);

    string killer_name  = GetName(killer);
    string killer_id    = GetPCID(killer);
    if(!StringToInt(killer_id))
    {
        if(b_fam)
        {
            killer_name  = "FAMILIAR_"+killer_name;
            killer_id    = GetPCID(GetMaster(killer));
        }
        if(!StringToInt(killer_id))
        {
            killer_id    = "0";
        }
    }
    SetLocalString(victim,"KILLER_NAME",killer_name);
    SetLocalString(victim,"KILLER_ID", killer_id);
}

string GetPCDeathStatus(string pcid)
{
    return Data_GetCampaignString("DEAD", OBJECT_INVALID, pcid);
}

void RecordPCDeath(object oPC)
{
    // if not a character in the DB... exit
    if(!StringToInt(GetPCID(oPC)))
        return;

    // first mark the PC as dead in the DB
    Data_SetCampaignString("DEAD", IntToString(GetTimeCumulative(TIME_DAYS)), oPC);

    // record the record of the death in the DB
    /*if(MODULE_NWNX_MODE)
    {
        // Get all the information about the death
        string character_id = GetPCID(oPC);
        string killer_id    = GetLocalString(oPC, "KILLER_ID");//GetPCID(oKiller);
        string killer_name  = GetLocalString(oPC, "KILLER_NAME");//GetName(oKiller);

        killer_id   = EncodeSpecialChars(killer_id);
        killer_name = EncodeSpecialChars(killer_name);
        string killer_type  = GetLocalString(oPC, "KILLER_TYPE");

        object oArea        = GetArea(oPC);
        string area_name    = GetName(oArea);
        string area_id      = GetIDFromArea(oArea);

        // death record
        // id, timestamp, campaign, killed (id), killer (id,name,type), area (id, name)
        string sQuery = "INSERT INTO character_deaths (campaign_id, character_id, killer_type, killer_id, killer_name, area_id, area_name) "
                 +"VALUES("+NWNX_GetCampaignID(GetModule())+","+character_id+",'"+killer_type+"','"+killer_id+"','"+killer_name+"','"+area_id+"','"+area_name+"');";

        NWNX_SqlExecDirect(sQuery);
    } */
}

void ClearPCDeath(string pcid, string status="0")
{
    // if this is not an int... this is not a character stored in the db
    if(!StringToInt(pcid))
        return;

    // status can be
    // RAISED       --> raise with 1 hit point
    // RESURRECTED  --> raise with full hitpoints
    // 0            --> alive. not dead.

    // PC dead flag set to 0 in DB
    Data_SetCampaignString("DEAD", status, OBJECT_INVALID, pcid);

}

//::///////////////////////////////////////////////
//:: Name: Color Fcns
//:: Copyright (c) 2006 Jesse Wright
//:://////////////////////////////////////////////
/*
DoColorize - wrapper for all ColorStringManip() calls
ColorStringManip - replaces all instances of sChar from sText with sColor

  12/22/2006 - Fixed a bug to ColorStringManip that caused an infinite loop if
    the character it was looking to replace was the first character in the
    target string. It was a stupid bug (> 0 needed to be >= 0)  - TV (JW)
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Wright
//:: Created On: 6/4/2006
//:: Last Modified: 12/22/2006
//:://////////////////////////////////////////////

string DoColorize(string sText, int bDescription=FALSE)
{
    if(bDescription)
        sText = COLOR_DESCRIPTION + sText;
    else
        sText = COLOR_WHITE + sText;

    sText = ColorStringManip(sText, "(", COLOR_OBJECT);
    if(bDescription)
        sText = ColorStringManip(sText, ")", COLOR_DESCRIPTION);
    else
        sText = ColorStringManip(sText, ")", COLOR_WHITE);

    sText = ColorStringManip(sText, "[", COLOR_ACTION);
    if(bDescription)
        sText = ColorStringManip(sText, "]", COLOR_DESCRIPTION);
    else
        sText = ColorStringManip(sText, "]", COLOR_WHITE);

    return sText;
}

string ColorStringManip(string sText, string sChar, string sColor)
{
    int iPosition = 0;               //position of syntax char
    int iLength;

    string sTemp1;
    string sTemp2;

    while (iPosition != -1)
    {
        iPosition = FindSubString(sText, sChar);

        if (iPosition >= 0)
        {
            iLength = GetStringLength(sText);
            sTemp1 = GetSubString(sText, 0, iPosition);
            sTemp2 = GetSubString(sText, (iPosition + 1), (iLength - iPosition));
            sText = sTemp1 + sTemp2;
            sText = InsertString(sText, sColor, iPosition);
        }
    }

    return sText;
}

// ........  CREATURES......................................

int CreatureGetNaturalPhenoType(object oCreature)
{
    int nNaturalPhenoType = GetSkinInt(oCreature,"PHENOTYPE_NATURAL");

    if(!nNaturalPhenoType)
    {
        nNaturalPhenoType = GetPhenoType(oCreature);
        if(nNaturalPhenoType==PHENOTYPE_NORMAL || nNaturalPhenoType==PHENOTYPE_BIG)
            SetSkinInt(oCreature,"PHENOTYPE_NATURAL", nNaturalPhenoType+1000);
        else
            nNaturalPhenoType = 0; // fallback
    }
    else
        nNaturalPhenoType -= 1000;


    return nNaturalPhenoType;
}


int GetCreatureSizeModifier(object oCreature)
{
    switch(GetCreatureSize(oCreature))
    {
        case CREATURE_SIZE_TINY: return(2);
        case CREATURE_SIZE_SMALL: return(1);
        case CREATURE_SIZE_MEDIUM: return(0);
        case CREATURE_SIZE_LARGE: return(-1);
        case CREATURE_SIZE_HUGE: return(-2);
    }
    return(0);
}

int GetCreatureWeight(object oCreature)
{
    int nWeight;
    switch(GetCreatureSize(oCreature))
    {
        case CREATURE_SIZE_TINY:    nWeight=1; break;
        case CREATURE_SIZE_SMALL:   nWeight=25; break;
        case CREATURE_SIZE_MEDIUM:  nWeight=100; break;
        case CREATURE_SIZE_LARGE:   nWeight=300; break;
        case CREATURE_SIZE_HUGE:    nWeight=1500; break;
        default:                    nWeight=100; break;
    }
    return (FloatToInt(GetWeight(oCreature)/10.0)+nWeight);
}

int GetCreatureHeight(object oCreature, int bMeters=FALSE)
{
    if(GetObjectType(oCreature)!=OBJECT_TYPE_CREATURE){ return FALSE; } //Creatures only
    int nType       = GetAppearanceType(oCreature);
    string sHeight  = Get2DAString("appearance","HEIGHT",nType);
    float fMeters   = StringToFloat(sHeight);
    if(bMeters)
        return FloatToInt(fMeters);
    else
        return FloatToInt(fMeters*3.28);
}

int CreatureGetIsAnimal(object oCreature=OBJECT_SELF)
{
    int nRacial = GetRacialType(oCreature);

    if(     nRacial==RACIAL_TYPE_ANIMAL
        ||(     GetAbilityScore(oCreature,ABILITY_INTELLIGENCE)<8
            &&  (nRacial==RACIAL_TYPE_BEAST || nRacial==23) // lycanthropes
          )
      )
        return TRUE;
    else
        return FALSE;
}

int CreatureGetIsHumanoid(object oCreature=OBJECT_SELF)
{
    int nRacial = GetRacialType(oCreature);

    if(     nRacial<=6  // player races
        ||  nRacial==12 // goblin
        //||  nRacial==14 // animorphs
        //||  nRacial==15 // scalykind (lizardfolk etc..)
        ||  nRacial==17 // fey
        //||  nRacial==18 // giant
       //||  nRacial==23 // lycanthropes
      )
        return TRUE;
    else
        return FALSE;
}

int CreatureGetIsSpider(object oCreature=OBJECT_SELF)
{
    int nAppType    = GetAppearanceType(oCreature);

    if(     (nAppType>=157 && nAppType<=162)
        ||  nAppType==406 ||  nAppType==407 ||  nAppType==446// driders
        ||  nAppType==422
        ||  nAppType==900
        ||  nAppType==965
        ||  (nAppType>=1061 && nAppType<=1065) //infensa spiders in Q
        ||  nAppType==1144 || nAppType==1145   // q driders
      /*||  (nAppType>=5101 && nAppType<=5102) // infensa spiders resized by Hene
        ||  (nAppType>=5158 && nAppType<=5165) // infensa spiders resized by Hene
        ||  (nAppType==5396 || nAppType==5397) // shadow spiders
        ||  (nAppType>=5502 && nAppType<=5504) // spider mounts
      */
      )
        return TRUE;
    else
        return FALSE;
}

int CreatureGetIsFungus(object oCreature=OBJECT_SELF)
{
    int nAppear = GetAppearanceType(oCreature);

    if(     (nAppear>=942 && nAppear<=944)      // myconids
        //||  (nAppear>=5010 && nAppear<=5014)    // vegepygmies
      )
        return TRUE;
    else
        return FALSE;

}

int CreatureGetHasHands(object oCreature=OBJECT_SELF)
{
    if(GetObjectType(oCreature)!=OBJECT_TYPE_CREATURE){ return FALSE; } //Creatures only
    //if(GetLocalInt(oCreature, "FORM_HASHANDS")){return TRUE;}

    int nType       = GetAppearanceType(oCreature);
    if(nType<7){ return TRUE; } // shortcut process for standard PC races
    string sHands   = Get2DAString("appearance_x","HASHANDS",nType);
    int bHands      = StringToInt(sHands);
    //if(bHands){SetLocalInt(oCreature, "FORM_HASHANDS", TRUE);}
    return bHands;
}

// Determines if the creature is aquatic (breathes in water/swims) - [FILE: v2_inc_creatures]
int CreatureGetIsAquatic(object oCreature=OBJECT_SELF)
{
    int bAquatic;

    /*
    bAquatic    = GetLocalInt(oCreature, "FORM_AQUATIC");
    if( bAquatic==1)
        return TRUE;
    else if(bAquatic==-1)
        return FALSE;
    */
    int nType       = GetAppearanceType(oCreature);
    string sAqua    = Get2DAString("appearance_x", "AQUATIC", nType);
        bAquatic    = StringToInt(sAqua);

    /*
    if(bAquatic)
        SetLocalInt(oCreature, "FORM_AQUATIC", 1);
    else
        SetLocalInt(oCreature, "FORM_AQUATIC", -1);
    */

    return bAquatic;
}

int CreatureGetIsSoftBodied(object oCreature=OBJECT_SELF)
{
    int bSoft;

    /*
    bSoft    = GetLocalInt(oCreature, "FORM_SOFTBODIED");
    if( bSoft==1)
        return TRUE;
    else if(bSoft==-1)
        return FALSE;
    */

    int nType       = GetAppearanceType(oCreature);
    string sSoft    = Get2DAString("appearance_x", "SOFTBODIED", nType);
        bSoft       = StringToInt(sSoft);

    /*
    if(bSoft)
        SetLocalInt(oCreature, "FORM_SOFTBODIED", 1);
    else
        SetLocalInt(oCreature, "FORM_SOFTBODIED", -1);
    */

    return bSoft;
}


object CreatureGetResponseToSitterInSeat(object oCreature , object oSeat)
{
    object oSitter  = GetSittingCreature(oSeat);
    int nResponse   = FALSE;

    // relinquish claim on seat (no response)
    {
        DeleteLocalObject(oCreature,"SEAT_CLAIMED");
        DeleteLocalInt(oCreature,"SEAT_CLAIMED");
        if(GetLocalString(oSeat,"SEAT_CLAIMED")==ObjectToString(oCreature))
            DeleteLocalString(oSeat,"SEAT_CLAIMED");
        DeleteLocalInt(oCreature,"SEAT_SOCIAL");

        oSeat   = OBJECT_INVALID;
    }

    SetLocalInt(oCreature,"SEAT_RESPONSE", nResponse);

    return oSeat;
}

int CreatureGetIsBusy(object oCreature=OBJECT_SELF, int nIgnoreAction=ACTION_INVALID, int nIgnoreCombat=FALSE, int nIgnoreConversation=FALSE)
{
    if(     (!nIgnoreConversation && IsInConversation(oCreature))
        ||  (!nIgnoreCombat && GetIsInCombat(oCreature))
      )
        return TRUE;

    int nCurrent    = GetCurrentAction(oCreature);
    if(     nCurrent==ACTION_INVALID
        ||  nCurrent==nIgnoreAction
        ||  nCurrent==ACTION_WAIT
        ||  nCurrent==ACTION_SIT
        ||  nCurrent==ACTION_RANDOMWALK
      )
        return FALSE;
    else
        return TRUE;
}

int GetIsShoutHeard(object oShouter)
{
    // telepathic or able to hear
    return(     GetLocalInt(oShouter, "AI_TELEPATHIC")
            ||  GetLocalInt(OBJECT_SELF, "AI_TELEPATHIC")
            ||(     !GetHasEffect(EFFECT_TYPE_DEAF)
                &&  !GetHasEffect(EFFECT_TYPE_SILENCE)
                &&  !GetHasEffect(EFFECT_TYPE_SILENCE, oShouter)
              )
          );
}

int CreatureGetIsCivilized(object oCreature=OBJECT_SELF)
{
    if(GetLocalInt(oCreature,"AI_CIVILIZED"))
        return TRUE;

    return FALSE;
}

int GetIsPrey(object oCreature, object oPredator=OBJECT_SELF)
{
    //if(!GetCreatureIsHungry(oPredator))
    //    return FALSE;

    string sPredID      = ObjectToString(oPredator);
    int bPrey           = GetLocalInt(oCreature,"PREY_OF_"+sPredID);
    if(bPrey==-1)
        return FALSE;
    else if(bPrey==TRUE)
        return TRUE;

    int nPreyRace       = GetRacialType(oCreature);
    int nPredRace       = GetRacialType(oPredator);
    int nPreyOnLarger   = GetLocalInt(oPredator, "AI_ATTACK_LARGER");
    int nPreySize       = GetCreatureSize(oCreature);
    int nPredSize       = GetCreatureSize(oPredator)+GetLocalInt(oPredator, "AI_SIZE_MODIFIER");

    if(     GetIsFriend(oCreature, oPredator)
        ||  GetFactionEqual(oCreature, oPredator)
        //||  GetSharesGroupMembership(oPredator,oCreature)
      )
    {
        SetLocalInt(oCreature,"PREY_OF_"+sPredID,-1);
        return FALSE;
    }
    else if(    nPredRace==RACIAL_TYPE_DRAGON
            ||( nPredRace==RACIAL_TYPE_UNDEAD
                &&(     nPreyRace!=RACIAL_TYPE_OOZE
                    &&  nPreyRace!=RACIAL_TYPE_ELEMENTAL
                    &&  nPreyRace!=RACIAL_TYPE_CONSTRUCT
                    &&  nPreyRace!=RACIAL_TYPE_OUTSIDER
                  )
              )
           )
    {
        SetLocalInt(oCreature,"PREY_OF_"+sPredID,1);
        return TRUE;
    }

    else if(     nPreyRace==RACIAL_TYPE_CONSTRUCT
            ||  nPreyRace==RACIAL_TYPE_ELEMENTAL
            ||  nPreyRace==RACIAL_TYPE_UNDEAD
            ||  nPreyRace==RACIAL_TYPE_DRAGON
            ||( nPreySize>nPredSize && !nPreyOnLarger )
            ||( nPreyRace==RACIAL_TYPE_OOZE
                &&(     nPredRace!=RACIAL_TYPE_VERMIN
                    &&  nPredRace!=RACIAL_TYPE_OOZE
                    &&  nPredRace!=RACIAL_TYPE_ABERRATION
                    &&  nPredRace!=RACIAL_TYPE_ELEMENTAL
                  )
              )
           )
    {
        SetLocalInt(oCreature,"PREY_OF_"+sPredID,-1);
        return FALSE;
    }

    if(GetLocalInt(oPredator, "AI_CARNIVORE") || GetLocalInt(oPredator, "AI_OMNIVORE"))
    {
        if(GetLocalInt(oCreature, "CREATURE_PLANT") && GetLocalInt(oPredator, "AI_CARNIVORE"))
        {
            SetLocalInt(oCreature,"PREY_OF_"+sPredID,-1);
            return FALSE;
        }

        if(GetIsNeutral(oCreature, oPredator))
        {
            if(GetLocalInt(oCreature, "AI_HERBIVORE"))
            {
                return TRUE;
            }
            else if(GetLocalInt(oCreature, "AI_OMNIVORE"))
            {
                if(     nPreySize<nPredSize
                    ||( GetLocalInt(oPredator,"AI_CARNIVORE")&&nPreyOnLarger )
                  )
                    return TRUE;
            }
            else if(GetLocalInt(oCreature, "AI_CARNIVORE"))
            {
                if(nPreySize<nPredSize)
                    return TRUE;
            }
            else
            {
                if(CreatureGetIsAnimal(oCreature))
                {
                    if(nPreySize<nPredSize||nPreyOnLarger)
                        return TRUE;
                }
                else
                {
                    if(GetLocalInt(oPredator, "AI_OMNIVORE"))
                    {
                        if(nPreySize<nPredSize||nPreyOnLarger)
                        {
                            if(d2()==1)
                                return TRUE;
                            else
                                return FALSE;
                        }
                        else
                            return FALSE;
                    }
                    else
                        return FALSE;
                }
            }
        }
        else if(GetIsEnemy(oCreature, oPredator))
        {
            if(GetLocalInt(oCreature, "AI_HERBIVORE")||GetLocalInt(oCreature, "AI_OMNIVORE"))
            {
                return TRUE;
            }
            else if(GetLocalInt(oCreature, "AI_CARNIVORE"))
            {
                if(nPreySize<nPredSize || nPreyOnLarger)
                    return TRUE;
            }
            else
            {
                if(nPreySize<nPredSize || nPreyOnLarger)
                    return TRUE;
            }
        }
    }
    else if(GetLocalInt(oPredator, "AI_HERBIVORE"))
    {
        if(GetLocalInt(oCreature, "CREATURE_PLANT"))
        {
            if(nPreySize<nPredSize || nPreyOnLarger)
            {
                SetLocalInt(oCreature,"PREY_OF_"+sPredID,1);
                return TRUE;
            }
        }
        else
        {
            SetLocalInt(oCreature,"PREY_OF_"+sPredID,-1);
            return FALSE;
        }
    }
    // predator lacks special animal behavior
    else
    {
        bPrey   = GetIsEnemy(oCreature, oPredator);
    }

    return bPrey;
}

float GetScentRange(object oCreature)
{
    int nRace   = GetRacialType(oCreature);
    if( GetHasFeat( FEAT_SCENT, oCreature) ) // scent feat
    {
        float fDist = GetLocalFloat(oCreature, "AI_DISTANCE_THREATENED");
        if(fDist==0.0)
            fDist   = 10.0;
        return fDist;
    }
    else
        return 0.0;
}

int GetReputationReactionType(object oTarget, object oSource=OBJECT_SELF, int bSharesGroup=FALSE)
{
    //string sPCID    = GetPCIdentifier(oTarget);

    //if(DEBUG && GetTag(oSource)=="aa_testcow")
    //   return 0;

    // Get current reputation
    int nRep    = GetReputation(oSource, oTarget);

    // adjust by historical record of combined penalties and bonuses
    /*
    if(GetLocalInt(oSource, "UNIQUE"))
        nRep    += PRR_GetHistoricalValue(oTarget, oSource);

    if(!GetIsCharmedBy(oTarget,oSource)&&PRR_CHARM_Check(oTarget,oSource))
        nRep    += 25;
    */

    if(nRep>89)
        return 2;
    else if(nRep<10 && !bSharesGroup) // group membership supresses hostility
        return 1;
    else
        return 0;
}

// ........  AREAS and subareas (triggers)......................................

string AreaGetDescription(object oPC, object oArea=OBJECT_SELF, int bEntry=FALSE, int nEntries=0)
{
    string sAreaDescription;

    // first entry
    if(bEntry && nEntries<=1)
    {
        if(GetIsNight())
            sAreaDescription    = GetLocalString(oArea, "AREA_DESCRIPTION_FIRST_NIGHT");
        if(sAreaDescription=="")
            sAreaDescription    = GetLocalString(oArea, "AREA_DESCRIPTION_FIRST");
    }

    // night description
    if(sAreaDescription=="" && GetIsNight())
        sAreaDescription    = GetLocalString(oArea, "AREA_DESCRIPTION_NIGHT");

    // default
    if(sAreaDescription=="")
        sAreaDescription    = GetLocalString(oArea, "AREA_DESCRIPTION");

    return sAreaDescription;
}

int AreaGetIsMappedByPC(object oPC, object oArea=OBJECT_SELF)
{
    // this is a place to check if oPC knows the entire area
    // intention is to have persistent knowledge of areas

    return FALSE;
}

int GetDescriptionCanContinue(object oPC, object oTrigger=OBJECT_SELF)
{
    // trigger only gives description when an object is present
    string sObject  = GetLocalString(oTrigger, "DESCRIPTION_OBJECT");
    if( sObject!="" )
    {
        int nNth=1;
        int bPresent;
        object oArea    = GetArea(oTrigger);
        object oNearest = GetNearestObjectByTag(sObject,oTrigger,nNth);
        while(      GetIsObjectValid(oNearest)
                &&  GetArea(oNearest)==oArea
             )
        {
            if(GetIsInSubArea(oNearest,oTrigger))
            {
                bPresent= TRUE;
                break;
            }

            oNearest    = GetNearestObjectByTag(sObject,oTrigger,++nNth);
        }

        if(!bPresent)
            return FALSE; // object to describe is not present.
    }

    // restricted time?
    int nHour       = GetTimeHour();
    int nHourStart  = GetLocalInt(oTrigger, "DESCRIPTION_HOUR_START");
    int nHourEnd    = GetLocalInt(oTrigger, "DESCRIPTION_HOUR_END");
    if(!nHourEnd) nHourEnd = 24;
    if(     (nHour<nHourStart||nHour>=nHourEnd)
        ||  (GetLocalInt(oTrigger, "DESCRIPTION_DAY") && !GetIsDay())
        ||  (GetLocalInt(oTrigger, "DESCRIPTION_NIGHT") && !GetIsNight())
      )
        return FALSE;

    // restricted to feat
    if(   //(GetLocalInt(oTrigger, "DESCRIPTION_TRACK") && !GetHasFeat(FEAT_TRACK, oPC)) ||
          //(GetLocalInt(oTrigger, "DESCRIPTION_SCENT") && !GetHasFeat(FEAT_SCENT, oPC)) ||
            (GetLocalInt(oTrigger, "DESCRIPTION_STONECUNNING") && !GetHasFeat(FEAT_STONECUNNING, oPC))
      )
        return FALSE;

    return TRUE;
}

// ........  SPELLS ............................................................

int GetSpellComponent(string sComponent, int nSpellID)
{
    string sReq = GetStringLowerCase(Get2DAString("spells", "VS", nSpellID));
    sComponent  = GetStringLowerCase(sComponent);

    if (FindSubString(sReq, sComponent)!=-1)
        return TRUE;
    else
        return FALSE;
}

void CasterClearsSpellOverrides()
{
    // Used By Community Patch
    DeleteLocalInt(OBJECT_SELF, "SPECIAL_ABILITY_CASTER_LEVEL_OVERRIDE");
    DeleteLocalInt(OBJECT_SELF, "SPECIAL_ABILITY_DC_OVERRIDE");
    DeleteLocalInt(OBJECT_SELF, "SPECIAL_ABILITY_METAMAGIC_OVERRIDE");
}

void CasterSetConcentration(object oConcentrate, string sScript="")
{
    SetLocalInt(OBJECT_SELF, "CONCENTRATION", TRUE);
    SetLocalString(OBJECT_SELF,"CONCENTRATION_SCRIPT",sScript);
    SetLocalObject(OBJECT_SELF,"CONCENTRATION_OBJECT",oConcentrate);
}

int DispelObject(int nSpellID, int nLevel, int nDC, int bAutoDispel=FALSE)
{
    // determine max spell level for caster
    int nMax;
    switch(nSpellID)
    {
        case SPELL_MORDENKAINENS_DISJUNCTION: nMax = 40; break;
        case SPELL_GREATER_DISPELLING: nMax = 15; break;
        case SPELL_DISPEL_MAGIC: nMax = 10; break;
        case SPELL_LESSER_DISPEL: nMax = 5; break;
        default: return FALSE; break;
    }

    if(bAutoDispel)
        return TRUE;

    int nMod;
    if (nLevel == 0)
        nMod = 1;
    else if (nLevel>nMax)
        nMod = nMax;
    else
        nMod = nLevel;

    // dispel?
    if ( (nMod + d20()) >= nDC)
    {
        if(nDC>=30)
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF));
        else if(nDC>=26)
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION), GetLocation(OBJECT_SELF));
        else if(nDC>=21)
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL_GREATER), GetLocation(OBJECT_SELF));
        else
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL), GetLocation(OBJECT_SELF));

        return TRUE;
    }
    return FALSE;
}

void FamiliarDestroyExtraSpellFocus(int nMax=1)
{
    if(nMax==-1)
        return;

    object oFocus   = GetFirstItemInInventory();
    int nCount, bDestroy;
    while(oFocus!=OBJECT_INVALID)
    {
        if(GetLocalInt(oFocus,SPELLFOCUS_TYPE))
        {
            ++nCount;
            if(nCount>=nMax)
            {
                bDestroy    = TRUE;
                DestroyObject(oFocus);
            }
        }

        oFocus   = GetNextItemInInventory();
    }

    if(bDestroy)
        SendMessageToPC(OBJECT_SELF, DMBLUE+GetName(OBJECT_SELF)+" may only carry "+PALEBLUE+IntToString(nMax)+DMBLUE+" Spell Focus at a time.");
}

string GetSpellFocusTag(int nType, location lTarget, object oTarget=OBJECT_INVALID)
{
    string sTag;
    if(nType==1)
    {
        sTag    += GetStringRight(GetTag(GetAreaFromLocation(lTarget)),8);
        vector vPos = GetPositionFromLocation(lTarget);
        sTag    += FloatToString(vPos.x,8)+FloatToString(vPos.y,8)+FloatToString(vPos.z,8);
    }
    else
    {
        sTag    += GetTag(oTarget) + GetName(oTarget);
        if(GetStringLength(sTag)>32)
            sTag    = GetStringRight(sTag,32);
    }

    return sTag;
}

int GetIsSpellFocusSuccessful(object oFocus, int nSpellID)
{
    int bSuccess;
    int nSpellFocusType  = GetLocalInt(oFocus, SPELLFOCUS_TYPE);
    if(nSpellFocusType==1)// location
    {
        location lLoc   = GetSpellFocusLocation(oFocus);

        /*
        if(GetIsObjectValid(GetAreaFromLocation(lLoc)))
        {
            if(     nSpellID==SPELL_DIMENSIONAL_PORTAL
                ||  nSpellID==SPELL_TELEPORT
              )
                bSuccess=TRUE;
        }
        else
        {
            // feedback about invalid location
        }
        */
    }
    else if(nSpellFocusType==2)// NPC
    {
        object oNPC = GetLocalObject(oFocus, SPELLFOCUS_CREATURE);

        if( oNPC!=OBJECT_INVALID )
        {
            /*
            if(     nSpellID==SPELL_DIMENSIONAL_PORTAL
                ||  nSpellID==SPELL_TRANSDIMENSIONAL_PORTAL
                ||  nSpellID==SPELL_TELEPORT_LESSER
                ||  nSpellID==SPELL_TELEPORT
                ||  nSpellID==SPELL_BESTOW_CURSE
              )
                bSuccess=TRUE;
            */
        }
        else
        {
            // feedback about invalid creature
        }
    }
    else if(nSpellFocusType==3)// PC
    {
        object oPC  = GetPCByPCID(GetLocalString(oFocus, SPELLFOCUS_CREATURE));

        if( oPC!=OBJECT_INVALID )
        {
            /*
            if(     nSpellID==SPELL_DIMENSIONAL_PORTAL
                ||  nSpellID==SPELL_TRANSDIMENSIONAL_PORTAL
                ||  nSpellID==SPELL_TELEPORT_LESSER
                ||  nSpellID==SPELL_TELEPORT
                ||  nSpellID==SPELL_BESTOW_CURSE
              )
                bSuccess=TRUE;
            */
        }
        else
        {
            // feedback about invalid PC
        }
    }
    else
    {
        // ????
    }
    return bSuccess;
}

location GetSpellFocusLocation(object oFocus)
{


    return  Location(   GetObjectByTag(GetLocalString(oFocus, SPELLFOCUS_LOCATION_TAG)),
                        Vector( GetLocalFloat(oFocus, SPELLFOCUS_LOCATION_X),
                                GetLocalFloat(oFocus, SPELLFOCUS_LOCATION_Y),
                                GetLocalFloat(oFocus, SPELLFOCUS_LOCATION_Z)
                              ),
                        GetLocalFloat(oFocus, SPELLFOCUS_LOCATION_F)
                    );
}

// Stores a location on a spell focus. - [FILE: spellfocus_inc]
void StoreSpellFocusLocation(object oFocus, location lLoc)
{
    vector vPos     = GetPositionFromLocation(lLoc);

    SetLocalString(oFocus, SPELLFOCUS_LOCATION_TAG, GetTag(GetAreaFromLocation(lLoc)));
    SetLocalFloat(oFocus, SPELLFOCUS_LOCATION_X, vPos.x);
    SetLocalFloat(oFocus, SPELLFOCUS_LOCATION_Y, vPos.y);
    SetLocalFloat(oFocus, SPELLFOCUS_LOCATION_Z, vPos.z);
    SetLocalFloat(oFocus, SPELLFOCUS_LOCATION_F, GetFacingFromLocation(lLoc));
}

void SetAOECaster(int nSpellId, object oCaster)
{
    int nIndex;
    string sSpellID = IntToString(nSpellId);
    string sAOEID   = "AOE"+sSpellID+"_ID"+IntToString(nIndex)+"_CASTER";
    object oMod     = GetModule();
    object oC       = GetLocalObject(oMod, sAOEID);

    while (GetIsObjectValid(oC))
    {
        sAOEID  = "AOE"+sSpellID+"_ID"+IntToString(++nIndex)+"_CASTER";
        oC      = GetLocalObject(oMod, sAOEID);
    }

    SetLocalObject(oMod, sAOEID, oCaster);
    SetLocalInt(oCaster,"AOE"+sSpellID+"_ID", nIndex);
}


int GetIsScryTargetWarded(location lTarget, object oTarget)
{
    // warding check
    if(     GetLocalInt(GetAreaFromLocation(lTarget), "SCRY_NO")
        ||  GetLocalInt(oTarget, "SCRY_NO")
      )
        return TRUE;
    else
        return FALSE;
}

void ClairaudienceEnd(object oCreator)
{
    object oSensor  = GetLocalObject(oCreator, "SCRY_SENSOR");
    int nSensorID   = GetLocalInt(oSensor, "SCRY_ID");
    if( GetIsObjectValid(OBJECT_SELF) )
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL), oCreator, 0.1);
        SendMessageToPC(oCreator, PINK+"Your "+RED+"clairaudience"+PINK+" spell ends.");
        // Garbage Collection
        DeleteLocalInt(oCreator, "SCRYING");
        DeleteLocalObject(oCreator, "SCRY_SENSOR");
        object oAOE = GetLocalObject(oSensor, "PAIRED");
        DestroyObject(oAOE, 0.1);

        DestroyObject(oSensor, 0.1);

        if(!GetHasSpellEffect(SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, oCreator))
            return;
        // ensure the spell is cancelled
        effect eSpell   = GetFirstEffect(oCreator);
        while(GetIsEffectValid(eSpell))
        {
            if(GetEffectSpellId(eSpell)==SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE)
                RemoveEffect(oCreator, eSpell);
            eSpell = GetNextEffect(oCreator);
        }
    }
}

void EndScrying(object oPC)
{
    int scry_val = GetLocalInt(oPC, "SCRYING");
    if(scry_val)
    {
        ClairaudienceEnd(oPC);
    }
    DeleteLocalInt(oPC, "SCRYING");
}


int IncrementAnimatedWeaponCount(int nLevel)
{
    // OBJECT_SELF = creator / spell caster
    int nWeapons    = GetLocalInt(OBJECT_SELF, "ANIMATED_WEAPON_COUNT")+1;

    int nMax        = 1 + nLevel/3;

    if(nWeapons > nMax)
        return FALSE;
    else
    {
        SetLocalInt(OBJECT_SELF, "ANIMATED_WEAPON_COUNT", nWeapons);
        return TRUE;
    }
}

void DecrementAnimatedWeaponCount()
{
    // OBJECT_SELF = weapon wielder
    if(OBJECT_SELF!=OBJECT_INVALID && !GetLocalInt(OBJECT_SELF, "ANIMATED_WEAPON_COUNT_DEC"))
    {
        object oMaster  = GetMaster(OBJECT_SELF);
        if(GetIsObjectValid(oMaster))
        {
            int nWeapons    = GetLocalInt(oMaster, "ANIMATED_WEAPON_COUNT")-1;
            if(nWeapons<0){ nWeapons = 0; }
            SetLocalInt(oMaster, "ANIMATED_WEAPON_COUNT", nWeapons);
            SetLocalInt(OBJECT_SELF, "ANIMATED_WEAPON_COUNT_DEC", TRUE);
        }
    }
}

void CancelDancingWeapon(int nDispel=FALSE)
{
    DecrementAnimatedWeaponCount();
    SetPlotFlag(OBJECT_SELF, FALSE);

    // Drop weapon -------------------------------------------------------------
    object oWeapon      = GetLocalObject(OBJECT_SELF, "WEAPON");
    string sBlade       = GetLocalString(OBJECT_SELF, "WEAPON_SOUND");
    AssignCommand(OBJECT_SELF, ActionUnequipItem(oWeapon));
    object oItem = CopyObject(oWeapon,GetLocation(OBJECT_SELF));
    AssignCommand(OBJECT_SELF, PlaySound(sBlade));
    DestroyObject(oWeapon, 0.1);
    // -------------------------------------------------------------------------

    if(nDispel)
    {
        location lLoc   = GetLocation(OBJECT_SELF);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(239), lLoc); // spark
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(282), lLoc); // hit elec
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(681), lLoc); // mag blue
    }
    else
    {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISPEL), GetLocation(OBJECT_SELF));
    }
    DestroyObject(OBJECT_SELF, 0.5);
}

// ................ LIGHT ......................................................

int GetLightColor(object oLight=OBJECT_SELF)
{
    string sColor   = GetStringUpperCase(GetLocalString(oLight,LIGHT_VALUE));
    int nBrightness = GetLocalInt(oLight, LIGHT_VALUE);

    int nColor      = VFX_DUR_LIGHT_YELLOW_15; // default color

    if(sColor == "BLUE")
    {
        switch(nBrightness)
        {
            case 1: return VFX_DUR_LIGHT_BLUE_5; break;
            case 2: return VFX_DUR_LIGHT_BLUE_10; break;
            case 3: return VFX_DUR_LIGHT_BLUE_15; break;
            case 4: return VFX_DUR_LIGHT_BLUE_20; break;
            default: return VFX_DUR_LIGHT_BLUE_15; break;
        }
    }
    else if(sColor == "GREY")
    {
        switch(nBrightness)
        {
            case 1: return VFX_DUR_LIGHT_GREY_5; break;
            case 2: return VFX_DUR_LIGHT_GREY_10; break;
            case 3: return VFX_DUR_LIGHT_GREY_15; break;
            case 4: return VFX_DUR_LIGHT_GREY_20; break;
            default: return VFX_DUR_LIGHT_GREY_15; break;
        }
    }
    else if(sColor == "ORANGE")
    {
        switch(nBrightness)
        {
            case 1: return VFX_DUR_LIGHT_ORANGE_5; break;
            case 2: return VFX_DUR_LIGHT_ORANGE_10; break;
            case 3: return VFX_DUR_LIGHT_ORANGE_15; break;
            case 4: return VFX_DUR_LIGHT_ORANGE_20; break;
            default: return VFX_DUR_LIGHT_ORANGE_15; break;
        }
    }
    else if(sColor == "PURPLE")
    {
        switch(nBrightness)
        {
            case 1: return VFX_DUR_LIGHT_PURPLE_5; break;
            case 2: return VFX_DUR_LIGHT_PURPLE_10; break;
            case 3: return VFX_DUR_LIGHT_PURPLE_15; break;
            case 4: return VFX_DUR_LIGHT_PURPLE_20; break;
            default: return VFX_DUR_LIGHT_PURPLE_15; break;
        }
    }
    else if(sColor == "RED")
    {
        switch(nBrightness)
        {
            case 1: return VFX_DUR_LIGHT_RED_5; break;
            case 2: return VFX_DUR_LIGHT_RED_10; break;
            case 3: return VFX_DUR_LIGHT_RED_15; break;
            case 4: return VFX_DUR_LIGHT_RED_20; break;
            default: return VFX_DUR_LIGHT_RED_15; break;
        }
    }
    else if(sColor == "WHITE")
    {
        switch(nBrightness)
        {
            case 1: return VFX_DUR_LIGHT_WHITE_5; break;
            case 2: return VFX_DUR_LIGHT_WHITE_10; break;
            case 3: return VFX_DUR_LIGHT_WHITE_15; break;
            case 4: return VFX_DUR_LIGHT_WHITE_20; break;
            default: return VFX_DUR_LIGHT_WHITE_15; break;
        }
    }

    return nColor;
}

void InitializeTorch(object oItem, string sType)
{
    if(GetLocalInt(oItem,"CONTINUAL_FLAME"))
    {

        return;
    }
    if(sType=="nw_it_torch001"){ sType = "torch"; }
    int nPos = FindSubString(sType, "_");
    if(nPos!=-1){ sType = GetStringLeft(sType, nPos); }

    SetLocalInt(oItem, "LIGHTABLE" , TRUE);
    SetLocalString(oItem,"LIGHTABLE_TYPE" , sType);
}

int GetBrightestLightWielded(object oPC, object oSkipped)
{
    object oItem;
    int nSlot;
    int iLightBrightness = 0;

    // Cycle through all equipped items looking for the value of the brightest light property
    for (nSlot=0; nSlot<NUM_INVENTORY_SLOTS; nSlot++)
    {
        oItem          =   GetItemInSlot(nSlot, oPC);
        if (oItem != oSkipped)
        {
            itemproperty ip =   GetFirstItemProperty(oItem);
            while ( GetIsItemPropertyValid(ip) )
            {
             if ( GetItemPropertyType(ip) == ITEM_PROPERTY_LIGHT )
             {
                if( iLightBrightness < GetItemPropertyCostTableValue(ip) )
                {
                 iLightBrightness = GetItemPropertyCostTableValue(ip);
                }
             }
            //Next itemproperty on the list...
            ip = GetNextItemProperty(oItem);
            }
        }
    }

    return iLightBrightness;
}

int PCCanLight(object oSconce, object oPC)
{
    if(GetLocalInt(oSconce, "LIGHT_FIRE"))
    {
        if(     GetIsObjectValid(GetItemPossessedBy(oPC, "flintsteel"))
            ||  GetIsWieldingFlame(oPC)
          )
        {
            return TRUE;
        }
        else
        {
            SendMessageToPC(oPC, RED+"You need "+YELLOW+"flint and steel"+RED+" or an equipped open flame ("+YELLOW+"torch"+RED+","+YELLOW+" flaming sword"+RED+", etc...) to light the "+YELLOW+GetName(oSconce)+RED+".");
            return FALSE;
        }
    }
    else
        return TRUE;
}

//When PC's light was destroyed, adjust their light flag.
void PCLostLight(object oPC, object oLostLight)
{
    int iLightBrightness = GetBrightestLightWielded(oPC, oLostLight);

    if(GetLocalInt(oPC, LIGHT_VALUE)>iLightBrightness)
        SetLocalInt(oPC, LIGHT_VALUE,iLightBrightness);
}


// TIME related functions ......................................................

int GetTimeCumulative(int nTime=TIME_MINUTES)
{
    int iYear       = GetCalendarYear() - CAMPAIGN_YEAR_BASE;
    int iMonth      = GetCalendarMonth()- CAMPAIGN_MONTH_BASE;
    int iDay        = GetCalendarDay()  - CAMPAIGN_DAY_BASE;

    if(nTime==TIME_MINUTES)
    {
        return( (GetTimeMinute()*IGMINUTES_PER_RLMINUTE) + ((GetTimeHour()+((iDay+((iMonth+(iYear*12))*28))*24))*60) );
    }
    else if (nTime==TIME_HOURS)
    {
        return (GetTimeHour()+((iDay+((iMonth+(iYear*12))*28))*24));
    }
    // can only handle about 60 years worth of cumaltive seconds
    else if (nTime==TIME_SECONDS)
    {
        return(GetTimeSecond()
                        +(
                          (
                            (GetTimeMinute()*IGMINUTES_PER_RLMINUTE) + ((GetTimeHour()+((iDay+((iMonth+(iYear*12))*28))*24))*60)
                          )*60
                         )
                    );
    }
    else if (nTime==TIME_DAYS)
    {
        return(iDay+((iMonth+(iYear*12))*28));
    }

    // return minutes as default
    return( ((GetTimeMinute()*IGMINUTES_PER_RLMINUTE)+ ((GetTimeHour()+((iDay+((iMonth+(iYear*12))*28))*24))*60) ) );
}

int ConvertRealSecondsToGameSeconds(int nRealSeconds)
{

    int nGameMinutes    = (nRealSeconds/60)*IGMINUTES_PER_RLMINUTE;
    int nGameSeconds    = (nGameMinutes*60)+(nRealSeconds%60);

    return nGameSeconds;
}

struct DATETIME ConvertTimeStampToDateTime(string sTimeStamp, int gametime=TRUE)
{
    struct DATETIME time;

    // 0 if this is real time, 1 if this is game time
    // timestamp length changes due to year ranges altering
    int g =   (gametime!=FALSE);

    time.year   = StringToInt(GetSubString(sTimeStamp,0,4+g));
    time.month  = StringToInt(GetSubString(sTimeStamp,5+g,2));
    time.day    = StringToInt(GetSubString(sTimeStamp,8+g,2));
    time.hour   = StringToInt(GetSubString(sTimeStamp,11+g,2));
    time.minute = StringToInt(GetSubString(sTimeStamp,14+g,2));
    time.second = StringToInt(GetSubString(sTimeStamp,17+g,2));

    return time;
}

string ConvertDateTimeToTimeStamp(struct DATETIME time, int gametime=TRUE)
{
    string timestamp;

    int yln =   4;
    if(gametime){yln = 5;}

    string year     = IntToString(time.year);
           year     = (GetStringLength(year)<yln)? GetStringLeft("00000", yln-GetStringLength(year))+year : year;
    string month    = IntToString(time.month);
           month    = (GetStringLength(month)<2)? GetStringLeft("0000", 2-GetStringLength(month))+month : month;
    string day      = IntToString(time.day);
           day      = (GetStringLength(day)<2)? GetStringLeft("0000", 2-GetStringLength(day))+day : day;
    string hour     = IntToString(time.hour);
           hour     = (GetStringLength(hour)<2)? GetStringLeft("0000", 2-GetStringLength(hour))+hour : hour;
    string minute   = IntToString(time.minute);
           minute   = (GetStringLength(minute)<2)? GetStringLeft("0000", 2-GetStringLength(minute))+minute : minute;
    string second   = IntToString(time.second);
           second   = (GetStringLength(second)<2)? GetStringLeft("0000", 2-GetStringLength(second))+second : second;

    return (year+"-"+month+"-"+day+" "+hour+":"+minute+":"+second);
}


void InitializeFade(object oObject)
{
    object oArea    = GetArea(oObject);
    int nFadeCnt    = GetLocalInt(oArea, "FADE_COUNT");
    int nIt         = 1;
    object oDummy   = GetLocalObject(oArea,"FADE_"+IntToString(nIt));
    while(GetIsObjectValid(oDummy))
        oDummy   = GetLocalObject(oArea,"FADE_"+IntToString(++nIt));
    if(nIt>nFadeCnt)
        SetLocalInt(oArea, "FADE_COUNT",nIt);
    // Store Object and Fade Time on oArea
    SetLocalObject(oArea, "FADE_"+IntToString(nIt), oObject);

    int nFadeTime   = GetLocalInt(oObject, "FADE_TIME");
    if(nFadeTime<1)
        nFadeTime   = 12;

    SetLocalInt(oArea, "FADE_"+IntToString(nIt), nFadeTime+GetTimeCumulative());
}

void ObjectsFade(object oArea)
{
    int nFadeCnt    = GetLocalInt(oArea, "FADE_COUNT");
    int nTime       = GetTimeCumulative();
    int nFade; string sFade; object oFade;
    int nIt         = nFadeCnt;
    int bDestroy;

    while(nIt>0)
    {
        sFade   = "FADE_"+IntToString(nIt);
        nFade   = GetLocalInt(oArea,sFade);
        if(nFade)
        {
            if(nFade<nTime)
            {
                if(nIt==nFadeCnt)
                    nFadeCnt--;
                bDestroy=1;
            }
        }
        else
            bDestroy=1;

        // Destroy Object
        if(bDestroy)
        {
            bDestroy= 0;
            oFade   = GetLocalObject(oArea, sFade);
            DeleteLocalObject(oArea,sFade); // garbage collection
            DeleteLocalInt(oArea,sFade); // garbage collection
            if(GetIsObjectValid(oFade))
                DestroyObject(oFade);
        }
        // continue countdown to 0
        nIt--;
    }

    if(nFadeCnt>0)
        SetLocalInt(oArea, "FADE_COUNT", nFadeCnt);
    else
        DeleteLocalInt(oArea, "FADE_COUNT");
}

// END TIME ....................................................................


// XP ..........................................................................

int XPGetPCNeedsToLevel(object oPC, int bNext = TRUE)
{
    int nXP;
    int nLevel  = GetHitDice(oPC);
    if(!bNext){--nLevel;}

    switch (nLevel)
    {
        case 0:  nXP=     0; break;
        case 1:  nXP=  1000; break;
        case 2:  nXP=  3000; break;
        case 3:  nXP=  6000; break;
        case 4:  nXP= 10000; break;
        case 5:  nXP= 15000; break;
        case 6:  nXP= 21000; break;
        case 7:  nXP= 28000; break;
        case 8:  nXP= 36000; break;
        case 9:  nXP= 45000; break;
        case 10: nXP= 55000; break;
        case 11: nXP= 66000; break;
        case 12: nXP= 78000; break;
        case 13: nXP= 91000; break;
        case 14: nXP=105000; break;
        case 15: nXP=120000; break;
        case 16: nXP=136000; break;
        case 17: nXP=153000; break;
        case 18: nXP=171000; break;
        case 19: nXP=190000; break;
        case 20: nXP=210000; break;
    }

    if(bNext)
        nXP = nXP - GetXP(oPC);

    return nXP;
}


// END XP ......................................................................

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// BEGIN TETHYR CUSTOM FUNCTIONS
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////



// This function works with the location saving script, in order to properly return what location is saved.
string TE_GetLocationName(string sLoc)
{
    if (sLoc == "")
    {
        return "nonexistent.";}
    else if (sLoc == "WP_Whipinn")
    {
        return "Whippoorwill Inn.";}
    else if (sLoc == "WP_Lockfalls")
    {
        return "Lockwood Falls.";}
    else if (sLoc == "WP_Swamprise")
    {
        return "Swamprise Keep.";}
    else if (sLoc == "WP_Southspire")
    {
        return "Southspire Hold.";}
    else
    {
        return "Failed";
    }
}

//Custom Caster Level Calculator
int TE_ArcaneCasterLevel(object oPC)
{
    int nClass1 = GetClassByPosition(1,oPC);
    int nClass2 = GetClassByPosition(2,oPC);
    int nClass3 = GetClassByPosition(3,oPC);
    int nCasterLvl = 0;
    int nLevel1 = GetLevelByClass(nClass1,oPC);
    int nLevel2 = GetLevelByClass(nClass2,oPC);
    int nLevel3 = GetLevelByClass(nClass3,oPC);

    if (TE_ArcaneCasterClass(nClass1) == 1)
    {
        nCasterLvl = nCasterLvl + (nLevel1);
    }

    if (TE_ArcaneCasterClass(nClass2) == 1)
    {
        nCasterLvl = nCasterLvl + (nLevel2);
    }

    if (TE_ArcaneCasterClass(nClass3) == 1)
    {
        nCasterLvl = nCasterLvl + (nLevel3);
    }

    return nCasterLvl;
}

int TE_DivineCasterLevel(object oPC)
{
    int nClass1 = GetClassByPosition(1,oPC);
    int nClass2 = GetClassByPosition(2,oPC);
    int nClass3 = GetClassByPosition(3,oPC);
    int nCasterLvl = 0;
    int nLevel1 = GetLevelByClass(nClass1,oPC);
    int nLevel2 = GetLevelByClass(nClass2,oPC);
    int nLevel3 = GetLevelByClass(nClass3,oPC);

    if (TE_DivineCasterClass(nClass1) == 1)
    {
        nCasterLvl = nCasterLvl + (nLevel1);
    }

    if (TE_DivineCasterClass(nClass2) == 1)
    {
        nCasterLvl = nCasterLvl + (nLevel2);
    }

    if (TE_DivineCasterClass(nClass3) == 1)
    {
        nCasterLvl = nCasterLvl + (nLevel3);
    }

    return nCasterLvl;

}

//Returns 1 if the class is a spellcasting class.
//Returns 0 if the class is not a spellcasting class.
int TE_ArcaneCasterClass(int nClass)
{
    int nRes;
    switch (nClass)
    {
    case 1: //Bard
        nRes = 1;
        break;
    case 9: //Sorc
        nRes = 1;
        break;
    case 10: //Wiz
        nRes = 1;
        break;
    case 28: //Harper
        nRes = 1;
        break;
    case 30: // Assassin
        nRes = 1;
        break;
    case 34: // PM
        nRes = 1;
        break;
    case 47: //Warlock
        nRes = 1;
        break;
    case 49: //Spellfire Channeler
        nRes = 1;
        break;
    case 52: //Warmage
        nRes = 1;
        break;
    case 53: //Bladesinger
        nRes = 1;
        break;
    case 55: //Eldritch Knight
        nRes = 1;
        break;
    case 57: //Artificer
        nRes = 1;
        break;
    case 56: //Mystic Knight
        nRes = 1;
        break;
    default:
        nRes = 0;
        break;
    }
    return nRes;
}

//Returns 1 if the class is an Arcane spellcasting class.
//Returns 0 if the class is not an Arcane spellcasting class.
int TE_DivineCasterClass(int nClass)
{
    int nRes;
    switch (nClass)
    {
    case 2: //Cleric
        nRes = 1;
        break;
    case 3: //Druid
        nRes = 1;
        break;
    case 6: //Paladin
        nRes = 1;
        break;
    case 7: //Ranger
        nRes = 1;
        break;
    case 31: //Blackguard
        nRes = 1;
        break;
    case 50: //Blighter
        nRes = 1;
        break;
    case 51: // Blackcoat
        nRes = 1;
        break;
    case 56: //Mystic Knight
        nRes = 1;
        break;
    default:
        nRes = 0;
        break;
    }
    return nRes;
}

//Returns the gestalt casting class for the spell being cast.
int TE_GetCasterLevel(object oPC, int nClass)
{
    int nCstrLvl = 0;
    int nSpell = GetLastSpell();
    int nDivLvl = TE_DivineCasterLevel(oPC);
    int nArcLvl = TE_ArcaneCasterLevel(oPC);
    int nShad = GetLevelByClass(54,oPC);
    int nMyst = GetLevelByClass(56,oPC);

    if(GetIsPC(oPC) != TRUE || GetIsDMPossessed(oPC) == TRUE)
    {
        return nCstrLvl = GetCasterLevel(oPC);
    }

    if(GetIsDM(oPC) == TRUE)
    {
        return 15;
    }

    object oObject = GetSpellCastItem();
    if(GetIsObjectValid(oObject) == TRUE && (GetBaseItemType(oObject) != BASE_ITEM_MAGICSTAFF || GetBaseItemType(oObject) != BASE_ITEM_MAGICWAND))
    {
        if(GetLocalInt(oObject, "iCasterLvl") == 0)
        {
            nCstrLvl = 5;
            SendMessageToPC(oPC, "Calculated Caster Level: 0, Item Caster Level: 5");
        }
        else
        {
            nCstrLvl = GetLocalInt(oObject,"iCasterLvl");
            SendMessageToPC(oPC, "Calculated Caster Level: " + IntToString(nCstrLvl));
        }
    }
    else
    {
        if(nClass == CLASS_TYPE_INVALID)
        {
            //Warlock
            if(GetLevelByClass(47,oPC) >= 1)
            {
                nClass = 47;
            }
            //Assassin
            else if(GetLevelByClass(30,oPC) >= 1)
            {
                nClass = 30;
            }
            //Blackcoat
            else if(GetLevelByClass(51,oPC) >= 1)
            {
                nClass = 51;
            }
            //Blighter
            else if(GetLevelByClass(50,oPC) >= 1)
            {
                nClass = 50;
            }
            //Harper
            else if(GetLevelByClass(28,oPC) >= 1)
            {
                nClass = 28;
            }
            //Blackguard
            else if(GetLevelByClass(31,oPC) >= 1)
            {
                nClass = 31;
            }
            //Channeler
            else if(GetLevelByClass(49,oPC) >= 1)
            {
                nClass = 49;
            }
            //Shadow Adept
            else if(GetLevelByClass(54,oPC) >= 1)
            {
                nClass = 54;
            }
            //Palemasturu
            else if(GetLevelByClass(34,oPC) >= 1)
            {
                nClass = 34;
            }
            //Artificer
            else if(GetLevelByClass(57,oPC) >= 1)
            {
                nClass = 57;
            }
            //Mystic Knight
            else if(GetLevelByClass(56,oPC) >= 1)
            {
                nClass = 56;
            }
        }

        if (TE_hasGestaltPrec(oPC) == 1)
        {
            nCstrLvl = (nArcLvl + nDivLvl);
        }
        else
        {
            if (TE_ArcaneCasterClass(nClass) == 1)
            {
                nCstrLvl = (nArcLvl + (nDivLvl/2));

            }
            else if (TE_DivineCasterClass(nClass) == 1)
            {
                nCstrLvl = (nDivLvl + (nArcLvl/2));

            }
        }
    }
    int nMod = getHasSpellmastery(oPC,nSpell);
    nCstrLvl = nCstrLvl + nMod;

    WriteTimestampedLogEntry("Caster Level: "+IntToString(nCstrLvl));
    SendMessageToPC(oPC, "Calculated Caster Level: "+IntToString(nCstrLvl));
    return nCstrLvl;
}

int TE_GetSpellSaveDC(object oPC, int nSpell, int nClass)
{
    int nDC = 10;
    //SendMessageToPC(oPC,SFGetSpellInfo(nSpell));
    int nLevel = SFGetInnateSpellLevel(nSpell);
    int nSchool = TE_GetSpellSchool(nSpell);
    int nMod1 = 0;
    int nMod2 = 0;
    int nSpellMasteryBonus = getSpellmasteryEffect(oPC, nSpell);
    int nWeaveMasteryBonus = getSpellmasteryEffect(oPC, nSpell, "Weavemastery");

    // find the Ability Mod
    if((nClass == 2)||
       (nClass == 3)||
       (nClass == 6)||
       (nClass == 7)||
       (nClass == 31)||
       (nClass == 56)||
       (nClass == 50))
    {
        nMod1 = GetAbilityModifier(ABILITY_WISDOM,oPC);
    }
    else if((nClass == 1)||
            (nClass == 9)||
            (nClass == 47))
    {
        nMod1 = GetAbilityModifier(ABILITY_CHARISMA,oPC);
    }
    else if(nClass == 10 ||
            nClass == 57)
    {
        nMod1 = GetAbilityModifier(ABILITY_INTELLIGENCE,oPC);
    }
    // Spell Shool Specialisation mod
    if(nSchool == SPELL_SCHOOL_ABJURATION)
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION,oPC) == TRUE)
        {
            nMod2 = 2;
        }
        else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION,oPC) == TRUE)
        {
            nMod2 = 4;
        }
        else if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION,oPC) == TRUE)
        {
            nMod2 = 6;
        }

    }
    if(nSchool == SPELL_SCHOOL_CONJURATION)
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION,oPC) == TRUE)
        {
            nMod2 = 2;
        }
        else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION,oPC) == TRUE)
        {
            nMod2 = 4;
        }
        else if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION,oPC) == TRUE)
        {
            nMod2 = 6;
        }

    }
    if(nSchool == SPELL_SCHOOL_DIVINATION)
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION,oPC) == TRUE)
        {
            nMod2 = 2;
        }
        else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINATION,oPC) == TRUE)
        {
            nMod2 = 4;
        }
        else if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION,oPC) == TRUE)
        {
            nMod2 = 6;
        }

    }
    if(nSchool == SPELL_SCHOOL_ENCHANTMENT)
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT,oPC) == TRUE)
        {
            nMod2 = 2;
        }
        else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT,oPC) == TRUE)
        {
            nMod2 = 4;
        }
        else if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT,oPC) == TRUE)
        {
            nMod2 = 6;
        }
        if(GetHasFeat(1300,OBJECT_SELF) == TRUE)
        {
            nMod2 = (nMod2+1);
        }

    }
    if(nSchool == SPELL_SCHOOL_EVOCATION)
    {
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION,oPC) == TRUE)
        {
            nMod2 = 2;
        }
        else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION,oPC) == TRUE)
        {
            nMod2 = 4;
        }
        else if (GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION,oPC) == TRUE)
        {
            nMod2 = 6;
        }

        if(GetHasFeat(1300,OBJECT_SELF) == TRUE)
        {
            nMod2 = (nMod2-1);
        }
    }
    if(nSchool == SPELL_SCHOOL_ILLUSION)
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION,oPC) == TRUE)
        {
            nMod2 = 2;
        }
        else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION,oPC) == TRUE)
        {
            nMod2 = 4;
        }
        else if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION,oPC) == TRUE)
        {
            nMod2 = 6;
        }

        if(GetHasFeat(1300,OBJECT_SELF) == TRUE)
        {
            nMod2 = (nMod2+1);
        }
    }
    if(nSchool == SPELL_SCHOOL_NECROMANCY)
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY,oPC) == TRUE)
        {
            nMod2 = 2;
        }
        else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY,oPC) == TRUE)
        {
            nMod2 = 4;
        }
        else if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY,oPC) == TRUE)
        {
            nMod2 = 6;
        }
        if(GetHasFeat(1300,OBJECT_SELF) == TRUE)
        {
            nMod2 = (nMod2+1);
        }
    }
    if(nSchool == SPELL_SCHOOL_TRANSMUTATION)
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION,oPC) == TRUE)
        {
            nMod2 = 2;
        }
        else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION,oPC) == TRUE)
        {
            nMod2 = 4;
        }
        else if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION,oPC) == TRUE)
        {
            nMod2 = 6;
        }

        if(GetHasFeat(1300,OBJECT_SELF) == TRUE)
        {
            nMod2 = (nMod2-1);
        }
    }
    // spell mastery static bonus
    if (nSpellMasteryBonus > 0)
    {
        nMod2 = (nMod2+nSpellMasteryBonus);
//        SendMessageToPC(oPC, "Due to your Mastery of spells your spells are cast at +" +
//                              IntToString(nSpellMasteryBonus) +
//                              " effective caster level and effect targets with a +" +
//                              IntToString(nSpellMasteryBonus) +
//                              " effective DC.");
    }

    // weavemastery static bonus
    if (nWeaveMasteryBonus > 0)
    {
        nMod2 = (nMod2+nWeaveMasteryBonus);
 //       SendMessageToPC(oPC, "Your spells are cast at +" +
 //                             IntToString(nWeaveMasteryBonus) +
 //                             " effective caster level and effect targets with a +" +
 //                             IntToString(nWeaveMasteryBonus) +
 //                             " effective DC.");
    }
    int nReturn = (nDC + nLevel + nMod1 + nMod2);

/*
    SendMessageToPC(oPC, "Basemod: " + IntToString(nDC) + " + " +
                         "Spell level: " + IntToString(nLevel) + " + " +
                         "Int mod: " + IntToString(nMod1) + " + " +
                         IntToString(nMod2)+ " = " +
                         IntToString(nReturn));
*/
    return nReturn;
}

//Returns whether a character has a background feat.
int GetHasBackground(object oPC)
{
    if(GetHasFeat(1153,oPC) == TRUE)      {return TRUE;}
    else if(GetHasFeat(1154,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1155,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1156,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1157,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1158,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1159,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1160,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1161,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1162,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1163,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1164,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1165,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1166,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1167,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1168,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1169,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1170,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1171,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1172,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1173,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1174,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1185,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1389,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1390,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1391,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1392,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1393,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1394,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1395,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1396,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1397,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1398,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1399,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1400,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1401,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1460,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1461,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1462,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1463,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1464,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1465,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1466,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1467,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1468,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1469,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1470,oPC) == TRUE) {return TRUE;}
    else if(GetHasFeat(1471,oPC) == TRUE) {return TRUE;}
    else
    {
        return FALSE;
    }
}

// Returns if the class int is a PRC
int GetIsClassPRC(int nClass)
{
    int iPRC = 0;

    switch (nClass)
    {
        case 27:
        case 28:
        case 29:
        case 30:
        case 31:
        case 32:
        case 33:
        case 34:
        case 35:
        case 36:
        case 37:
        case 41:
        case 49:
        case 50:
        case 51:
        case 52:
        case 53:
        case 54:
        case 55:
        {
            iPRC = 1;
        }
        default:
        {
            iPRC = 0;
        }
    }

    if (iPRC == 1)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }

}


int TE_hasGestaltPrec(object oPc){
    // checking for deities of magic
    if(GetHasFeat(1326, oPc))
    {
        return 1;
    }
    // check for next deity
    else if(GetHasFeat(1306, oPc))
    {
        return 1;
    }
    else if(GetHasFeat(1347, oPc))
    {
        return 1;
    }
    else if(GetHasFeat(1351, oPc))
    {
        return 1;
    }
    else if(GetHasFeat(1300, oPc))
    {
        return 1;
    }
    // no special gestalting rules will apply
    else
    {
        return 0;
    }
}

int getHasSpellmastery(object oPC, int nSpell, string sSpecCase = "")
{
    //SendMessageToPC(oPC, "getHasspellmastery");
    string sSchool =  SFGetSpellSchoolName(nSpell);
    int nLevel = SFGetInnateSpellLevel(nSpell);
    int nMastery = 0;
    int nBonus = getSpellmasteryEffect(oPC, nSpell);
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    if (sSpecCase != ""){sSchool = sSpecCase;}
    if(GetLocalInt(oItem, sSchool) != 0){nMastery = GetLocalInt(oItem, sSchool);}
    if ((nMastery / 10) >= nLevel)
    {
        return 1;

    }
    return 0;
}

int getSpellmastery(object oPC, int nSpell, string sSpecCase = "")
{
    int nSchool = TE_GetSpellSchool(nSpell);
    string sSchool =  SFGetSpellSchoolName(nSchool);
   // SendMessageToPC(oPC,"get spellmastery for School: " + sSchool);
    if (sSpecCase == "Weavemastery"){sSchool = sSpecCase;}
    if (sSpecCase == "Wildmagic"){sSchool = sSpecCase;}
    int nMastery = 0;
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    if(GetLocalInt(oItem, sSchool) != 0)
    {
        nMastery = GetLocalInt(oItem, sSchool);
//        SendMessageToPC(oPC,"You Have Mastery in the School " + sSchool);
    }
    else
    {
//        SendMessageToPC(oPC,"You do not have Mastery in the School " + sSchool);
    }
    return nMastery;
}

/*
mastery under 30%       +1 DC & CL Hedgemage
 30- 60%    +2 DC & CL Vizier Rank/Attuned Item
 60-99% +3 DC & CL Archmage
 100%       +4 DC & CL Hierophant
*/

int getSpellmasteryEffect(object oPC, int nSpell, string sSpecCase = "")
{
//    SendMessageToPC(oPC, " getspellmastery effect");
    int nRank = 0;
    int nMasteryLevel = getSpellmastery(oPC, nSpell, sSpecCase);
    if ((sSpecCase == "Weavemastery") && (nMasteryLevel == 100)){return 2;}
    if (nMasteryLevel >= 1){nRank = 1;}
    if (nMasteryLevel >= 30){nRank = 2;}
    if (nMasteryLevel >= 60){nRank = 3;}
    if (nMasteryLevel == 100){nRank = 4;}
//    SendMessageToPC(oPC, "Spellmastery Rank = " + IntToString(nRank));
    return nRank;
}


string GetItemTypeGeneralName(object oItem)
{
    string sType = "Item";
    if (GetBaseItemType(oItem) == BASE_ITEM_ARMOR)           { sType="Armor";}
    if (GetBaseItemType(oItem) == BASE_ITEM_AMULET)          { sType="Amulet";}
    if (GetBaseItemType(oItem) == BASE_ITEM_ARROW)           { sType="Ammo";}
    if (GetBaseItemType(oItem) == BASE_ITEM_BASTARDSWORD)    { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_BATTLEAXE)       { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_BELT)            { sType="Belt";}
    if (GetBaseItemType(oItem) == BASE_ITEM_BOLT) {sType="Ammo";}
    if (GetBaseItemType(oItem) == BASE_ITEM_BOOTS) { sType="Boots";}
    if (GetBaseItemType(oItem) == BASE_ITEM_BRACER) { sType="Bracer";}
    if (GetBaseItemType(oItem) == BASE_ITEM_BULLET) {sType="Ammo";}
    if (GetBaseItemType(oItem) == BASE_ITEM_CLOAK) { sType="Cloak";}
    if (GetBaseItemType(oItem) == BASE_ITEM_CLUB) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_DAGGER) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_DART) { sType="Ammo";}
    if (GetBaseItemType(oItem) == BASE_ITEM_DIREMACE) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_DOUBLEAXE) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_DWARVENWARAXE) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_GREATAXE) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_GREATSWORD) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_HALBERD) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_HANDAXE) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_HEAVYCROSSBOW) { sType="Ranged";}
    if (GetBaseItemType(oItem) == BASE_ITEM_HEAVYFLAIL) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_HELMET) { sType="Helm";}
    if (GetBaseItemType(oItem) == BASE_ITEM_KAMA) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_KATANA) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_KUKRI) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_LARGESHIELD) { sType="Shield";}
    if (GetBaseItemType(oItem) == BASE_ITEM_LIGHTCROSSBOW) { sType="Ranged";}
    if (GetBaseItemType(oItem) == BASE_ITEM_LIGHTFLAIL) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_LIGHTHAMMER) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_LIGHTMACE) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_LONGBOW) { sType="Ranged";}
    if (GetBaseItemType(oItem) == BASE_ITEM_LONGSWORD) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_MAGICROD) { sType="Rod";}
    if (GetBaseItemType(oItem) == BASE_ITEM_MAGICSTAFF) { sType="Staff";}
    if (GetBaseItemType(oItem) == BASE_ITEM_MAGICWAND) { sType="Wand";}
    if (GetBaseItemType(oItem) == BASE_ITEM_MORNINGSTAR) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_QUARTERSTAFF) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_RAPIER) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_RING) { sType="Jewelry";}
    if (GetBaseItemType(oItem) == BASE_ITEM_SCIMITAR) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_SCYTHE) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_SHORTBOW) { sType="Ranged";}
    if (GetBaseItemType(oItem) == BASE_ITEM_SHORTSPEAR) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_SHORTSWORD) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_SHURIKEN) { sType="Ammo";}
    if (GetBaseItemType(oItem) == BASE_ITEM_SICKLE) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_SLING) { sType="Ranged";}
    if (GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD) { sType="Shield";}
    if (GetBaseItemType(oItem) == BASE_ITEM_THROWINGAXE) { sType="Ammo";}
    if (GetBaseItemType(oItem) == BASE_ITEM_TOWERSHIELD) { sType="Shield";}
    if (GetBaseItemType(oItem) == BASE_ITEM_TRIDENT) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_TWOBLADEDSWORD) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_WARHAMMER) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_WHIP) { sType="Weapon";}
    if (GetBaseItemType(oItem) == BASE_ITEM_ENCHANTED_POTION) sType ="Potion";
    if (GetBaseItemType(oItem) == BASE_ITEM_ENCHANTED_SCROLL) sType ="Scroll";
    if (GetBaseItemType(oItem) == BASE_ITEM_SPELLSCROLL) sType = "Scroll";
    if (GetBaseItemType(oItem) == BASE_ITEM_GEM) sType = "Gem";
    if (GetBaseItemType(oItem) == BASE_ITEM_MISCLARGE)  sType = "Item";
    if (GetBaseItemType(oItem) == BASE_ITEM_MISCMEDIUM) sType = "Item";
    if (GetBaseItemType(oItem) == BASE_ITEM_MISCTALL) sType = "Item";
    if (GetBaseItemType(oItem) == BASE_ITEM_MISCTHIN) sType = "Item";
    if (GetBaseItemType(oItem) == BASE_ITEM_MISCWIDE) sType = "Item";
    if (GetBaseItemType(oItem) == BASE_ITEM_SCROLL) sType = "Scroll";

    return sType;
}

int TE_GetSpellSchool(int nSpell)
{
    int nResult = 0;
    switch(nSpell)
    {
        case 0: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 1: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 2: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 3: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 4: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 5: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 6: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 7: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 8: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 9: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 10: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 11: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 12: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 13: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 14: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 15: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 16: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 17: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 18: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 19: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 20: nResult = SPELL_SCHOOL_DIVINATION; break;
        case 21: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 22: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 23: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 24: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 25: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 26: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 27: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 28: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 29: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 30: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 31: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 32: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 33: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 34: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 35: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 36: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 37: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 38: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 39: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 40: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 41: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 42: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 43: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 44: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 45: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 46: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 47: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 48: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 49: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 50: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 51: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 52: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 53: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 54: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 55: nResult = SPELL_SCHOOL_DIVINATION; break;
        case 56: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 57: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 58: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 59: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 60: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 61: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 62: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 63: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 64: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 65: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 66: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 67: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 68: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 69: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 70: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 71: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 72: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 73: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 74: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 75: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 76: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 77: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 78: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 79: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 80: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 81: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 82: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 83: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 84: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 85: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 86: nResult = SPELL_SCHOOL_DIVINATION; break;
        case 87: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 88: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 89: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 90: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 91: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 92: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 93: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 94: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 95: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 96: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 97: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 98: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 99: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 100: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 101: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 102: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 103: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 104: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 105: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 106: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 107: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 108: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 109: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 110: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 111: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 112: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 113: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 114: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 115: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 116: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 117: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 118: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 119: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 120: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 121: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 122: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 123: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 124: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 125: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 126: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 127: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 128: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 129: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 130: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 131: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 132: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 133: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 134: nResult = SPELL_SCHOOL_DIVINATION; break;
        case 135: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 136: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 137: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 138: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 139: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 140: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 141: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 142: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 143: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 144: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 145: nResult = SPELL_SCHOOL_DIVINATION; break;
        case 146: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 147: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 148: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 149: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 150: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 151: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 152: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 153: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 154: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 155: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 156: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 157: nResult = SPELL_SCHOOL_DIVINATION; break;
        case 158: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 159: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 160: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 161: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 162: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 163: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 164: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 165: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 166: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 167: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 168: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 169: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 170: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 171: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 172: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 173: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 174: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 175: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 176: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 177: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 178: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 179: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 180: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 181: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 182: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 183: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 184: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 185: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 186: nResult = SPELL_SCHOOL_DIVINATION; break;
        case 187: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 188: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 189: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 190: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 191: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 192: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 193: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 194: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 195: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 196: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 197: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 198: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 199: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 200: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 201: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 202: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 203: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 204: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 205: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 206: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 207: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 208: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 209: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 210: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 211: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 212: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 213: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 214: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 215: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 216: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 217: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 218: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 219: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 220: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 221: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 222: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 223: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 224: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 225: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 226: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 227: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 228: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 229: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 230: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 231: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 232: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 233: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 234: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 235: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 236: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 237: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 238: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 239: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 240: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 241: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 242: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 243: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 244: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 245: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 246: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 247: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 248: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 249: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 250: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 251: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 252: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 253: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 254: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 255: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 256: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 257: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 258: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 259: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 260: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 261: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 262: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 263: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 264: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 265: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 266: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 267: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 268: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 269: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 270: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 271: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 272: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 273: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 274: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 275: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 276: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 277: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 278: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 279: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 280: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 281: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 282: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 283: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 284: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 285: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 286: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 287: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 288: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 289: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 290: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 291: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 292: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 293: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 294: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 295: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 296: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 297: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 298: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 299: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 300: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 301: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 302: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 303: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 304: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 305: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 306: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 307: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 308: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 309: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 310: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 311: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 312: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 313: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 314: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 315: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 316: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 317: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 318: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 319: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 320: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 321: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 322: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 323: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 324: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 325: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 326: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 327: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 328: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 329: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 330: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 331: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 332: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 333: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 334: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 335: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 336: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 337: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 338: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 339: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 340: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 341: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 342: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 343: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 344: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 345: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 346: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 347: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 348: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 349: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 350: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 351: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 352: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 353: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 354: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 355: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 356: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 357: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 358: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 359: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 360: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 361: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 362: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 363: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 364: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 365: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 366: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 367: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 368: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 369: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 370: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 371: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 372: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 373: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 374: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 375: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 376: nResult = SPELL_SCHOOL_DIVINATION; break;
        case 377: nResult = SPELL_SCHOOL_DIVINATION; break;
        case 378: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 379: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 380: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 381: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 382: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 383: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 384: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 385: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 386: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 387: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 388: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 389: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 390: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 391: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 392: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 393: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 394: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 395: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 396: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 397: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 398: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 399: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 400: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 401: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 402: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 403: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 404: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 405: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 406: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 407: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 408: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 409: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 410: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 411: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 412: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 413: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 414: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 415: nResult = SPELL_SCHOOL_DIVINATION; break;
        case 416: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 417: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 418: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 419: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 420: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 421: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 422: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 423: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 424: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 425: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 426: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 427: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 428: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 429: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 430: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 431: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 432: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 433: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 434: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 435: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 436: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 437: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 438: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 439: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 440: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 441: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 442: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 443: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 444: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 445: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 446: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 447: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 448: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 449: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 450: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 451: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 452: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 453: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 454: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 455: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 456: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 457: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 458: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 459: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 460: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 461: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 462: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 463: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 464: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 465: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 466: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 467: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 468: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 469: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 470: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 471: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 472: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 473: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 474: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 475: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 476: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 477: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 478: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 479: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 480: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 481: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 482: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 483: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 484: nResult = SPELL_SCHOOL_GENERAL; break;
        case 485: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 486: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 487: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 488: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 489: nResult = SPELL_SCHOOL_GENERAL; break;
        case 490: nResult = SPELL_SCHOOL_GENERAL; break;
        case 491: nResult = SPELL_SCHOOL_GENERAL; break;
        case 492: nResult = SPELL_SCHOOL_GENERAL; break;
        case 493: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 494: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 495: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 496: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 497: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 498: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 499: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 500: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 501: nResult = SPELL_SCHOOL_GENERAL; break;
        case 502: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 503: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 504: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 505: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 506: nResult = SPELL_SCHOOL_GENERAL; break;
        case 507: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 508: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 509: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 510: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 511: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 512: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 513: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 514: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 515: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 516: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 517: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 518: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 519: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 520: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 521: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 522: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 523: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 524: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 525: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 526: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 527: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 528: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 529: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 530: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 531: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 532: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 533: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 534: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 535: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 536: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 537: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 538: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 539: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 540: nResult = SPELL_SCHOOL_GENERAL; break;
        case 541: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 542: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 543: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 544: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 545: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 546: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 547: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 548: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 549: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 550: nResult = SPELL_SCHOOL_GENERAL; break;
        case 551: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 552: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 553: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 554: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 555: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 556: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 557: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 558: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 559: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 560: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 561: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 562: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 563: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 564: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 565: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 566: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 567: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 568: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 569: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 570: nResult = SPELL_SCHOOL_GENERAL; break;
        case 571: nResult = SPELL_SCHOOL_GENERAL; break;
        case 572: nResult = SPELL_SCHOOL_GENERAL; break;
        case 573: nResult = SPELL_SCHOOL_GENERAL; break;
        case 574: nResult = SPELL_SCHOOL_GENERAL; break;
        case 575: nResult = SPELL_SCHOOL_GENERAL; break;
        case 576: nResult = SPELL_SCHOOL_GENERAL; break;
        case 577: nResult = SPELL_SCHOOL_GENERAL; break;
        case 578: nResult = SPELL_SCHOOL_GENERAL; break;
        case 579: nResult = SPELL_SCHOOL_GENERAL; break;
        case 580: nResult = SPELL_SCHOOL_GENERAL; break;
        case 581: nResult = SPELL_SCHOOL_GENERAL; break;
        case 582: nResult = SPELL_SCHOOL_GENERAL; break;
        case 583: nResult = SPELL_SCHOOL_GENERAL; break;
        case 584: nResult = SPELL_SCHOOL_GENERAL; break;
        case 585: nResult = SPELL_SCHOOL_GENERAL; break;
        case 586: nResult = SPELL_SCHOOL_GENERAL; break;
        case 587: nResult = SPELL_SCHOOL_GENERAL; break;
        case 588: nResult = SPELL_SCHOOL_GENERAL; break;
        case 589: nResult = SPELL_SCHOOL_GENERAL; break;
        case 590: nResult = SPELL_SCHOOL_GENERAL; break;
        case 591: nResult = SPELL_SCHOOL_GENERAL; break;
        case 592: nResult = SPELL_SCHOOL_GENERAL; break;
        case 593: nResult = SPELL_SCHOOL_GENERAL; break;
        case 594: nResult = SPELL_SCHOOL_GENERAL; break;
        case 595: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 596: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 597: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 598: nResult = SPELL_SCHOOL_GENERAL; break;
        case 599: nResult = SPELL_SCHOOL_GENERAL; break;
        case 600: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 601: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 602: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 603: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 604: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 605: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 606: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 607: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 608: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 609: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 610: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 611: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 612: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 613: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 614: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 615: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 616: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 617: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 618: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 619: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 620: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 621: nResult = SPELL_SCHOOL_GENERAL; break;
        case 622: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 623: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 624: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 625: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 626: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 627: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 628: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 629: nResult = SPELL_SCHOOL_GENERAL; break;
        case 630: nResult = SPELL_SCHOOL_GENERAL; break;
        case 631: nResult = SPELL_SCHOOL_GENERAL; break;
        case 632: nResult = SPELL_SCHOOL_GENERAL; break;
        case 633: nResult = SPELL_SCHOOL_GENERAL; break;
        case 634: nResult = SPELL_SCHOOL_GENERAL; break;
        case 635: nResult = SPELL_SCHOOL_GENERAL; break;
        case 636: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 637: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 638: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 639: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 640: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 641: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 642: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 643: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 644: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 645: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 646: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 647: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 648: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 649: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 650: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 651: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 652: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 653: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 654: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 655: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 656: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 657: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 658: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 659: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 660: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 661: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 662: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 663: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 664: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 665: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 666: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 667: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 668: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 669: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 670: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 671: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 672: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 673: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 674: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 675: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 676: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 677: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 678: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 679: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 680: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 681: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 682: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 683: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 684: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 685: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 686: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 687: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 688: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 689: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 690: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 691: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 692: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 693: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 694: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 695: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 696: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 697: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 698: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 699: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 700: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 701: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 702: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 703: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 704: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 705: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 706: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 707: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 708: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 709: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 710: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 711: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 712: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 713: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 714: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 715: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 716: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 717: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 718: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 719: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 720: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 721: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 722: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 723: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 724: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 725: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 726: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 727: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 728: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 729: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 730: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 731: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 732: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 733: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 734: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 735: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 736: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 737: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 738: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 739: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 740: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 741: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 742: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 743: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 744: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 745: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 746: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 747: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 748: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 749: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 750: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 751: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 752: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 753: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 754: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 755: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 756: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 757: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 758: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 759: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 760: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 761: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 762: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 763: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 764: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 765: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 766: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 767: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 768: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 769: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 770: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 771: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 772: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 773: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 774: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 775: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 776: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 777: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 778: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 779: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 780: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 781: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 782: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 783: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 784: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 785: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 786: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 787: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 788: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 789: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 790: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 791: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 792: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 793: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 794: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 795: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 796: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 797: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 798: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 799: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 800: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 801: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 802: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 803: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 804: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 805: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 806: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 807: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 808: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 809: nResult = SPELL_SCHOOL_DIVINATION; break;
        case 810: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 811: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 812: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 813: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 814: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 815: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 816: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 817: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 818: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 819: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 820: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 821: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 822: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 823: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 824: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 825: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 826: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 827: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 828: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 829: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 830: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 831: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 832: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 833: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 834: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 835: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 836: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 837: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 838: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 839: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 840: nResult = SPELL_SCHOOL_GENERAL; break;
        case 841: nResult = SPELL_SCHOOL_GENERAL; break;
        case 842: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 843: nResult = SPELL_SCHOOL_GENERAL; break;
        case 844: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 845: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 846: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 847: nResult = SPELL_SCHOOL_GENERAL; break;
        case 848: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 849: nResult = SPELL_SCHOOL_GENERAL; break;
        case 850: nResult = SPELL_SCHOOL_GENERAL; break;
        case 851: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 852: nResult = SPELL_SCHOOL_GENERAL; break;
        case 853: nResult = SPELL_SCHOOL_GENERAL; break;
        case 854: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 855: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 856: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 857: nResult = SPELL_SCHOOL_GENERAL; break;
        case 858: nResult = SPELL_SCHOOL_DIVINATION; break;
        case 859: nResult = SPELL_SCHOOL_GENERAL; break;
        case 860: nResult = SPELL_SCHOOL_GENERAL; break;
        case 861: nResult = SPELL_SCHOOL_GENERAL; break;
        case 862: nResult = SPELL_SCHOOL_GENERAL; break;
        case 863: nResult = SPELL_SCHOOL_GENERAL; break;
        case 864: nResult = SPELL_SCHOOL_GENERAL; break;
        case 865: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 866: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 867: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 868: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 869: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 870: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 871: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 872: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 873: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 874: nResult = SPELL_SCHOOL_GENERAL; break;
        case 875: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 876: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 877: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 878: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 879: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 880: nResult = SPELL_SCHOOL_GENERAL; break;
        case 881: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 882: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 883: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 884: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 885: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 886: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 887: nResult = SPELL_SCHOOL_GENERAL; break;
        case 888: nResult = SPELL_SCHOOL_GENERAL; break;
        case 889: nResult = SPELL_SCHOOL_GENERAL; break;
        case 890: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 891: nResult = SPELL_SCHOOL_GENERAL; break;
        case 892: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 893: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 894: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 895: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 896: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 897: nResult = SPELL_SCHOOL_GENERAL; break;
        case 898: nResult = SPELL_SCHOOL_GENERAL; break;
        case 899: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 900: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 901: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 902: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 903: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 904: nResult = SPELL_SCHOOL_GENERAL; break;
        case 905: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 906: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 907: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 908: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 909: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 910: nResult = SPELL_SCHOOL_GENERAL; break;
        case 911: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 912: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 913: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 914: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 915: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 916: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 917: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 918: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 919: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 920: nResult = SPELL_SCHOOL_GENERAL; break;
        case 921: nResult = SPELL_SCHOOL_GENERAL; break;
        case 922: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 923: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 924: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 925: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 926: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 927: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 928: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 929: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 930: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 931: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 932: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 933: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 934: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 935: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 936: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 937: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 938: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 939: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 940: nResult = SPELL_SCHOOL_GENERAL; break;
        case 941: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 942: nResult = SPELL_SCHOOL_GENERAL; break;
        case 943: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 944: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 945: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 946: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 947: nResult = SPELL_SCHOOL_GENERAL; break;
        case 948: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 949: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 950: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 951: nResult = SPELL_SCHOOL_GENERAL; break;
        case 952: nResult = SPELL_SCHOOL_GENERAL; break;
        case 953: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 954: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 955: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 956: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 957: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 958: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 959: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 960: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 961: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 962: nResult = SPELL_SCHOOL_GENERAL; break;
        case 963: nResult = SPELL_SCHOOL_GENERAL; break;
        case 964: nResult = SPELL_SCHOOL_GENERAL; break;
        case 965: nResult = SPELL_SCHOOL_GENERAL; break;
        case 966: nResult = SPELL_SCHOOL_GENERAL; break;
        case 967: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 968: nResult = SPELL_SCHOOL_GENERAL; break;
        case 969: nResult = SPELL_SCHOOL_GENERAL; break;
        case 970: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 971: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 972: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 973: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 974: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 975: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 976: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 977: nResult = SPELL_SCHOOL_NECROMANCY; break;
        case 978: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 979: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 980: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 981: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 982: nResult = SPELL_SCHOOL_TRANSMUTATION; break;
        case 983: nResult = SPELL_SCHOOL_GENERAL; break;
        case 984: nResult = SPELL_SCHOOL_CONJURATION; break;
        case 985: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 986: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 987: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 988: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 989: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 990: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 991: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 992: nResult = SPELL_SCHOOL_EVOCATION; break;
        case 993: nResult = SPELL_SCHOOL_ILLUSION; break;
        case 994: nResult = SPELL_SCHOOL_ENCHANTMENT; break;
        case 995: nResult = SPELL_SCHOOL_GENERAL; break;
        case 996: nResult = SPELL_SCHOOL_GENERAL; break;
        case 997: nResult = SPELL_SCHOOL_GENERAL; break;
        case 998: nResult = SPELL_SCHOOL_ABJURATION; break;
        case 999: nResult = SPELL_SCHOOL_GENERAL; break;
        case 1000: nResult = SPELL_SCHOOL_NECROMANCY; break;


        default: nResult =0; break;

    }
    return nResult;
}

int TE_GetDeity(object oPC)
{
    if (GetHasFeat(DEITY_Akadi,oPC) == TRUE)
    {
        return DEITY_Akadi;
    }
    else if (GetHasFeat(DEITY_Amaunator,oPC) == TRUE)
    {
        return DEITY_Amaunator;
    }
    else if (GetHasFeat(DEITY_Auril,oPC) == TRUE)
    {
        return DEITY_Auril;
    }
    else if (GetHasFeat(DEITY_Bane,oPC) == TRUE)
    {
        return DEITY_Bane;
    }
    else if (GetHasFeat(DEITY_Beshaba,oPC) == TRUE)
    {
        return DEITY_Beshaba;
    }
    else if (GetHasFeat(DEITY_Bhaal,oPC) == TRUE)
    {
        return DEITY_Bhaal;
    }
    else if (GetHasFeat(DEITY_Chauntea,oPC) == TRUE)
    {
        return DEITY_Chauntea;
    }
    else if (GetHasFeat(DEITY_Cyric,oPC) == TRUE)
    {
        return DEITY_Cyric;
    }
    else if (GetHasFeat(DEITY_Deneir,oPC) == TRUE)
    {
        return DEITY_Deneir;
    }
    else if (GetHasFeat(DEITY_Dwarven_Powers,oPC) == TRUE)
    {
        return DEITY_Dwarven_Powers;
    }
    else if (GetHasFeat(DEITY_Eldath,oPC) == TRUE)
    {
        return DEITY_Eldath;
    }
    else if (GetHasFeat(DEITY_Elven_Powers,oPC) == TRUE)
    {
        return DEITY_Elven_Powers;
    }
    else if (GetHasFeat(DEITY_Finder_Wyvernspur,oPC) == TRUE)
    {
        return DEITY_Finder_Wyvernspur;
    }
    else if (GetHasFeat(DEITY_Garagos,oPC) == TRUE)
    {
        return DEITY_Garagos;
    }
    else if (GetHasFeat(DEITY_Gargauth,oPC) == TRUE)
    {
        return DEITY_Gargauth;
    }
    else if (GetHasFeat(DEITY_Gnomish_Powers,oPC) == TRUE)
    {
        return DEITY_Gnomish_Powers;
    }
    else if (GetHasFeat(DEITY_Gond,oPC) == TRUE)
    {
        return DEITY_Gond;
    }
    else if (GetHasFeat(DEITY_Grumbar,oPC) == TRUE)
    {
        return DEITY_Grumbar;
    }
    else if (GetHasFeat(DEITY_Gwaeron_Windstrom,oPC) == TRUE)
    {
        return DEITY_Gwaeron_Windstrom;
    }
    else if (GetHasFeat(DEITY_Halfling_Powers,oPC) == TRUE)
    {
        return DEITY_Halfling_Powers;
    }
    else if (GetHasFeat(DEITY_Helm,oPC) == TRUE)
    {
        return DEITY_Helm;
    }
    else if (GetHasFeat(DEITY_Hoar,oPC) == TRUE)
    {
        return DEITY_Hoar;
    }
    else if (GetHasFeat(DEITY_Ibrandul,oPC) == TRUE)
    {
        return DEITY_Ibrandul;
    }
    else if (GetHasFeat(DEITY_Ilmater,oPC) == TRUE)
    {
        return DEITY_Ilmater;
    }
    else if (GetHasFeat(DEITY_Ishtisha,oPC) == TRUE)
    {
        return DEITY_Ishtisha;
    }
    else if (GetHasFeat(DEITY_Jergal,oPC) == TRUE)
    {
        return DEITY_Jergal;
    }
    else if (GetHasFeat(DEITY_Karsus,oPC) == TRUE)
    {
        return DEITY_Karsus;
    }
    else if (GetHasFeat(DEITY_Kelemvor,oPC) == TRUE)
    {
        return DEITY_Kelemvor;
    }
    else if (GetHasFeat(DEITY_Kossuth,oPC) == TRUE)
    {
        return DEITY_Kossuth;
    }
    else if (GetHasFeat(DEITY_Lathander,oPC) == TRUE)
    {
        return DEITY_Lathander;
    }
    else if (GetHasFeat(DEITY_Leira,oPC) == TRUE)
    {
        return DEITY_Leira;
    }
    else if (GetHasFeat(DEITY_Lliira,oPC) == TRUE)
    {
        return DEITY_Lliira;
    }
    else if (GetHasFeat(DEITY_Loviatar,oPC) == TRUE)
    {
        return DEITY_Loviatar;
    }
    else if (GetHasFeat(DEITY_Lurue,oPC) == TRUE)
    {
        return DEITY_Lurue;
    }
    else if (GetHasFeat(DEITY_Malar,oPC) == TRUE)
    {
        return DEITY_Malar;
    }
    else if (GetHasFeat(DEITY_Mask,oPC) == TRUE)
    {
        return DEITY_Mask;
    }
    else if (GetHasFeat(DEITY_Mielikki,oPC) == TRUE)
    {
        return DEITY_Mielikki;
    }
    else if (GetHasFeat(DEITY_Milil,oPC) == TRUE)
    {
        return DEITY_Milil;
    }
    else if (GetHasFeat(DEITY_Moander,oPC) == TRUE)
    {
        return DEITY_Moander;
    }
    else if (GetHasFeat(DEITY_Myrkul,oPC) == TRUE)
    {
        return DEITY_Myrkul;
    }
    else if (GetHasFeat(DEITY_Mystra,oPC) == TRUE)
    {
        return DEITY_Mystra;
    }
    else if (GetHasFeat(DEITY_Nobanion,oPC) == TRUE)
    {
        return DEITY_Nobanion;
    }
    else if (GetHasFeat(DEITY_Oghma,oPC) == TRUE)
    {
        return DEITY_Oghma;
    }
    else if (GetHasFeat(DEITY_Orcish_Powers,oPC) == TRUE)
    {
        return DEITY_Orcish_Powers;
    }
    else if (GetHasFeat(DEITY_Red_Knight,oPC) == TRUE)
    {
        return DEITY_Red_Knight;
    }
    else if (GetHasFeat(DEITY_Savras,oPC) == TRUE)
    {
        return DEITY_Savras;
    }
    else if (GetHasFeat(DEITY_Selune,oPC) == TRUE)
    {
        return DEITY_Selune;
    }
    else if (GetHasFeat(DEITY_Shar,oPC) == TRUE)
    {
        return DEITY_Shar;
    }
    else if (GetHasFeat(DEITY_Sharess,oPC) == TRUE)
    {
        return DEITY_Sharess;
    }
    else if (GetHasFeat(DEITY_Shaundakul,oPC) == TRUE)
    {
        return DEITY_Shaundakul;
    }
    else if (GetHasFeat(DEITY_Shiallia,oPC) == TRUE)
    {
        return DEITY_Shiallia;
    }
    else if (GetHasFeat(DEITY_Siamorphe,oPC) == TRUE)
    {
        return DEITY_Siamorphe;
    }
    else if (GetHasFeat(DEITY_Silvanus,oPC) == TRUE)
    {
        return DEITY_Silvanus;
    }
    else if (GetHasFeat(DEITY_Sune,oPC) == TRUE)
    {
        return DEITY_Sune;
    }
    else if (GetHasFeat(DEITY_Talona,oPC) == TRUE)
    {
        return DEITY_Talona;
    }
    else if (GetHasFeat(DEITY_Talos,oPC) == TRUE)
    {
        return DEITY_Talos;
    }
    else if (GetHasFeat(DEITY_Tempus,oPC) == TRUE)
    {
        return DEITY_Tempus;
    }
    else if (GetHasFeat(DEITY_Torm,oPC) == TRUE)
    {
        return DEITY_Torm;
    }
    else if (GetHasFeat(DEITY_Tymora,oPC) == TRUE)
    {
        return DEITY_Tymora;
    }
    else if (GetHasFeat(DEITY_Tyr,oPC) == TRUE)
    {
        return DEITY_Tyr;
    }
    else if (GetHasFeat(DEITY_Ulutiu,oPC) == TRUE)
    {
        return DEITY_Ulutiu;
    }
    else if (GetHasFeat(DEITY_Umberlee,oPC) == TRUE)
    {
        return DEITY_Umberlee;
    }
    else if (GetHasFeat(DEITY_Underdark_Powers,oPC) == TRUE)
    {
        return DEITY_Underdark_Powers;
    }
    else if (GetHasFeat(DEITY_Valkur,oPC) == TRUE)
    {
        return DEITY_Valkur;
    }
    else if (GetHasFeat(DEITY_Velsharoon,oPC) == TRUE)
    {
        return DEITY_Velsharoon;
    }
    else if (GetHasFeat(DEITY_Waukeen,oPC) == TRUE)
    {
        return DEITY_Waukeen;
    }
    else if (GetHasFeat(DEITY_Xvim,oPC) == TRUE)
    {
        return DEITY_Xvim;
    }
    else
    {
        return 0;
    }
}

//Gets faction creature and adjusts reputation.
void ChangeFactionReputation(object oPC, string sFaction, int nReputation)
{
    object oFaction = GetObjectByTag(sFaction);
    AdjustReputation(oPC,oFaction,nReputation);
}

void TE_Faction_Fix(object oPC)
{
    int nUndead = GetIsUndead(oPC);
    object oInsig = GetItemPossessedBy(oPC,"te_insignia");
    string sSettlement = GetLocalString(oInsig,"Settlement");

    if(nUndead == 1)
    {
        ChangeFactionReputation(oPC,FACTION_RESTUNDEAD,-100);
        ChangeFactionReputation(oPC,FACTION_RESTUNDEAD,50);
        ChangeFactionReputation(oPC,FACTION_HUNGUNDEAD,-100);
        ChangeFactionReputation(oPC,FACTION_HUNGUNDEAD,50);
    }

    if(sSettlement == "sLock")
    {
        ChangeFactionReputation(oPC,FACTION_KEEP_LOCKCOM,100);
        ChangeFactionReputation(oPC,FACTION_KEEP_LOCKDEF,100);
    }
    if(sSettlement == "sBrost")
    {
        ChangeFactionReputation(oPC,FACTION_KEEP_BROSTCOM,100);
        ChangeFactionReputation(oPC,FACTION_KEEP_BROSTDEF,100);
    }
    if(sSettlement == "sTejarn")
    {
        ChangeFactionReputation(oPC,FACTION_KEEP_TEJARNCOM,100);
        ChangeFactionReputation(oPC,FACTION_KEEP_TEJARNDEF,100);
    }
    if(sSettlement == "sSwamp")
    {
        ChangeFactionReputation(oPC,FACTION_KEEP_SWAMPCOM,100);
        ChangeFactionReputation(oPC,FACTION_KEEP_SWAMPDEF,100);
    }
    if(sSettlement == "sSpire")
    {
        ChangeFactionReputation(oPC,FACTION_KEEP_SOUTHCOM,100);
        ChangeFactionReputation(oPC,FACTION_KEEP_SOUTHDEF,100);
    }
}

int TE_getThirtyFeetExtraSpellDamage(object oCaster, int nIsAware)
{
    int nRogueLVL = GetLevelByClass(CLASS_TYPE_ROGUE, oCaster);
    int nBlackGuardLVL = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oCaster);
    int nAssasinLVL = GetLevelByClass(CLASS_TYPE_ASSASSIN, oCaster);
    int nDamageDice = 0;
    int nDamage = 0;

    if(GetHasFeat(FEAT_POINT_BLANK_SHOT, oCaster))
    {
        nDamage = 1;
    }
    //if target is not aware of danger.
    if(nIsAware == 0)
    {
        // calculating extra damage dice
        nDamageDice = nRogueLVL/2;
        nDamageDice = nDamageDice + nBlackGuardLVL/2;
        nDamageDice = nDamageDice + nAssasinLVL/2;
        // calculating extra damage
        nDamage = nDamage + d6(nDamageDice);
    }
    return nDamage;
}


