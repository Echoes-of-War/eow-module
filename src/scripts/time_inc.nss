#include "x0_i0_stringlib"

//Returns the time string based in seconds with the year concatinated on the end.  a time delay can be applied using the folloing as a guide.
//iDelayMonths is between 0 - 12
//iDelayDays is between 0 - 28
//iDelayHours is between 0 - 23
//iDelayMinutes is between 0 - 59
//iDelaySeconds is between 0 - 59
string GetTimeString(int iDelayMonths = 0, int iDelayDays = 0, int iDelayHours = 0, int iDelayMinutes = 0, int iDelaySeconds = 0)
{
    iDelayMonths += GetCalendarMonth()-1;
    iDelayDays += GetCalendarDay()-1;
    iDelayHours += GetTimeHour();
    iDelayMinutes += GetTimeMinute();
    iDelaySeconds += GetTimeSecond();

    int iTimeInt = iDelaySeconds + 60*iDelayMinutes + 3600*iDelayHours + 86400*iDelayDays + 2419200*iDelayMonths;
    int iYear = GetCalendarYear();

    if(iTimeInt > 29030399)
    {
        iTimeInt -= 29030400;
        iYear++;
    }

    return IntToString(iTimeInt) + "," + IntToString(iYear);
}

//Returns whether or not a specified
int GetIsTimeUp(string sEvalTime)
{
    int iCurrentTime = StringToInt(GetTokenByPosition(GetTimeString(), ",", 0));
    int iCurrentYear = GetCalendarYear();
    int iEvalTime = StringToInt(GetTokenByPosition(sEvalTime, ",", 0));
    int iEvalYear = StringToInt(GetTokenByPosition(sEvalTime, ",", 1));

    if(iCurrentYear > iEvalYear) return TRUE;
    if(iCurrentYear == iEvalYear && iCurrentTime >= iEvalTime) return TRUE;

    return FALSE;
}

//Returns the remaing about of time in a user friendly format.
string GetRemainingTime(string sEvalTime)
{
    int iCurrentTime = StringToInt(GetTokenByPosition(GetTimeString(), ",", 0));
    int iCurrentYear = GetCalendarYear();
    int iEvalTime = StringToInt(GetTokenByPosition(sEvalTime, ",", 0));
    int iEvalYear = StringToInt(GetTokenByPosition(sEvalTime, ",", 1));
    int iRemainingTime = iEvalTime - iCurrentTime;

    string sRemainingTime;

    if(iEvalYear - iCurrentYear > 0)
    {
        sRemainingTime += IntToString(iEvalYear - iCurrentYear) + " Year";
        if(iEvalYear - iCurrentYear > 1) sRemainingTime += "s";
        if(iRemainingTime > 0) sRemainingTime += ", ";
    }

    //Gets the amount of Months left.
    int iRemainingIncrement = iRemainingTime/2914200;
    if(iRemainingIncrement > 0)
    {
        sRemainingTime += IntToString(iRemainingIncrement) + " Month";
        if(iRemainingIncrement > 1) sRemainingTime += "s";
        iRemainingTime -= iRemainingIncrement*2914200;
        if(iRemainingTime > 0) sRemainingTime += ", ";
    }

    //Gets the amount of Days left.
    iRemainingIncrement = iRemainingTime/86400;
    if(iRemainingIncrement > 0)
    {
        sRemainingTime += IntToString(iRemainingIncrement) + " Day";
        if(iRemainingIncrement > 1) sRemainingTime += "s";
        iRemainingTime -= iRemainingIncrement*86400;
        if(iRemainingTime > 0) sRemainingTime += ", ";
    }

    //Gets the amount of Hours left.
    iRemainingIncrement = iRemainingTime/3600;
    if(iRemainingIncrement > 0)
    {
        sRemainingTime += IntToString(iRemainingIncrement) + " Hour";
        if(iRemainingIncrement > 1) sRemainingTime += "s";
        iRemainingTime -= iRemainingIncrement*3600;
        if(iRemainingTime > 0) sRemainingTime += ", ";
    }

    //Gets the amount of Minutes left.
    iRemainingIncrement = iRemainingTime/60;
    if(iRemainingIncrement > 0)
    {
        sRemainingTime += IntToString(iRemainingIncrement) + " Minute";
        if(iRemainingIncrement > 1) sRemainingTime += "s";
        iRemainingTime -= iRemainingIncrement*60;
        if(iRemainingTime > 0) sRemainingTime += ", ";
    }

    //Gets the amount of Seconds left.
    if(iRemainingTime > 0)
    {
        sRemainingTime += IntToString(iRemainingTime) + " Second";
        if(iRemainingTime > 1) sRemainingTime += "s";
    }

    return sRemainingTime;
}
