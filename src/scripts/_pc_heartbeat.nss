#include "_inc_death"

void main()
{
    object oSelf = OBJECT_SELF;
    if (GetIsInBleedout(oSelf) == TRUE && GetCurrentHitPoints(oSelf) > 0)
    {
        DeInitiateBleedout(oSelf, FALSE);
    }
}
