//::///////////////////////////////////////////////
//:: Example XP2 OnItemEquipped
//:: x2_mod_def_equ
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnEquip Event
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: April 15th, 2008
//:: Added Support for Mounted Archery Feat penalties
//:://////////////////////////////////////////////

#include "q_inc_switches"
#include "x2_inc_intweapon"
#include "x3_inc_horse"
#include "q_inc_itemprop"

void main()
{

    object oItem = GetPCItemLastEquipped();
    object oPC   = GetPCItemLastEquippedBy();
    // -------------------------------------------------------------------------
    // Intelligent Weapon System
    // -------------------------------------------------------------------------
    if (IPGetIsIntelligentWeapon(oItem))
    {
        IWSetIntelligentWeaponEquipped(oPC,oItem);
        // prevent players from reequipping their weapon in
        if (IWGetIsInIntelligentWeaponConversation(oPC))
        {
                object oConv =   GetLocalObject(oPC,"X2_O_INTWEAPON_SPIRIT");
                IWEndIntelligentWeaponConversation(oConv, oPC);
        }
        else
        {
            //------------------------------------------------------------------
            // Trigger Drain Health Event
            //------------------------------------------------------------------
            if (GetLocalInt(oPC,"X2_L_ENSERRIC_ASKED_Q3")==1)
            {
                ExecuteScript ("x2_ens_dodrain",oPC);
            }
            else
            {
                IWPlayRandomEquipComment(oPC,oItem);
            }
        }
    }

    // -------------------------------------------------------------------------
    // Mounted benefits control
    // -------------------------------------------------------------------------
    if (GetWeaponRanged(oItem))
    {
        SetLocalInt(oPC,"bX3_M_ARCHERY",TRUE);
        HORSE_SupportAdjustMountedArcheryPenalty(oPC);
    }

    // -------------------------------------------------------------------------
    // Generic Item Script Execution Code
    // If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
    // it will execute a script that has the same name as the item's tag
    // inside this script you can manage scripts for all events by checking against
    // GetUserDefinedItemEventNumber(). See x2_it_example.nss
    // -------------------------------------------------------------------------
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
    {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_EQUIP);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
            return;
        }
    }

//------------------------------------------------------------------------------
//                           PROJECT Q CUSTOMIZATIONS
//------------------------------------------------------------------------------

    // -------------------------------------------------------------------------
    // DLA Dynamic Quivers
    // -------------------------------------------------------------------------
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_DLA_DYNAMIC_QUIVERS) == TRUE)
    {
        //Only add quiver if a cloak is not equipped
        if (GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC) == OBJECT_INVALID)
        {
            int nBaseItemType = GetBaseItemType(oItem);
            int nNeckPartId = GetCreatureBodyPart(CREATURE_PART_NECK, oPC);

            if (nBaseItemType == BASE_ITEM_ARROW ||
                nBaseItemType == BASE_ITEM_BOLT ||
                nBaseItemType == BASE_ITEM_HEAVYCROSSBOW ||
                nBaseItemType == BASE_ITEM_LIGHTCROSSBOW ||
                nBaseItemType == BASE_ITEM_LONGBOW ||
                nBaseItemType == BASE_ITEM_SHORTBOW)
            {
                if (nNeckPartId != 7)
                {
                    //Store the original neck value
                    SetLocalInt(oPC, "Q_NECK_PART_ID", nNeckPartId);

                    SetCreatureBodyPart(CREATURE_PART_NECK, 7, oPC);
                }
            }
        }

        //Remove quiver if a cloak is equipped
        if (GetBaseItemType(oItem) == BASE_ITEM_CLOAK)
        {
            if (GetCreatureBodyPart(CREATURE_PART_NECK, oPC) == 7)
            {
                int nNeckPartId = GetLocalInt(oPC, "Q_NECK_PART_ID");
                SetCreatureBodyPart(CREATURE_PART_NECK, nNeckPartId, oPC);

                //Delete the stored neck value
                DeleteLocalInt(oPC, "Q_NECK_PART_ID");
            }
        }
    }

    // -------------------------------------------------------------------------
    // Check for Use Limitation: Gender
    // -------------------------------------------------------------------------
    if (GetItemHasItemProperty(oItem, 88 /*ITEM_PROPERTY_USE_LIMITATION_GENDER*/))
    {
        itemproperty ipGenderProperty = GetFirstItemProperty(oItem);

        while ((GetIsItemPropertyValid(ipGenderProperty)) && (GetItemPropertyType(ipGenderProperty) != 88 /*ITEM_PROPERTY_USE_LIMITATION_GENDER*/))
        {
            ipGenderProperty=GetNextItemProperty(oItem);
        }
        //If itemproperty is INVALID exit function
        if (!GetIsItemPropertyValid(ipGenderProperty))
            return;

        if (GetItemPropertySubType(ipGenderProperty)!=GetGender(oPC))
        {
            //Not equal, so take it off if equipped!
            AssignCommand(oPC, ActionUnequipItem(oItem));

            //Tell PC why.
            SendMessageToPC(oPC, "You cannot use this item because of it's gender restriction.");
        }
    }
}
