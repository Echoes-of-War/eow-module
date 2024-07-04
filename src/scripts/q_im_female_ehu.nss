//::///////////////////////////////////////////////
//:: Name: Q General Conversation
//:: FileName: q_im_female_ehu
//:: Website: http://www.qnwn.net
//:: Contact: projectq@qnwn.net
//:://////////////////////////////////////////////
/*
    Project Q - Release 1.5

    Return TRUE if
        -   PC Speaker is female
        -   PC Speaker is human (use appearance type rather than race)
        -   PC Speaker is elf (use appearance type rather than race)
*/
//:://////////////////////////////////////////////
//:: Created By: pstemarie
//:: Created On: 22 Dec 2011
//:://////////////////////////////////////////////

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    if((GetGender(oPC) == GENDER_FEMALE) && (GetAppearanceType(oPC) == APPEARANCE_TYPE_HUMAN || GetAppearanceType(oPC) == APPEARANCE_TYPE_ELF))
        return TRUE;

    return FALSE;
}
