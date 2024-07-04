//::///////////////////////////////////////////////
//:: FileName: tbx0_banjo01
//:://////////////////////////////////////////////
/*
    this script will cause pc to equip my banjo and
    do the play music animation

    call script from an item with item property:
    "unique power, self only - unlimited uses per day"

    (item should be restricted to be used only by
    human and half-elves, as they are the only ones
    the animation works for!)
*/
//:://////////////////////////////////////////////
//:: Created By: John Hawkins
//:: Created On: 04/04/2008
//:://////////////////////////////////////////////
//:: Updated By: Pstemarie, On: 21 May, 2014
//::             - Rewrote script to accomodate all races / both sexes

#include "x2_inc_switches"
#include "q_inc_music"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();
    object oPC, oItem;

    if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {
        oPC          = GetItemActivator();
        oItem        = GetItemActivated();
        int iPheno   = GetPhenoType(oPC);
        int nEffect;

        // make sure user is correct phenotype to use playing animation...
        if (iPheno != 40)
        {
            SetLocalInt(oPC,"PHENO_ORIGIN",iPheno);
            SetPhenoType(40, oPC);
        }

        // we can't play music with weapons equipped!
        object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
        object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
        string sMessage = "*You cannot play music when you have other items in your hands!*";
        if(GetIsObjectValid(oLeft) || GetIsObjectValid(oRight))
        {
            AssignCommand(oPC,ClearAllActions());
            SendMessageToPC(oPC,sMessage);
            return;
        }

        // *everything checks out, continuing with function*

        nEffect = GetInstrumentVFX(oPC,oItem);
        AssignCommand(oPC,PlayInstrument(nEffect));
    }
}
