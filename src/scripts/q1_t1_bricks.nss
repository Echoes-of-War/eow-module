#include "q_inc_traps"

void main()
{
    if(GetLocalInt(OBJECT_SELF,"TRP_TRIGGERED"))
        return;

    SetLocalInt(OBJECT_SELF,"TRP_TRIGGERED",1);


    object oTrap;

    if(GetLocalInt(OBJECT_SELF,"TRP_PLCBL_SHOW")==0)
    {
        location lPlcbl = GetLocalLocation(OBJECT_SELF,"TRP_PLCBL_LOC");
        SetLocalInt(OBJECT_SELF,"TRP_PLCBL_SHOW",1);
        oTrap = CreateObject(OBJECT_TYPE_PLACEABLE,"fallingbrickpcbl",lPlcbl);
        SetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ",oTrap);
    }
    else
        oTrap = GetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ");


    AssignCommand(oTrap,DelayCommand(1.0,TrapPlayAnim(oTrap)));

    int nDC = 15;
    object oPC = GetNearestObject(OBJECT_TYPE_CREATURE, oTrap);
    AssignCommand(oPC, PlaySound("as_na_rockfallg1"));//cb_bu_stonelg
    int nDamage,nN;
    while(GetIsObjectValid(oPC)&&(GetDistanceBetween(oTrap,oPC)<2.0))
    {
        nDamage = d6(2);

        nDamage = TrapSave(oPC, nDC, nDamage);

        if(nDamage>0)
        {
            DelayCommand(1.1,FallingBrickHitPC(oPC,nDamage));
        }

        nN++;
        oPC = GetNearestObject(OBJECT_TYPE_CREATURE, oTrap, nN);
    }
}


