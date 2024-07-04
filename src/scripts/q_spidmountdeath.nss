//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT7
/*
  Default OnDeath event handler for NPCs.

  Adjusts killer's alignment if appropriate and
  alerts allies to our death.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////
//:://////////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: April 1st, 2008
//:: Added Support for Dying Wile Mounted
//:://///////////////////////////////////////////////

#include "x2_inc_compon"
#include "x0_i0_spawncond"

void main()
{
    int nClass = GetLevelByClass(CLASS_TYPE_COMMONER);
    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
    object oKiller = GetLastKiller();

    // If we're a good/neutral commoner,
    // adjust the killer's alignment evil
    if(nClass > 0 && (nAlign == ALIGNMENT_GOOD || nAlign == ALIGNMENT_NEUTRAL))
    {
        AdjustAlignment(oKiller, ALIGNMENT_EVIL, 5);
    }

    // Call to allies to let them know we're dead
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);

    // NOTE: the OnDeath user-defined event does not
    // trigger reliably and should probably be removed
    if(GetSpawnInCondition(NW_FLAG_DEATH_EVENT))
    {
         SignalEvent(OBJECT_SELF, EventUserDefined(1007));
    }
    craft_drop_items(oKiller);

/////////////////////////////////
// Goblin Worg Rider stuff
/////////////////////////////////

// Get position and facing of Worg and set spawn point for the Goblin
    vector vWorg = GetPosition(OBJECT_SELF);
    float fAngle = GetFacing(OBJECT_SELF);
    location lGoblin;
    vector vChange;
    object oArea = GetArea(OBJECT_SELF);
    vChange.y = cos(fAngle) * 0.6;
    lGoblin = Location(oArea, vWorg+vChange, fAngle);

// Spawn the goblin because the worg has died
    effect eKnockdwn = ExtraordinaryEffect(EffectKnockdown());
    object oSpawn = CreateObject(OBJECT_TYPE_CREATURE,"nw_goblinb",lGoblin,FALSE);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdwn, oSpawn, 2.0);
}
