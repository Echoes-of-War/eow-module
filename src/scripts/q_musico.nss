//::///////////////////////////////////////////////
//:: Name: Musician OnSpawn
//:: FileName: q_musico
//:://////////////////////////////////////////////
/*
    this script will cause the social npc to play
    a musical instrument.
*/
//:://////////////////////////////////////////////
//:: Created By: John Hawkins
//:: Created On: 04/20/2008
//:://////////////////////////////////////////////
/*
    Updated By: Paul Ste. Marie, On: 20 Nov 2011 - added failsafe and removed unnecessary AssignCommand function from line 24
*/
void main()
{
    //failsafe - check correct phenotype
    if (GetPhenoType(OBJECT_SELF) != 40)
        SetPhenoType(40);

    effect eBanjo = EffectVisualEffect(750);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eBanjo,OBJECT_SELF);
    ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM1,1.0,60000.0);
}
