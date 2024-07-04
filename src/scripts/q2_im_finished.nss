//::///////////////////////////////////////////////
//:: Name: Q Shield Crafting Conversation
//:: FileName: q2_im_finished
//:: Website: http://www.qnwn.net
//:: Contact: projectq@qnwn.net
//:://////////////////////////////////////////////
/*
    Project Q - Release 1.5

    Finish crafting

    Based on an original script by BioWare
*/
//:://////////////////////////////////////////////
//:: Created By: pstemarie
//:: Created On: 21 Dec 2011
//:://////////////////////////////////////////////

#include "x2_inc_craft"
void main()
{
    object oPC = GetPCSpeaker();
    if (CIGetCurrentModMode(GetPCSpeaker()) != X2_CI_MODMODE_INVALID )
    {
        object oBackup = CIGetCurrentModBackup(oPC);

        int nCost = GetLocalInt(oPC,"X2_TAILOR_CURRENT_COST");
        int nDC =  GetLocalInt(oPC,"X2_TAILOR_CURRENT_DC");

        if (GetGold(oPC) >= nCost)
        {
            TakeGoldFromCreature(nCost,oPC,TRUE);
        }
        else
        {
            FloatingTextStrRefOnCreature(83447,oPC);
            ExecuteScript ("x2_im_cancel", OBJECT_SELF);
            return;
        }
        int bSuccess = FALSE;
        if (CIGetCurrentModMode(oPC) == X2_CI_MODMODE_ARMOR)
        {
            if ( GetIsSkillSuccessful(oPC,SKILL_CRAFT_ARMOR,nDC))
            {
                  //FloatingTextStrRefOnCreature(83449,oPC);
                  bSuccess = TRUE;
            }
        }
        else
        {
            if ( GetIsSkillSuccessful(oPC,SKILL_CRAFT_WEAPON,nDC))
            {
                  bSuccess = TRUE;
                  //FloatingTextStrRefOnCreature(83449,oPC);
            }
        }

        if (!bSuccess)
        {
            FloatingTextStrRefOnCreature(83448,oPC);
            // run the cleanup script
            ExecuteScript ("x2_im_cancel", OBJECT_SELF);
            return;
        }

        object oNew = CIGetCurrentModItem(oPC);
        AssignCommand(oPC,ClearAllActions(TRUE));
        if (CIGetCurrentModMode(oPC) == X2_CI_MODMODE_ARMOR)
        {
             AssignCommand(oPC, ActionEquipItem(oNew,INVENTORY_SLOT_CHEST));
        }
        else if (CIGetCurrentModMode(oPC) == X2_CI_MODMODE_WEAPON)
        {
               AssignCommand(oPC, ActionEquipItem(oNew,INVENTORY_SLOT_LEFTHAND));
        }
        //----------------------------------------------------------------------
        // This is to work around a problem with temporary item properties
        // sometimes staying around when they are on a cloned item.
        //----------------------------------------------------------------------
        IPRemoveAllItemProperties(oNew,DURATION_TYPE_TEMPORARY);

        DeleteLocalInt(oPC,"X2_TAILOR_CURRENT_COST");
        DeleteLocalInt(oPC,"X2_TAILOR_CURRENT_DC");
        CISetCurrentModMode(oPC,X2_CI_MODMODE_INVALID );

        // remove backup
        DestroyObject(oBackup);
    }
    else
    {
       ClearAllActions();
    }

    // Remove custscene immobilize from player
    effect eEff = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEff))
    {
         if (GetEffectType(eEff) == EFFECT_TYPE_CUTSCENEIMMOBILIZE
             && GetEffectCreator(eEff) == oPC
             && GetEffectSubType(eEff) == SUBTYPE_EXTRAORDINARY )
         {
            RemoveEffect(oPC,eEff);
         }
         eEff = GetNextEffect(oPC);
     }

    RestoreCameraFacing() ;

}
