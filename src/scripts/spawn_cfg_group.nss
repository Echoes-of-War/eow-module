//
// Spawn Groups
//
//
// nChildrenSpawned
// : Number of Total Children ever Spawned
//
// nSpawnCount
// : Number of Children currently Alive
//
// nSpawnNumber
// : Number of Children to Maintain at Spawn
//
// nRandomWalk
// : Walking Randomly? TRUE/FALSE
//
// nPlaceable
// : Spawning Placeables? TRUE/FALSE
//
//
//int ParseFlagValue(string sName, string sFlag, int nDigits, int nDefault);
//int ParseSubFlagValue(string sName, string sFlag, int nDigits, string sSubFlag, int nSubDigits, int nDefault);

object GetChildByTag(object oSpawn, string sChildTag);
object GetChildByNumber(object oSpawn, int nChildNum);
object GetSpawnByID(int nSpawnID);
void DeactivateSpawn(object oSpawn);
void DeactivateSpawnsByTag(string sSpawnTag);
void DeactivateAllSpawns();
void DespawnChildren(object oSpawn);
void DespawnChildrenByTag(object oSpawn, string sSpawnTag);

// user configurable: Add groups and their creatures inside this function [FILE: spawn_cfg_group]
// this function needs to be called in the module's onload event.
void NESSInitializeGroups();
// this function is called by NESSInitializeGroups() [FILE: spawn_cfg_group]
// for each creature you add to a group use the following line:
// NESSAddCreatureToGroup("CreatureResRef", "GroupName", #);
// more explanation:
// "CreatureResRef" - is the resource reference (resref) of the creature blueprint to spawn.
//                    Put the resref between quotes.
// "GroupName"      - is the name you will use to identify this list of creatures.
//                    Put the name between quotes.
// #                - is an integer value of the creature's challenge rating.
//                    CRs of 1 and below should be listed as 1. Do not use fractions or decimal points. Positive, whole numbers only.
void NESSAddCreatureToGroup(string CreatureResRef, string GroupName, int CreatureChallengeRating);
// this function is called by SpawnGroup() [FILE: spawn_cfg_group]
// the return value is a resref for a creature
string NESSGetCreatureFromGroupList(object oSpawn, string sGroupName, int nCR=0);



// user configurable: Add groups and their creatures inside this function [FILE: spawn_cfg_group]
// this function needs to be called in the module's onload event.
void NESSInitializeGroups()
{
// for each creature you add to a group use the following line:
//  NESSAddCreatureToGroup("CreatureResRef", "GroupName", #);
// more explanation:
// "CreatureResRef" - is the resource reference (resref) of the creature blueprint to spawn.
//                    Put the resref between quotes.
// "GroupName"      - is the name you will use to identify this list of creatures.
//                    Put the name between quotes.
// #                - is an integer value of the creature's challenge rating.
//                    CRs of 1 and below should be listed as 1. Do not use fractions or decimal points. Positive, whole numbers only.

////////////////////////////////////////////////////////////////////////////////
// Spiders
////////////////////////////////////////////////////////////////////////////////
    NESSAddCreatureToGroup("te_mons1c","sg_spider",2);
    NESSAddCreatureToGroup("te_mons2cf","sg_spider",4);

    NESSAddCreatureToGroup("te_npc_2082","sg_amnpeas",1);
    NESSAddCreatureToGroup("te_npc_2083","sg_amnpeas",1);
    NESSAddCreatureToGroup("te_npc_2084","sg_amnpeas",1);
    NESSAddCreatureToGroup("te_npc_2085","sg_amnpeas",1);
    NESSAddCreatureToGroup("te_npc_2086","sg_amnpeas",1);
    NESSAddCreatureToGroup("te_npc_2087","sg_amnpeas",1);
    NESSAddCreatureToGroup("te_npc_2088","sg_amnpeas",1);

////////////////////////////////////////////////////////////////////////////////
// Bandits
////////////////////////////////////////////////////////////////////////////////
    NESSAddCreatureToGroup("te_bandit006","sg_bandit",1);
    NESSAddCreatureToGroup("te_bandit007","sg_bandit",1);
    NESSAddCreatureToGroup("te_bandit008","sg_bandit",1);
    NESSAddCreatureToGroup("te_bandit009","sg_bandit",1);

    NESSAddCreatureToGroup("te_bandit010","sg_banditlead",1);
    NESSAddCreatureToGroup("te_bandit011","sg_banditlead",1);
    NESSAddCreatureToGroup("te_bandit012","sg_banditlead",1);

////////////////////////////////////////////////////////////////////////////////
// Peasants - General
////////////////////////////////////////////////////////////////////////////////
NESSAddCreatureToGroup("te_npc_1016","sg_peasbrost",1);
NESSAddCreatureToGroup("te_npc_1016n","sg_peasbrost",1);
NESSAddCreatureToGroup("te_npc_1016n001","sg_peasbrost",1);
NESSAddCreatureToGroup("te_npc_1016n002","sg_peasbrost",1);
NESSAddCreatureToGroup("te_npc_1016n003","sg_peasbrost",1);
NESSAddCreatureToGroup("te_npc_1016n004","sg_peasbrost",1);
NESSAddCreatureToGroup("te_npc_1016p1","sg_peasbrost",1);
NESSAddCreatureToGroup("te_npc_1016p2","sg_peasbrost",1);
NESSAddCreatureToGroup("te_npc_1016p003","sg_peasbrost",1);
NESSAddCreatureToGroup("te_npc_1016x","sg_peasbrost",1);
NESSAddCreatureToGroup("te_npc_1016y","sg_peasbrost",1);
NESSAddCreatureToGroup("te_npc_1016z","sg_peasbrost",1);
NESSAddCreatureToGroup("te_npc_1016z001","sg_peasbrost",1);
NESSAddCreatureToGroup("te_npc_1016z002","sg_peasbrost",1);
NESSAddCreatureToGroup("te_npc_1016z023","sg_peasbrost",1);
NESSAddCreatureToGroup("te_npc_1016z236","sg_peasbrost",1);
NESSAddCreatureToGroup("te_npc_1016z237","sg_peasbrost",1);
NESSAddCreatureToGroup("te_npc_1016z238","sg_peasbrost",1);
NESSAddCreatureToGroup("te_npc_1040","sg_peasbrost",1);

////////////////////////////////////////////////////////////////////////////////
// Peasants - Farmers
////////////////////////////////////////////////////////////////////////////////

NESSAddCreatureToGroup("te_npc_1007","sg_peasfarm",1);
NESSAddCreatureToGroup("te_npc_1007b","sg_peasfarm",1);
NESSAddCreatureToGroup("te_npc_1007b001","sg_peasfarm",1);
NESSAddCreatureToGroup("te_npc_1007w","sg_peasfarm",1);
NESSAddCreatureToGroup("te_npc_1007w001","sg_peasfarm",1);

////////////////////////////////////////////////////////////////////////////////
// Brost - Knight
////////////////////////////////////////////////////////////////////////////////

NESSAddCreatureToGroup("te_npc_1015","sg_knightbrost",1);
NESSAddCreatureToGroup("te_npc_1015a","sg_knightbrost",1);
NESSAddCreatureToGroup("te_npc_1015b","sg_knightbrost",1);
NESSAddCreatureToGroup("te_npc_1015n","sg_knightbrost",1);
NESSAddCreatureToGroup("te_npc_1020","sg_knightbrost",1);
NESSAddCreatureToGroup("te_npc_1021","sg_knightbrost",1);
NESSAddCreatureToGroup("te_npc_1030","sg_knightbrost",1);
NESSAddCreatureToGroup("te_npc_1102","sg_knightbrost",1);
NESSAddCreatureToGroup("te_npc_1103","sg_knightbrost",1);

////////////////////////////////////////////////////////////////////////////////
// Calishite Caravanners
////////////////////////////////////////////////////////////////////////////////
NESSAddCreatureToGroup("te_npc_1004","sg_caravan",1);
NESSAddCreatureToGroup("te_npc_1005","sg_caravan",1);
NESSAddCreatureToGroup("te_npc_1005cc1","sg_caravan",1);
NESSAddCreatureToGroup("te_npc_1005cc12","sg_caravan",1);
NESSAddCreatureToGroup("te_npc_1005cc013","sg_caravan",1);
NESSAddCreatureToGroup("te_npc_1005cc014","sg_caravan",1);
NESSAddCreatureToGroup("te_npc_1086","sg_caravan",1);
NESSAddCreatureToGroup("te_npc_1086a","sg_caravan",1);
NESSAddCreatureToGroup("te_npc_1086a001","sg_caravan",1);
NESSAddCreatureToGroup("te_npc_1086a002","sg_caravan",1);
NESSAddCreatureToGroup("te_npc_1087","sg_caravan",1);

////////////////////////////////////////////////////////////////////////////////
// Brost Mercs
////////////////////////////////////////////////////////////////////////////////
NESSAddCreatureToGroup("te_npc_1101","sg_mercs",1);
NESSAddCreatureToGroup("te_npc_1037","sg_mercs",1);
NESSAddCreatureToGroup("te_npc_1037a","sg_mercs",1);
NESSAddCreatureToGroup("te_npc_1037a001","sg_mercs",1);
NESSAddCreatureToGroup("te_npc_1037c","sg_mercs",1);
NESSAddCreatureToGroup("te_npc_1037d","sg_mercs",1);
NESSAddCreatureToGroup("te_npc_1031","sg_mercs",1);
NESSAddCreatureToGroup("te_npc_10421","sg_mercs",1);
NESSAddCreatureToGroup("te_npc_1044","sg_mercs",1);
NESSAddCreatureToGroup("te_npc_1045","sg_mercs",1);

////////////////////////////////////////////////////////////////////////////////
// Brost Servants
////////////////////////////////////////////////////////////////////////////////
NESSAddCreatureToGroup("te_npc_1016pa","sg_servbrost",1);
NESSAddCreatureToGroup("te_npc_1016pa001","sg_servbrost",1);
NESSAddCreatureToGroup("te_npc_1016pa002","sg_servbrost",1);
NESSAddCreatureToGroup("te_npc_1016pa003","sg_servbrost",1);

////////////////////////////////////////////////////////////////////////////////
// Brost Misc
////////////////////////////////////////////////////////////////////////////////
NESSAddCreatureToGroup("te_npc_1017","sg_miscbrost",1);
NESSAddCreatureToGroup("te_npc_1018","sg_miscbrost",1);
NESSAddCreatureToGroup("te_npc_1035","sg_miscbrost",1);
NESSAddCreatureToGroup("te_npc_1038","sg_miscbrost",1);

////////////////////////////////////////////////////////////////////////////////
// SWAMPFIRE NPCS
////////////////////////////////////////////////////////////////////////////////
NESSAddCreatureToGroup("te_swamcom001","sg_peasswamp",1);
NESSAddCreatureToGroup("te_swamcom002","sg_peasswamp",1);
NESSAddCreatureToGroup("te_swamcom003","sg_peasswamp",1);
NESSAddCreatureToGroup("te_swamcom004","sg_peasswamp",1);
NESSAddCreatureToGroup("te_swamcom005","sg_peasswamp",1);
NESSAddCreatureToGroup("te_swamcom006","sg_peasswamp",1);
NESSAddCreatureToGroup("te_swamcom007","sg_peasswamp",1);
NESSAddCreatureToGroup("te_swamcom008","sg_peasswamp",1);
NESSAddCreatureToGroup("te_swamcom009","sg_peasswamp",1);
NESSAddCreatureToGroup("te_swamcom010","sg_peasswamp",1);
NESSAddCreatureToGroup("te_swamcom011","sg_peasswamp",1);
NESSAddCreatureToGroup("te_swamcom012","sg_peasswamp",1);


////////////////////////////////////////////////////////////////////////////////
// Occultist Petitioners + Imp
////////////////////////////////////////////////////////////////////////////////
NESSAddCreatureToGroup("te_npc_2244","sg_babyoccult",2);
NESSAddCreatureToGroup("te_npc_2245","sg_babyoccult",2);
NESSAddCreatureToGroup("te_npc_2246","sg_babyoccult",2);
NESSAddCreatureToGroup("te_npc_2247","sg_babyoccult",2);


////////////////////////////////////////////////////////////////////////////////
// Occultists + Erinyes
////////////////////////////////////////////////////////////////////////////////
NESSAddCreatureToGroup("te_npc_o1050","sg_occult",4);
NESSAddCreatureToGroup("te_npc_o1051","sg_occult",4);
NESSAddCreatureToGroup("te_npc_o1052","sg_occult",4);
NESSAddCreatureToGroup("te_npc_o1055","sg_occult",4);
NESSAddCreatureToGroup("te_gunner001","sg_occult",4);

////////////////////////////////////////////////////////////////////////////////
// Zombies
////////////////////////////////////////////////////////////////////////////////
NESSAddCreatureToGroup("te_zombie001","sg_zombielite",1);
NESSAddCreatureToGroup("te_zombie002","sg_zombielite",1);
NESSAddCreatureToGroup("te_zombie003","sg_zombielite",1);
NESSAddCreatureToGroup("te_zombie004","sg_zombielite",1);

NESSAddCreatureToGroup("te_zombie006","sg_zombieheavy",3);
NESSAddCreatureToGroup("te_zombie005","sg_zombieheavy",3);
NESSAddCreatureToGroup("te_zombie007","sg_zombieheavy",3);
NESSAddCreatureToGroup("te_zombie009","sg_zombieheavy",3);

//Random Walking on the Road - 1 Guy Spawn
NESSAddCreatureToGroup("te_npc_1101","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1037","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1037a","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1037a001","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1037c","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1037d","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1031","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_10421","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1044","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1045","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1004","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1005","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1005cc1","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1005cc12","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1005cc013","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1005cc014","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1086","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1086a","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1086a001","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1086a002","sg_randroadwalk",1);
NESSAddCreatureToGroup("te_npc_1087","sg_randroadwalk",1);

NESSAddCreatureToGroup("te_npc_1079lk","sg_lockknife",1);
NESSAddCreatureToGroup("te_npc_1080lk","sg_lockknife",1);
NESSAddCreatureToGroup("te_npc_1081lk","sg_lockknife",1);
NESSAddCreatureToGroup("te_npc_1082lk","sg_lockknife",1);
NESSAddCreatureToGroup("te_gunner004","sg_lockknife",2);


NESSAddCreatureToGroup("te_npc_te0001","sg_armym",1);
NESSAddCreatureToGroup("te_npc_te0002","sg_armya",1);

//Foot Defenders
NESSAddCreatureToGroup("te_npc_lw001","sg_lockpf",1);
NESSAddCreatureToGroup("te_npc_te0001","sg_tejpf",1);
NESSAddCreatureToGroup("te_npc_1133","sg_spipf",1);
NESSAddCreatureToGroup("te_br_npc_k1008","sg_swapf",1);
NESSAddCreatureToGroup("te_npc_1098","sg_bropf",1);
//Range Defenders
NESSAddCreatureToGroup("te_npc_lw004","sg_lockpa",1);
NESSAddCreatureToGroup("te_npc_te0002","sg_tejpa",1);
NESSAddCreatureToGroup("te_npc_1132","sg_spipa",1);
NESSAddCreatureToGroup("te_br_npc_k1012","sg_swapa",1);
NESSAddCreatureToGroup("te_npc_1099","sg_bropa",1);
//Gateguards
NESSAddCreatureToGroup("te_npc_lw003","sg_lockga",1);
NESSAddCreatureToGroup("purplecloakkn002","sg_tejga",1);
NESSAddCreatureToGroup("te_ss_k040","sg_spiga",1);
NESSAddCreatureToGroup("te_br_npc_k1009","sg_swaga",1);
NESSAddCreatureToGroup("te_npc_1098","sg_broga",1);
//Knight Melee
NESSAddCreatureToGroup("te_npc_lw002","sg_lockkf",1);
NESSAddCreatureToGroup("purplecloakknigh","sg_tejkf",1);
NESSAddCreatureToGroup("te_ss_k001","sg_spikf",1);
NESSAddCreatureToGroup("te_ss_k005","sg_spikf",1);
NESSAddCreatureToGroup("te_br_npc_k1012","sg_swakf",1);
NESSAddCreatureToGroup("te_br_npc_k1009","sg_swakf",1);
NESSAddCreatureToGroup("te_br_npc_k1008","sg_swakf",1);
NESSAddCreatureToGroup("te_npc_1015","sg_brokf",1);
NESSAddCreatureToGroup("te_npc_1015b","sg_brokf",1);
NESSAddCreatureToGroup("te_npc_1020","sg_brokf",1);
NESSAddCreatureToGroup("te_npc_1021","sg_brokf",1);
NESSAddCreatureToGroup("te_npc_1030","sg_brokf",1);
NESSAddCreatureToGroup("te_npc_1031","sg_brokf",1);
NESSAddCreatureToGroup("te_npc_1101","sg_brokf",1);
//Knight Range
NESSAddCreatureToGroup("te_npc_lw004","sg_lockka",1);
NESSAddCreatureToGroup("te_npc_purpleks","sg_tejka",1);
NESSAddCreatureToGroup("te_ss_k009","sg_spika",1);
NESSAddCreatureToGroup("te_br_npc_k1012","sg_swaka",1);
NESSAddCreatureToGroup("te_npc_1015a","sg_broka",1);
NESSAddCreatureToGroup("te_npc_1015n","sg_broka",1);



/////////Amnians
NESSAddCreatureToGroup("te_npc_1088","sg_amndesert",1);
NESSAddCreatureToGroup("te_npc_1089","sg_amndesert",1);
NESSAddCreatureToGroup("te_npc_1090","sg_amndesert",1);
NESSAddCreatureToGroup("te_npc_1091","sg_amndesert",1);

NESSAddCreatureToGroup("te_npc_1092","sg_amndesertboss",1);
NESSAddCreatureToGroup("te_npc_1093","sg_amndesertboss",1);
NESSAddCreatureToGroup("te_gunner002","sg_amndesertboss",1);
NESSAddCreatureToGroup("te_npc_1096","sg_amndesertboss",1);

NESSAddCreatureToGroup("te_npc_1104","sg_lockghknight",1);
NESSAddCreatureToGroup("te_npc_1105","sg_lockghknight",1);
NESSAddCreatureToGroup("te_npc_1108","sg_lockghknight",1);

NESSAddCreatureToGroup("te_npc_1106","sg_lockghsold",1);
NESSAddCreatureToGroup("te_npc_1107","sg_lockghsold",1);

NESSAddCreatureToGroup("te_npc_2158","sg_duergar",1);
NESSAddCreatureToGroup("te_npc_2159","sg_duergar",1);
NESSAddCreatureToGroup("te_npc_2160","sg_duergar",1);

NESSAddCreatureToGroup("drowftr","sg_drow",1);
NESSAddCreatureToGroup("drowwizard","sg_drow",1);
NESSAddCreatureToGroup("drowrogue","sg_drow",1);
NESSAddCreatureToGroup("drowcleric","sg_drow",1);

NESSAddCreatureToGroup("te_udmons_5","sg_drider",1);
NESSAddCreatureToGroup("te_udmons_6","sg_drider",1);
NESSAddCreatureToGroup("te_udmons_7","sg_drider",1);

NESSAddCreatureToGroup("te_npc_1050","sg_deserter",1);
NESSAddCreatureToGroup("te_npc_1051","sg_deserter",1);
NESSAddCreatureToGroup("te_npc_1052","sg_deserter",1);

NESSAddCreatureToGroup("te_npc_1053","sg_deserterlead",1);
NESSAddCreatureToGroup("te_npc_1054","sg_deserterlead",1);
NESSAddCreatureToGroup("te_npc_1055","sg_deserterlead",1);

NESSAddCreatureToGroup("te_npc_2025","sg_blightweak",1);
NESSAddCreatureToGroup("te_npc_2026","sg_blightweak",1);
NESSAddCreatureToGroup("te_bl_bird","sg_blightweak",1);

NESSAddCreatureToGroup("te_bl_bo","sg_blightstrong",1);
NESSAddCreatureToGroup("te_bl_ox","sg_blightstrong",1);
NESSAddCreatureToGroup("te_bl_spi","sg_blightstrong",1);
NESSAddCreatureToGroup("te_bl_wol","sg_blightstrong",1);

NESSAddCreatureToGroup("te_npc_1066","sg_blighter",1);
NESSAddCreatureToGroup("te_npc_1067","sg_blighter",1);
NESSAddCreatureToGroup("te_npc_2252","sg_blighter",1);
NESSAddCreatureToGroup("te_npc_2253","sg_blighter",1);

NESSAddCreatureToGroup("te_npc_2254","sg_blightlead",1);

NESSAddCreatureToGroup("te_mons1h","sg_gobless",1);
NESSAddCreatureToGroup("te_gob1","sg_gobless",1);
NESSAddCreatureToGroup("te_gob2","sg_gobless",1);

NESSAddCreatureToGroup("te_gob3","sg_gobgreat",1);
NESSAddCreatureToGroup("te_mons3h","sg_gobgreat",1);
NESSAddCreatureToGroup("te_gob4","sg_gobgreat",1);

NESSAddCreatureToGroup("te_npc_1079","sg_brigand",1);
NESSAddCreatureToGroup("te_npc_1080","sg_brigand",1);
NESSAddCreatureToGroup("te_npc_1081","sg_brigand",1);
NESSAddCreatureToGroup("te_npc_1082","sg_brigand",1);

NESSAddCreatureToGroup("te_npc_2266","sg_hell",1);
NESSAddCreatureToGroup("te_npc_2266","sg_hell",1);
NESSAddCreatureToGroup("te_plan3","sg_hell",1);
NESSAddCreatureToGroup("te_plan3","sg_hell",1);
NESSAddCreatureToGroup("te_npc_2268","sg_hell",1);

NESSAddCreatureToGroup("te_npc_2048","sg_hellmed",1);
NESSAddCreatureToGroup("te_npc_2048","sg_hellmed",1);
NESSAddCreatureToGroup("te_plan9","sg_hellmed",1);
NESSAddCreatureToGroup("te_plan9","sg_hellmed",1);


NESSAddCreatureToGroup("te_npc_2240","sg_udless",4);
NESSAddCreatureToGroup("te_skelwar","sg_udless",4);
NESSAddCreatureToGroup("te_skelfoo","sg_udless",4);

NESSAddCreatureToGroup("te_npc_2241","sg_udgreat",4);
NESSAddCreatureToGroup("te_skelsent","sg_udgreat",4);
NESSAddCreatureToGroup("te_skelsent2","sg_udgreat",4);
NESSAddCreatureToGroup("te_skelkni","sg_udgreat",4);

NESSAddCreatureToGroup("te_npc_2057","sg_suoresshell",4);
NESSAddCreatureToGroup("te_npc_2058","sg_suoresshell",4);
NESSAddCreatureToGroup("te_npc_2064","sg_suoresshell",4);
NESSAddCreatureToGroup("te_npc_2048","sg_suoresshell",4);

NESSAddCreatureToGroup("te_npc_1083","sg_darkmoon",4);
NESSAddCreatureToGroup("te_npc_1084","sg_darkmoon",4);

NESSAddCreatureToGroup("cyriccleric","sg_cyric",4);
NESSAddCreatureToGroup("cyricftr","sg_cyric",4);
NESSAddCreatureToGroup("cyricmage","sg_cyric",4);
NESSAddCreatureToGroup("cyricrogue","sg_cyric",4);


NESSAddCreatureToGroup("te_npc_2165","sg_orc",4);
NESSAddCreatureToGroup("te_npc_2166","sg_orc",4);
NESSAddCreatureToGroup("te_npc_2174","sg_orc",4);

NESSAddCreatureToGroup("te_npc_2167","sg_orog",4);
NESSAddCreatureToGroup("te_npc_2168","sg_orog",4);
NESSAddCreatureToGroup("te_npc_2172","sg_orog",4);
NESSAddCreatureToGroup("te_npc_2175","sg_orog",4);

NESSAddCreatureToGroup("te_mons4h","sg_ogre",4);
NESSAddCreatureToGroup("te_mons8h","sg_ogre",4);
NESSAddCreatureToGroup("te_mons4hb","sg_ogre",4);
NESSAddCreatureToGroup("te_npc_2329","sg_ogre",4);

NESSAddCreatureToGroup("te_udmons_9","sg_behold",4);
NESSAddCreatureToGroup("te_udmons_10","sg_behold",4);
NESSAddCreatureToGroup("te_udmons_11","sg_behold",4);

NESSAddCreatureToGroup("te_npc_2256","sg_daco",4);
NESSAddCreatureToGroup("te_npc_2257","sg_daco",4);

NESSAddCreatureToGroup("te_npc_2004","sg_skulk",4);
NESSAddCreatureToGroup("te_npc_2005","sg_skulk",4);

NESSAddCreatureToGroup("te_npc_2018","sg_abysslow",4);
NESSAddCreatureToGroup("te_plan4","sg_abysslow",4);
NESSAddCreatureToGroup("te_npc_2260","sg_abysslow",4);

NESSAddCreatureToGroup("te_br_npc_k1004","sg_thrallkn",4);
NESSAddCreatureToGroup("te_br_npc_k1005","sg_thrallkn",4);
NESSAddCreatureToGroup("te_br_npc_k1007","sg_thrallkn",4);
NESSAddCreatureToGroup("te_npc_1015a001","sg_thrallkn",4);

NESSAddCreatureToGroup("te_npc_2263","sg_dacoelite",4);
NESSAddCreatureToGroup("te_npc_2264","sg_dacoelite",4);
NESSAddCreatureToGroup("te_npc_2265","sg_dacoelite",4);

NESSAddCreatureToGroup("te_mons3f","sg_ankheg",4);

NESSAddCreatureToGroup("te_lw_min001","sg_lwminers",4);
NESSAddCreatureToGroup("te_lw_min002","sg_lwminers",4);

    NESSAddCreatureToGroup("te_sumun03","sg_ghoul",1);
    NESSAddCreatureToGroup("te_npc_2031","sg_ghoul",1);

    NESSAddCreatureToGroup("te_npc_2279","sg_skeleton",4);
    NESSAddCreatureToGroup("te_npc_2280","sg_heucuva",1);
    NESSAddCreatureToGroup("te_npc_2281","sg_heucuva",1);
    NESSAddCreatureToGroup("te_npc_2282","sg_gskeleton",1);

    NESSAddCreatureToGroup("te_npc_2273","sg_airgr",1);
    NESSAddCreatureToGroup("te_npc_2278","sg_airgr",1);
    NESSAddCreatureToGroup("te_npc_2050","sg_airgr",1);

    NESSAddCreatureToGroup("te_npc_2279","sg_aljana",1);
    NESSAddCreatureToGroup("te_npc_2028","sg_aljana",1);
    NESSAddCreatureToGroup("te_npc_2029","sg_aljana",1);
    NESSAddCreatureToGroup("te_npc_2020","sg_aljana",1);
    NESSAddCreatureToGroup("te_npc_2023","sg_aljana",1);

    NESSAddCreatureToGroup("te_mons3f","sg_ankheg",1);
    NESSAddCreatureToGroup("te_mons5f","sg_ankheg",1);

    NESSAddCreatureToGroup("te_bl_bo","sg_blightgr",1);
    NESSAddCreatureToGroup("te_bl_wol","sg_blightgr",1);

    NESSAddCreatureToGroup("te_bl_bird","sg_blightls",1);
    NESSAddCreatureToGroup("te_bl_spi","sg_blightls",1);

    NESSAddCreatureToGroup("te_npc_2046","sg_bloodmot",1);

    NESSAddCreatureToGroup("te_mons3h","sg_bugbear",1);
    NESSAddCreatureToGroup("te_mons3hb","sg_bugbear",1);
    NESSAddCreatureToGroup("te_mons3hc","sg_bugbear",1);
    NESSAddCreatureToGroup("te_mons3hd","sg_bugbear",1);

    NESSAddCreatureToGroup("te_npc_2260","sg_abysshi",1);
    NESSAddCreatureToGroup("te_plan10","sg_abysshi",1);

    NESSAddCreatureToGroup("te_npc_2260","sg_earth",1);
    NESSAddCreatureToGroup("te_teja008","sg_earth",1);
    NESSAddCreatureToGroup("te_npc_2054","sg_earth",1);

    NESSAddCreatureToGroup("te_npc_2275","sg_fire",1);
    NESSAddCreatureToGroup("te_npc_2267","sg_fire",1);
    NESSAddCreatureToGroup("te_spire009","sg_fire",1);

    NESSAddCreatureToGroup("te_mons2hp","sg_gnoll",1);
    NESSAddCreatureToGroup("te_npc_1126","sg_gnoll",1);
    NESSAddCreatureToGroup("te_mons2hpb","sg_gnoll",1);

    NESSAddCreatureToGroup("te_shad2","sg_shadgr",1);
    NESSAddCreatureToGroup("te_shad3","sg_shadgr",1);

    NESSAddCreatureToGroup("te_npc_1049","sg_gobhob",1);
    NESSAddCreatureToGroup("te_mons2f","sg_gobhob",1);

    NESSAddCreatureToGroup("te_shad1","sg_shadls",1);
    NESSAddCreatureToGroup("te_shad2","sg_shadls",1);

    NESSAddCreatureToGroup("te_npc_2170","sg_orcchief",1);
    NESSAddCreatureToGroup("te_npc_2169","sg_orcchief",1);
    NESSAddCreatureToGroup("te_npc_2173","sg_orcchief",1);
    NESSAddCreatureToGroup("te_npc_2171","sg_orcchief",1);

    NESSAddCreatureToGroup("te_udmons_1","sg_revenant",1);
    NESSAddCreatureToGroup("te_udmons_2","sg_revenant",1);
    NESSAddCreatureToGroup("te_udmons_3","sg_revenant",1);
    NESSAddCreatureToGroup("te_udmons_4","sg_revenant",1);

    NESSAddCreatureToGroup("te_sumun01","sg_sundead",1);
    NESSAddCreatureToGroup("te_sumun02","sg_sundead",1);
    NESSAddCreatureToGroup("te_sumun03","sg_sundead",1);
    NESSAddCreatureToGroup("te_sumun04","sg_sundead",1);
    NESSAddCreatureToGroup("te_sumun05","sg_sundead",1);

    NESSAddCreatureToGroup("te_cgvamp","sg_vampknight",1);
    NESSAddCreatureToGroup("te_cuvawm","sg_vampknight",1);

    NESSAddCreatureToGroup("te_npc_2277","sg_water",1);
    NESSAddCreatureToGroup("te_npc_2276","sg_water",1);
    NESSAddCreatureToGroup("te_telf008","sg_water",1);

    NESSAddCreatureToGroup("te_mons4fp","sg_werewolf",1);
    NESSAddCreatureToGroup("te_mons8fp","sg_werewolf",1);

    NESSAddCreatureToGroup("te_npc_2030","sg_wight",1);

    NESSAddCreatureToGroup("te_npc_2208","sg_ishla",1);
    NESSAddCreatureToGroup("te_npc_2209","sg_ishla",1);

    NESSAddCreatureToGroup("te_npc_2208a","sg_ishlahrs",1);
    NESSAddCreatureToGroup("te_npc_2209b","sg_ishlahrs",1);

    NESSAddCreatureToGroup("te_npc_2208c","sg_ishlain",1);
    NESSAddCreatureToGroup("te_npc_2209c","sg_ishlain",1);

    NESSAddCreatureToGroup("te_npc_2314","sg_loviatar",1);
    NESSAddCreatureToGroup("te_npc_2316","sg_loviatar",1);


    NESSAddCreatureToGroup("te_npc_2130","sg_animbook",1);
    NESSAddCreatureToGroup("te_npc_2130a","sg_animbook",1);
    NESSAddCreatureToGroup("te_npc_2130b","sg_animbook",1);
    NESSAddCreatureToGroup("te_npc_2130c","sg_animbook",1);
    NESSAddCreatureToGroup("te_npc_2130d","sg_animbook",1);
    NESSAddCreatureToGroup("te_npc_2130e","sg_animbook",1);

    NESSAddCreatureToGroup("te_npc_2306","sg_brokeone",1);
    NESSAddCreatureToGroup("te_npc_2307","sg_brokeone",1);
    NESSAddCreatureToGroup("te_npc_2308","sg_brokeone",1);

    NESSAddCreatureToGroup("te_npc_2309","sg_brokegrt",1);
    NESSAddCreatureToGroup("te_npc_2310","sg_brokegrt",1);
    NESSAddCreatureToGroup("te_npc_2311","sg_brokegrt",1);

    NESSAddCreatureToGroup("te_npc_2317","sg_arcaco",1);
    NESSAddCreatureToGroup("te_npc_2318","sg_arcaco",1);

    NESSAddCreatureToGroup("te_udmons_1","sg_fdrow",1);
    NESSAddCreatureToGroup("te_udmons_2","sg_fdrow",1);
    NESSAddCreatureToGroup("te_udmons_3","sg_fdrow",1);


    NESSAddCreatureToGroup("te_npc_2319","sg_kahkashanls",1);
    NESSAddCreatureToGroup("te_npc_2320","sg_kahkashanls",1);
    NESSAddCreatureToGroup("te_npc_2321","sg_kahkashanls",1);
    NESSAddCreatureToGroup("te_npc_2322","sg_kahkashanls",1);
    NESSAddCreatureToGroup("te_npc_2323","sg_kahkashanls",1);
    NESSAddCreatureToGroup("te_npc_2324","sg_kahkashanls",1);

    NESSAddCreatureToGroup("te_npc_2325","sg_kahkashangr",1);
    NESSAddCreatureToGroup("te_npc_2326","sg_kahkashangr",1);
    NESSAddCreatureToGroup("te_npc_2327","sg_kahkashangr",1);
    NESSAddCreatureToGroup("te_npc_2328","sg_kahkashangr",1);


    NESSAddCreatureToGroup("te_npc_2331","sg_dwarfrest",1);
    NESSAddCreatureToGroup("te_npc_2332","sg_dwarfrest",1);
    NESSAddCreatureToGroup("te_npc_2333","sg_dwarfrest",1);
    NESSAddCreatureToGroup("te_npc_2334","sg_dwarfrest",1);
    NESSAddCreatureToGroup("te_npc_2335","sg_dwarfrest",1);
}


void NESSAddCreatureToGroup(string CreatureResRef, string GroupName, int CreatureChallengeRating)
{
    object oMod         = GetModule();

    // sanity checks
    if(CreatureResRef=="" || GroupName=="") return;
    if(CreatureChallengeRating<1) CreatureChallengeRating = 1;


    // add creature to master list
    int nIndex  =   GetLocalInt(oMod,"NESS_COUNT_"+GroupName)+1;
                    SetLocalInt(oMod,"NESS_COUNT_"+GroupName,nIndex);

    SetLocalString(oMod, "NESS_"+GroupName+"_"+IntToString(nIndex),CreatureResRef);

    if(CreatureChallengeRating>0)
    {
        // add creature to CR list
        string CRLabel  = IntToString(CreatureChallengeRating);
        int nCRIndex    = GetLocalInt(oMod, "NESS_COUNT_CR"+CRLabel+"_"+GroupName)+1;
                          SetLocalInt(oMod, "NESS_COUNT_CR"+CRLabel+"_"+GroupName, nCRIndex);

        SetLocalString(oMod, "NESS_"+GroupName+"_"+IntToString(CreatureChallengeRating)+"_"+IntToString(nCRIndex),CreatureResRef);
    }
}



string NESSGetCreatureFromGroupList(object oSpawn, string sGroupName, int nCR=0)
{
    string sResRef;

    // set to TRUE below if you want to prevent a spawn
    int bNoSpawn;
    if(sGroupName!="")
    {
        // USER CONFIGURABLE ---------------------------------------------------
        if(sGroupName=="goblincommoners")
        {

        }
        /*
        else if (sGroupName == "gobsnboss")
        {
            if(GetLocalInt(oSpawn, "IsBossSpawned"))
            {
                // Find the Boss
                object oBoss = GetChildByTag(oSpawn, GetLocalString(oSpawn,"BossTag"));

                // Check if Boss is Alive
                if(oBoss==OBJECT_INVALID || GetIsDead(oBoss))
                {
                    // He's dead, Deactivate Camp!
                    SetLocalInt(oSpawn, "SpawnDeactivated", TRUE);
                    bNoSpawn    = TRUE;
                }
                else
                {


                }
            }
            else
            {
                // No Boss, so Let's Spawn Him
                if(!nCR || nCR>=11)
                {
                    sResRef = "nw_goblinboss";
                    if(nCR)
                        SetLocalInt(oSpawn, "NESS_LAST_SPAWN_CR",11);
                }
                else if(nCR>=4)
                {
                    sResRef = "nw_gobchiefa";
                    SetLocalInt(oSpawn, "NESS_LAST_SPAWN_CR",4);
                }
                else
                {
                    sResRef = "nw_gobchiefb";
                    SetLocalInt(oSpawn, "NESS_LAST_SPAWN_CR",3);
                }

                SetLocalString(oSpawn,"BossTag", GetStringUpperCase(sResRef));
                SetLocalInt(oSpawn, "IsBossSpawned", TRUE);
            }
        }
        */
        // END USER CONFIGURABLE -----------------------------------------------

        // we have yet to receive a creature resref so lets randomly select one from our list...
        if(sResRef=="" && !bNoSpawn)
        {
            object oMod = GetModule();
            string sGroupLabel; int nListCount;
            // scaled encounters....
            if(nCR)
            {
                    nListCount  = GetLocalInt(oMod, "NESS_COUNT_CR"+IntToString(nCR)+"_"+sGroupName);
                while( !nListCount && nCR>0 )
                    nListCount  = GetLocalInt(oMod, "NESS_COUNT_CR"+IntToString(--nCR)+"_"+sGroupName);

                if(nListCount)
                {
                    sGroupLabel = "NESS_"+sGroupName+"_"+IntToString(nCR)+"_";
                    SetLocalInt(oSpawn, "NESS_LAST_SPAWN_CR",nCR);
                }
                else
                    DeleteLocalInt(oSpawn, "NESS_LAST_SPAWN_CR");
            }
            // randomly from the entire list
            else
            {
                    nListCount  = GetLocalInt(oMod, "NESS_COUNT_"+sGroupName);
                if(nListCount)
                    sGroupLabel = "NESS_"+sGroupName+"_";
            }

            if(sGroupLabel!="")
            {
                // This line ensures the Random function behaves randomly.
                int iRandomize = Random(Random(GetTimeMillisecond()));

                sResRef = GetLocalString(oMod, sGroupLabel+IntToString(Random(nListCount)+1));
            }
        }

    }

    return sResRef;
}

// Convert a given EL equivalent and its encounter level,
// return the corresponding CR
float ConvertELEquivToCR(float fEquiv, float fEncounterLevel)
{
    if (fEquiv == 0.0)
        return 0.0;
    /*
    float fCR, fEquivSq, fTemp;
    fEquivSq = fEquiv * fEquiv;
    fTemp = log(fEquivSq);
    fTemp /= log(2.0);
    fCR = fEncounterLevel + fTemp;
    */

    return fEncounterLevel + (log(fEquiv * fEquiv)/log(2.0));
}

// Convert a given CR to its encounter level equivalent per DMG page 101.
float ConvertCRToELEquiv(float fCR, float fEncounterLevel)
{
    if(     fCR>fEncounterLevel
        ||  fCR<1.0
      )
        return 1.0;
/*
    float fEquiv, fExponent, fDenom;

    fExponent   = (fEncounterLevel - fCR)*0.5;
    fDenom      = pow(2.0, fExponent);
    fEquiv      =  1.0 / fDenom;
*/
    return (1.0 / pow(2.0, ((fEncounterLevel - fCR)*0.5) ) );
}

// - [File: spawn_cfg_group]
string SpawnGroup(object oSpawn, string sTemplate);
string SpawnGroup(object oSpawn, string sTemplate)
{
    // Initialize
    string sRetTemplate;
    int nSpawnNumber    = GetLocalInt(oSpawn, "f_SpawnNumber");

    // BEGIN SCALING -----------------------------------------------------------
    if (GetStringLeft(sTemplate, 7) == "scaled_")
    {
        float fEncounterLevel;
        string sGroupType = GetStringRight(sTemplate, GetStringLength(sTemplate) - 7);

        // First Time in for this encounter?
        if (!GetLocalInt(oSpawn, "ScaledInProgress"))
        {

            // First time in - find the party level
            int nTotalPCs = 0;
            int nTotalPCLevel = 0;

            float fTriggerRadius    = GetLocalFloat(oSpawn, "f_SpawnTrigger");
            if(fTriggerRadius>0.0)
            {
                location lLoc   = GetLocation(oSpawn);
                object oPC  = GetFirstObjectInShape(SHAPE_SPHERE,fTriggerRadius,lLoc);
                while (oPC != OBJECT_INVALID)
                {
                    if(!GetIsDM(oPC) && GetIsPC(oPC))
                    {
                        nTotalPCs++;
                        nTotalPCLevel = nTotalPCLevel + GetHitDice(oPC);
                    }
                    oPC = GetNextObjectInShape(SHAPE_SPHERE,fTriggerRadius,lLoc);
                }
            }
            else
            {
                object oArea = GetArea(OBJECT_SELF);
                object oPC = GetFirstPC();
                while (oPC != OBJECT_INVALID)
                {
                    if(     !GetIsDM(oPC)
                        &&  GetArea(oPC)==oArea
                      )
                    {
                        nTotalPCs++;
                        nTotalPCLevel = nTotalPCLevel + GetHitDice(oPC);
                    }
                    oPC = GetNextPC();
                }
            }

            if (nTotalPCs == 0)
                fEncounterLevel = 0.0;
            else
            {
                float fPCs      = IntToFloat(nTotalPCs);
                fEncounterLevel = (IntToFloat(nTotalPCLevel)/ fPCs)
                                  // *(fPCs/4.0)
                                    ;
            }

            // Save this for subsequent calls
            SetLocalFloat(oSpawn, "ScaledEncounterLevel", fEncounterLevel);

            // We're done when the CRs chosen add up to the desired encounter level
            SetLocalInt(oSpawn, "ScaledCallCount", 0);
            SetLocalInt(oSpawn, "ScaledInProgress", TRUE);
        }

            fEncounterLevel     = GetLocalFloat(oSpawn, "ScaledEncounterLevel");
        int nScaledCallCount    = GetLocalInt(oSpawn, "ScaledCallCount");

        // For simplicity, I'm not supporting creatures with CR < 1.0)
        if (fEncounterLevel < 1.0)
            // We're done... No creatures have CR low enough to add to this encounter
            sRetTemplate = "";
        else
        {
            int nCR;
            if(nScaledCallCount)
            // randomly choose a CR at or below the remaining (uncovered) encounter level
                nCR = Random(FloatToInt(fEncounterLevel)) + 1;
            else
                // on the first call use the largest possible CR
                nCR = FloatToInt(fEncounterLevel);
            sRetTemplate = NESSGetCreatureFromGroupList(oSpawn, sGroupType, nCR);

            // Calculate remaining
            nCR = GetLocalInt(oSpawn, "NESS_LAST_SPAWN_CR");

            float fElRemaining  = 1.0 - ConvertCRToELEquiv(IntToFloat(nCR), fEncounterLevel);

            fEncounterLevel = ConvertELEquivToCR(fElRemaining, fEncounterLevel);
            SetLocalFloat(oSpawn, "ScaledEncounterLevel", fEncounterLevel);
        }

        SetLocalInt(oSpawn, "ScaledCallCount", ++nScaledCallCount);
        if (nScaledCallCount >= nSpawnNumber)
            // reset...
            SetLocalInt(oSpawn, "ScaledInProgress", FALSE);
    }
    // END SCALING -------------------------------------------------------------
    else
    {
        sRetTemplate = NESSGetCreatureFromGroupList(oSpawn, sTemplate);
    }

// -------------------------------------------
// Only Make Modifications Between These Lines
//
    return sRetTemplate;
}
