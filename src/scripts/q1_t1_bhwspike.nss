#include "q_inc_traps"

void main()
{
    object oTrap = GetNearestObjectByTag("BH_Trap");
    int nDC = 15;
    int nTot = 0;
    int nN, nDamage;
    object oPC = GetEnteringObject();
    for(nN=0;nN<4;nN++)
    {
        nDamage = d4(2);

        nDamage = TrapSave(oPC, nDC, nDamage);

        if(nDamage>0)
            AssignCommand(oTrap,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL), oPC));

        nTot+=nDamage;
    }
    if(nTot>0)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_COM_BLOOD_CRT_RED), oPC);
        AssignCommand(oPC,PlaySound("cb_ht_metblleth2"));
        PlayVoiceChat(VOICE_CHAT_PAIN1,oPC);
    }
    else
       AssignCommand(oPC,PlaySound("cb_sw_blade2"));
}
