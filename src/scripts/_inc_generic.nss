object GetIDToken(object oPC)
{
    object oIDToken = GetItemPossessedBy(oPC, "idtoken");
    if (oIDToken == OBJECT_INVALID)
    {
        oIDToken = CreateItemOnObject("idtoken", oPC);
    }
    return oIDToken;
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

void DestroyNonPlayerCreatures(object oArea)
{
    object oObject = GetFirstObjectInArea(oArea);

    while (GetIsObjectValid(oObject))
    {
        // Check if the object is a creature and not a player or a DM
        if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE &&
            !GetIsPC(oObject) &&
            !GetIsDM(oObject))
        {
            // Destroy the creature
            DestroyObject(oObject);
        }

        oObject = GetNextObjectInArea(oArea);
    }
}

// returns iCharacters from the end of a string
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
