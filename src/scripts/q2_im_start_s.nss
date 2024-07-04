//::///////////////////////////////////////////////
//:: Name: Q Shield Crafting Conversation
//:: FileName: q2_im_start_s
//:: Website: http://www.qnwn.net
//:: Contact: projectq@qnwn.net
//:://////////////////////////////////////////////
/*
    Project Q - Release 1.5

    Based on an original script by BioWare
*/
//:://////////////////////////////////////////////
//:: Created By: pstemarie
//:: Created On: 21 Dec 2011
//:://////////////////////////////////////////////

#include "q_inc_itemprop"
#include "x2_inc_craft"

void main()
{

    StoreCameraFacing();

    object oPC = GetPCSpeaker();

    // * Make the camera float near the PC
    float fFacing  = GetFacing(oPC) + 180.0;
    fFacing += 90.0;
    if (fFacing > 359.0)
    {
        fFacing -=359.0;
    }
    SetCameraFacing(fFacing, 3.5f, 75.0,CAMERA_TRANSITION_TYPE_FAST ) ;
    CISetCurrentModMode(GetPCSpeaker(),X2_CI_MODMODE_WEAPON );
    SetCustomToken(X2_CI_MODIFYARMOR_GP_CTOKENBASE,"0");
    SetCustomToken(X2_CI_MODIFYARMOR_GP_CTOKENBASE+1,"0");

    object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, GetPCSpeaker());
    object oBackup = CopyItem(oItem,IPGetIPWorkContainer());
    CISetCurrentModBackup(oPC, oBackup);
    CISetCurrentModItem(oPC, oItem);

    //* Immobilize player while crafting
    effect eImmob = EffectCutsceneImmobilize();
    eImmob = ExtraordinaryEffect(eImmob);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eImmob,oPC);
}
