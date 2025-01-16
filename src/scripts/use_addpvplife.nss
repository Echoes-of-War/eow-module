// INCLUDES  -------------------------------------------------------------------

#include "_i_death"

// EXECUTION  ------------------------------------------------------------------

void main()
{
    object oPC = GetLastUsedBy();
    int iLives = PVPGetRemainingLives(oPC);
    int iNewLives = ++iLives;
    PVPSetRemainingLives(oPC, iNewLives);
}
