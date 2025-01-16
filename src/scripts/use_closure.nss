#include "_i_death"

void main()
{
    object oPC = GetLastUsedBy();
    SetPlayerClosure(oPC, TRUE);
    DelayCommand(0.1, ClearAndJump(oPC, GetWaypointByTag("wp_closure")));
}
