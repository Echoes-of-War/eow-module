#include "eow_inc_colours"
#include "nwnx_chat"

////////////////////////////////////////////////////////////////////////
// PRIVATE METHODS, do not call outside of on chat

// this is a message, either IC or OOC
void ProcessSpeech();
// Process a player's chat command
void ProcessCommand(string sCommand);
// Used to project speech to a PC's associate
void ProjectSpeechTo(int nAssociateType, string sMessage);
// Decide whether to send an obscured or plain chat to a player
void SendLanguageFilteredMessage(int nChatChannel, int nLang, string sSpeech, string sSpeechObscured, object oPC, object oTarget);
////////////////////////////////////////////////////////////////////////

void main()
{
    string sChatMessage = GetPCChatMessage();
    string sFirstChar = GetStringLeft(sChatMessage, 1);
    string sMessage = GetStringRight(sChatMessage, GetStringLength(sChatMessage) - 1);

    if      (sFirstChar == "!")
    {
        ProcessCommand(sMessage);
    }
    else if (sFirstChar == "#")
    {
        ProjectSpeechTo(ASSOCIATE_TYPE_ANIMALCOMPANION, sMessage);
    }
    else if (sFirstChar == "@")
    {
        ProjectSpeechTo(ASSOCIATE_TYPE_FAMILIAR, sMessage);
    }
    else if (sFirstChar == "^")
    {
        ProjectSpeechTo(ASSOCIATE_TYPE_SUMMONED, sMessage);
    }
    else if (sFirstChar == "%")
    {
        ProjectSpeechTo(ASSOCIATE_TYPE_DOMINATED, sMessage);
    }
    else if (sFirstChar == "$")
    {
        ProjectSpeechTo(ASSOCIATE_TYPE_HENCHMAN, sMessage);
    }
    else // not a command or a projection, so regular RP
    {
        ProcessSpeech();
    }

    // DMFI processing for listeners and miscellaneous stuff.
    // Might need configuration so that it doesn't introduce unwanted functionality.
    ExecuteScript("dmfi_onplychat", OBJECT_SELF);
}

void ProjectSpeechTo(int nAssociateType, string sMessage)
{
    object oAssociate = GetAssociate(nAssociateType, GetPCChatSpeaker(), 1);
    if(oAssociate != OBJECT_INVALID)
    {
        AssignCommand(oAssociate, ActionSpeakString(sMessage, GetPCChatVolume()));
    }
}

void ProcessCommand(string sCommand)
{
    SetPCChatMessage();
    SendMessageToPC(GetPCChatSpeaker(), ColourWrapError("TODO import commands"));
}

void ProcessSpeech()
{
    object oPC = GetPCChatSpeaker();
    int nChatVolume = GetPCChatVolume();
    string sOriginal = GetPCChatMessage();

    if (nChatVolume == TALKVOLUME_PARTY)
    {
        SetPCChatMessage();
        SendMessageToPC(oPC, ColourWrapError("Party Chat is Disabled.") + " Your message was: " +sOriginal);
    }
    else if (nChatVolume == TALKVOLUME_SILENT_SHOUT)
    {
        SendMessageToPC(oPC, "Sent to DM channel: " + ColourWrapPrivate(sOriginal));
    }
    else
    {
        int bWhisper = nChatVolume == TALKVOLUME_WHISPER;
        SetPCChatMessage(ColourWrapSpeech(sOriginal, bWhisper, NARRATION_STYLE_BRACKETS));
    }
}

void SendLanguageFilteredMessage(int nChatChannel, int nLang, string sSpeech, string sSpeechObscured, object oPC, object oTarget)
{
    // TODO remove this and uncomment above when languages are implemented
    NWNX_Chat_SendMessage(nChatChannel, sSpeech, oPC, oTarget);

    // string sFiltered = sSpeechObscured;
    // object oItem = GetItemPossessedBy(oTarget,"PC_Data_Object");
    // if (nLang == -1                                        // common
    //     || GetLocalInt(oItem, IntToString(nLang)) == 1     // speaks language
    //     || GetIsDM(oTarget) || GetIsDMPossessed(oTarget))  // is DM
    // {
    //     // set to raw speech
    //     sFiltered = sSpeech;
    // }
    // NWNX_Chat_SendMessage(nChatChannel, sFiltered, oPC, oTarget);
}