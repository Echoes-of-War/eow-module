//::///////////////////////////////////////////////
//:: Beholder Ray Attacks
//:: x2_s2_beholdray
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Implementation for the new version of the
    beholder rays, using projectiles instead of
    rays
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-16
//:://////////////////////////////////////////////
//:: Updated On: July 1, 2012, Project Q - Pstemarie (by The Krit - used without permission)
//::                          Rewritten by The Krit to route the petrification ray through the DoPetrification() function.

#include "x0_i0_spells"


// Adds an extra visual effect for the petrification ray.
void PetrificationVisual(object oTarget);

void main()
{
    int    nSpell  = GetSpellId();
    object oTarget = GetSpellTargetObject();
    int    nSaveDC = 15;

    // Special handling for petrification.
    if ( nSpell == 778 ) // BEHOLDER_RAY_PETRI
    {
        // The save DC is also the duration (if not permanent).
        DoPetrification(nSaveDC, OBJECT_SELF, oTarget, 778, nSaveDC);
        DelayCommand(0.1, PetrificationVisual(oTarget));
        return;
    }

    // Signal this ability being used.
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

    // Perform a saving throw.
    int bSave = FALSE; // Was the saving throw successful?
    switch (nSpell)
    {
        case 776: // BEHOLDER_RAY_DEATH
        case 783: // BEHOLDER_RAY_WOUND
                    bSave = 0 < MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC);
                    break;

        case 777: // BEHOLDER_RAY_TK (knockdown)
        case 779: // BEHOLDER_RAY_CHARM
        case 780: // BEHOLDER_RAY_SLOW
        case 784: // BEHOLDER_RAY_FEAR
                    bSave = 0 < MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC);
                    break;

        // The remaining rays have no defined effects.
        //case 785: // Undefined beholder ray.
        //case 786: // Undefined beholder ray.
        //case 787: // Undefined beholder ray.
    }

    // If the save failed.
    if ( !bSave )
    {
        // Determine the effects to produce.
        effect  eDuration, eInstant;
        float fDuration = 0.0;
        switch ( nSpell )
        {
            case 776: eInstant = EffectLinkEffects(EffectVisualEffect(VFX_IMP_DEATH),
                                                   EffectDeath(TRUE));
                      break;

            case 777: eInstant = EffectVisualEffect(VFX_IMP_STUN);
                      eDuration = ExtraordinaryEffect(EffectKnockdown());
                      fDuration = 6.0;
                      break;

            case 779: eInstant = EffectVisualEffect(VFX_IMP_CHARM);
                      eDuration = EffectCharmed();
                      fDuration = 24.0;
                      break;

            case 780: eInstant = EffectVisualEffect(VFX_IMP_SLOW);
                      eDuration = EffectSlow();
                      fDuration = RoundsToSeconds(6);
                      break;

            case 783: eInstant = EffectLinkEffects(EffectVisualEffect(VFX_COM_BLOOD_REG_RED),
                                                   EffectDamage(d8(2) + 10));
                      break;

            case 784: eInstant = EffectVisualEffect(VFX_IMP_FEAR_S);
                      eDuration = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR),
                                                    EffectFrightened());
                      fDuration = RoundsToSeconds(d4() + 1);
                      break;

            // Provide a default just in case another spell makes it here.
            default: eInstant = EffectVisualEffect(VFX_IMP_DESTRUCTION);
        }//switch

        // Apply the effects
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eInstant, oTarget);
        if ( fDuration > 0.0 )
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDuration, oTarget, fDuration);
    }//if (!bSave)
    else
    {
        // Only one ray has an effect if the save was made.
        if ( nSpell == 776 ) // Death ray
        {
            effect eDamage = EffectLinkEffects(EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY),
                                                EffectDamage(d6(3) + 13));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
        }
    }
}


// Adds an extra visual effect to petrification.
void PetrificationVisual(object oTarget)
{
    // See if oTarget has been petrified by this ray.
    // (Or an earlier petrification ray. Close enough.)
    if ( GetHasSpellEffect(778, oTarget) )
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oTarget);
}
