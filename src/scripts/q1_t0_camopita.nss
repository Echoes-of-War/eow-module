void main()
{
    object oPC = GetEnteringObject();

    //Now we make them fall in the hole.

    int nDC;
    int nDamage;
    object oTrap = GetAreaOfEffectCreator(OBJECT_SELF);
    string sTag = GetTag(oTrap);

    nDamage =d6(1);
    if(GetTrapDetectedBy(oTrap,oPC))
        nDC = 10;
    else
        nDC = 25;

    if(ReflexSave(oPC, nDC, SAVING_THROW_TYPE_TRAP))
    {
        SendMessageToPC(oPC,"You jump to the side and avoid falling into the pit");
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_REFLEX_SAVE_THROW_USE), oPC);
    }
    else
    {
        SendMessageToPC(oPC,"You fall into the pit!");
        AssignCommand(oPC,PlaySound("cb_ht_fleshston2"));
        PlayVoiceChat(VOICE_CHAT_PAIN3,oPC);
        if(GetCurrentHitPoints(oPC)-nDamage>0)
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDisappearAppear(GetLocation(oPC)), oPC, 30.0f);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectParalyze(), oPC, 30.0f);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL), oPC);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), GetLocation(oPC));
            DelayCommand(30.0,SendMessageToPC(oPC,"You finally climb out of the pit"));
        }
        else
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL), oPC);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), GetLocation(oPC));
        }
    }
}
