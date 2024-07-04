//::///////////////////////////////////////////////
//:: Name: Q General Conversation
//:: FileName: q_im_female
//:: Website: http://www.qnwn.net
//:: Contact: projectq@qnwn.net
//:://////////////////////////////////////////////
/*
    Project Q - Release 1.5

    Return TRUE if
        -   PC Speaker is female
*/
//:://////////////////////////////////////////////
//:: Created By: pstemarie
//:: Created On: 22 Dec 2011
//:://////////////////////////////////////////////

int StartingConditional()
{
    if(GetGender(GetPCSpeaker()) == GENDER_FEMALE)
        return TRUE;

    return FALSE;
}
