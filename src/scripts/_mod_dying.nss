#include "_inc_death"

void main()
{
    object oPC = GetLastPlayerDying();
    InitiateBleedout(oPC);
}
