//::///////////////////////////////////////////////
//:: Name: Uh-Oh (Vaei Hanging Prisoner)
//:: FileName: Q_PRISONER_SP
//:://////////////////////////////////////////////
/*
    use this in the "On_Spawn" event of a part-based NPC
    and it will turn them into a hanging* prisoner until
    they are interrupted by someone.

    note: you must set the phenotype to "hanging prisoner"
    or else the animation will not fire properly.

    *made to be used with the Additonal Animations created
    by Vaei and distributed by projectQ. any other use may
    cause an undesired
    outcome.
*/
//:://////////////////////////////////////////////
//:: Created By: Paul Ste. Marie
//:: Created On: 20 Nov 2011
//:://////////////////////////////////////////////

void main()
{
    //failsafe - check correct phenotype
    if (GetPhenoType(OBJECT_SELF) != 43)
        SetPhenoType(43);

    ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM16,2.0,60000.0);
}
