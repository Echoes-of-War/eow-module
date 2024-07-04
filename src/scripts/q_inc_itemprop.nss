//::///////////////////////////////////////////////
//:: Name: Q Shield Crafting Function Library
//:: FileName: q_inc_itemprop
//:: Website: http://www.qnwn.net
//:: Contact: projectq@qnwn.net
//:://////////////////////////////////////////////
/*
    Project Q - Release 1.5

    Based on x2_inc_itemprops by BioWare
*/
//:://////////////////////////////////////////////
//:: Created By: pstemarie
//:: Created On: 21 Dec 2011
//:://////////////////////////////////////////////

#include "x2_inc_craft"

int Q_IPGetShieldAppearanceColor(object oWeapon, int nPart, int nMode)
{
    string sMode;

    switch (nMode)
    {
        case        X2_IP_WEAPONTYPE_NEXT : sMode ="Next";
                    break;
        case        X2_IP_WEAPONTYPE_PREV : sMode ="Prev";
                    break;
    }

    int nCurrApp  = GetItemAppearance(oWeapon,ITEM_APPR_TYPE_WEAPON_COLOR,nPart);
    int nRet;

    int nMax =  8;// IPGetNumberOfArmorAppearances(nPart)-1; // index from 0 .. numparts -1
    int nMin =  1;

    // return a random valid armor type
    if (nMode == X2_IP_WEAPONTYPE_RANDOM)
    {
        return Random(nMax)+nMin;
    }

    else
    {
        if (nMode == X2_IP_WEAPONTYPE_NEXT)
        {
            // current appearance is max, return min
            if (nCurrApp == nMax)
            {
                return nMin;
            }
            // current appearance is min, return min +1
            else if (nCurrApp == nMin)
            {
                nRet = nMin +1;
                return nRet;
            }

            //SpeakString("next");
            // next
            nRet = nCurrApp +1;
            return nRet;
        }
        else // previous
        {
            // current appearance is max, return nMax-1
            if (nCurrApp == nMax)
            {
                nRet = nMax -1;
                return nRet;
            }
            // current appearance is min, return max
            else if (nCurrApp == nMin)
            {
                return nMax;
            }

            //SpeakString("prev");

            nRet = nCurrApp -1;
            return nRet;
        }
    }
}


int Q_IPGetShieldAppearanceType(object oWeapon, int nPart, int nMode)
{
    string sMode;

    switch (nMode)
    {
        case        X2_IP_WEAPONTYPE_NEXT : sMode ="Next";
                    break;
        case        X2_IP_WEAPONTYPE_PREV : sMode ="Prev";
                    break;
    }

    int nCurrApp  = GetItemAppearance(oWeapon,ITEM_APPR_TYPE_WEAPON_MODEL,nPart);
    int nRet;

    int nMax =  21;// IPGetNumberOfArmorAppearances(nPart)-1; // index from 0 .. numparts -1
    int nMin =  1;

    // return a random valid armor type
    if (nMode == X2_IP_WEAPONTYPE_RANDOM)
    {
        return Random(nMax)+nMin;
    }

    else
    {
        if (nMode == X2_IP_WEAPONTYPE_NEXT)
        {
            // current appearance is max, return min
            if (nCurrApp == nMax)
            {
                return nMin;
            }
            // current appearance is min, return min +1
            else if (nCurrApp == nMin)
            {
                nRet = nMin +1;
                return nRet;
            }

            //SpeakString("next");
            // next
            nRet = nCurrApp +1;

            if (nPart == ITEM_APPR_WEAPON_MODEL_BOTTOM)
            {
                if ((GetBaseItemType(oWeapon) == BASE_ITEM_LARGESHIELD) && (nRet >= 10 && nRet <= 20))
                    nRet = 20;

                else if ((GetBaseItemType(oWeapon) == BASE_ITEM_TOWERSHIELD) && (nRet >= 7 && nRet <= 20))
                    nRet = 20;
            }
            else if (nPart == ITEM_APPR_WEAPON_MODEL_MIDDLE)
            {
                if ((GetBaseItemType(oWeapon) == BASE_ITEM_LARGESHIELD) && (nRet >= 5 && nRet <= 20))
                    nRet = 20;

                else if ((GetBaseItemType(oWeapon) == BASE_ITEM_TOWERSHIELD) && (nRet >= 5 && nRet <= 20))
                    nRet = 20;
            }
            return nRet;
        }
        else // previous
        {
            // current appearance is max, return nMax-1
            if (nCurrApp == nMax)
            {
                nRet = nMax -1;
                return nRet;
            }
            // current appearance is min, return max
            else if (nCurrApp == nMin)
            {
                return nMax;
            }

            //SpeakString("prev");

            nRet = nCurrApp -1;

            if (nPart == ITEM_APPR_WEAPON_MODEL_BOTTOM)
            {
                if ((GetBaseItemType(oWeapon) == BASE_ITEM_LARGESHIELD) && (nRet <= 20 && nRet >= 10))
                    nRet = 9;
                else if ((GetBaseItemType(oWeapon) == BASE_ITEM_TOWERSHIELD) && (nRet <= 20 && nRet >= 7))
                    nRet = 6;
            }
            else if (nPart == ITEM_APPR_WEAPON_MODEL_MIDDLE)
            {
                if ((GetBaseItemType(oWeapon) == BASE_ITEM_LARGESHIELD || GetBaseItemType(oWeapon) == BASE_ITEM_TOWERSHIELD) && (nRet <= 20 && nRet >= 5))
                    nRet = 4;
            }
            return nRet;
        }
    }
}

// ----------------------------------------------------------------------------
// Returns a new armor based of oArmor with nPartModified
// nPart - ITEM_APPR_WEAPON_MODEL_* constant of the part to be changed
// nMode -
//          X2_IP_WEAPONTYPE_NEXT    - next valid appearance
//          X2_IP_WEAPONTYPE_PREV    - previous valid apperance;
//          X2_IP_WEAPONTYPE_RANDOM  - random valid appearance (torso is never changed);
// bDestroyOldOnSuccess - Destroy oArmor in process?
// Uses Get2DAstring, so do not use in loops
// ----------------------------------------------------------------------------
object Q_IPGetModifiedShield(object oWeapon, int nModify, int nPart, int nMode, int bDestroyOldOnSuccess)
{
    int nNewApp;
    if (nModify == ITEM_APPR_TYPE_WEAPON_MODEL)
    {
        nNewApp = Q_IPGetShieldAppearanceType(oWeapon, nPart,  nMode);
    }
    else
    {
        nNewApp = Q_IPGetShieldAppearanceColor(oWeapon, nPart,  nMode);
    }

    //SpeakString("old: " + IntToString(GetItemAppearance(oWeapon,nModify,nPart)));
    //SpeakString("new: " + IntToString(nNewApp));
    object oNew = CopyItemAndModify(oWeapon, nModify, nPart, nNewApp,TRUE);
    if (oNew != OBJECT_INVALID)
    {
        if( bDestroyOldOnSuccess )
        {
            DestroyObject(oWeapon);
        }
        return oNew;
    }
    // Safety fallback, return old weapon on failures
       return oWeapon;
}
