//::///////////////////////////////////////////////
//:: Name: Solo Dance
//:: FileName: Q_SP_DANCER
//:://////////////////////////////////////////////
/*
    use this in the "On_Spawn" event of a human or
    half-elf and it will make them dance* until they
    are interrupted by someone.

    *made to be used with the Romantic Animation Suite
    created by NinjaWeasleMan and distributed by
    projectQ. any other use may cause an undesired
    outcome.
*/
//:://////////////////////////////////////////////
//:: Created By: John Hawkins
//:: Created On: Aug 01, 2009
//:://////////////////////////////////////////////
/*
    Updated By: Paul Ste. Marie, On: 20 Nov 2011 - removed unnecessary AssignCommand function from line 24
*/
void main()
{
    ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM19,2.0,60000.0);
}
