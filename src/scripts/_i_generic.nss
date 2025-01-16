//::////////////////////////////////////////////////////////////////////////////
//:: _i_generic
//::////////////////////////////////////////////////////////////////////////////
/*

    Generic helper functions

*/
//::////////////////////////////////////////////////////////////////////////////
//:: Created:   Galefer (03/12/24)
//::////////////////////////////////////////////////////////////////////////////

// INCLUDES  -------------------------------------------------------------------

#include "nw_i0_generic"
#include "x3_inc_string"

// GLOBALS ---------------------------------------------------------------------

// Example Global
const string sExample = "EXAMPLE";

// DECLARATIIONS ---------------------------------------------------------------

// Checks if DEBUG_MODE is TRUE or FALSE in the module variables.
// Make sure this is FALSE during live, non-testing gameplay.
int GetDebugMode();

object GetIDToken(object oPC);

float ConvertMinutesToSeconds(int nMinutes);

int GetIsPlayerWithin(object oPC, object oTarget, float fMeters);

object GetObjectInArea(object oArea, string sTag);

void ClearAndJump(object oPC, object oTarget);

// returns iCharacters from the end of a string
string GetLastCharacters(string sInput, int iCharacters);

void DestroyContents(object oContainer);

void RemoveEffectsByTag(object oTarget, string sEffect);

void DelayDestroyObject(object oObject);

int GetIsAreaInstanced(object oArea);

void SetIsAreaInstanced(object oArea, int iState);
// IMPLEMENTATIONS -------------------------------------------------------------

int GetDebugMode()
{
    object oMod = GetModule();
    int iDebugMode = GetLocalInt(oMod, "DEBUG_MODE");
    return iDebugMode;
}

void SendDebugMessage(string sMessage, object oPC, string sScript)
{
    if (GetDebugMode() == TRUE)
    {
        string sName = GetName(oPC);
        string sDebugTag = StringToRGBString("[DEBUG] ", "777");
        string sDebugTag2 = StringToRGBString("["+sName+"] ", "353");
        string sDebugTag3 = StringToRGBString("["+sScript+"] ", "744");
        string sDebugText = StringToRGBString(sMessage, "447");
        sMessage = sDebugTag + sDebugTag2 + sDebugTag3 + sDebugText;
        object oPC = GetFirstPC();
        while (oPC != OBJECT_INVALID)
        {
            SendMessageToPC(oPC, sMessage);
            oPC = GetNextPC();
        }
    }
}

string DebugBoolean(int iBoolean)
{
    string sBoolean;
    if (iBoolean == FALSE)
    {
        sBoolean = StringToRGBString("FALSE", "700");
    } else
    {
        sBoolean = StringToRGBString("TRUE", "070");
    }
    return sBoolean;
}

int GetIsAreaInstanced(object oArea)
{
    int iInstance = GetLocalInt(oArea, "INSTANCE");
    return iInstance;
}

void SetIsAreaInstanced(object oArea, int iState)
{
    SetLocalInt(oArea, "INSTANCE", iState);
}

float ConvertMinutesToSeconds(int nMinutes)
{
    // Multiply the minutes by 60 to get seconds
    return IntToFloat(nMinutes * 60);
}

int GetIsPlayerWithin(object oPC, object oTarget, float fMeters)
{
    // Get the distance between the player and the target object
    float fDistance = GetDistanceBetween(oPC, oTarget);

    // Check if the distance is less than or equal to fMeters
    if (fDistance <= fMeters)
    {
        return TRUE;  // The player is within fMeters
    }

    return FALSE;     // The player is not within fMeters
}

object GetObjectInArea(object oArea, string sTag)
{
    object oTarget;
    object oObject = GetFirstObjectInArea(oArea);
    {
        while (oObject != OBJECT_INVALID)
        {
            if (GetTag(oObject) == sTag)
                oTarget = oObject;
            oObject = GetNextObjectInArea(oArea);
        }
    }
    return oTarget;
}

void ClearAndJump(object oPC, object oTarget)
{
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, JumpToObject(oTarget));
}

void ClearAndJumpToLocation(object oPC, location lLocation)
{
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, JumpToLocation(lLocation));
}

string GetLastCharacters(string sInput, int iCharacters)
{
    int nLength = GetStringLength(sInput);
    int nStart = nLength - iCharacters;
    if (nStart < 0)
    {
        nStart = 0;
    }
    return GetSubString(sInput, nStart, iCharacters);
}

void DestroyContents(object oContainer)
{
    object oItem = GetFirstItemInInventory(oContainer);
    while (oItem != OBJECT_INVALID)
    {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oContainer);
    }

}

void RemoveEffectsByTag(object oTarget, string sEffect)
{
    effect eEffect = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEffect) == TRUE)
    {
        if (GetEffectTag(eEffect) == sEffect)
            RemoveEffect(oTarget, eEffect);
        eEffect = GetNextEffect(oTarget);
    }
}

void DelayDestroyObject(object oObject)
{

    DestroyObject(oObject);

}

// EXECUTION  ------------------------------------------------------------------

//void main(){}
