#include "_inc_rest"

void main()
{
    object oPC = GetItemActivator();
    object oArea = GetArea(oPC);
    location lLocation = GetItemActivatedTargetLocation();
    CreateCamp(lLocation, oPC);
}
