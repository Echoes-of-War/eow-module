#include "q_inc_traps"

void main()
{
    object oTrap;
    if(GetLocalInt(OBJECT_SELF,"TRP_PLCBL_SHOW")==0)
    {
        location lPlcbl = GetLocalLocation(OBJECT_SELF,"TRP_PLCBL_LOC");
        SetLocalInt(OBJECT_SELF,"TRP_PLCBL_SHOW",1);
        oTrap = CreateObject(OBJECT_TYPE_PLACEABLE,"razorwirepcbl",lPlcbl);
        SetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ",oTrap);
    }
    else
        oTrap = GetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ");


    int nDC=25;
    int nDamage = d6(2);
    object oPC = GetEnteringObject();
    if(GetTrapDetectedBy(OBJECT_SELF, oPC))
        nDC =10;

    nDamage = TrapSave(oPC, nDC, nDamage);

    if(nDamage>0)
    {
        PlayVoiceChat(VOICE_CHAT_PAIN1,oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_COM_BLOOD_REG_RED), oPC);
        AssignCommand(oTrap,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_NORMAL), oPC));
        if(nDamage>6)
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedDecrease(80), oPC, 30.0f);
    }
}


