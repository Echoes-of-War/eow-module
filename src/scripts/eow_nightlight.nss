void main()
{
  object oTarget = OBJECT_SELF;
  effect eDur =  TagEffect(EffectVisualEffect(VFX_DUR_LIGHT_YELLOW_20), "LIGHT");

  if(GetTimeHour()==20)
  {
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oTarget);
  }
  else if(GetTimeHour()==6)
  {
    // Remove blindness from the PC
    effect eLoop = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eLoop))
    {
        if(GetEffectType(eLoop) == EFFECT_TYPE_VISUALEFFECT && GetEffectTag(eLoop) == "LIGHT")
        {
            RemoveEffect(oTarget, eLoop);
        }
        eLoop = GetNextEffect(oTarget);
    }
  }
}
