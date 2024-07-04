//::///////////////////////////////////////////////
//:: Name: Q Romantic Aniamtions
//:: FileName: q_inc_anims
//:: Website: http://www.qnwn.net
//:: Contact: projectq@qnwn.net
//:://////////////////////////////////////////////
/*
    This file includes mulitple constants and functions
    designed to support romantic animations included in
    Project Q - Release 1.
*/
//:://////////////////////////////////////////////
//:: Created By: Tim McDaniel (TrickyHandz)
//:: Created On: 1 August 2009
//:://////////////////////////////////////////////

#include "x0_i0_position"

//::////////////////////////:://
//:: Q CONSTANT DEFINITIONS :://
//::////////////////////////:://

const int Q_ANIMATION_LOOPING_KISS1 = ANIMATION_LOOPING_CUSTOM11; //Kissing, Standing Up
const int Q_ANIMATION_LOOPING_KISS2 = ANIMATION_LOOPING_CUSTOM12; //Kissing, Lying down, Man-on-Top
const int Q_ANIMATION_LOOPING_KISS3 = ANIMATION_LOOPING_CUSTOM13; //Kissing, Lying down, Woman-on-Top
const int Q_ANIMATION_LOOPING_HUG = ANIMATION_LOOPING_CUSTOM14; //Hugging, Standing up
const int Q_ANIMATION_LOOPING_DANCE = ANIMATION_LOOPING_CUSTOM19; //Solo Dance, Female Characters Only
const int Q_ANIMATION_LOOPING_WALTZ = ANIMATION_LOOPING_CUSTOM20; //Waltzing

//::///////////////////////:://
//:: Q FUNCTION PROTOTYPES :://
//::///////////////////////:://

//Determines proper distance that should be between creatures for the specified
//Romantic animation.  If animations are not supported for the creatures specified
//this function will return -1.0f.
//*Romantic Animations only support same race interaction.
//**This function is called within Q_ExecutePartneredAnimation(), however it was
//**left in place as it can be used for checks in conditional statements.
//
//nAnimation = Q_ANIMATION_LOOPING_*
float Q_GetPartneredAnimationDistance(object oCreature, object oPartner, int nAnimation);

//Applies CutsceneGhost() effect to specified creature
//This allows creatures to "touch" during partner animations
//It is important to remove this effect or the creature affected
//will permanently have CutSceneGhost applied.
void Q_CutsceneGhost(object oCreature);

//Removes CutsceneGhost() effect from specified creature
void Q_RemoveCutsceneGhost(object oCreature);

//Applies CutsceneGhost effect to specified creatures
//This allows creatures to "touch" during partner animations.
//It is important to remove this effect or the creatured affected
//will permanently have CutSceneGhost applied.
void Q_PartnerCutsceneGhost(object oCreature, object oPartner);

//Removes CutsceneGhost from specified creatures
void Q_RemovePartnerCutsceneGhost(object oCreature, object oPartner);

//Cause the action subjects to play a partnered animation
//If creatures are not considered compatible nAnimation
//will not play.
//nAnimation = Q_ANIMATION_LOOPING_*
//fSpeed = Speed of the animation (set to 1.0 if no value is entered)
//fDuration = Duration the animation will play in seconds
//            (Set to if no value is entered)
void Q_ExecutePartneredAnimation(object oCreature, object oPartner, int nAnimation, float fSpeed=1.0, float fDuration=0.0);


//::///////////////////////////:://
//:: Q FUNCTION DEFINITIONS :://
//::///////////////////////////:://

float Q_GetPartneredAnimationDistance(object oCreature, object oPartner, int nAnimation)
    {
    int nRace1 = GetRacialType(oCreature);
    int nRace2 = GetRacialType(oPartner);
    int nGender1 = GetGender(oCreature);
    int nGender2 = GetGender(oPartner);
    int nMaleRace;
    int nFemaleRace;

    if (nGender1 == GENDER_FEMALE && nGender2 == GENDER_MALE)
        {
        //Based on gender, assign the Race to the proper integer
        nFemaleRace = nRace1;
        nMaleRace = nRace2;
        }

    else if (nGender1 == GENDER_MALE && nGender2 == GENDER_FEMALE)
        {
        //Based on gender, assign race to proper integer
        nFemaleRace = nRace2;
        nMaleRace = nRace1;
        }

    else
        {
        //If characters are the same gender, return -1.0
        return -1.0;
        }


    switch (nMaleRace)
        {
        //if the Male is either Human or Half-Elf continue on
        case RACIAL_TYPE_HUMAN:
        case RACIAL_TYPE_HALFELF:
            {
            switch (nFemaleRace)
                {
                //if the Female is either Human or Half-Elf continue on
                case RACIAL_TYPE_HUMAN:
                case RACIAL_TYPE_HALFELF:
                    {
                    switch (nAnimation)
                        {
                        //Based on the animation find the proper distance character should be separated by
                        case Q_ANIMATION_LOOPING_KISS1: return 1.0;
                        case Q_ANIMATION_LOOPING_KISS2: return 0.25;
                        case Q_ANIMATION_LOOPING_KISS3: return 0.25;
                        case Q_ANIMATION_LOOPING_HUG: return 1.0;
                        case Q_ANIMATION_LOOPING_WALTZ: return 0.30;
                        //if nAnimation is not listed above return -1.0
                        default: return -1.0;
                        }
                    }
                }
            }
        //If the male is an Elf, continue on
        case RACIAL_TYPE_ELF:
            {
            switch (nFemaleRace)
                {
                //If the Female is an Elf, continue on
                case RACIAL_TYPE_ELF:
                    {
                    switch (nAnimation)
                        {
                        //Based on the animation find the proper distance character should be separated by
                        case Q_ANIMATION_LOOPING_KISS1: return 0.90;
                        case Q_ANIMATION_LOOPING_KISS2: return 0.25;
                        case Q_ANIMATION_LOOPING_KISS3: return 0.25;
                        case Q_ANIMATION_LOOPING_HUG: return 0.90;
                        case Q_ANIMATION_LOOPING_WALTZ: return 0.30;
                        //If nAnimation is not listed above, return -1.0
                        default: return -1.0;
                        }
                    }
                }
            }
        //If the Male is a Dwarf, continue on
        case RACIAL_TYPE_DWARF:
            {
            switch (nFemaleRace)
                {
                //If the Feamle is a Dwarf, continue on
                case RACIAL_TYPE_DWARF:
                    {
                    switch (nAnimation)
                        {
                        //Based on the animation find the proper distance character should be separated by
                        case Q_ANIMATION_LOOPING_KISS1: return 0.70;
                        case Q_ANIMATION_LOOPING_KISS2: return 0.20;
                        case Q_ANIMATION_LOOPING_KISS3: return 0.20;
                        case Q_ANIMATION_LOOPING_HUG: return 0.70;
                        case Q_ANIMATION_LOOPING_WALTZ: return 0.30;
                        //If nAnimation is not listed above, return -1.0
                        default: return -1.0;
                        }
                    }
                }
            }
        //If the male if a Half-Orc, continue on
        case RACIAL_TYPE_HALFORC:
            {
            switch (nFemaleRace)
                {
                //If the Female is a Half-Orc, continue on
                case RACIAL_TYPE_HALFORC:
                    {
                    switch (nAnimation)
                        {
                        //Based on the animation find the proper distance character should be separated by
                        case Q_ANIMATION_LOOPING_KISS1: return 1.02;
                        case Q_ANIMATION_LOOPING_KISS2: return 0.25;
                        case Q_ANIMATION_LOOPING_KISS3: return 0.25;
                        case Q_ANIMATION_LOOPING_HUG: return 1.02;
                        case Q_ANIMATION_LOOPING_WALTZ: return 0.30;
                        //If nAnimation is not listed above, return -1.0
                        default: return -1.0;
                        }
                    }
                }
            }
        //If the Male is a Gnome, continue on
        case RACIAL_TYPE_GNOME:
            {
            switch (nFemaleRace)
                {
                //If the Female is a Gnome, continue on
                case RACIAL_TYPE_GNOME:
                    {
                    switch (nAnimation)
                        {
                        //Based on the animation find the proper distance character should be separated by
                        case Q_ANIMATION_LOOPING_KISS1: return 0.70;
                        case Q_ANIMATION_LOOPING_KISS2: return 0.17;
                        case Q_ANIMATION_LOOPING_KISS3: return 0.17;
                        case Q_ANIMATION_LOOPING_HUG: return 0.70;
                        case Q_ANIMATION_LOOPING_WALTZ: return 0.30;
                        //If nAnimation is not listed above, return -1.0
                        default: return -1.0;
                        }
                    }
                }
            }
        //If the Male is a Halfling, continue on
        case RACIAL_TYPE_HALFLING:
            {
            switch (nFemaleRace)
                {
                //If the Female is a Halfling, continue on
                case RACIAL_TYPE_HALFLING:
                    {
                    switch (nAnimation)
                        {
                        //Based on the animation find the proper distance character should be separated by
                        case Q_ANIMATION_LOOPING_KISS1: return 0.70;
                        case Q_ANIMATION_LOOPING_KISS2: return 0.17;
                        case Q_ANIMATION_LOOPING_KISS3: return 0.17;
                        case Q_ANIMATION_LOOPING_HUG: return 0.70;
                        case Q_ANIMATION_LOOPING_WALTZ: return 0.30;
                        //If nAnimation is not listed above, return -1.0
                        default: return -1.0;
                        }
                    }
                }
            }
        }
      //If the character Races were not compatible, return -1.0
      return -1.0;
    }
//::///////////////////////////////////////////////////////////////////////////:://
//::///////////////////////////////////////////////////////////////////////////:://

void Q_CutsceneGhost(object oCreature)
    {
    //Create the CutsceneGhost effect
    effect eGhost = EffectCutsceneGhost();
           //Make the effect Supernatural
           eGhost = SupernaturalEffect(eGhost);
    //Apply the effect Permanently to oCreature
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, oCreature);
    }

//::///////////////////////////////////////////////////////////////////////////:://
//::///////////////////////////////////////////////////////////////////////////:://

void Q_PartnerCutsceneGhost(object oCreature, object oPartner)
    {
    //Create the CutsceneGhost Effect
    effect eGhost = EffectCutsceneGhost();
           //Make the effect Supernatural
           eGhost = SupernaturalEffect( eGhost );
    //Apply the effect Permanently to oCreature
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eGhost,oCreature);
    //Apply the effect Permanently to oPartner
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eGhost,oPartner);
    }

//::///////////////////////////////////////////////////////////////////////////:://
//::///////////////////////////////////////////////////////////////////////////:://

void Q_RemoveCutsceneGhost(object oCreature)
    {
    //Find the first effect on oCreature
    effect eLoop = GetFirstEffect(oCreature);
    //If the first effect is valid, continue
    while (GetIsEffectValid(eLoop))
        {
        //If the first effect is CutsceneGhost continue
        if (GetEffectType(eLoop) == EFFECT_TYPE_CUTSCENEGHOST)
            {
            //Remove the CutsceneGhost effect
            RemoveEffect(oCreature, eLoop);
            }
        //If the first effect was not CutsceneGhost, find the next effect on oCreature
        eLoop = GetNextEffect(oCreature);
        }
    }

//::///////////////////////////////////////////////////////////////////////////:://
//::///////////////////////////////////////////////////////////////////////////:://

void Q_RemovePartnerCutsceneGhost(object oCreature, object oPartner)
    {
    //Remove CutsceneGhost from both objects using the Q_RemoveCutsceneGhost() function
    //This will loop through all effects on creatures to make sure we only remove CutsceneGhost
    Q_RemoveCutsceneGhost(oCreature);
    Q_RemoveCutsceneGhost(oPartner);
    }

//::///////////////////////////////////////////////////////////////////////////:://
//::///////////////////////////////////////////////////////////////////////////:://

void Q_ExecutePartneredAnimation(object oCreature, object oPartner, int nAnimation, float fSpeed=1.0, float fDuration=0.0)
    {
    //Establish the location of oCreature
    location lCreature = GetLocation(oCreature);
    //Find out which way oCreature is facing
    float fCreatureFacing = GetFacingFromLocation(lCreature);
    //Find the distance creatures should be separated by based on which animation is being called
    float fDist = Q_GetPartneredAnimationDistance(oCreature, oPartner, nAnimation);

    //If the distance returned by Q_GetPartneredAnimationDistance() equals -1.0
    //it is not valid, so stop here.
    if (fDist == -1.0) return;

    //If the distance returned by Q_GetPartneredAnimationDistance() was not equal to -1.0
    //it is valid, so we need to find the vector for oPartner creature based on the location
    //of of oCreature
    vector vTarget = GetChangedPosition(GetPositionFromLocation(lCreature), fDist, fCreatureFacing);

    //Build a new location for oPartner based on vVector and the opposite faceing direcation of oCreature
    //This will make characters face each other
    location lTarget = Location(GetAreaFromLocation(lCreature), vTarget, GetOppositeDirection(fCreatureFacing));

    //After 1 second, Jump oPartner to the new location we built
    DelayCommand(1.0, AssignCommand(oPartner, ActionJumpToLocation(lTarget)));
    //Make oPartner face towards oCreature
    DelayCommand(1.0, AssignCommand(oPartner, ActionDoCommand(SetFacingPoint(GetPositionFromLocation(lCreature)))));
    //Delay for 1 more second and then begin playing nAnimation for both character
    //This will be simultaneous movement.
    DelayCommand(2.0, AssignCommand(oPartner, ActionPlayAnimation(nAnimation, fSpeed, fDuration)));
    DelayCommand(2.0, AssignCommand(oCreature, ActionPlayAnimation(nAnimation, fSpeed, fDuration)));

    //Delays have been placed on commands for characters to make sure that everything is executed
    //prior to moving on to the next event.  It was felt that 2 seconds was the best time for this
    //function as anything lower caused errors in character movement and alignments prior to animations
    //being executed.
    }
//::///////////////////////////////////////////////////////////////////////////:://
//::///////////////////////////////////////////////////////////////////////////:://


