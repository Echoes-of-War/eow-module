// ----------------------
// -- Persistent item  --
// -- and PC variables --
// --    by Taro94     --
// ----------------------

// This library is an implementation of persistent item (and PC by extension)
// variables in NWScript. These provide persistence even for localvault characters.
// They make use of unidentified descriptions of items so it's not advised
// to use them on unidentified items or items that can become unidentified.

// For everything to work correctly, avoid using the following characters
// in names and values of your variables: !@#$|=

// In order to use PC persistent variables, please make sure that PCs
// have PC skins equipped. These can be custom skins,
// but since this library uses an item equipped in the skin slot
// as a medium for persistent variable storage, it's important that
// every PC has some skin item and that it's not swapped for any other skin
// during the game (which would, of course, result in the loss of any
// variables stored using the SetPC<...> functions).

// Also note that in NWN 1.69 any string above 8KB will be truncated to 8KB
// when trying to set it as a new description of an object. The limit is 128KB
// in NWN:EE, so it is a smaller concern now.


// -------------------------
// -- Function prototypes --
// -------------------------

// Set oItem's persistent integer variable sVarName to nValue
void SetItemInt(object oItem, string sVarName, int nValue);

// Set oPC's persistent integer variable sVarName to nValue
// Requires oPC's skin object to exist
void SetPCInt(object oPC, string sVarName, int nValue);

// Set oItem's persistent string variable sVarName to sValue
void SetItemString(object oItem, string sVarName, string sValue);

// Set oPC's persistent string variable sVarName to nValue
// Requires oPC's skin object to exist
void SetPCString(object oPC, string sVarName, string sValue);

// Set oItem's persistent float variable sVarName to fValue
void SetItemFloat(object oItem, string sVarName, float fValue);

// Set oPC's persistent float variable sVarName to nValue
// Requires oPC's skin object to exist
void SetPCFloat(object oPC, string sVarName, float fValue);

// Return oItem's persistent integer variable sVarName
// * Return value on error: 0
int GetItemInt(object oItem, string sVarName);

// Return oPC's persistent integer variable sVarName
// * Return value on error: 0
int GetPCInt(object oPC, string sVarName);

// Return oItem's persistent string variable sVarName
// * Return value on error: ""
string GetItemString(object oItem, string sVarName);

// Return oPC's persistent string variable sVarName
// * Return value on error: ""
string GetPCString(object oPC, string sVarName);

// Return oItem's persistent float variable sVarName
// * Return value on error: 0.0f
float GetItemFloat(object oItem, string sVarName);

// Return oPC's persistent string variable sVarName
// * Return value on error: 0.0f
float GetPCFloat(object oPC, string sVarName);

// Delete oItem's local integer variable sVarName
void DeleteItemInt(object oItem, string sVarName);

// Delete oPC's local integer variable sVarName
void DeletePCInt(object oPC, string sVarName);

// Delete oItem's local string variable sVarName
void DeleteItemString(object oItem, string sVarName);

// Delete oPC's local string variable sVarName
void DeletePCString(object oPC, string sVarName);

// Delete oItem's local float variable sVarName
void DeleteItemFloat(object oItem, string sVarName);

// Delete oPC's local float variable sVarName
void DeletePCFloat(object oPC, string sVarName);



// -----------------------------
// -- Function implementation --
// -----------------------------

string GetItemVariable(object oItem, string sType, string sVar)
{
    string sDesc = GetDescription(oItem, FALSE, FALSE); //ex. "$$|!nVar=20|"
    if (sDesc != "" && GetStringLeft(sDesc, 3) != "$$|") return "";

    int nIndex1 = FindSubString(sDesc, "|"+sType+sVar+"=");
    int nIndex2 = FindSubString(sDesc, "|", nIndex1+1);

    if (nIndex1 == -1) return ""; //variable not found, return empty string

    string sSubstring = GetSubString(sDesc, nIndex1, nIndex2-nIndex1); //ex. "|!nVar=20"
    int nEqualIndex = FindSubString(sSubstring, "=");

    return GetSubString(sSubstring, nEqualIndex+1, GetStringLength(sSubstring)-nEqualIndex-1);
}

void DeleteItemVariable(object oItem, string sType, string sVar)
{
    string sDesc = GetDescription(oItem, FALSE, FALSE); //ex. "$$|!nVar=20|"
    if (sDesc != "" && GetStringLeft(sDesc, 3) != "$$|") return;

    string sSubstring, sFound;

    int nIndex1 = FindSubString(sDesc, "|"+sType+sVar+"=")+1;
    int nIndex2 = FindSubString(sDesc, "|", nIndex1+1);

    if (nIndex1 == 0) return;

    sDesc = GetSubString(sDesc, 0, nIndex1) + GetSubString(sDesc, nIndex2+1, GetStringLength(sDesc));
    SetDescription(oItem, sDesc, FALSE);
    return;
}

void SetItemVariable(object oItem, string sType, string sVar, string sVal)
{
    if (sVar == "" || sVal == "") return;
    string sDesc = GetDescription(oItem, FALSE, FALSE);
    if (GetStringLeft(sDesc, 3) != "$$|")
    {
        sDesc = "$$|";
        SetDescription(oItem, sDesc, FALSE);
    }

    else if (FindSubString(sDesc, "|"+sType+sVar+"=") != -1)
        DeleteItemVariable(oItem, sType, sVar);

    string sAdded = sType + sVar + "=" + sVal + "|";
    sDesc = GetDescription(oItem, FALSE, FALSE) + sAdded;

    SetDescription(oItem, sDesc, FALSE);
}

void SetItemInt(object oItem, string sVarName, int nValue)
{
    SetItemVariable(oItem, "!", sVarName, IntToString(nValue));
}

void SetItemString(object oItem, string sVarName, string sValue)
{
    SetItemVariable(oItem, "@", sVarName, sValue);
}

void SetItemFloat(object oItem, string sVarName, float fValue)
{
    SetItemVariable(oItem, "#", sVarName, FloatToString(fValue));
}

int GetItemInt(object oItem, string sVarName)
{
    string sValue = GetItemVariable(oItem, "!", sVarName);
    if (sValue == "") return 0;
    return StringToInt(sValue);
}

string GetItemString(object oItem, string sVarName)
{
    return GetItemVariable(oItem, "@", sVarName);
}

float GetItemFloat(object oItem, string sVarName)
{
    string sValue = GetItemVariable(oItem, "#", sVarName);
    if (sValue == "") return 0.0f;
    return StringToFloat(sValue);
}

void DeleteItemInt(object oItem, string sVarName)
{
    DeleteItemVariable(oItem, "!", sVarName);
}

void DeleteItemString(object oItem, string sVarName)
{
    DeleteItemVariable(oItem, "@", sVarName);
}

void DeleteItemFloat(object oItem, string sVarName)
{
    DeleteItemVariable(oItem, "#", sVarName);
}

void SetPCInt(object oPC, string sVarName, int nValue)
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if (GetIsObjectValid(oSkin) == FALSE) return;
    SetItemInt(oSkin, sVarName, nValue);
}

void SetPCString(object oPC, string sVarName, string sValue)
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if (GetIsObjectValid(oSkin) == FALSE) return;
    SetItemString(oSkin, sVarName, sValue);
}

void SetPCFloat(object oPC, string sVarName, float fValue)
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if (GetIsObjectValid(oSkin) == FALSE) return;
    SetItemFloat(oSkin, sVarName, fValue);
}

int GetPCInt(object oPC, string sVarName)
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if (GetIsObjectValid(oSkin) == FALSE) return 0;
    return GetItemInt(oSkin, sVarName);
}

string GetPCString(object oPC, string sVarName)
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if (GetIsObjectValid(oSkin) == FALSE) return "";
    return GetItemString(oSkin, sVarName);
}

float GetPCFloat(object oPC, string sVarName)
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if (GetIsObjectValid(oSkin) == FALSE) return 0.0;
    return GetItemFloat(oSkin, sVarName);
}

void DeletePCInt(object oPC, string sVarName)
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if (GetIsObjectValid(oSkin) == FALSE) return;
    DeleteItemInt(oSkin, sVarName);
}

void DeletePCString(object oPC, string sVarName)
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if (GetIsObjectValid(oSkin) == FALSE) return;
    DeleteItemString(oSkin, sVarName);
}

void DeletePCFloat(object oPC, string sVarName)
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if (GetIsObjectValid(oSkin) == FALSE) return;
    DeleteItemFloat(oSkin, sVarName);
}
