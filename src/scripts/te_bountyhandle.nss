#include "nwnx_time"

void TE_DeathHandle(object oDead, object oKiller);

//oPC == Object you wish to give XP to. Only PCs have multiclassing penalty.
//nXPToGive == Amount of XP Reward. If negative, multiclassing penalty will never be calculated or looked at.
//nMulticlass == TRUE for assessing multiclassing penalty. Default = 0/False.
void GiveTrueXPToCreature_Bount(object oPC, int nXPToGive, int nMulticlass);

void TE_DeathHandle(object oDead, object oKiller)
{
       //PIETY STUFF, LEADERSHIP STUFF
       object oItem = GetItemPossessedBy(oKiller,"PC_Data_Object");
    int nPiety = GetLocalInt(oItem,"nPiety");

    if(GetLocalInt(oKiller,"nLead") > 0 && GetLocalInt(oKiller,"nXPReward") == 1)
    {
        SendMessageToPC(oKiller,"You gain the benefits of imparted knowledge on this kill! - "+IntToString(GetLocalInt(oKiller,"nLead"))+" additional XP awarded.");
        SetLocalInt(oKiller,"nLead",0);
        GiveTrueXPToCreature_Bount(oKiller,GetLocalInt(oKiller,"nLead"),FALSE);
    }

    if(GetLevelByClass(CLASS_TYPE_PALADIN,oKiller) >= 1 && GetLevelByClass(CLASS_TYPE_BLACKGUARD,oKiller) < 1 && GetLevelByClass(51,oKiller) < 1)
    {
        int nType = GetRacialType(oDead);

        if(nType != RACIAL_TYPE_UNDEAD &&
        nType != RACIAL_TYPE_ANIMAL &&
        nType != RACIAL_TYPE_VERMIN &&
        nType != RACIAL_TYPE_MAGICAL_BEAST &&
        nType != RACIAL_TYPE_BEAST &&
        nType != RACIAL_TYPE_OOZE &&
        nType != RACIAL_TYPE_ABERRATION &&
        nType != RACIAL_TYPE_CONSTRUCT &&
        nType != RACIAL_TYPE_ELEMENTAL &&
        nType != RACIAL_TYPE_DRAGON)
        {
            if(GetAlignmentGoodEvil(oDead) == ALIGNMENT_NEUTRAL)
            {
                SetLocalInt(oItem,"nPiety",nPiety-10);
                AdjustAlignment(oKiller,ALIGNMENT_CHAOTIC,5,FALSE);
                SendMessageToPC(oKiller,"This unnecessary bloodshed tarnishes you in the eyes of your deity.");
            }
            else if(GetAlignmentGoodEvil(oDead) == ALIGNMENT_GOOD)
            {
                SetLocalInt(oItem,"nPiety",0);
                SetLocalInt(oItem,"iTrans",1);
                AdjustAlignment(oKiller,ALIGNMENT_EVIL,25,FALSE);
                AdjustAlignment(oKiller,ALIGNMENT_CHAOTIC,25,FALSE);
                SendMessageToPC(oKiller,"The murder of a righteous person weighs heavily on your soul. You have fallen from the grace of your deity.");
            }
        }
    }
    else if(GetLevelByClass(51,oKiller) >= 1)
    {
        if(nPiety >= 50)
        {
            int nType = GetRacialType(oDead);

            if(nType == RACIAL_TYPE_UNDEAD || nType == RACIAL_TYPE_OUTSIDER)
            {
                SetLocalInt(oItem,"nPiety",nPiety+2);
            }
        }
    }
    else if(GetLevelByClass(CLASS_TYPE_BLACKGUARD,oKiller) >= 1)
    {
        if(nPiety >= 50)
        {
            if(GetAlignmentGoodEvil(oDead) == ALIGNMENT_GOOD)
            {
                SetLocalInt(oItem,"nPiety",nPiety+2);
            }
            else
            {
                SetLocalInt(oItem,"nPiety",nPiety+1);
                GiveTrueXPToCreature_Bount(oKiller,5,FALSE);
            }
        }
    }

    if(GetLocalInt(oItem,"nPiety") < 0)     {SetLocalInt(oItem,"nPiety",0);}
    if(GetLocalInt(oItem,"nPiety") > 100)   {SetLocalInt(oItem,"nPiety",100);}

    //BOUNTY STUFF
    object oPlace = OBJECT_INVALID;

    if(GetResRef(oDead) == "te_mons6dr" || GetResRef(oDead) == "te_gr_stag"|| GetResRef(oDead) == "te_sylvan_051"|| GetResRef(oDead) == "te_sylvan_029"|| GetResRef(oDead) == "te_sylvan_061")
    {
        oPlace = CreateObject(OBJECT_TYPE_PLACEABLE, "te_hunt_mam", GetLocation(oDead),FALSE,"ceb_crresshide");
        SetLocalString(oPlace, "type","antlers");
    }

    if(GetLocalInt(oDead, "SoftHide") == 1)
    {
        oPlace = CreateObject(OBJECT_TYPE_PLACEABLE, "te_hunt_mam", GetLocation(oDead),FALSE,"ceb_crresshide");
        SetLocalString(oPlace, "type","softhide");
    }
    if(GetLocalInt(oDead, "HardHide") == 1)
    {
        oPlace = CreateObject(OBJECT_TYPE_PLACEABLE, "te_hunt_mam", GetLocation(oDead),FALSE,"ceb_crresshide");
        SetLocalString(oPlace, "type","hardhide");
    }
    if(GetResRef(oDead) == "te_udmons_9"||GetResRef(oDead) == "te_udmons_10"||GetResRef(oDead) == "te_udmons_11")
    {
        oPlace = CreateObject(OBJECT_TYPE_PLACEABLE, "te_hunt_mam", GetLocation(oDead),FALSE,"te_eyestalk");
        SetLocalString(oPlace, "type","te_eyestalk");
    }

    if(GetResRef(oDead) == "te_udmons_15"||GetResRef(oDead) == "te_udmons_13"||GetResRef(oDead) == "te_mons6c")
    {
        oPlace = CreateObject(OBJECT_TYPE_PLACEABLE, "te_hunt_mam", GetLocation(oDead),FALSE,"te_tentacle");
        SetLocalString(oPlace, "type","te_tentacle");
    }

    //Firedrake
    if(GetResRef(oDead) == "te_npc_2312"||GetResRef(oDead) == "te_npc_2313")
    {
        if(d100(1)<=75)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE, "te_hunt_mam", GetLocation(oDead),FALSE,"te_bounty034");
            SetLocalString(oPlace, "type","te_firedrake");
        }
    }

    if(GetResRef(oDead) == "te_npc_2275"||GetResRef(oDead) == "te_npc_2267"||GetResRef(oDead) == "te_mons6d")
    {
        if(d100(1)<=75)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE, "te_hunt_fire", GetLocation(oDead),FALSE,"te_ankheg");
            SetLocalString(oPlace, "type","te_plogiston");
        }
    }

    if(GetResRef(oDead) == "te_mons3f"||GetResRef(oDead) == "te_mons5f")
    {
        if(d100(1)<=50)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE, "te_hunt_bug", GetLocation(oDead),FALSE,"te_ankheg");
            SetLocalString(oPlace, "type","te_ankheg");
        }
    }
    if(GetResRef(oDead) == "te_mons5h")
    {
        oPlace = CreateObject(OBJECT_TYPE_PLACEABLE, "te_hunt_mam", GetLocation(oDead),FALSE,"te_minotaur");
        SetLocalString(oPlace, "type","te_minotaur");
    }
    if(GetResRef(oDead) == "te_juvred")
    {
        oPlace = CreateObject(OBJECT_TYPE_PLACEABLE, "te_hunt_mam", GetLocation(oDead),FALSE,"te_dragon");
        SetLocalString(oPlace, "type","te_dragon");
    }
    if(GetResRef(oDead) == "te_udmons_5"||GetResRef(oDead) == "te_udmons_6"||GetResRef(oDead) == "te_udmons_7")
    {
        oPlace = CreateObject(OBJECT_TYPE_PLACEABLE, "te_hunt_bug", GetLocation(oDead),FALSE,"te_drider");
        SetLocalString(oPlace, "type","te_drider");
    }
    if(GetResRef(oDead) == "te_mons6dr")
    {
        oPlace = CreateObject(OBJECT_TYPE_PLACEABLE, "te_hunt_mam", GetLocation(oDead),FALSE,"te_stag");
        SetLocalString(oPlace, "type","te_stag");
    }
    if(GetResRef(oDead) == "te_teja005"||GetResRef(oDead) == "te_sylvan_044")
    {
        oPlace = CreateObject(OBJECT_TYPE_PLACEABLE, "te_hunt_mam", GetLocation(oDead),FALSE,"te_satyr");
        SetLocalString(oPlace, "type","te_satyr");
    }

    if(GetResRef(oDead) == "te_lake002"||GetResRef(oDead) == "te_gr_owl"||GetResRef(oDead) == "te_sylvan_049"||GetResRef(oDead) == "te_sylvan_037")
    {
        if(d100(1)<=75)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remains",GetLocation(oDead),FALSE);
            CreateItemOnObject("it_comp_owlfeath",oPlace,1);
        }
    }

    if(GetResRef(oDead) == "te_sylvan_004"||GetResRef(oDead) == "te_sylvan_008"||GetResRef(oDead) == "te_sylvan_012"||GetResRef(oDead) == "te_sylvan_017"||
       GetResRef(oDead) == "te_sylvan_036"||GetResRef(oDead) == "te_sylvan_039"||GetResRef(oDead) == "te_sylvan_042"||GetResRef(oDead) == "te_sylvan_043"||
       GetResRef(oDead) == "te_sylvan_053"||GetResRef(oDead) == "te_sylvan_065")
    {
        if(d100(1)<=75)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remains",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_cebcraft013",oPlace,1);
        }
    }

    if(GetResRef(oDead) == "te_npc_1125" || GetResRef(oDead) == "te_mons2cf" || GetResRef(oDead) == "te_udmons_5u")
    {
        if(d100(1)<=50)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_hunt_bug",GetLocation(oDead),FALSE);
            SetLocalString(oPlace, "type","te_silkgland");
        }
    }

    if(GetResRef(oDead) == "te_mons3c")
    {
        oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_hunt_bug",GetLocation(oDead),FALSE);
        SetLocalString(oPlace, "type","te_spidven");
    }

    //Wyvern Blood
    if(GetResRef(oDead) == "te_mons6fm")
    {
        if(d100(1)<=25)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("it_wyvernbld001",oPlace,1);
        }
    }

    //Occultists - summoningmanual
    if(GetResRef(oDead) == "te_npc_o1055" ||GetResRef(oDead) == "te_npc_o1050" || GetResRef(oDead) == "te_npc_o1052" || GetResRef(oDead) == "te_npc_o1051"||
       GetResRef(oDead) == "te_npc_2244" ||GetResRef(oDead) == "te_npc_2245" || GetResRef(oDead) == "te_npc_2246" || GetResRef(oDead) == "te_npc_2247"
    )
    {
        if(d100(1)<=20)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("summonersmanual",oPlace,1);
        }

    }

    //Goblins - goblin ears te_bount001
    if(GetResRef(oDead) == "te_mons1h"||GetResRef(oDead) == "te_gob3"||GetResRef(oDead) == "te_gob2"||GetResRef(oDead) == "te_gob1" ||
        GetResRef(oDead) == "te_gob4")
    {
        if(d100(1)<=50)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount001",oPlace,1);
        }
    }

    //Ogre - ogre ear te_bount002
    if(GetResRef(oDead) == "te_mons4h"||GetResRef(oDead) == "te_mons8h"||GetResRef(oDead) == "te_mons4hc"||GetResRef(oDead) == "te_mons4hb")
    {
        if(d100(1)<=95)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount002",oPlace,1);
        }
    }

    //Hobgoblin Ear - te_bount003
    if(GetResRef(oDead) == "te_mons2f"||GetResRef(oDead) == "te_npc_1049")
    {
        if(d100(1)<=95)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount003",oPlace,1);
        }
    }

    //Bugbear - Bugbear ear - te_bount004
    if(GetResRef(oDead) == "te_mons3h" || GetResRef(oDead) == "te_mons3hd" || GetResRef(oDead) == "te_mons3hc" || GetResRef(oDead) == "te_mons3hb")
    {
        if(d100(1)<=75)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount004",oPlace,1);
        }
    }

    //Ghouls - ghoul tongue te_bount006
    if(GetResRef(oDead) == "te_npc_2031"||GetResRef(oDead) == "te_sumun03"||GetResRef(oDead) == "te_npc_2041")
    {
        if(d100(1)<=75)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount006",oPlace,1);
        }
    }

    //Ooze - te_bount007
    if(GetResRef(oDead) == "te_mons4cm"||GetResRef(oDead) == "te_mons5cm")
    {
        if(d100(1)<=50)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_bug",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount007",oPlace,1);
        }
    }

    //Trolls - te_bount008
    if(GetResRef(oDead) == "te_mons6h"||GetResRef(oDead) == "te_mons6hb")
    {
        if(d100(1)<=75)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount008",oPlace,1);
        }
    }

    //NONCORPOREAL UNDEAD  te_bount009
    if(GetResRef(oDead) =="te_npc_2265" || GetResRef(oDead) =="te_npc_1108" || GetResRef(oDead) =="te_npc_1104" ||
        GetResRef(oDead) =="te_npc_1105" || GetResRef(oDead) =="te_npc_1106" || GetResRef(oDead) =="te_npc_1107" ||
        GetResRef(oDead) =="te_npc_2029" || GetResRef(oDead) =="te_npc_2243" ||
        GetResRef(oDead) =="te_sumun05" || GetResRef(oDead) =="te_npc_2161" || GetResRef(oDead) =="te_npc_2255" ||
        GetResRef(oDead) =="te_su_spec" || GetResRef(oDead) =="te_npc_2028" || GetResRef(oDead) =="te_npc_2056" ||
                GetResRef(oDead) =="te_npc_2317" || GetResRef(oDead) =="te_npc_2318" || GetResRef(oDead) =="te_npc_2331" ||
                GetResRef(oDead) =="te_npc_2332" || GetResRef(oDead) =="te_npc_2333" || GetResRef(oDead) =="te_npc_2334" || GetResRef(oDead) =="te_npc_2335" ||
                GetResRef(oDead) =="te_npc_2044" || GetResRef(oDead) =="te_su_wrai" || GetResRef(oDead) =="te_npc_2317" || GetResRef(oDead) =="te_npc_2318")
    {
        if(d100(1)<=25)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_nonc",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount009",oPlace,1);
        }
    }

    //SHADOWS   te_bount009
    if( GetResRef(oDead) =="te_shad1" || GetResRef(oDead) =="te_shad3" || GetResRef(oDead) =="te_shad4" || GetResRef(oDead) =="te_shad2" )
    {
        if(d100(1)<=25)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_nonc",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount009",oPlace,1);
        }
    }

    //meaty undead te_bount010
    if(GetResRef(oDead) =="te_npc_2055" || GetResRef(oDead) =="te_npc_2023" || GetResRef(oDead) =="te_telf009" ||GetResRef(oDead) =="te_lake009" ||
    GetResRef(oDead) =="te_marsh010" || GetResRef(oDead) =="te_gr_careat" ||GetResRef(oDead) =="te_spire010" ||GetResRef(oDead) =="te_teja010" ||
    GetResRef(oDead) =="te_bl_bird" || GetResRef(oDead) =="te_telf014" ||GetResRef(oDead) =="te_lake012" || GetResRef(oDead) =="te_spire011" ||
    GetResRef(oDead) =="te_bl_bo" || GetResRef(oDead) =="te_npc_2025" || GetResRef(oDead) =="te_npc_2026" || GetResRef(oDead) =="te_bl_ox" ||
    GetResRef(oDead) =="te_telf014" || GetResRef(oDead) =="te_lake011" ||   GetResRef(oDead) =="te_marsh011" ||  GetResRef(oDead) =="te_bl_spi" ||
    GetResRef(oDead) =="te_spire012" ||  GetResRef(oDead) =="te_bl_wol" ||    GetResRef(oDead) =="te_npc_2051" ||  GetResRef(oDead) =="te_npc_2033" ||
    GetResRef(oDead) =="te_zombie001" || GetResRef(oDead) =="te_zombie002" || GetResRef(oDead) =="te_zombie003" || GetResRef(oDead) =="te_zombie004" ||
    GetResRef(oDead) =="te_sylvan_009" || GetResRef(oDead) =="te_sylvan_019" || GetResRef(oDead) =="te_sylvan_020" || GetResRef(oDead) =="te_sylvan_021" ||
    GetResRef(oDead) =="te_sylvan_022" || GetResRef(oDead) =="te_sylvan_023" ||
    GetResRef(oDead) =="te_zombie005" || GetResRef(oDead) =="te_zombie007" || GetResRef(oDead) =="te_zombie006" || GetResRef(oDead) =="te_zombie009")
    {
        if(d100(1)<=50)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount010",oPlace,1);
        }
    }

    //skelies te_bount011
    if(GetResRef(oDead) == "te_skelfoo"||GetResRef(oDead) == "te_skelkni"||GetResRef(oDead) == "te_skelsent2"||GetResRef(oDead) == "te_skelsent"||
        GetResRef(oDead) == "te_skelwar"||GetResRef(oDead) == "te_npc_2282"||GetResRef(oDead) == "te_npc_2280"||GetResRef(oDead) == "te_npc_2281"||
        GetResRef(oDead) == "te_sumun01"||GetResRef(oDead) == "te_npc_2279")
    {
        if(d100(1)<=50)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_bone",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount011",oPlace,1);
        }
    }

    //vamps te_bount012
    if(GetResRef(oDead) == "te_cu_vawm"||GetResRef(oDead) == "te_cu_vasd"||GetResRef(oDead) == "te_cgvamp"||GetResRef(oDead) == "te_cuvamp"||
        GetResRef(oDead) == "te_cu_vawi")
    {
        if(d100(1)<=50)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_dust",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount012",oPlace,1);
        }
    }

    // N/A te_bount013

    //bandits - bandithead te_bount014
    if(GetResRef(oDead) == "bandit002"||GetResRef(oDead) == "bandit005"||GetResRef(oDead) == "te_npc_1079lk"||GetResRef(oDead) == "te_bandit1"||
        GetResRef(oDead) == "te_bandit006"||GetResRef(oDead) == "te_bandit008"||GetResRef(oDead) == "te_npc_1080lk"||GetResRef(oDead) == "te_bandit2"||
        GetResRef(oDead) == "bandit003"||GetResRef(oDead) == "bandit004"||GetResRef(oDead) == "te_npc_1081lk"||GetResRef(oDead) == "te_bandit3"||
        GetResRef(oDead) == "te_bandit007"||GetResRef(oDead) == "te_bandit009"||GetResRef(oDead) == "te_npc_1082lk"||GetResRef(oDead) == "te_bandit4"||
        GetResRef(oDead) == "te_npc_1081"||GetResRef(oDead) == "te_npc_1082"||GetResRef(oDead) == "te_npc_1079"||GetResRef(oDead) == "te_npc_1080" ||
        GetResRef(oDead) == "te_npc_2256"||GetResRef(oDead) == "te_npc_2257"||GetResRef(oDead) == "te_npc_2263"||GetResRef(oDead) == "te_npc_2264"
        )
    {
        if(d100(1)<=25)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount014",oPlace,1);
        }
    }

    //blighters te_bount015
    if(GetResRef(oDead) == "te_npc_1066"||GetResRef(oDead) == "te_npc_1067"||GetResRef(oDead) == "te_npc_2252"||GetResRef(oDead) == "te_npc_2253"||GetResRef(oDead) == "te_npc_2254")
    {
        if(d100(1)<=25)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount015",oPlace,1);
        }
    }

    //Deserters and deserter heads te_bount016
    if(GetResRef(oDead) == "te_npc_1050"||GetResRef(oDead) == "te_npc_1051"||GetResRef(oDead) == "te_npc_1052" ||
       GetResRef(oDead) == "te_npc_1053"|| GetResRef(oDead) == "te_npc_1054" ||GetResRef(oDead) == "te_npc_1055" )
    {
        if(d100(1)<=50)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount016",oPlace,1);
        }
    }

    // N/A te_bount017


    //Hill Gian te_bount018
    if(GetResRef(oDead) == "te_mons7h")
    {
        if(d100(1)<=95)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount018",oPlace,1);
        }
    }

    //Werewolves - te_bount019
    if(GetResRef(oDead) == "te_mons4fp"||GetResRef(oDead) == "te_mons8fp"||GetResRef(oDead) == "te_spire013")
    {
        if(d100(1)<=75)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount019",oPlace,1);
        }
    }

    // N/A te_bount020

    //Orcs and Orogs te_bounty021
    if(GetResRef(oDead) == "te_npc_2165"||GetResRef(oDead) == "te_npc_2207"||GetResRef(oDead) == "te_npc_2166"||GetResRef(oDead) == "te_npc_2175"||
        GetResRef(oDead) == "te_npc_2174"||GetResRef(oDead) == "te_npc_2167"||GetResRef(oDead) == "te_npc_2168"||GetResRef(oDead) == "te_npc_2172")
    {
        if(d100(1)<=25)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount021",oPlace,1);
        }
    }

    //Shadow Thief Order
    if(GetResRef(oDead) == "te_npc_1129")
    {
        if(d100(1)<=25)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount022",oPlace,1);
        }
    }

    //Orcs Orog chief heads te_bounty023
    if(GetResRef(oDead) == "te_npc_2170"||GetResRef(oDead) == "te_npc_2169"||GetResRef(oDead) == "te_npc_2171"||GetResRef(oDead) == "te_npc_2173")
    {
        if(d100(1)<=25)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount023",oPlace,1);
        }
    }

    //Gnolls - te_bount024
    if(GetResRef(oDead) == "te_mons2hp"||GetResRef(oDead) == "te_telf010"||GetResRef(oDead) == "te_teja011"||GetResRef(oDead) == "te_npc_1126" ||
       GetResRef(oDead) == "te_telf011"||GetResRef(oDead) == "te_npc_1126b"||GetResRef(oDead) == "te_mons2hpb"
    )
    {
        if(d100(1)<=75)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount024",oPlace,1);
        }
    }

    //Drow - te_bount025
    if(GetResRef(oDead) == "drowcleric"||GetResRef(oDead) == "drowrogue"||GetResRef(oDead) == "drowftr"||GetResRef(oDead) == "drowwizard")
    {
        if(d100(1)<=75)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount025",oPlace,1);
        }
    }

    //Vampire - te_bount026
    if(GetResRef(oDead) == "te_npc_2262" ||GetResRef(oDead) == "te_udmons_8" || GetResRef(oDead) == "te_br_npc_k1001" || GetResRef(oDead) == "te_br_npc_k1002"||
       GetResRef(oDead) == "te_br_npc_k1004" ||GetResRef(oDead) == "te_br_npc_k1005" || GetResRef(oDead) == "te_br_npc_k1007" || GetResRef(oDead) == "te_npc_1015a001"
    )
    {
        if(d100(1)<=50)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount026",oPlace,1);
        }
    }

    //N/A - te_bount027

    //Infernal Crystals - te_bount028
    if(GetResRef(oDead) == "te_npc_2036" || GetResRef(oDead) == "te_npc_2266" || GetResRef(oDead) == "te_npc_2268" || GetResRef(oDead) == "te_plan3" ||
       GetResRef(oDead) == "te_npc_2048" || GetResRef(oDead) == "te_npc_2269")
    {
        if(d100(1)<=50)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_plan",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount028",oPlace,1);
        }
    }

    //Demons - Demonhearts te_bount028
    if(GetResRef(oDead) == "te_npc_2042" || GetResRef(oDead) == "te_udmons_14" || GetResRef(oDead) == "te_npc_2062" || GetResRef(oDead) == "te_plan4" ||
       GetResRef(oDead) == "te_npc_2018" || GetResRef(oDead) == "te_npc_2260"|| GetResRef(oDead) == "te_npc_2035"|| GetResRef(oDead) == "te_npc_2053")
    {
        if(d100(1)<=50)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_plan",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount029",oPlace,1);
        }
    }

    //Baatezu te_bount030
    if(GetResRef(oDead) == "te_plan15" || GetResRef(oDead) == "te_plan9" || GetResRef(oDead) == "te_npc_2057" || GetResRef(oDead) == "te_npc_2064" ||
       GetResRef(oDead) == "te_npc_2063" || GetResRef(oDead) == "te_npc_2058"|| GetResRef(oDead) == "te_plan21")
    {
        if(d100(1)<=50)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_plan",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount030",oPlace,1);
        }
    }

    //Tanari - te_bount031
    if(GetResRef(oDead) == "te_npc_2047" || GetResRef(oDead) == "te_plan22" || GetResRef(oDead) == "te_npc_2065" || GetResRef(oDead) == "te_npc_2066" ||
       GetResRef(oDead) == "te_plan10" || GetResRef(oDead) == "te_plan16")
    {
        if(d100(1)<=50)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_plan",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount031",oPlace,1);
        }
    }

    //Bullywug - te_bount032
    if(GetResRef(oDead) == "te_npc_2303"||GetResRef(oDead) == "te_npc_2304"||GetResRef(oDead) == "te_npc_2305")
    {
        if(d100(1)<=25)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remains",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount032",oPlace,1);
        }
    }

    //Cyricists - audit check
    if(GetResRef(oDead) == "cyriccleric"||GetResRef(oDead) == "cyricftr"||GetResRef(oDead) == "cyricmage"||GetResRef(oDead) == "cyricrogue")
    {
        if(d100(1)<=50)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bount033",oPlace,1);
        }
    }

    //Lovitarans - audit check
    if(GetResRef(oDead) == "te_npc_2314" ||GetResRef(oDead) == "te_npc_2315" ||GetResRef(oDead) == "te_npc_2316")
    {
        if(d100(1)<=25)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_bounty035",oPlace,1);
        }
    }
    //Duergar miner slave
    if(GetResRef(oDead) == "te_npc_2158")
    {
        if(d100(1)<=10)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("ceb_crtpickaxe",oPlace,1);
        }
    }

    //Duergar - Adamantine bars te_item_0006
    if(GetResRef(oDead) == "te_npc_2160" || GetResRef(oDead) == "te_npc_2159")
    {
        if(d100(1)<=2)
        {
            oPlace = CreateObject(OBJECT_TYPE_PLACEABLE,"te_remain_mam",GetLocation(oDead),FALSE);
            CreateItemOnObject("te_item_0006",oPlace,1);
        }
    }

    if(GetIsObjectValid(oPlace) == TRUE)
    {
        SetLocalInt(oPlace,"nCreated",NWNX_Time_GetTimeStamp());
    }
}

//oPC == Object you wish to give XP to. Only PCs have multiclassing penalty.
//nXPToGive == Amount of XP Reward. If negative, multiclassing penalty will never be calculated or looked at.
//nMulticlass == TRUE for assessing multiclassing penalty. Default = 0/False.
void GiveTrueXPToCreature_Bount(object oPC, int nXPToGive, int nMulticlass)
{
    if(nXPToGive < 0)
    {
        SetXP(oPC,GetXP(oPC)+(nXPToGive));
    }
    else
    {
        if(nMulticlass == TRUE)
        {
            object oItem = GetItemPossessedBy(oPC,"PC_Data_Object");
            if(GetLocalInt(oItem,"iMulticlass") == TRUE)
            {
                nXPToGive = (nXPToGive - FloatToInt(IntToFloat(nXPToGive)*0.20));
                SetXP(oPC,GetXP(oPC)+nXPToGive);
            }
            else
            {
                SetXP(oPC,GetXP(oPC)+(nXPToGive));
            }
        }
        else
        {
            SetXP(oPC,GetXP(oPC)+(nXPToGive));
        }
    }
}
//void main(){}
