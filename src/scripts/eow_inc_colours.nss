#include "colors_inc"

string RED        = ColorTokenRed();
string WHITE      = ColorTokenDialog();
string GREY       = ColorTokenWhisper();
string NEON       = ColorTokenTell();
string PERIWINKLE = ColorToken(199, 200, 222);
string DARKBLUE   = ColorToken(118, 120, 159);


const int NARRATION_STYLE_QUOTATIONS = 0;
const int NARRATION_STYLE_BRACKETS   = 1;
const int NARRATION_STYLE_STARS      = 2;

const string QUOTATION_CHARACTER = "\"";
const string BRACKET_OPEN_CHARACTER = "[";
const string BRACKET_CLOSE_CHARACTER = "]";
const string STAR_CHARACTER = "*";


string ColourWrapError(string sRaw);
string ColourWrapPrivate(string sRaw);
string ColourWrapSpeech(string sRaw, int bWhisper, int nNarrationStyle);

// PRIVATE ----------------------------------
string ColourWrap(string sRaw, string sColour);
// ------------------------------------------


string ColourWrapError(string sRaw)
{
    return ColourWrap(sRaw, RED);
}

string ColourWrapPrivate(string sRaw)
{
    return ColourWrap(sRaw, NEON);
}

string ColourWrapSpeech(string sRaw, int bWhisper, int nNarrationStyle)
{
    string sSpeechStart = "";

    // TODO revisit for language implementation
    // Determine if the player has a language toggled
    // int iLangSpoken = -1; //Common
    // if(GetLocalInt(oPC,"LangOn") == 1)
    // {
    //     iLangSpoken = GetLocalInt(oPC,"LangSpoken");
    //     sSpeechStart = GetColorForLanguage(iLangSpoken) + "[" + GetLanguageName(iLangSpoken) + "] " + COLOR_END;
    // }

    string sSpeechColor = WHITE;
    string sEmoteColor = PERIWINKLE;
    if (bWhisper)
    {
        sSpeechColor = GREY;
        sEmoteColor = DARKBLUE;
    }

    string sCurrentChar = GetStringLeft(sRaw, 1);;
    int i = 0;
    int bSpeaking = FALSE;
    int bEmoting = FALSE;
    string sSpeech = sSpeechStart;
    // string sSpeechObscured = sSpeechStart;

    if (nNarrationStyle == NARRATION_STYLE_BRACKETS || nNarrationStyle == NARRATION_STYLE_STARS)
    {
        string sEmoteStartChar = BRACKET_OPEN_CHARACTER;
        string sEmoteEndChar = BRACKET_CLOSE_CHARACTER;
        if (nNarrationStyle == NARRATION_STYLE_STARS)
        {
            sEmoteStartChar = STAR_CHARACTER;
            sEmoteEndChar = STAR_CHARACTER;
        }

        while (i < GetStringLength(sRaw))
        {
            if (!bEmoting && !bSpeaking)
            {
                if (sCurrentChar == sEmoteStartChar)
                {
                    sSpeech         += sEmoteColor + sCurrentChar;
                    // sSpeechObscured += sEmoteColor + sCurrentChar;
                    bEmoting = TRUE;
                }
                else
                {
                    sSpeech         += sSpeechColor + sCurrentChar;
                    // sSpeechObscured += sSpeechColor + TranslateCommonToLanguage(iLangSpoken,sCurrentChar);
                    bSpeaking = TRUE;
                }
            }
            else if (bEmoting)
            {
                sSpeech         += sCurrentChar;
                // sSpeechObscured += sCurrentChar;
                if (sCurrentChar == sEmoteEndChar)
                {
                    sSpeech         += ColorTokenEnd();
                    // sSpeechObscured += COLOR_END;
                    bEmoting = FALSE;
                }
            }
            else if (bSpeaking)
            {
                if (sCurrentChar == sEmoteStartChar)
                {
                    sSpeech         += ColorTokenEnd() + sEmoteColor + sCurrentChar;
                    // sSpeechObscured += COLOR_END + sEmoteColor + sCurrentChar;
                    bSpeaking = FALSE;
                    bEmoting = TRUE;
                }
                else
                {
                    sSpeech         += sCurrentChar;
                    // sSpeechObscured += TranslateCommonToLanguage(iLangSpoken,sCurrentChar);
                }
            }
            i++;
            sCurrentChar = GetSubString(sRaw, i, 1);
        }
    }
    else // default to NARRATION_STYLE_QUOTATIONS
    {
        while (i < GetStringLength(sRaw))
        {
            if (sCurrentChar == QUOTATION_CHARACTER)
            {
                if (!bEmoting && !bSpeaking) // first character
                {
                    sSpeech         += sSpeechColor + sCurrentChar;
                    // sSpeechObscured += sSpeechColor + sCurrentChar;
                    bSpeaking = TRUE;
                }
                else if (bEmoting)
                {
                    sSpeech         += ColorTokenEnd() + sSpeechColor + sCurrentChar;
                    // sSpeechObscured += COLOR_END + sSpeechColor + sCurrentChar;
                    bSpeaking = TRUE;
                    bEmoting = FALSE;
                }
                else if (bSpeaking)
                {
                    sSpeech         += sCurrentChar + ColorTokenEnd() + sEmoteColor;
                    // sSpeechObscured += sCurrentChar + COLOR_END + sEmoteColor;
                    bSpeaking = FALSE;
                    bEmoting = TRUE;
                }
            }
            else
            {
                if (!bEmoting && !bSpeaking) // first character
                {
                    sSpeech         += sEmoteColor + sCurrentChar;
                    // sSpeechObscured += sEmoteColor + sCurrentChar;
                    bEmoting = TRUE;
                }
                else if (bEmoting)
                {
                    sSpeech         += sCurrentChar;
                    // sSpeechObscured += sCurrentChar;
                }
                else if (bSpeaking)
                {
                    sSpeech         += sCurrentChar;
                    // sSpeechObscured += TranslateCommonToLanguage(iLangSpoken,sCurrentChar);
                }
            }
            i++;
            sCurrentChar = GetSubString(sRaw, i, 1);
        }
    }

    return sSpeech;
}

// PRIVATE
string ColourWrap(string raw, string sColour)
{
    return sColour + raw + ColorTokenEnd();
}
