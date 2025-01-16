#include "_i_death"

void main()
{
    object oPC = GetLastUsedBy();
    PVPSetRemainingLives(oPC, 3);
    ClearAndJump(oPC, GetWaypointByTag(WP_RESPAWN));
}
