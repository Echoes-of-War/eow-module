//::///////////////////////////////////////////////
//:: Name: Q General Conversation
//:: FileName: q_im_female_hu
//:: Website: http://www.qnwn.net
//:: Contact: projectq@qnwn.net
//:://////////////////////////////////////////////
/*
    Project Q - Release 1.5

    Return TRUE if
        -   PC Speaker is female
        -   PC Speaker is human (use appearance type rather than race)
*/
//:://////////////////////////////////////////////
//:: Created By: pstemarie
//:: Created On: 22 Dec 2011
//:://////////////////////////////////////////////

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    if((GetGender(oPC) == GENDER_FEMALE) && (GetAppearanceType(oPC) == APPEARANCE_TYPE_HUMAN))
        return TRUE;

    return FALSE;
}
