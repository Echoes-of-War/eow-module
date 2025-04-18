//::///////////////////////////////////////////////
//:: Lands of Intrigue Function Handler
//:: //:: Function(D20) 2016
//:://////////////////////////////////////////////
/*
    Instructions: Add below string at beginning of script for functions
        #include "loi_functions"

    Table of Contents
    2. CONSTANTS LIST
        1.1
        1.2 SubRace & Affliction Constants

        2.1 Regular Commands
                GetWaypointLocation
                TeleportObjectToObject
                TeleportObjectToLocation
        2.2 PCData Commands
                GetPCAffliction
                GetPCDeadStatus
                GetPCSubRace
                SetPCAffliction
                SetPCDeadStatus
                SetPCSubRace
        2.3 Death/Respawn Commands
                CreatePCBody
                DestroyPCBody
                EventRevivePCBody
                GetPCBodyOwner
        2.4 Placeable Commands
                GetIsPickable
                GetIsPlaceable
                GetIsTurnable
                GetPlaceableType
                EventPlacePlaceable
                EventTakePlaceable
                EventUsePlaceable
                SetIsPickable - Not Done
                SetIsTurnable - Not Done
                SetPlaceableType - Not Done
    3. FUNCTION LIST
        3.1 Regular Funmctions
                GetWaypointLocation
                TeleportObject
        3.2 PCData Functions
                GetPCAffliction
                GetPCDeadStatus
                GetPCSubRace
                SetPCAffliction
                SetPCDeadStatus
                SetPCSubRace
        3.3 Death/Respawn Functions
                CreatePCBody
                GetPCBodyOwner
*/
//:://////////////////////////////////////////////
//:: Created By: Jonathan Lorentsen
//:: Email: jlorents93@hotmail.com
//:: Created On: 8Jun16
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
/*
1. CONSTANTS
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//::1.1 Placeholder
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
//::1.2 Affliction & SubRace Constants
//:://////////////////////////////////////////////
//AFFLICTION
const int PC_AFFLICTION_NONE = 0;
const int PC_AFFLICTION_WEREWOLF = 1;
const int PC_AFFLICTION_VAMPIRE_THRALL= 2;
const int PC_AFFLICTION_VAMPIRE = 3;
const int PC_AFFLICTION_VAMPIRE_DRIDER = 4;
const int PC_AFFLICTION_REVENANT = 5;
const int PC_AFFLICTION_DRIDER = 6;
const int PC_AFFLICTION_LICH = 7;

//SUBRACE
const int PC_SUBRACE_NONE = 0;
const int PC_SUBRACE_LYCAN = 1;
const int PC_SUBRACE_COPPER_ELF = 2;
const int PC_SUBRACE_GREEN_ELF = 3;
const int PC_SUBRACE_DARK_ELF = 4;
const int PC_SUBRACE_SILVER_ELF = 5;
const int PC_SUBRACE_GOLD_ELF = 6;
const int PC_SUBRACE_GOLD_DWARF = 7;
const int PC_SUBRACE_GREY_DWARF = 8;
const int PC_SUBRACE_SHIELD_DWARF = 9;
const int PC_SUBRACE_AASIMAR = 10;
const int PC_SUBRACE_TIEFLING = 11;

//:://////////////////////////////////////////////
//::1.3 Placeable Constants
//:://////////////////////////////////////////////
const int PLACEABLE_TYPE_NORMAL = 0;
const int PLACEABLE_TYPE_CHAIR = 1;
const int PLACEABLE_TYPE_LIGHTSOURCE = 2;
const int PLACEABLE_TYPE_SIGN = 3;
const int PLACEABLE_TYPE_CONTAINER = 4;
const int PLACEABLE_TYPE_SIEGE = 5;

#include "gs_inc_fixture"

//:://////////////////////////////////////////////
/*
2. COMMAND LIST
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//::2.1 Regular Commands
//:://////////////////////////////////////////////

//Get Waypoint Location
//sTag - Waypoint Tag
//Returns Location of Waypoint by Tag
location GetWaypointLocation(string sTag);

//Teleport Object to Location
//oTarget - Target Object
//ldestination - Target Destination
void TeleportObjectToLocation(object oTarget, location lDestination);

//Teleport Object to Object
//oTarget - Target Object
//ldestination - Target Destination
void TeleportObjectToObject(object oTarget, object oObject);

//:://////////////////////////////////////////////
//::2.2 PCData Commands
//:://////////////////////////////////////////////

//Get PC Affliction Status
//oPC - oTargetPC
//Returns int
//  None = 0, Werewolf = 1, Vampire Thrall 2,
//  Vampire = 3, Vampire Drider = 4, Revenant = 5
//  Drider = 6, Lich = 7 Vampiric Mist = 8
//*PC_Data_Object - int iPCAffliction
int GetPCAffliction(object oPC);

//Get PC Dead Status
//oTargetPC - Target PC
//ReturnsDeadStatus
//  0 = Alive
//  1 = Dead
//  2 = ???
//*PC_Data_Object - int iPCDead
int GetPCDeadStatus(object oTargetPC);

//Get PC SubRace Status
//oPC - oTargetPC
//Returns int
//  None = 0, Natual Lycan = 1, Copper Elf = 2,
//  Green Elf = 3, Dark Elf = 4, Silver Elf = 5,
//  Gold Elf = 6, Gold Dwarf = 7, Grey Dwarf = 8,
//  Shield Dwarf = 9, Aasimar = 10, Tiefling = 11
//*PC_Data_Object - int iPCSubRace
int GetPCSubRace(object oPC);

//Set PC Affliction Status
//oTargetPC - Target PC
//nType - Status
//  None = 0, Werewolf = 1, Vampire Thrall 2,
//  Vampire = 3, Vampire Drider = 4, Revenant = 5
//  Drider = 6, Lich = 7, Vampiric Mist = 8
//*PC_Data_Object - int iPCAffliction
void SetPCAffliction(object oTargetPC, int nType);

//Set PC Dead Status
//oTargetPC - Target PC
//nType - Status
//  0 = Alive
//  1 = Dead
//*PC_Data_Object - int iPCDead
void SetPCDeadStatus(object oTargetPC, int nType);

//Set PC SubRace Status
//oTargetPC - Target PC
//nType - Status
//  None = 0, Natual Lycan = 1, Copper Elf = 2,
//  Green Elf = 3, Dark Elf = 4, Silver Elf = 5,
//  Gold Elf = 6, Gold Dwarf = 7, Grey Dwarf = 8,
//  Shield Dwarf = 9, Aasimar = 10, Tiefling = 11
//*PC_Data_Object - int iPCSubRace
void SetPCSubRace(object oTargetPC, int nType);

//:://////////////////////////////////////////////
//::2.3 Death/Respawn Commands
//:://////////////////////////////////////////////

//Create PC Corpse
//oPC - Target PC
//Places PC Corpse at PC Location
void CreatePCBody(object oPC, int nGoldPenalty=FALSE);


//Destroy PC Corpse
//oPC - Target PC
void DestroyPCBody(object oPC);

//Revive PC Corpse
//oTarget - Target Object
//oReviver - Sends Message to Reviver
void EventRevivePCBody(object oTarget, object oReviver=OBJECT_INVALID);

//Get PC Corpse Owner
//oPC - Target PC
//Returns object
object GetPCBodyOwner(object oTarget);

//:://////////////////////////////////////////////
//::2.4 Placeable Commands
//:://////////////////////////////////////////////

//Returns 1 if Pickable
//* "iPick" Variable from Object
int GetIsPickable(object oObject);

//Returns 1 if Placeable
//* "iDrop" Variable from Item
int GetIsPlaceable(object oItem);

//Returns 1 if Turnable
//* "iTurn" Variable from Object
int GetIsTurnable(object oObject);

//Return Placeable Type
//PLACEABLE_TYPE_NORMAL = 0, PLACEABLE_TYPE_CHAIR = 1
//PLACEABLE_TYPE_LIGHTSOURCE = 2, PLACEABLE_TYPE_SIGN = 3
//PLACEABLE_TYPE_CONTAINER = 4, PLACEABLE_TYPE_SIEGE = 5
//* "iType" Variable from Object
int GetPlaceableType(object oObject);

//Fires Place Event
//Instructions: Add to OnPlayerUnaq Module Script
//Ensure Item (TAG) & Placeable (Blueprint Resref) is same
//Add Variable "iDrop = 1" into the Item
//Note: Refrain using with Stackable Items, buggy/won't fire or consume all stacks.
void EventPlacePlaceable(object oPC, object oItem);

//Fires Take Event
//Instructions: Ensure Item (TAG) & Placeable (Blueprint Resref) is same
void EventTakePlaceable(object oPC,object oPlaceable);

//Fires Conversation from Object
//Instructions: Add to Placeable's OnUsedscript to Use Object.
//oPC - Target PC
//oObject - Conversating Object
//sDialogResRef - Conversationg Dialogue ResRef
void EventUsePlaceable(object oPC, object oObject, string sDialogResRef="");

//Create PC Corpse
//oPC - Target PC
//Places PC Corpse at DM Location
void DM_CreatePCBody(object oPC, location lDM);

//Gets the first free placeable slot in the area "array" of 20 values. Will return first free slot.
int GetFreePlaceableSlot(object oArea);

//Respawn as normal in Maus.
void EventRespawnSafePCBody(object oTarget, object oReviver=OBJECT_INVALID);

//Respawn if no body found.
void EventRespawnSafeNoBody(object oPC);

//Calculate XP penalty for resurrection
int PenaltyForResurrection(object oPC, int iPenPerHD=500);
//:://////////////////////////////////////////////
/*
3. COMMAND FUNCTION
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//::3.1 Regular Functions
//:://////////////////////////////////////////////

//Get Nearest PC

//Get Waypoint Location
location GetWaypointLocation(string sTag)
{
    //Declare major variables
    object oTarget = GetWaypointByTag(sTag);

    //Function
    return GetLocation(oTarget);
}

//Teleport Object to Location
void TeleportObjectToLocation(object oTarget, location lDestination)
{
    //Function
    AssignCommand(oTarget, ClearAllActions());
    AssignCommand(oTarget, JumpToLocation(lDestination));
}

//Teleport Object to Object
void TeleportObjectToObject(object oTarget, object oObject)
{
    //Delcare major variables
    location lDestination = GetLocation(oObject);

    //Function
    AssignCommand(oTarget, ClearAllActions());
    AssignCommand(oTarget, JumpToLocation(lDestination));
}

//:://////////////////////////////////////////////
//::3.2 PCData Functions
//:://////////////////////////////////////////////

//Get PC SubRace Status
int GetPCAffliction(object oPC)
{
    //Declare major variables
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");

    //Function
    return GetLocalInt(oItem, "iPCAffliction");
}

//Get PC Dead Status
int GetPCDeadStatus(object oTargetPC)
{
    //Declare major variables
    object oItem = GetItemPossessedBy(oTargetPC, "PC_Data_Object");

    //Function
    return GetLocalInt(oItem, "iPCDead");
}

//Get PC SubRace Status
int GetPCSubRace(object oPC)
{
    //Declare major variables
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");

    //Function
    return GetLocalInt(oItem, "iPCSubrace");
}
//Set PC Affliction Status
void SetPCAffliction(object oTargetPC, int nType)
{
    //Declare major variables
    object oItem = GetItemPossessedBy(oTargetPC, "PC_Data_Object");

    //Function
    SetLocalInt(oItem, "iPCAffliction", nType);
    if (nType == 3)
    {
        SetLocalInt(oItem,"iUndead", 1);
        SetLocalInt(oItem,"PC_ECL2",4);}
    else if (nType == 4)
    {
        SetLocalInt(oItem, "iUndead", 1);
        SetLocalInt(oItem,"PC_ECL2",8);}
    else if (nType == 8)
    {
        SetLocalInt(oItem, "iUndead", 1);
        SetLocalInt(oItem,"PC_ECL2",13);}
    else if (nType == 5)
    {
        SetLocalInt(oItem, "iUndead", 1);
        SetLocalInt(oItem,"PC_ECL2",4);}
    else if (nType == 6)
    {
        SetLocalInt(oItem, "iUndead", 0);
        SetLocalInt(oItem,"PC_ECL2",4);}
    else if (nType == 4)
    {
        SetLocalInt(oItem, "iUndead", 1);
        SetLocalInt(oItem,"PC_ECL2",8);}
    else if (nType == 7)
    {
        SetLocalInt(oItem, "iUndead", 1);
        SetLocalInt(oItem,"PC_ECL2",4);}
    else
    {
        SetLocalInt(oItem,"iUndead",0);
        SetLocalInt(oItem,"PC_ECL2", 0);}
}

//Set PC Dead Status
void SetPCDeadStatus(object oTargetPC, int nType)
{
    //Declare major variables
    object oItem = GetItemPossessedBy(oTargetPC, "PC_Data_Object");

    //Function
    SetLocalInt(oItem, "iPCDead", nType);
}

//Set PC SubRace Status
void SetPCSubRace(object oTargetPC, int nType)
{
    //Declare major variables
    object oItem = GetItemPossessedBy(oTargetPC, "PC_Data_Object");

    //Function
    SetLocalInt(oItem, "iPCSubrace", nType);
}

//:://////////////////////////////////////////////
//::3.3 Death/Respawn Functions
//:://////////////////////////////////////////////

//Create PC Corpse
void CreatePCBody(object oPC, int nGoldPenalty)
{
    //Declare major variables
    object oBody;
    object oDupe;
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    string sPCName = GetName(oPC);
    string sBodyID = ObjectToString(oPC)+"BODY";
    location lPC = GetLocation(oPC);
    oDupe = GetObjectByTag(sBodyID);

    //Function
    //Destroy Duplicate, Create Body, Change Name, Store Owner, Drop Gold
    DestroyObject(oDupe);
    oBody = CreateObject(OBJECT_TYPE_PLACEABLE, "PCBody", lPC, FALSE, sBodyID);
    SetName(oBody, sPCName+"'s Body");
    SetLocalObject(oBody, "oOwner", oPC);
    SetLocalObject(oItem, "oCorpse", oBody);

    if(GetObjectType(oBody) == OBJECT_TYPE_PLACEABLE)
    {
        gsFXSaveFixture(GetTag(GetArea(oBody)),oBody);
    }

    //Gold Penalty Switch
    if (nGoldPenalty == TRUE)
    {
        AssignCommand(oBody, TakeGoldFromCreature(GetGold(oPC), oPC));
        int nD10 = Random(11);
        object oDrop;
        object oCopy;

        if(nD10 == 1)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 2)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_BELT,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 3)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_BOOTS,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 4)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 5)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 6)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 7)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 8)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_NECK,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 9)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 10)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 11)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_ARMS,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
    }
    else
    {
    }

    object oStain = CreateObject(OBJECT_TYPE_PLACEABLE, "te_deathstain", lPC, FALSE);
    SetLocalObject(oStain, "oOwner", oPC);
    SetLocalString(oStain,"sName",sPCName);
}

//Create PC Corpse
void CreateUndeadPCBody(object oPC, int nGoldPenalty)
{
    //Declare major variables
    object oBody;
    object oDupe;
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    string sPCName = GetName(oPC);
    string sBodyID = ObjectToString(oPC)+"BODY";
    location lPC = GetLocation(oPC);
    oDupe = GetObjectByTag(sBodyID);

    //Function
    //Destroy Duplicate, Create Body, Change Name, Store Owner, Drop Gold
    DestroyObject(oDupe);
    oBody = CreateObject(OBJECT_TYPE_PLACEABLE, "UNDBody", lPC, FALSE, sBodyID);
    SetName(oBody, sPCName+"'s Ashes");
    SetLocalObject(oBody, "oOwner", oPC);
    SetLocalObject(oItem, "oCorpse", oBody);
    SetLocalInt(oBody,"nUndead",1);

    if(GetObjectType(oBody) == OBJECT_TYPE_PLACEABLE)
    {
        gsFXSaveFixture(GetTag(GetArea(oBody)),oBody);
    }

    //Gold Penalty Switch
    if (nGoldPenalty == TRUE)
    {
        AssignCommand(oBody, TakeGoldFromCreature(GetGold(oPC), oPC));
        int nD10 = Random(11);
        object oDrop;
        object oCopy;

        if(nD10 == 1)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 2)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_BELT,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 3)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_BOOTS,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 4)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 5)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 6)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 7)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 8)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_NECK,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 9)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 10)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
        else if(nD10 == 11)
        {
            oDrop = GetItemInSlot(INVENTORY_SLOT_ARMS,oPC);
            if(oDrop != OBJECT_INVALID)
            {
                oCopy = CopyItem(oDrop,oBody,TRUE);
                DestroyObject(oDrop,0.1f);
            }
        }
    }
    else
    {
    }
}


//Destroy PC Corpse
void DestroyPCBody(object oPC)
{
    //Declare major variables
    object oBody;
    string sPCName = GetName(oPC);
    string sBodyID = ObjectToString(oPC)+"BODY";
    location lPC = GetLocation(oPC);
    oBody = GetObjectByTag(sBodyID);
    gsFXDeleteFixture(GetTag(GetArea(oBody)),oBody);
    DestroyObject(oBody);
}

//Revive living PC Body
void EventRevivePCBody(object oTarget, object oReviver=OBJECT_INVALID)
{
    //Declare major variables
    effect eEffect = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
    location lTarget = GetLocation(oTarget);
    object oTargetPC = GetPCBodyOwner(oTarget);

    //Functions
    if (GetLocalInt(oTarget, "PCBody") == 1 && GetIsObjectValid(oTargetPC) == TRUE && GetLocalInt(oTarget,"Undead") != 1)
    {
        if(GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
        {
            gsFXDeleteFixture(GetTag(GetArea(oTarget)),oTarget);
        }
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, lTarget);
        DestroyObject(oTarget);
        SetPCDeadStatus(oTargetPC, 0);
        SetLocalInt(GetItemPossessedBy(oTargetPC,"PC_Data_Object"),"ShoonAfflic",0);

        int iXP = GetXP(oTargetPC);
        int iXPPenPerLevel = 500;
        if (GetIsObjectValid(oReviver))
        {
            iXPPenPerLevel = 250;
        }
        int iXPPen = PenaltyForResurrection(oTargetPC, iXPPenPerLevel); 
        SetXP(oTargetPC, iXP - iXPPen);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(),oTargetPC);
        TeleportObjectToLocation(oTargetPC, lTarget);
        if (GetAreaFromLocation(lTarget) == OBJECT_INVALID)
        {
            TeleportObjectToObject(oTargetPC, GetItemPossessor(oTarget));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, GetLocation(GetItemPossessor(oTarget)));
        }
    }
    else
    {
        SendMessageToPC(oReviver, "Invalid Object or Player Unavailable");
    }
}

//Revive living PC Body
void EventResurrectPCBody(object oTarget, object oReviver=OBJECT_INVALID)
{
    //Declare major variables
    effect eEffect = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
    location lTarget = GetLocation(oTarget);
    object oTargetPC = GetPCBodyOwner(oTarget);

    //Functions
    if (GetLocalInt(oTarget, "PCBody") == 1 && GetIsObjectValid(oTargetPC) == TRUE && GetLocalInt(oTarget,"Undead") != 1)
    {
        if(GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
        {
            gsFXDeleteFixture(GetTag(GetArea(oTarget)),oTarget);
        }
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, lTarget);
        DestroyObject(oTarget);
        SetLocalInt(GetItemPossessedBy(oTargetPC,"PC_Data_Object"),"ShoonAfflic",0);
        SetPCDeadStatus(oTargetPC, 0);

        int iXP = GetXP(oTargetPC);
        int iXPPen = PenaltyForResurrection(oTargetPC, 100);
        SetXP(oTargetPC, iXP - iXPPen);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(),oTargetPC);
        TeleportObjectToLocation(oTargetPC, lTarget);
        if (GetAreaFromLocation(lTarget) == OBJECT_INVALID)
        {
            TeleportObjectToObject(oTargetPC, GetItemPossessor(oTarget));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, GetLocation(GetItemPossessor(oTarget)));
        }
    }
    else
    {
        SendMessageToPC(oReviver, "Invalid Object or Player Unavailable");
    }
}

//Revive undead PC Body
void EventReviveUndPCBody(object oTarget, object oReviver=OBJECT_INVALID)
{
    //Declare major variables
    effect eEffect = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
    location lTarget = GetLocation(oTarget);
    object oTargetPC = GetPCBodyOwner(oTarget);

    //Functions
    if (GetLocalInt(oTarget, "PCBody") == 1 && GetIsObjectValid(oTargetPC) == TRUE && GetLocalInt(oTarget,"Undead") == 1)
    {
        if(GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
        {
            gsFXDeleteFixture(GetTag(GetArea(oTarget)),oTarget);
        }
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, lTarget);
        DestroyObject(oTarget);
        SetPCDeadStatus(oTargetPC, 0);

        int iXP = GetXP(oTargetPC);
        int iXPPen = PenaltyForResurrection(oTargetPC, 250);
        SetXP(oTargetPC, iXP - iXPPen);
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(),oTargetPC);
        TeleportObjectToLocation(oTargetPC, lTarget);
        if (GetAreaFromLocation(lTarget) == OBJECT_INVALID)
        {
            TeleportObjectToObject(oTargetPC, GetItemPossessor(oTarget));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, GetLocation(GetItemPossessor(oTarget)));
        }
    }
    else
    {
        SendMessageToPC(oReviver, "Invalid Object or Player Unavailable");
    }
}

//Get PC Corpse Owner
object GetPCBodyOwner(object oTarget)
{
    //Function
    return GetLocalObject(oTarget, "oOwner");
}

//:://////////////////////////////////////////////
//::3.4 Placeable Functions
//:://////////////////////////////////////////////

//Returns 1 if Pickable
int GetIsPickable(object oObject)
{
    //Function
    return GetLocalInt(oObject, "iPick");
}

//Returns 1 if Placeable
int GetIsPlaceable(object oItem)
{
    //Function
    return GetLocalInt(oItem, "iDrop");
}

//Returns 1 if Turnable
int GetIsTurnable(object oObject)
{
    //Function
    return GetLocalInt(oObject, "iTurn");
}

//Return Placeable Type
int GetPlaceableType(object oObject)
{
    //Function
    return GetLocalInt(oObject, "iType");
}

//Place Placeable
void EventPlacePlaceable(object oPC, object oItem)
{
    if (GetIsPlaceable(oItem) == 1)
    {
        //Declare Variables
        string sTag;
        location lTarget = GetLocation(oItem);
        object oPlaceable;
        object oBody;
        object oOwner = GetPCBodyOwner(oItem);

        //Functions
        if (GetLocalInt(oItem, "PCBody") == 0)
        {
            sTag = GetTag(oItem);
            oPlaceable = CreateObject(OBJECT_TYPE_PLACEABLE, sTag, lTarget, TRUE);
            if (GetAreaFromLocation(lTarget) != OBJECT_INVALID)
            {
                int nSaved = gsFXSaveFixture(GetTag(GetArea(oPlaceable)),oPlaceable);
                DestroyObject(oItem, 0.0f);
                if(nSaved = TRUE) { SendMessageToPC(oPC,"Placeable persistently saved to area.");}
                else{SendMessageToPC(oPC,"Placeable limit for the area reached! Placeable NOT saved to area.");}
            }
        }
        else if (GetLocalInt(oItem, "PCBody") == 1)
        {
            sTag = GetResRef(oItem);
            string sBodyID = GetTag(oItem);
            string sName = GetName(oItem);
            oBody = CreateObject(OBJECT_TYPE_PLACEABLE, sTag, lTarget, TRUE, sBodyID);
            if (GetAreaFromLocation(lTarget) != OBJECT_INVALID)
            {
                gsFXSaveFixture(GetTag(GetArea(oPlaceable)),oPlaceable);
                DestroyObject(oItem, 0.0f);
            }
            SetName(oBody, sName);
            SetLocalObject(oBody, "oOwner", oOwner);
        }
    }
}

//Take Placeable
void EventTakePlaceable(object oPC, object oPlaceable)
{
    //Major Variables
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object"); //Fetch PC Data Item
    object oTarget = GetLocalObject(oItem, "oPick"); //Get Temp Var
    object oOwner = GetPCBodyOwner(oTarget);
    object oBody;
    string sTag = GetResRef(oTarget); //Set Tag String by ResRef Name
    string sName = GetName(oTarget);
    string sBody = GetTag(oTarget);

    object oArea = GetArea(oPC);
    string sATag = GetTag(oArea);


    //Functions
    if (GetLocalInt(oTarget, "PCBody") == 0)
        {
        gsFXDeleteFixture(GetTag(GetArea(oPC)),oTarget);
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 3.0));
        CreateItemOnObject(sTag, oPC, 1);
        DestroyObject(oTarget, 0.0);
        DeleteLocalObject(oItem, "oPick");
        }
    else if (GetLocalInt(oTarget, "PCBody") == 1)
        {
        gsFXDeleteFixture(GetTag(GetArea(oPC)),oTarget);
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 3.0));
        oBody = CreateItemOnObject(sTag, oPC, 1, sBody);
        SetName(oBody, sName);
        SetLocalObject(oBody, "oOwner", oOwner);
        DestroyObject(oTarget, 0.0);
        DeleteLocalObject(oItem, "oPick");
        }
}

//Use Placeable
void EventUsePlaceable(object oPC, object oObject, string sDialogResRef="")
{
    //Deckare Variables
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");

    //Functions
    AssignCommand(oPC, ActionStartConversation(oObject, sDialogResRef, TRUE, FALSE));
    SetLocalObject(oItem, "oPick", oObject); //Set Temp Var to Call
}


void DM_CreatePCBody(object oPC, location lDM)
{
    //Declare major variables
    object oBody;
    object oDupe;
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    string sPCName = GetName(oPC);
    string sBodyID = ObjectToString(oPC)+"BODY";
    oDupe = GetObjectByTag(sBodyID);

    //Function
    //Destroy Duplicate, Create Body, Change Name, Store Owner, Drop Gold
    DestroyObject(oDupe);
    oBody = CreateObject(OBJECT_TYPE_PLACEABLE, "PCBody", lDM, FALSE, sBodyID);
    SetName(oBody, sPCName+"'s Body");
    SetLocalInt(oBody, "PCBody",1);
    SetLocalObject(oBody, "oOwner", oPC);
    SetLocalObject(oItem, "oCorpse", oBody);
}

void EventRespawnSafePCBody(object oTarget, object oReviver=OBJECT_INVALID)
{
    //Declare major variables
    effect eEffect = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
    location lTarget = GetWaypointLocation("wp_mausrespawn");
    object oTargetPC = GetPCBodyOwner(oTarget);

    //Functions
    if (GetLocalInt(oTarget, "PCBody") == 1 && GetIsObjectValid(oTargetPC) == TRUE && GetLocalInt(oTarget,"Undead") != 1)
    {
        if(GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
        {
            gsFXDeleteFixture(GetTag(GetArea(oTarget)),oTarget);
        }
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, lTarget);
        DestroyObject(oTarget);
        SetPCDeadStatus(oTargetPC, 0);

        int iXP = GetXP(oTargetPC);
        int iXPPen = PenaltyForResurrection(oTargetPC, 500);
        SetXP(oTargetPC, iXP - iXPPen);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(),oTargetPC);
        TeleportObjectToLocation(oTargetPC, lTarget);
        if (GetAreaFromLocation(lTarget) == OBJECT_INVALID)
        {
            TeleportObjectToObject(oTargetPC, GetItemPossessor(oTarget));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, GetLocation(GetItemPossessor(oTarget)));
        }
    }
    else
    {
        SendMessageToPC(oReviver, "Invalid Object or Player Unavailable");
    }
}

//Respawn if no body found.
void EventRespawnSafeNoBody(object oPC)
{
    //Declare major variables
    effect eEffect = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
    location lTarget = GetWaypointLocation("wp_mausrespawn");

    //Functions
    if (GetIsObjectValid(oPC) == TRUE && GetLocalInt(oPC,"Undead") != 1)
    {
        SetPCDeadStatus(oPC, 0);

        int iXP = GetXP(oPC);
        int iXPPen = PenaltyForResurrection(oPC, 500);
        SetXP(oPC, iXP - iXPPen);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(),oPC);
        TeleportObjectToLocation(oPC, lTarget);
    }
}

//Calculate XP penalty for resurrection
int PenaltyForResurrection(object oPC, int iPenPerHD=500)
{
    int iHD = GetHitDice(oPC);
    int iXPPen = iHD*iPenPerHD;

    if (iHD <=5)
    {
        iXPPen = 0;
    }

    return iXPPen;
}