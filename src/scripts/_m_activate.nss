//::////////////////////////////////////////////////////////////////////////////
//:: _m_activate
//::////////////////////////////////////////////////////////////////////////////
/*

    Module activate item event script.

*/
//::////////////////////////////////////////////////////////////////////////////
//:: Created:   Galefer (03/12/24)
//::////////////////////////////////////////////////////////////////////////////

// INCLUDES  -------------------------------------------------------------------

#include "_i_chat"

// EXECUTION  ------------------------------------------------------------------

void main()
{
    object oItem = GetItemActivated();
    string sResRef = GetResRef(oItem);

    // Food
    if (GetStringLeft(sResRef, 4) == "food")
    {
        ExecuteScript("_x_food", OBJECT_SELF);
    }

    // Bandage
    if (sResRef == "bandage")
    {
        ExecuteScript("_x_bandage", OBJECT_SELF);
    }

    // Camping Supplies
    if (sResRef == "itm_camp_equip")
    {
        ExecuteScript("_x_camp", OBJECT_SELF);
    }

    // DM TOOL: Lifewand
    if (sResRef == "dmtool_life")
    {
        ExecuteScript("_x_lifewand", OBJECT_SELF);
    }
}
