//::///////////////////////////////////////////////
//:: ZEP_TORCHSPAWN2.nss
//:: Created by by Dan Heidel 1/21/04 for CEP
//:://////////////////////////////////////////////
/*
    UPDATE, Manuel Fierlbeck (MF), 15.11.2014:
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

    This function is called on heartbeat and designed to exert minimal
    drag on the system except during module load.  This function is used
    to initialize light-emitting placeables.  Since there is no OnSpawn
    event handler for placeables, the OnHeartbeat handler is used instead.
    As long as the total number of lighting placeables is kept to a reasonable
    number, the CPU impact will be minimal.

    This is used to initialize a light-emitting placeable and to update certain
    placeable behaviors if certain conditions are met.

    The following local variables are used on light-emitting placeables:

    CEP_L_AMION: this is a localint that holds the present on-off state of the
    placeable.  If the placeable is to be switched on or off, please use the
    zep_torch or zep_torchupdate functions.  DO NOT CHANGE THIS VARIABLE MANUALLY.
    Doing so will cause the light-emitting placeable to stop functioning
    properly if done improperly.

    CEP_L_LIGHTCYCLE: this is a localint that determines whether the light-
    -emitting placeable will automatically switch itself on and off to match the
    day/night cycle.  If it is set to 1, the placeable will shut off during the
    day. If set to 0, the placeable does not change state unless zep_torch or
    zep_torchupdate are used to change it.
    Also note that cycling placeables update on every heartbeat.  This means
    that if a cycling light-emitter is turned off at night, it will switch back
    on on the next heartbeat.

    CEP_L_LIGHTCONST: this localstring holds the name of the lighting constant
    used to put a colored light on a lit light-emitting placeable.  For example,
    if a torch is supposed to emit a 20 foot diameter yellow light, CEP_L_LIGHTCONST
    should contain "YELLOW_20".  The function ColorInit in the zep_inc_main
    library converts this string into a number which can be used by the game
    engine.
    The following colors and light radii are available:
    White, Yellow, Orange, Red, Green, Blue and Purple  (note that Green actually
    calls a GREY lighting effect which is green for some inscrutible reason)
    5, 10, 15, 20 are the available radii.  Note that some light colors are
    brighter than others.  Consult the CEP Builder's guide for more information.

    Note: the ColorInit function only looks at the first two and last two
    characters of the string so YELLOW_5 could be called by YE_5 and RED_20
    with RE20 but for readability, the user is encouraged to use the full names.
    Note: changing this string only causes the lighting color to change when a
    a cycling light-emitter switches states, a light-emitter is switched on or
    off with zep_torch or when a zep_torchupdate is called on a light-emitter.

    CEP_L_LIGHTSWAP: this localstring holds the resref of its counterpart
    light-emitter.  For example, a lit wooden lantern's CEP_L_LIGHTSWAP
    contains "owoodlantern001" and an unlit wood lantern's CEP_L_LIGHTSWAP
    contains "woodlantern001".  This variable provides a handle so that the
    lit/unlit light-emitter placeable can be swapped for its counterpart
    when the placeable "switches" on or off.  NEVER CHANGE THIS VARIABLE.

    CEP_L_LIGHTINITIALIZED: this localint is 0 if the placeable hasn't been
    initialized yet, 1 if it has.  This localint is defined at runtime.  NEVER
    CHANGE THIS VARIABLE.

********************************************************************************

    Due to various limitations in the Aurora NWN graphics engine, the switching
    of light-emitting placeables is done by deleting the placeable and putting
    it's lit/unlit counterpart at the same position.

    Use zep_torch on a light-emitting placeable to switch it on or off.

    If the color of a light-emitting placeable is changed and the change is to
    be reflected in game, a zep_torchupdate must be used on the placeable.

    As provided, the light-emitting placeables provided in CEP should work with
    little to no builder intervention.  The local variables are all set.  Simply
    place a lit or unlit placeable and it will take care of itself.

    All light-emitting placeables in the Civilization Exterior/Lighting category
    are day/night cycling by default, the rest are non-cycling.  Change the value
    of CEP_L_LIGHTCYCLE in the variables on your placed placeable if you wish to
    change this.

    Likewise, the color and radius of the emitted light can be changed on
    placeables placed down in the toolset.

*/

//----------------------------------------------------------------------------
// 04/19/2010      Malishara: added code to play nice with DMTS tools
//----------------------------------------------------------------------------

#include "zep_inc_main"
#include "dmts_common_inc"

// #include "debug_util"

// required delay until a placeable has disappeared
const float DELAY_ = 4.0;

// recomputes static lighting as soon as all pending update events have been
// encountered
void UpdateAreaDelayed_()
{
    int counter = GetLocalInt(OBJECT_SELF, "CEP_L_UPDATE");
    // Log("UpdateAreaDelayed", "counter=" + I(counter));

    if (counter <= 1) {
        RecomputeStaticLighting(OBJECT_SELF);
        DeleteLocalInt(OBJECT_SELF, "CEP_L_UPDATE");
    } else {
        SetLocalInt(OBJECT_SELF, "CEP_L_UPDATE", counter - 1);
    }
}


// recomputes static lighting after a delay.
void UpdateArea_(object area)
{
    int counter = GetLocalInt(area, "CEP_L_UPDATE") + 1;
    SetLocalInt(area, "CEP_L_UPDATE", counter);
    // Log("UpdateArea", "new counter=" + I(counter), area);
    AssignCommand(area, DelayCommand(DELAY_, UpdateAreaDelayed_()));
}


// applies or removes the static or dynamic light on a placeable according to
// the configured color and radius
void SetLightEffect_(object target, int on)
{
    string fn = "SetLightEffect";

    string lightConst = GetLocalString(target, "CEP_L_LIGHTCONST");
    // Log(fn, "lightConst='" + lightConst + "', on=" + B(on), target);

    if (lightConst != "") {
        if (on) {
            // MF: bugfix: made effect non-dispellable
            effect eLight = SupernaturalEffect(EffectVisualEffect(ColorInit(lightConst)));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLight, target);
        } else {
            // remove light effect - required if placeable was not switched
            effect e = GetFirstEffect(target);
            while (GetIsEffectValid(e)) {
                if (GetEffectType(e) == EFFECT_TYPE_VISUALEFFECT &&
                    GetEffectSubType(e) == SUBTYPE_SUPERNATURAL) {
                    RemoveEffect(target, e);
                    // Log(fn, "removed effect " + EffectToString(e), target);
                }
                e = GetNextEffect(target);
            }
        }
    } else {
        // MF: if light effect is not indicated, assume static illumination
        SetPlaceableIllumination(target, on);
    }
    UpdateArea_(GetArea(target));
}


void main()
{
    int nLightCycle = GetLocalInt(OBJECT_SELF, "CEP_L_LIGHTCYCLE");
    int nInitialized = GetLocalInt(OBJECT_SELF, "CEP_L_LIGHTINITIALIZED");
    // 0 if the first time this function has run for this torch, 1 if it has run before
    if (nInitialized) {
        // if placeable has been initialized and doesn't have a lightcycle,
        // there's nothing to do. Exit immediately to save CPU time.
        if (!nLightCycle)
            return;
    } else {
        // if the placeable wasn't marked as initialized, it is now.
        SetLocalInt(OBJECT_SELF, "CEP_L_LIGHTINITIALIZED", TRUE);
        // SetLocalInt(OBJECT_SELF, "CEP_L_LIGHTDIURNAL", !GetIsNight());
    }

    int nAmIOn = GetLocalInt(OBJECT_SELF, "CEP_L_AMION");
    if (nLightCycle) {
        // This is a cycling placeable. If the on/off state matches what it
        // should be, return. Ensure that required light effect is set on first
        // call.
        int isNight = GetIsNight();
        if (nInitialized && isNight == nAmIOn)
            return;

        // check whether to swap the placeable by its lit/unlit counterpart
        object oNew = OBJECT_SELF;
        string sLightSwap = GetLocalString(OBJECT_SELF, "CEP_L_LIGHTSWAP");
        int swap = (isNight != nAmIOn && sLightSwap != "" && sLightSwap != GetResRef(OBJECT_SELF));
        if (swap) {
            // destroy the placeable and replace it by its lit/unlit counterpart
            // at the same location
            oNew = CreateObject(OBJECT_TYPE_PLACEABLE, sLightSwap, GetLocation(OBJECT_SELF), FALSE, GetTag(OBJECT_SELF));

            // store light configuration and new state on the new placeable
            // SetLocalInt(oNew, "CEP_L_LIGHTDIURNAL", isNight);
            SetLocalInt(oNew, "CEP_L_LIGHTINITIALIZED", TRUE);
            SetLocalString(oNew, "CEP_L_LIGHTCONST", GetLocalString(OBJECT_SELF, "CEP_L_LIGHTCONST"));
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

            // Copy DMTS variables to new placeable
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
        }   // switch object

        // set new light state
        SetLocalInt(oNew, "CEP_L_AMION", isNight);
        SetLocalInt(oNew, "CEP_L_LIGHTCYCLE", TRUE);

        // apply dynamic or static light as needed
        SetLightEffect_(oNew, isNight);
        // return;
    } else {
        // no light cycle: on first call, place required light effect
        SetLightEffect_(OBJECT_SELF, nAmIOn);
    }
}


