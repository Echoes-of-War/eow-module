#include "_inc_death"

void main()
{
    object oPC = GetLastUsedBy();
    if (GetIsGhost(oPC) == TRUE)
    {
        DoGhostRespawn(oPC, OBJECT_SELF);
    } else
    {

    }
}
