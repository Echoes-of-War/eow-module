//::///////////////////////////////////////////////
//:: Name: Q ACP Function Library
//:: FileName: q_inc_acp
//:: Website: http://www.qnwn.net
//:: Contact: projectq@qnwn.net
//:://////////////////////////////////////////////
/*
    Project Q - Release 1.
*/
//:://////////////////////////////////////////////
//:: Created By: thurgood
//:: Created On: 17 August 2009
//:://////////////////////////////////////////////
/*
    Updated 12/21/11 by pstemarie Q v1.5 - added support for Vaei's animations and flying pheno

    Updated 7/2/12 by pstemarie Q v1.5 - added a work around for the demonblade robe issue, style now requires two weapons equipped

    Updated 5/19/13 by pstemarie Q v1.7 - implemented the module switch for the demonblade workaround allowing Builders to turn this OFF. Default is ON.
                                        - added a module switch that enables Builders to limit the unarmed styles to monks. Default is OFF.
*/


//::////////////////////////:://
//::    Q_ACP CONSTANTS     :://
//::////////////////////////:://

#include "x0_i0_position"
#include "q_inc_switches"

// style change keyword... must be the first word in the chatstring
const string Q_ACP_KEYWORD = "style ";
const string Q_ANIM_KEYWORD = "anim ";

const string Q_ACP_ARCANE_STRING  = "arcane";
const string Q_ACP_ASSASIN_STRING = "assasin";
const string Q_ACP_DEMON_STRING   = "demon";
const string Q_ACP_FENCING_STRING = "fencing";
const string Q_ACP_HEAVY_STRING   = "heavy";
const string Q_ACP_KENSAI_STRING  = "kensai";
const string Q_ACP_HUNG_STRING    = "hung";
const string Q_ACP_MUAY_STRING    = "muay";
const string Q_ACP_SHAO_STRING    = "shao";
const string Q_ACP_SHOTO_STRING   = "shoto";
const string Q_ACP_WARRIOR_STRING = "warrior";
const string Q_ACP_NORMAL_STRING  = "normal";
const string Q_SOCIAL_STRING      = "social";
const string Q_FLYING_STRING      = "flying";

const string Q_VAEI_CUSTOM1_STRING  = "onward";
const string Q_VAEI_CUSTOM2_STRING  = "thought";
const string Q_VAEI_CUSTOM3_STRING  = "headache";
const string Q_VAEI_CUSTOM4_STRING  = "crossed";
const string Q_VAEI_CUSTOM5_STRING  = "jump";
const string Q_VAEI_CUSTOM6_STRING  = "follow";
const string Q_VAEI_CUSTOM7_STRING  = "crouch";
const string Q_VAEI_CUSTOM8_STRING  = "sleep";

// do not change these constants unless the phenotypes have
// actually been rearanged or moved
const int Q_ACP_ARCANE_PHENO  = 5;//19;
const int Q_ACP_ASSASIN_PHENO = 2;//16;
const int Q_ACP_DEMON_PHENO   = 6;//20;
const int Q_ACP_FENCING_PHENO = 4;//18;
const int Q_ACP_HEAVY_PHENO   = 3;//17;
const int Q_ACP_KENSAI_PHENO  = 1;//15;
const int Q_ACP_HUNG_PHENO    = 19;//33;
const int Q_ACP_MUAY_PHENO    = 16;//30;
const int Q_ACP_SHAO_PHENO    = 18;//32;
const int Q_ACP_SHOTO_PHENO   = 17;//31;
const int Q_ACP_WARRIOR_PHENO = 7;//21;
const int Q_ACP_NORMAL_PHENO  = 0;
const int Q_SOCIAL_PHENO      = 26;//40;
const int Q_FLYING_PHENO      = 32;//46;

const int Q_ACP_MAXABASEPHENOTYPES = 32;//26;//19;//11;
const int Q_ACP_MAXSUPPORTEDPHENOTYPES = 1;
const int Q_ACP_ANIMATIONOFFSET = 14;//100;

//:://///////////////////////:://
//::  FUNCTION DECLARATIONS  :://
//:://///////////////////////:://

// Sets the phenotype of a PC based on spoken commands
// object oPC   - the PC that uttered the command
// string sText - the string that was spoken
void Q_ACPCheckChat(object oPC, string sText);

// Sets the phenotype of a PC to the given phenotype if it is in range
// object oPC    - the PC whose pheno type is to be modified
// int nPheno    - the phenotype to which the PC is being changed
// string sStyle - the style that was chosen by the PC
void Q_ACPSetStyle(object oPC, int nPheno, string sStyle = "");

//:://///////////////////////:://
//::  FUNCTION DEFINITIONS   :://
//:://///////////////////////:://

// Sets the phenotype of a PC to the given phenotype if it is in range
// object oPC    - the PC whose pheno type is to be modified
// int nPheno    - the phenotype to which the PC is being changed
// string sStyle - the style that was chosen by the PC
void Q_ACPSetStyle(object oPC, int nPheno, string sStyle = "")
{
    // make sure a valid phenotype was sent before changing it
    if ((nPheno != Q_ACP_ARCANE_PHENO) &&
        (nPheno != Q_ACP_ASSASIN_PHENO) &&
        (nPheno != Q_ACP_DEMON_PHENO) &&
        (nPheno != Q_ACP_FENCING_PHENO) &&
        (nPheno != Q_ACP_HEAVY_PHENO) &&
        (nPheno != Q_ACP_KENSAI_PHENO) &&
        (nPheno != Q_ACP_HUNG_PHENO) &&
        (nPheno != Q_ACP_MUAY_PHENO) &&
        (nPheno != Q_ACP_SHAO_PHENO) &&
        (nPheno != Q_ACP_SHOTO_PHENO) &&
        (nPheno != Q_ACP_WARRIOR_PHENO) &&
        (nPheno != Q_ACP_NORMAL_PHENO) &&
        (nPheno != Q_SOCIAL_PHENO) &&
        (nPheno != Q_FLYING_PHENO))
    {
        SendMessageToPC(oPC, "Invalid Style: " + sStyle);
        return;
    }

    // get the base body type
    int nCurrPheno = GetPhenoType(oPC);
    int nBasePheno;
    if (nCurrPheno >= Q_ACP_ANIMATIONOFFSET)
    {
        nBasePheno = (nCurrPheno - Q_ACP_ANIMATIONOFFSET - 1) / Q_ACP_MAXABASEPHENOTYPES;
    }
    else
    {
        nBasePheno = nCurrPheno;
    }
    // check that the base phenotype is actually supported
    if (nBasePheno >= Q_ACP_MAXSUPPORTEDPHENOTYPES)
    {
        SendMessageToPC(oPC, "Your current phenotype does not have alternate combat animation support");
        return;
    }
    // Optional - check that oPC has two weapons equipped if using demonblade style
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_REQUIRE_DEMONBLADE_MULTIWEAPON) == TRUE)
    {
        if (nPheno == Q_ACP_DEMON_PHENO)
        {
            int bValid = TRUE;
            object oSecondary = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
            if (oSecondary == OBJECT_INVALID)
            {
                bValid = FALSE;
            }
            else
            {
                int nBaseItemType = GetBaseItemType(oSecondary);
                if (nBaseItemType == BASE_ITEM_LARGESHIELD ||
                    nBaseItemType == BASE_ITEM_SMALLSHIELD ||
                    nBaseItemType == BASE_ITEM_TOWERSHIELD)
                {
                    bValid = FALSE;
                }
            }
            if (bValid == FALSE)
            {
                SendMessageToPC(oPC, "You must have two melee weapons equipped to use the demonblade style");
                return;
            }
        }
    }
    // Optional - only monks can use unarmed fighting styles
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_UNARMED_STYLES_LIMITATION) == TRUE)
    {
        if (nPheno == Q_ACP_HUNG_PHENO || nPheno == Q_ACP_MUAY_PHENO || nPheno == Q_ACP_SHAO_PHENO || nPheno == Q_ACP_SHOTO_PHENO)
        {
            int bValid = FALSE;
            if (GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0)
                bValid = TRUE;
            if (bValid == FALSE)
            {
                SendMessageToPC(oPC, "Only monks may use unarmed fighting styles");
                return;
            }
        }
    }
    // modify the style to be appropriate for the body type
    int nNewPheno;
    // the normal phenotype uses defualt animations
    if (nPheno == Q_ACP_NORMAL_PHENO)
    {
        nNewPheno = nBasePheno;
    }
    // these animations are offset
    else
    {
        nNewPheno = nBasePheno * Q_ACP_MAXABASEPHENOTYPES + Q_ACP_ANIMATIONOFFSET + nPheno;
    }
    SetPhenoType(nNewPheno, oPC);
    SendMessageToPC(oPC, "Setting animation style: " + sStyle + " " + IntToString(nNewPheno));

}

// Returns the Phenotype corresponding to the input string
// Returns -1 on invaid input
int Q_ACPGetPhenoFromString(string sText)
{
    // this should be passed in as lower case anyway
    // ... but make sure, just in case
    sText = GetStringLowerCase(sText);

    if (sText == GetStringLowerCase(Q_ACP_ARCANE_STRING))
    {
        return Q_ACP_ARCANE_PHENO;
    }

    if (sText == GetStringLowerCase(Q_ACP_ASSASIN_STRING))
    {
        return Q_ACP_ASSASIN_PHENO;
    }

    if (sText == GetStringLowerCase(Q_ACP_DEMON_STRING))
    {
        return Q_ACP_DEMON_PHENO;
    }

    if (sText == GetStringLowerCase(Q_ACP_FENCING_STRING))
    {
        return Q_ACP_FENCING_PHENO;
    }

    if (sText == GetStringLowerCase(Q_ACP_HEAVY_STRING))
    {
        return Q_ACP_HEAVY_PHENO;
    }

    if (sText == GetStringLowerCase(Q_ACP_KENSAI_STRING))
    {
        return Q_ACP_KENSAI_PHENO;
    }

    if (sText == GetStringLowerCase(Q_ACP_HUNG_STRING))
    {
        return Q_ACP_HUNG_PHENO;
    }

    if (sText == GetStringLowerCase(Q_ACP_MUAY_STRING))
    {
        return Q_ACP_MUAY_PHENO;
    }

    if (sText == GetStringLowerCase(Q_ACP_SHAO_STRING))
    {
        return Q_ACP_SHAO_PHENO;
    }

    if (sText == GetStringLowerCase(Q_ACP_SHOTO_STRING))
    {
        return Q_ACP_SHOTO_PHENO;
    }

    if (sText == GetStringLowerCase(Q_ACP_WARRIOR_STRING))
    {
        return Q_ACP_WARRIOR_PHENO;
    }

    if (sText == GetStringLowerCase(Q_ACP_NORMAL_STRING))
    {
        return Q_ACP_NORMAL_PHENO;
    }

    if (sText == GetStringLowerCase(Q_SOCIAL_STRING))
    {
        return Q_SOCIAL_PHENO;
    }

    if (sText == GetStringLowerCase(Q_FLYING_STRING))
    {
        return Q_FLYING_PHENO;
    }

    // if the string wasn't matched return -1 as an error code
    return -1;
}

// Returns the Phenotype corresponding to the input string
// Returns -1 on invaid input
int Q_VaeiGetAnimFromString(string sText)
{
    // this should be passed in as lower case anyway
    // ... but make sure, just in case
    sText = GetStringLowerCase(sText);

    if (sText == GetStringLowerCase(Q_VAEI_CUSTOM1_STRING))
    {
        return ANIMATION_LOOPING_CUSTOM16;
    }

    if (sText == GetStringLowerCase(Q_VAEI_CUSTOM2_STRING))
    {
        return ANIMATION_LOOPING_CUSTOM17;
    }

    if (sText == GetStringLowerCase(Q_VAEI_CUSTOM3_STRING))
    {
        return ANIMATION_LOOPING_CUSTOM5;
    }

    if (sText == GetStringLowerCase(Q_VAEI_CUSTOM4_STRING))
    {
        return ANIMATION_LOOPING_CUSTOM7;
    }

    if (sText == GetStringLowerCase(Q_VAEI_CUSTOM5_STRING))
    {
        return ANIMATION_LOOPING_CUSTOM8;
    }

    if (sText == GetStringLowerCase(Q_VAEI_CUSTOM6_STRING))
    {
        return ANIMATION_LOOPING_CUSTOM9;
    }

    if (sText == GetStringLowerCase(Q_VAEI_CUSTOM7_STRING))
    {
        return ANIMATION_LOOPING_CUSTOM10;
    }

    if (sText == GetStringLowerCase(Q_VAEI_CUSTOM8_STRING))
    {
        return ANIMATION_LOOPING_CUSTOM18;
    }

    // if the string wasn't matched return -1 as an error code
    return -1;
}

void Q_AddnAnimWrapper(object oPC, int nAnimIndex, float fAnimSpeed, float fAnimDuration)
{
    SendMessageToPC(oPC, "Playing Animation"); // Debug Line
    DelayCommand(0.1, AssignCommand(oPC, ClearAllActions()));
    DelayCommand(0.15, AssignCommand(oPC, ActionPlayAnimation(nAnimIndex, fAnimSpeed, fAnimDuration)));
    return;
}

float GetAppearanceModifierFromABAScaling(object oPC)
{
    int iRacialType = GetRacialType(oPC);

    if (GetGender(oPC) == GENDER_MALE)
    {
        if(iRacialType == IP_CONST_RACIALTYPE_HUMAN)
            return 1.0;
        else if(iRacialType == IP_CONST_RACIALTYPE_HALFLING)
            return 0.65;
        else if(iRacialType == IP_CONST_RACIALTYPE_ELF)
            return 0.895;
        else if(iRacialType == IP_CONST_RACIALTYPE_DWARF)
            return 0.68;
        else if(iRacialType == IP_CONST_RACIALTYPE_GNOME)
            return 0.63;
        else return 1.03;
    }
    else
    {
        if(iRacialType == IP_CONST_RACIALTYPE_HUMAN)
            return 0.988;
        else if(iRacialType == IP_CONST_RACIALTYPE_HALFLING)
            return 0.632;
        else if(iRacialType == IP_CONST_RACIALTYPE_ELF)
            return 0.883;
        else if(iRacialType == IP_CONST_RACIALTYPE_DWARF)
            return 0.648;
        else if(iRacialType == IP_CONST_RACIALTYPE_GNOME)
            return 0.63;
        else return 0.997;
    }
}

// Sets the phenotype of a PC based on spoken commands
// object oPC   - the PC that uttered the command
// string sText - the string that was spoken
void Q_ACPCheckChat(object oPC, string sText)
{
    // test if the first word is the specified keyword
    // just in case the keyword was changed and is not in lowercase, change it to lowercase
    if (GetStringLeft(sText, GetStringLength(Q_ACP_KEYWORD)) == GetStringLowerCase(Q_ACP_KEYWORD))
    {
        // get the remainder of the string following the keyword
        string sStyle = GetStringRight(sText, GetStringLength(sText) - GetStringLength(Q_ACP_KEYWORD));
        int nPheno = Q_ACPGetPhenoFromString(sStyle);
        if (nPheno != -1)
        {
            Q_ACPSetStyle(oPC, nPheno, sStyle);
            SetPCChatMessage();
        }
    }

    else if (GetStringLeft(sText, GetStringLength(Q_ANIM_KEYWORD)) == GetStringLowerCase(Q_ANIM_KEYWORD))
    {
        //get the remainder of the string following the keyword
        string sAnim = GetStringRight(sText, GetStringLength(sText) - GetStringLength(Q_ANIM_KEYWORD));
        int nAnim = Q_VaeiGetAnimFromString(sAnim);
        //SendMessageToPC(oPC, "Animation " +IntToString(nAnim)); // Debug Line
        if (nAnim != -1)
        {
            float fSpeed, fDuration;
            if (nAnim == ANIMATION_LOOPING_CUSTOM16) //Onward
            {
                fSpeed = 1.0;
                fDuration = 1.5;
            }
            else if (nAnim == ANIMATION_LOOPING_CUSTOM17 || //Thought
                     nAnim == ANIMATION_LOOPING_CUSTOM5 ||  //Headache
                     nAnim == ANIMATION_LOOPING_CUSTOM7 ||  //Crossed
                     nAnim == ANIMATION_LOOPING_CUSTOM10)   //Crouching tiger
            {
                fSpeed = 1.0;
                fDuration = 30.0;
            }
            else if (nAnim == ANIMATION_LOOPING_CUSTOM8) //Jump
            {
                fSpeed = 1.5;
                fDuration = 3.5;
            }
            else if (nAnim ==  ANIMATION_LOOPING_CUSTOM9) //Follow
            {
                fSpeed = 2.0;
                fDuration = 2.0;
            }
            else if (nAnim == ANIMATION_LOOPING_CUSTOM18) //Sleep
            {
                // This is to prevent PCs from holding a torch while sleeping.  It breaks the anim.
                object oLeftHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
                if (oLeftHand != OBJECT_INVALID)
                    AssignCommand(oPC, ActionUnequipItem(oLeftHand));

                fSpeed = 1.0;
                fDuration = 60.0;
            }
            if (nAnim == ANIMATION_LOOPING_CUSTOM8) //Jump
            {
                float fDist = 3.974 * GetAppearanceModifierFromABAScaling(oPC);
                location lTarget = GenerateNewLocationFromLocation(GetLocation(oPC), fDist, GetFacing(oPC), GetFacing(oPC));
                SetFootstepType(FOOTSTEP_TYPE_NONE, oPC);
                Q_AddnAnimWrapper(oPC, nAnim, fSpeed, fDuration);
                DelayCommand(4.40, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oPC, 0.63));
                DelayCommand(4.42, AssignCommand(oPC, JumpToLocation(lTarget)));
                DelayCommand(4.44, SetFootstepType(FOOTSTEP_TYPE_DEFAULT, oPC));
            }
            else
            {
                Q_AddnAnimWrapper(oPC, nAnim, fSpeed, fDuration);
            }
            SetPCChatMessage();
        }
    }
}

