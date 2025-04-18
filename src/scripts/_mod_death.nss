#include "_inc_death"

void main()
{
    object oPC = GetLastPlayerDied();
    InitiateBleedout(oPC);
}
