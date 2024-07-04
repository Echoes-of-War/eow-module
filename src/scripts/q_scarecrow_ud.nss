//::///////////////////////////////////////////////
//:: Default: On User Defined
//:: NW_C2_DEFAULTD
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determines the course of action to be taken
    on a user defined event.
*/
//:://////////////////////////////////////////////
//:: Created By: Don Moar
//:: Created On: April 28, 2002
//:://////////////////////////////////////////////
void main()
{
    int nUser = GetUserDefinedEventNumber();
    effect eGaze =  EffectDazed();
    object oVictim = GetLastDamager();
    int nSave = WillSave(oVictim, 19, SAVING_THROW_TYPE_SPELL, OBJECT_SELF);
    effect eViz =  EffectVisualEffect(49);

    if(nUser == 1003)
    {
        if(nSave == 0)
        {
            ApplyEffectToObject(2, eGaze, oVictim);
            ApplyEffectToObject(2, eViz, oVictim);
        }
     }
    else if(nUser = 1007)
    {
        oVictim = GetNearestObject();

        while(oVictim != OBJECT_INVALID)
        {
        RemoveEffect(oVictim, eGaze);
        RemoveEffect(oVictim, eViz);
        }
     }

}
