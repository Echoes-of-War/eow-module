//::///////////////////////////////////////////////
//:: _inc_loot
//:://////////////////////////////////////////////
/*
    MAGUS LOOT SYSTEM

    incorporates SOU treasure system from NWN.

    LOCAL VARIABLES ON LOOTABLE OBJECT

    LOOT            int     0 = no loot, 1 or more indicates the max number of items to create in loot
    LOOT_ONCE       int     1 = this object will only generate loot once per module load
    LOOT_PERIOD     int     time in game minutes between loot spawns. if unset, the default is used.
    LOOT_TYPE       string  a space delimited list of any number of treasure types. see below.
    LOOT_ITEM_ONCE  int     1 = duplicates from non-custom lists will only spawn once.
    LOOT_ONLY_QUALITY int   1 = non custom items will always be better than minimum value
    LOOT_LEVEL_ADJ  int     1 = min and max value of treasure is set by level, but never more than LOOT_VALUE_MAX and never less than LOOT_VALUE_MIN
    LOOT_VALUE_MAX  int     maximum GP value of loot (if an item puts total loot value over max, the item is destroyed)
    LOOT_VALUE_MIN  int     minimum GP value of loot (if total loot value is less than minimum, the remainder is gold)
    LOOT_REMAINDER  int     0 = no remainder, 1 = top off with coins

    LOOT TYPES:
        - "coins" type generates gold coins at random between min and max
        - "custom" type picks one item at random from a pseudo array defined as follows:
        LOOT_CUSTOM     int     length of custom loot pseduo-array
        LOOT_CUSTOM_1   string  resref of loot item #1
        LOOT_CUSTOM_,,, string  another resref of a custom loot item
        - other than these 2 special types this sould be the tag of a store, the inventory of which will contain a list of possible loot items
        - following the tag or special type you can use a % followed by 2 digits to indicate percentage.

    example:
        LOOT        = 10
        LOOT_TYPE   = loot_store1%99   coins%20   loot_weapons%15   loot_junk%34

    note that the percentage does not need to add up to 100%.
    Percentage for coins indicates % of total loot to be made up of coins.
    Percentage for custom indicates chance in 100 that one custom item will be spawned
    Percentage for merchant is both a chance to spawn and indicates the maximum number of items to be possibly generated from this source.
    So for our example loot_store1 will generate at most 9 items. loot_weapons 1, loot_junk 3
    coins will be generated first (because thats how treasure is generated) and comprise up to 20% of the total value of the loot

*/
//:://////////////////////////////////////////////
//:: Created:   magus (2016 mar 1)
//:: Modified:  magus (2016 mar 3)  -added- LootInitAreaMerchants
//::                                -mod-   LootGetLevelAdjValue   read local vars on module for level adj values
//:: Modified:  magus (2016 mar 6)  several adjustments to eliminate TMI errors
//:://////////////////////////////////////////////

// Shadows Of Undrentide treasure system (with a few small changes for compatibility)
#include "x0_i0_treasure"

#include "te_functions"

// GLOBALS ---------------------------------------------------------------------

// tag of area with the module's merchants
const string LOOT_STORE_AREA_TAG= "ooc_merchants";
// this is a label for a local variable set on an item generated as loot. Its a flag, so we can track, spawned loot
const string LOOT_ITEM  = "LOOT_ITEM_FLAG";

// DECLARATIIONS ---------------------------------------------------------------

struct LOOT
{
    int count;
    int value;
};

// determine appropriate level for loot [File: _inc_loot]
int LootGetLooterLevel(object oLooter, object oContainer=OBJECT_SELF);
// returns a min or max value for loot based on level [File: _inc_loot]
int LootGetLevelAdjValue(int nLevel, int nMin, int nMax, int return_max=TRUE);
// initialize all merchants in area [File: _inc_loot]
void LootInitAreaMerchants(object oArea=OBJECT_SELF);
// returns next type in list of types or "" if sType is the last [File: _inc_loot]
string LootGetNextTypeInList(string sType, string sList, object oContainer, int this_type_index=0);
// returns loot type based on its probability [File: _inc_loot]
string LootGetRandomType(object oContainer=OBJECT_SELF);
// initialize the set of possible items for the container [File: _inc_loot]
float LootInitPossibleList(string sLootTypes, int nMaxItems, int nMaxValue, int nMinValue, object oContainer);
// removes this item from the possible list [File: _inc_loot]
void LootSetItemImpossible(string loot_type, string loot_item, object oContainer);
// returns string of random loot item of type sType [File: _inc_loot]
string LootGetRandomItemOfType(string sType, object oContainer=OBJECT_SELF);
// generates a random amount of gold in a container [File: _inc_loot]
// range of gold is between nLow and nHigh
// return value equals amount of gold created
int LootCreateGold(int nHigh, int nLow, object oContainer=OBJECT_SELF, string sRef="nw_it_gold001");
// master function which generates loot for a container [File: _inc_loot]
void LootCreateItems(int loot_items_max, int loot_value, int loot_max, int loot_min, object oContainer, object oLooter, object oDataObj);
// master function which generates loot for a container [File: _inc_loot]
void LootGenerate(object oLooter, object oContainer=OBJECT_SELF);
// Calculate item drop for creatures killed by PC. - [FILE: _inc_loot]
void LootCreatureDeath(object oCreature, object oKiller=OBJECT_INVALID);


// IMPLEMENTATIONS -------------------------------------------------------------

int LootGetLooterLevel(object oLooter, object oContainer=OBJECT_SELF)
{
    int nLevel, nCount;
    location loc_loot   = GetLocation(oContainer);
    object  oPC = GetFirstObjectInShape(SHAPE_SPHERE, 25.5, loc_loot);
    while(GetIsObjectValid(oPC))
    {
        if(GetIsPC(oPC)&&!GetIsDM(oPC))
        {
            nLevel += GetHitDice(oPC);
            nCount++;
        }
        oPC = GetNextObjectInShape(SHAPE_SPHERE, 25.5, loc_loot);
    }
    if(!nCount)
        nLevel  = GetHitDice(oLooter);
    else
        nLevel  = nLevel/nCount;

    return nLevel;
}

int LootGetLevelAdjValue(int nLevel, int nMin, int nMax, int return_max=TRUE)
{
    object oMod = GetModule();
    int nMinTmp = GetLocalInt(oMod, "LOOT_VALUE_MIN_"+IntToString(nLevel));
    int nMaxTmp = GetLocalInt(oMod, "LOOT_VALUE_MAX_"+IntToString(nLevel));

    if(!nMinTmp&&!nMaxTmp)
    {
      switch(nLevel)
      {
        case 1:
            nMinTmp = 10;
            nMaxTmp = 300;
        break;
        case 2:
            nMinTmp = 20;
            nMaxTmp = 600;
        break;
        case 3:
            nMinTmp = 30;
            nMaxTmp = 900;
        break;
        case 4:
            nMinTmp = 50;
            nMaxTmp = 1200;
        break;
        case 5:
            nMinTmp = 70;
            nMaxTmp = 1600;
        break;
        case 6:
            nMinTmp = 90;
            nMaxTmp = 2000;
        break;
        case 7:
            nMinTmp = 110;
            nMaxTmp = 2600;
        break;
        case 8:
            nMinTmp = 150;
            nMaxTmp = 3400;
        break;
        case 9:
            nMinTmp = 200;
            nMaxTmp = 4500;
        break;
        case 10:
            nMinTmp = 250;
            nMaxTmp = 5800;
        break;
        case 11:
            nMinTmp = 300;
            nMaxTmp = 7500;
        break;
        case 12:
            nMinTmp = 350;
            nMaxTmp = 9800;
        break;
        case 13:
            nMinTmp = 400;
            nMaxTmp = 13000;
        break;
        case 14:
            nMinTmp = 450;
            nMaxTmp = 17000;
        break;
        case 15:
            nMinTmp = 500;
            nMaxTmp = 22000;
        break;
        case 16:
            nMinTmp = 600;
            nMaxTmp = 28000;
        break;
        case 17:
            nMinTmp = 800;
            nMaxTmp = 36000;
        break;
        case 18:
            nMinTmp = 1000;
            nMaxTmp = 47000;
        break;
        case 19:
            nMinTmp = 1200;
            nMaxTmp = 61000;
        break;
        case 20:
            nMinTmp = 1400;
            nMaxTmp = 80000;
        break;
      }
    }

    if(nMinTmp<nMin)
        nMinTmp = nMin;
    if(nMax && nMaxTmp>nMax)
        nMaxTmp = nMax;

    if(nMinTmp>nMaxTmp)
    {
        nMinTmp = nMaxTmp - (nLevel*100);
        if(nMinTmp<0)
            nMinTmp = 0;
    }

    if(return_max)
        return nMaxTmp;
    else
        return nMinTmp;
}

void LootInitAreaMerchants(object oArea=OBJECT_SELF)
{
    if(GetLocalInt(oArea, "LOOT_INIT_STORES"))
        return;
    else
        SetLocalInt(oArea, "LOOT_INIT_STORES", TRUE);

    float fDelay            = 0.0;
    object object_in_area   = GetFirstObjectInArea(oArea);
    int iteration           = 1;
    object oStore           = GetNearestObject(OBJECT_TYPE_STORE, object_in_area, iteration);
    while(GetIsObjectValid(oStore))
    {
        fDelay  += 0.1;
        DelayCommand(fDelay, CTG_InitContainer(oStore));
        oStore  = GetNearestObject(OBJECT_TYPE_STORE, object_in_area, ++iteration);
    }
}

string LootGetRandomType(object oContainer=OBJECT_SELF)
{
    string sType, loot_type_id_base;
    // generate random probability number based on type percentages
    int nPer    = Random(GetLocalInt(oContainer,"LOOT_LIST_PER"));
    int nPerThreshold;
    int nTotal  = GetLocalInt(oContainer,"LOOT_TYPES_COUNT");
    int nCurrent;
    for(nCurrent=1;nCurrent<=nTotal;nCurrent++)
    {
        loot_type_id_base = "LOOT_TYPE_"+IntToString(nCurrent);
        if(GetLocalInt(oContainer,loot_type_id_base+"_ACTIVE"))
        {
            nPerThreshold += GetLocalInt(oContainer,loot_type_id_base+"_PER");
            if(nPer<nPerThreshold)
            {
                sType   = GetLocalString(oContainer,loot_type_id_base);
                break;
            }
        }
    }

    return sType;
}

string LootGetNextTypeInList(string sType, string sList, object oContainer, int this_type_index=0)
{
    int loot_types_count    = GetLocalInt(oContainer,"LOOT_TYPES_COUNT");
    if(loot_types_count==1)
        return "";

    if(!this_type_index)
    {
        this_type_index =1;
        while(this_type_index<loot_types_count)
        {
            if(sType==GetLocalString(oContainer,"LOOT_TYPE_"+IntToString(this_type_index)))
                break;
            this_type_index++;
        }
    }

    if(this_type_index>=loot_types_count)
        return "";

    string next_type, loot_type_id;
    int nNext   = this_type_index+1;
    while(nNext<=loot_types_count)
    {
        loot_type_id    = "LOOT_TYPE_"+IntToString(nNext);
        next_type   = GetLocalString(oContainer,loot_type_id);
        if(GetLocalInt(oContainer, loot_type_id+"_ACTIVE"))
            return next_type;

        nNext++;
    }

    return "";
}

void LootInitSubList(string loot_type, int nPercent, int nLootMax, int nMaxValue, int nMinValue, object oContainer)
{
    string loot_type_list   = GetLocalString(oContainer,"LOOT_TYPES_LIST");
    if(FindSubString(loot_type_list, ":"+loot_type+":")!=-1)
        return;

    string list; // list of spawnable items. most important var for this function.
    int nItems; // number of items held by the loot merchant

    object oMasterL = GetObjectByTag(loot_type);
    if(GetIsObjectValid(oMasterL))
    {
        CTG_InitContainer(oMasterL);
        nItems  = CTG_GetNumItemsInBaseContainer(oMasterL);
    }
    else
        return; // loot merchant is invalid. pass....

    if(nItems)
    {
        int id, nValue; string sID;
        if(nItems>999){nItems=999;}
        for (id=1; id<=nItems; id++)
        {
            sID = IntToString(id);
            nValue  = GetLocalInt(oMasterL, sTreasureValueVar+sID);

            if(     nValue
                &&  (!nMaxValue || nMaxValue>=nValue)
                &&  nMinValue<=nValue
              )
            {
                // pad string so that we have fixed length strings
                if(id>99)
                {
                    // string length is fine
                }
                else if(id>9)
                    sID = "0"+sID;
                else
                    sID = "00"+sID;

                list+=sID+":";
            }
        }

        // was anything added?
        if(GetStringLength(list)>1)
        {
            int loot_types_count;
            if(loot_type_list=="")
                loot_type_list=":";
            else
            {
                int nPos = FindSubString(loot_type_list,":",1);
                while(nPos!=-1)
                {
                    loot_types_count++;
                    nPos = FindSubString(loot_type_list,":",nPos+1);
                }
            }
            loot_types_count++;
            loot_type_list+=loot_type+":";
            SetLocalString(oContainer,"LOOT_TYPES_LIST", loot_type_list);
            SetLocalInt(oContainer,"LOOT_TYPES_COUNT",loot_types_count);
            SetLocalInt(oContainer,"LOOT_LIST_PER",GetLocalInt(oContainer,"LOOT_LIST_PER")+nPercent);

            string loot_type_id = "LOOT_TYPE_"+IntToString(loot_types_count);
            SetLocalString(oContainer,loot_type_id, loot_type);
            SetLocalInt(oContainer,loot_type_id+"_ACTIVE", TRUE);
            SetLocalInt(oContainer,loot_type_id+"_PER",nPercent);

            string loot_list_id = "LOOT_LIST_"+loot_type;
            SetLocalString(oContainer, loot_list_id, list);
            SetLocalInt(oContainer,loot_list_id+"_ID",loot_types_count);
            SetLocalInt(oContainer,loot_list_id+"_MAX",nLootMax);
            SetLocalInt(oContainer,loot_list_id+"_CNT",0);
        }
    }
}

float LootInitPossibleList(string sLootTypes, int nMaxItems, int nMaxValue, int nMinValue, object oContainer)
{
    float init_delay = 0.001;
    string sTmp; int nTmp, nPer, nTmpPer;
    sLootTypes = " "+sLootTypes+" ";
    int loot_types_count, nValue;
    int nPos1   = 1;
    int nPosA;
    int nPos2   = FindSubString(sLootTypes," ", nPos1);

    object oMasterL;
    while(nPos2>-1)
    {
        if(nPos2==nPos1)
        {
            // do nothing but search again. we ignore spaces adjacent one another
        }
        // we've found a gap between delimters, parse it.
        else
        {
            sTmp    = GetSubString(sLootTypes, nPos1, nPos2-(nPos1));
            nPosA   = FindSubString(sTmp,"%");
            if(nPosA>-1)
            {
                nTmp    = StringToInt( GetStringRight(sTmp,GetStringLength(sTmp)-(nPosA+1)) );
                if(nTmp>100){nTmp = 100;} // never more than 100%
                if(nTmp)
                {
                    nTmpPer = nTmp;

                    nTmp= FloatToInt(nMaxItems*(nTmp/100.0f));
                    if(!nTmp){nTmp=1;}
                }
                else
                {
                    nTmp= 100;
                    nTmpPer = nTmp;
                }
                sTmp    = GetStringLeft(sTmp, nPosA);
            }
            else
            {
                nTmp    = 100;
                nTmpPer = nTmp;
            }

            string sType = sTmp;
            if(     sType == "coins"// coins are a special case. do not add to list
                ||  sType == "custom"// custom is a special case. do not add to list
              )
            {
                if(nTmpPer>100)
                    nTmpPer=100;
                SetLocalInt(oContainer, "LOOT_TYPE_"+GetStringUpperCase(sType)+"_PER", nTmpPer);
            }
            else
            {
                DelayCommand(init_delay, LootInitSubList(sType, nTmpPer, nTmp, nMaxValue, nMinValue, oContainer));
                init_delay += 0.01;
            }
        }
        nPos1   = nPos2+1;
        nPos2   = FindSubString(sLootTypes," ", nPos1);
    }

    return init_delay;
}

void LootSetItemImpossible(string loot_type, string loot_item, object oContainer)
{
    string sItemFnd = ":"+loot_item+":";
    string loot_list_name   = "LOOT_LIST_"+loot_type;
    string sPosSet  = GetLocalString(oContainer,loot_list_name);

    int nPos        = FindSubString(sPosSet,sItemFnd);
    if(nPos!=-1)
    {
        string sBefore = GetStringLeft(sPosSet,nPos);
        string sAfter  = GetStringRight(sPosSet,GetStringLength(sPosSet)-(nPos+(GetStringLength(sItemFnd)-1)) );
        SetLocalString(oContainer, loot_list_name, sBefore+sAfter);
    }
}

string LootGetRandomItemOfType(string sType, object oContainer=OBJECT_SELF)
{
    string sList    = GetLocalString(oContainer,"LOOT_LIST_"+sType);
    int item_len    = 4;
    int start_pos   = 1;
    int nLen        = GetStringLength(sList)-start_pos;

    int item_count  = nLen/item_len;
    int item_pos    = start_pos+(Random(item_count)*item_len);

    return GetSubString(sList,item_pos,item_len-1);
}

void LootTypeInactive(string loot_type, object oContainer)
{
    string loot_type_base_id    = "LOOT_TYPE_"+IntToString(GetLocalInt(oContainer,"LOOT_LIST_"+loot_type+"_ID"));
    int nTotalPer   = GetLocalInt(oContainer,"LOOT_LIST_PER")
                          - GetLocalInt(oContainer,loot_type_base_id+"_PER");
    SetLocalInt(oContainer,"LOOT_LIST_PER",nTotalPer);
    DeleteLocalInt(oContainer,loot_type_base_id+"_ACTIVE");

    string loot_list_base   = "LOOT_LIST_"+loot_type;
    DeleteLocalString(oContainer,loot_list_base);
    DeleteLocalInt(oContainer,loot_list_base+"_MAX");
    DeleteLocalInt(oContainer,loot_list_base+"_PER");
    DeleteLocalInt(oContainer,loot_list_base+"_CNT");
}

int LootCheckTypeFinished(string sType, object oContainer)
{
    string loot_list_base = "LOOT_LIST_"+sType;
    if(GetLocalInt(oContainer, loot_list_base+"_CNT")<GetLocalInt(oContainer,loot_list_base+"_MAX"))
    {
        if(GetStringLength(GetLocalString(oContainer,loot_list_base))<3)
            return TRUE;
        else
            return FALSE;
    }
    else
        return TRUE;
}

struct LOOT LootGetExistingLoot(object oContainer=OBJECT_SELF)
{
    struct LOOT loot;
    object oItem    = GetFirstItemInInventory(oContainer);
    while(GetIsObjectValid(oItem))
    {
        if(GetBaseItemType(oItem)==BASE_ITEM_GOLD)
        {
            loot.value += GetItemStackSize(oItem);
        }
        else if(GetLocalInt(oItem, LOOT_ITEM))
        {
            loot.count ++;
            loot.value += GetGoldPieceValue(oItem);
        }

        oItem   = GetNextItemInInventory(oContainer);
    }

    return loot;
}

int LootCreateGold(int nHigh, int nLow, object oContainer=OBJECT_SELF, string sRef="nw_it_gold001")
{
    int nGold   = Random((nHigh-nLow)+1)+nLow;

    if(GetObjectType(oContainer)==OBJECT_TYPE_CREATURE)
    {
        GiveGoldToCreature(oContainer,nGold);
    }
    else
    {
        /*
        // you could have other appearances for gold stacks if you set up these resrefs
        // and expand the base_item for gold with more bitmap appearances and drop models
        int nRandom = Random(6)+1;
        if(nRandom==1)
            sRef    = "gold_silver";
        else if(nRandom==2 || nRandom==3)
            sRef    = "gold_old";
        */
        object oGold= CreateItemOnObject(sRef,oContainer,nGold);
        SetLocalInt(oGold, LOOT_ITEM, TRUE); // flag this gold as loot
    }

    return nGold;
}

void LootCreateItems(int loot_items_max, int loot_value, int loot_max, int loot_min, object oContainer, object oLooter, object oDataObj)
{
    if(!GetLocalInt(oContainer, "LOOT_TYPES_COUNT"))
        return;

    int nEachOnce   = GetLocalInt(oDataObj, "LOOT_ITEM_ONCE");

    object oMasterL, oItem; string sID; int nValue, nCount;
    // determine type based on probability of each type
    string loot_type= LootGetRandomType(oContainer);
    while(loot_type!="")
    {
        oMasterL = GetObjectByTag(loot_type);
        if(GetIsObjectValid(oMasterL))
        {
            // get item for type
            sID     = LootGetRandomItemOfType(loot_type,oContainer);

            nValue  = GetLocalInt(oMasterL, sTreasureValueVar+sID);

            // item is too expensive
            if(loot_max && (loot_value+nValue)>loot_max)
            {
                LootSetItemImpossible(loot_type, sID, oContainer);
                if(LootCheckTypeFinished(loot_type, oContainer))
                    LootTypeInactive(loot_type, oContainer);// remove loot_type from list
            }
            // add this item to the loot, and update count
            else
            {
                oItem   = CopyItem( CTG_GetTreasureItem(oMasterL, StringToInt(sID)),
                                    oContainer,
                                    TRUE
                                  );
                SetLocalInt(oItem,LOOT_ITEM, TRUE); // flag this item as spawned loot, so that we can track it

                if(nEachOnce)
                    LootSetItemImpossible(loot_type, sID, oContainer);

                loot_value +=nValue;
                // increase count of total loot items
                nCount++;
                if(nCount>=loot_items_max)
                    break;

                // increase count of items of this type
                string loot_list_base = "LOOT_LIST_"+loot_type;
                SetLocalInt(oContainer,
                            loot_list_base+"_CNT",
                            GetLocalInt(oContainer,loot_list_base+"_CNT")+1
                           );

                // determine if this loot type is played out
                if(LootCheckTypeFinished(loot_type, oContainer))
                    LootTypeInactive(loot_type, oContainer);// remove loot_type from list
            }
        }
        // ERROR - the store for this loot type isn't showing up
        else
            LootTypeInactive(loot_type, oContainer);// remove loot_type from list

        // get next random loot type
        loot_type= LootGetRandomType(oContainer);
    }

    // REMAINDER
    // if the value of loot is less than the minimum (or less than max 33% of time), make up the difference with gold
    int nRemainderType  = GetLocalInt(oDataObj,"LOOT_REMAINDER");
    if(!loot_max){loot_max = loot_min+5;}
    if(     nRemainderType
        &&(     loot_value<loot_min
            ||  (loot_value<loot_max && d3()==1)
          )
      )
    {
        // remainder is made up with gold
        if(nRemainderType==1)
        {
            loot_value  += LootCreateGold(loot_max-loot_value, loot_min-loot_value, oContainer);
        }
    }
}

void LootGenerate(object oLooter, object oContainer=OBJECT_SELF)
{
    if(!GetHasInventory(oContainer))
        return;

    object oDataObj = oContainer;
    int nLootItems  = GetLocalInt(oDataObj, "LOOT");
    if(!nLootItems)
    {
        oDataObj    = GetLocalObject(oContainer,"PAIRED");
        nLootItems  = GetLocalInt(oDataObj, "LOOT");
        if(!nLootItems)
            return;
    }

    if(GetLocalInt(oDataObj, "LOOT_ONCE"))
        SetLocalInt(oDataObj,"LOOT",0);

    // time until next treasure can be spawned
    int nPeriod     = GetLocalInt(oDataObj, "LOOT_PERIOD");
    if(!nPeriod)
    {
        nPeriod     = LOOT_PERIOD_MINUTES;
        SetLocalInt(oDataObj,"LOOT_PERIOD",nPeriod);
    }

    struct LOOT loot_existing = LootGetExistingLoot(oContainer);

    // is it time to spawn treasure?
    int nMinutes    = GetTimeCumulative(TIME_MINUTES);
    if(nMinutes<GetLocalInt(oDataObj, "LOOT_NEXT_SPAWN"))
        return; // not time yet
    else
    {
        SetLocalInt(oDataObj, "LOOT_NEXT_SPAWN", nMinutes+nPeriod); // continue
        // check to see if old loot was left behind
        nLootItems -= loot_existing.count;
        if(nLootItems<1) return; // we are already full. Do not spawn anymore
    }

    string sLootType= GetStringLowerCase(GetLocalString(oDataObj, "LOOT_TYPE"));
    int nMin        = GetLocalInt(oDataObj, "LOOT_VALUE_MIN");
    int nMax        = GetLocalInt(oDataObj, "LOOT_VALUE_MAX");

    if(GetLocalInt(oDataObj, "LOOT_LEVEL_ADJ"))
    {
        int nLevel  = LootGetLooterLevel(oLooter, oContainer);
        if(nLevel)
        {
            nMax    = LootGetLevelAdjValue(nLevel, nMin, nMax);
            nMin    = LootGetLevelAdjValue(nLevel, nMin, nMax, FALSE);
        }
    }
    // initialize list of possible items
    int nMinTmp;
    if(GetLocalInt(oDataObj,"LOOT_ONLY_QUALITY"))
        nMinTmp = nMin;
    float delay_items   = LootInitPossibleList(sLootType,nLootItems,nMax,nMinTmp,oContainer);

    // setup loot tracking variables
    int nTotal, nValue, nCount, nMaxOfType;
    string sType, sID, sItemID;
    object oItem;

    // check for items and gold still in chest
    if(nMax)
    {
        nMax       -= loot_existing.value;
        if(nMax<1)
            return;
    }

    // create gold?
    int nGoldPer    = GetLocalInt(oContainer,"LOOT_TYPE_COINS_PER");
    if(nGoldPer)
    {
        int nGoldMax;
        if(!nMax)
            nGoldMax= 50000*nGoldPer/100;
        else
            nGoldMax= nMax*nGoldPer/100;

        nTotal      = LootCreateGold(nGoldMax, (nMin*nGoldPer/100), oContainer);
    }

    // create custom items?
    int nCustomPer  = GetLocalInt(oContainer,"LOOT_TYPE_CUSTOM_PER");

    if(     nCustomPer
        &&  Random(100)<nCustomPer
      )
    {

        int nImp;
        int nCustomLen  = GetLocalInt(oDataObj,"LOOT_CUSTOM");
        string sImp;
        while(nImp<nCustomLen)
        {
            sID = IntToString(Random(nCustomLen)+1);

            if(FindSubString(sImp, sID)!=-1)
                continue;
            else
            {
                // generate item
                oItem   = CreateItemOnObject(   GetStringLowerCase(GetLocalString(oDataObj,"LOOT_CUSTOM_"+sID)),
                                                oContainer
                                            );

                nValue  = GetGoldPieceValue(oItem);
                if(nMax && (nTotal+nValue)>nMax)
                {
                    sImp    += sID+" ";
                    nImp++;
                    DestroyObject(oItem);
                }
                else
                {
                    nTotal += nValue;
                    nLootItems--;
                    break;
                }
            }
        }
    }

    // loot merchant items
    if(nLootItems)
    {
        DelayCommand(delay_items, LootCreateItems(nLootItems,nTotal,nMax,nMin,oContainer,oLooter, oDataObj));
    }
}

//item drop for killed creatures
void LootCreatureDeath(object oCreature, object oKiller=OBJECT_INVALID)
{
    //craft_drop_items(oKiller); // bioware drop

    if(GetLocalInt(oCreature,"LOOT"))
    {
        // Generate loot -- if any
        LootGenerate(oKiller, oCreature);
        SetLocalInt(oCreature,"LOOT",0);
    }
}

//void main(){}
