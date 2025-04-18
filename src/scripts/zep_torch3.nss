//::///////////////////////////////////////////////
//:: ZEP_TORCH.nss
//:: Copyright (c) 2001 Bioware Corp.
//:: Modified by Dan Heidel 1/21/04 for CEP
//:://////////////////////////////////////////////
/*
    UPDATE:
    UPDATE, Manuel Fierlbeck (MF), 15.11.2014:
    - preserves DMTS variables
    - Transfer "plot" and "useable" flag onto the new placeable that is swapped
      in. This modification can reduce the number of required blueprint variants.
    - Transfer tag, override name and description onto the new placeable.
    - made light effect supernatural, so that it cannot be dispelled
    - CEP_L_LIGHTCONST is optional; if it's not set, static illumination is assumed.
    - CEP_L_LIGHTSWAP is optional; if it's not set, only effect resp. illumination
      is set or removed.
    - removed superfluous variable CEP_L_LIGHTDIURNAL
    - Old scripts "zep_torchspawn" and "zep_torch2" are kept for backwards
      compatibility.

    Turns the placeable object's animation on/off
    for the activation of torches, candles and othe light sources.
    It works by deleting the calling object and replacing it with its
    lit/unlit counterpart.  Although this function ignores the value of
    CEP_L_LIGHTCYCLE, if that localint is set to 1, the placeable will
    revert back to its normal lit/unlit day/night cycle state on the
    next heartbeat.  To properly turn off a cycling light-source placeable,
    CEP_L_LIGHTCYCLE must be set to 0.

    Works as zep_onoff except that no sounds are called and a
    lighting effect is called on the placeable instead.  The
    light type is stored in a local int CEP_L_LIGHT.  CEP_L_LIGHT is
    defined in zep_torchspawn from a table of constants - eg:
    VFX_DUR_LIGHT_YELLOW_20.  CEP_L_LIGHTCONST is a local string defined
    on the placeable which is used to set CEP_L_LIGHTCONST to the proper value.
    Place the name of the constant in this local string so that
    zep_torchspawn to operate correctly.

*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  January 2002
//:://////////////////////////////////////////////
// #include "debug_util"
#include "zep_inc_main"
#include "dmts_common_inc"

// required delay until a placeable has disappeared
const float DELAY_ = 4.0;

// applies the requested light effect with delay
void ApplyLight_(int light)
{
    // Log("ApplyLight", "light=" + I(light));

    // MF: bugfix: made effect non-dispellable
    effect e = SupernaturalEffect(EffectVisualEffect(light));
    DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e, OBJECT_SELF));
}


void main()
{
    // If placeable has a light cycle, exit - it would revert the change
    // on the next heartbeat
    if (GetLocalInt(OBJECT_SELF, "CEP_L_LIGHTCYCLE"))
        return;

    string fn = "zep_torch3";
    string sLightConst = GetLocalString(OBJECT_SELF, "CEP_L_LIGHTCONST");
    string sLightSwap = GetLocalString(OBJECT_SELF, "CEP_L_LIGHTSWAP");
    int nAmIOn = !GetLocalInt(OBJECT_SELF, "CEP_L_AMION");

    object oNew = OBJECT_SELF;
    int swap = (sLightSwap != "" && sLightSwap != GetResRef(OBJECT_SELF));
    if (swap) {
        // switch in lit/unlit counterpart
        oNew = CreateObject(OBJECT_TYPE_PLACEABLE, sLightSwap, GetLocation(OBJECT_SELF), FALSE, GetTag(OBJECT_SELF));
        // SetLocalInt(oNew, "CEP_L_LIGHTCYCLE", GetLocalInt(OBJECT_SELF, "CEP_L_LIGHTCYCLE"));
        // SetLocalInt(oNew, "CEP_L_LIGHTDIURNAL", GetIsNight());
        SetLocalString(oNew, "CEP_L_LIGHTCONST", sLightConst);
        SetLocalString(oNew, "CEP_L_LIGHTSWAP", GetResRef(OBJECT_SELF));

        // MF: transfer flags "plot", "useable", user-defined name and
        // user-defined description
        SetPlotFlag(oNew, GetPlotFlag(OBJECT_SELF));
        SetUseableFlag(oNew, GetUseableFlag(OBJECT_SELF));
        string name = GetName(OBJECT_SELF, FALSE);
        if (name != GetName(OBJECT_SELF, TRUE))
            SetName(oNew, name);
        string description = GetDescription(OBJECT_SELF, FALSE);
        if (description != GetDescription(OBJECT_SELF, TRUE))
            SetDescription(oNew, description);

        // MF: preserve DMTS variables as in zep_torchspawn
        RestoreVariables(oNew, SaveVariables(OBJECT_SELF));
        location initLoc = GetLocalLocation(OBJECT_SELF, "DM_PAA_lOriginal");
        if (GetIsObjectValid(GetAreaFromLocation(initLoc)))
            SetLocalLocation(oNew, "DM_PAA_lOriginal", initLoc);

        object oStageManager = GetLocalObject(OBJECT_SELF, "oStageManager");
        if (GetIsObjectValid(oStageManager)) {
            SetLocalObject(oNew, "oStageManager", oStageManager);
            SetLocalObject(oStageManager,
                GetLocalString(OBJECT_SELF, "sPropID_VarName"), oNew);
        }

        // MF: ensure that placeable is destroyable
        SetIsDestroyable(TRUE);
        DestroyObject(OBJECT_SELF, 0.0);
    } // swap object

    // store new state
    SetLocalInt(oNew, "CEP_L_AMION", nAmIOn);
    SetLocalInt(oNew, "CEP_L_LIGHTINITIALIZED", TRUE);

    // apply or remove light effect as required by the new state
    object area = GetArea(OBJECT_SELF);
    if (sLightConst != "") {
        if (nAmIOn) {
            int nLight = ColorInit(sLightConst);
            // MF: bugfix: DelayCommand() doesn't work here, because current
            // object will be destroyed. Delegate delayed effects to new placeable.
            AssignCommand(oNew, ApplyLight_(nLight));
        } else if (!swap) {
            // remove light effect if placeable was not swapped
            effect e = GetFirstEffect(oNew);
            while (GetIsEffectValid(e)) {
                if (GetEffectType(e) == EFFECT_TYPE_VISUALEFFECT &&
                    GetEffectSubType(e) == SUBTYPE_SUPERNATURAL) {
                    RemoveEffect(oNew, e);
                    // Log(fn, "removed effect " + EffectToString(e), oNew);
                }
                e = GetNextEffect(oNew);
            }
        }
    } else {
        // MF: if a light effect is not indicated, assume static illumination
        SetPlaceableIllumination(oNew, nAmIOn);
    }
    AssignCommand(area, DelayCommand(DELAY_, RecomputeStaticLighting(area)));
}
