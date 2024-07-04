//::///////////////////////////////////////////////////
//:: X0_S1_PETRGAZE
//:: Petrification touch attack monster ability.
//:: Fortitude save (DC 15) or be turned to stone permanently.
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/14/2002
//::///////////////////////////////////////////////////
//:: Updated On: July 1, 2012, Project Q - Pstemarie (from work by the Krit)
//::                          Strength of petrification now determined by caster, not target

#include "x0_i0_spells"

void main()
{
    object oTarget = GetSpellTargetObject();
    int nHitDice = GetHitDice(OBJECT_SELF);

    DoPetrification(nHitDice, OBJECT_SELF, oTarget, GetSpellId(), 15);
}

