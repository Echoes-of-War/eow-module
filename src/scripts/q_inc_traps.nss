//::///////////////////////////////////////////////
//:: Firehazurd's Trapporium (Project Q Edition)
//:: q_inc_traps
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    *General Notes*

    To use these scripts in your module you need to add this line to your
    OnModuleLoad Event under Module Properties.

    --
    LoadTrapporium();
    --


    To place a trap put down a copy of the placeable of the trap you want to
    use, the huge boulder for the rolling rock trap, the rug for the rugpit
    trap etc.

    Next, place a trapped object (door, placeable, trigger, etc) with the
    correct tag. Triggers for each trap type are already in the palette to
    make this easier.  But if you want a trap to be triggered by a door or
    chest you'll have to modify the tag yourself.  All you have to do is set
    the beginning of the trap's tag to the string given in each traps
    description. For example, if you want a rolling boulder attached to a
    chest the chest's tag must begin "RBFTrap". The chest will also need it's
    OnDisarm event script set to "q1_trap_disarm", and it's OnTriggered event
    script set to "q1_trap_fire".

    The traps set up in this mod should help you understand if you're having
    problems.  Be careful though, a placeable will always link itself to the
    closest trap with the correct tag.

    Reset switches need their tag set to the tag of the trap they reset, with
    a single digit on the end.  This digit tells the switch whether it should
    reset the closest trap with that tag, or the second closest, or third, etc.
    To reset the closest one the digit must be 1, so for a reset switch to
    reset the closest standard rolling boulder trap it's tag should be
    "RBFTrap1".

    Details on each trap follow.

    - Lacero


    *Razor Wire*

    Search DC: 22
    Disarm DC: 10
    Reflex DC: 25/10
    Damage:    2d6 slashing
    Tag:       RWFTrap

    This trap cannot be reset and will work until it is disarmed.
    When someone knows the trap is there the Reflex DC is reduced to 10.
    Also damage is halved for a failed disarm attempt.

    When someone takes >=6 damage from the trap they have their movement
    reduced by half for 20 seconds.


    *Rolling Boulder*

    Search DC: 20
    Disarm DC: 22
    Reflex DC: 25
    Damage:    2d6 bludgeoning
    Tag:       RBFTrap

    The trap hits everyone in a cylinder along the boulder's path.
    The trap stays around once fired, but will not trigger again until it is
    reset by pulling the reset switch.  Disarming the trap permanently stop
    it from working.

    When the trap deals any damage at all to someone they are knocked down
    for 30 seconds, exactly the same as the knockdown feat.


    *Rug Pit Trap*

    Search DC: 24
    Disarm DC: 20
    Reflex DC: 20/10
    Damage:    2d6 bludgeoning
    Tag:       RPFTrap

    The trap stays open once fired, and will trigger when anyone walks over the
    hole, if you make the reflex save you take no damage.  While open the trap
    has a Reflex save of 10, to make it look like a normal carpet again pull
    the reset switch.

    Disarming the trap will make it into a normal carpet.

    When hit by the trap people are made to dissappear for 60 seconds, while
    they climb out.  Unfortunately the animation for this makes them fly away,
    but as VFX_COM_UNLOAD_MODEL doesn't do anything it's the best way I know.


    *Metal Pit Trap*

    Search DC: 20
    Disarm DC: 23
    Reflex DC: 15/10
    Damage:    2d6 bludgeoning
    Tag:       MPFTrap

    The trap stays open once fired, and will trigger when anyone walks over the
    hole, if you make the reflex save you take no damage.  While open the trap
    has a Reflex save of 10, to close it and hide it again pull the lever.

    Disarming the trap will close the pit and leave it visible.

    When hit by the trap people are made to dissappear for 30 seconds, while
    they climb out.  Unfortunately the animation for this makes them fly away,
    but as VFX_COM_UNLOAD_MODEL doesn't do anything it's the best way I know.


    *Wall Blade Trap*

    Search DC: 22
    Disarm DC: 22
    Reflex DC: 15
    Damage:    4x4d2 piercing
    Tag:       WSFTrap         //Notice this is different to what you'd expect

    The trap can be reset, and so will work more than once.

    The trap hits the person who triggered it with 4 blades, each doing 4d2
    piercing damage and saved for separately.

    Disarming the trap will put the spikes away and leave the placeable visible.


    *Falling Bricks Trap*

    Search DC: 20
    Disarm DC: 20
    Reflex DC: 15
    Damage:    2d6 bludgeoning
    Tag:       FBFTrap

    The trap will only work once. Everyone within 2 metres of the trap is hit
    when it goes off.

    Disarming the trap will hide the placeable.


    *Swinging Rock Trap*

    Search DC: 20
    Disarm DC: 20
    Reflex DC: 15
    Damage:    4d6 bludgeoning
    Tag:       SRFTrap

    The trap can be reset and so will work more than once.  Everyone within 2
    metres of the trap is hit when it goes off.

    Disarming the trap will leave the placeable visible with the rock near the
    ceiling.


    *Swinging Blade Trap*

    Search DC: 22
    Disarm DC: 22
    Reflex DC: 15
    Damage:    1d13 slashing
    Tag:       SBFTrap

    The trap can be reset and so will work more than once. Everyone within 2
    metres of the trap is hit when it goes off.

    Disarming the trap will leave the placeable visible with the blade near the
    ceiling.


    *Whirling Blade Trap*

    Search DC: 20
    Disarm DC: 20
    Reflex DC: 20
    Damage:    2d4+2 slashing
    Tag:       WBFTrap

    The trap can be reset and so will work more than once. Everyone within 5
    metres of the trap is hit every round when it is active.

    Disarming the trap will stop it permanently.


    *Flood Trap*

    Search DC: 17
    Disarm DC: 23
    Reflex DC: -
    Damage:    Death in 5 rounds
    Tag:       FlFTrap

    The trap can be reset and so will work more than once.

    Everyone in the area of the water is killed 5 rounds after the trap is
    triggered, unless the reset switch is pulled before this happens. Also when
    triggered the trap will close and lock the nearest door. While in the water
    people have the slow effect.

    Disarming the trap will NOT get rid of water that is already there.

*/
//:://////////////////////////////////////////////
//:: Created By: Firehazurd and Lacero (Edited by Pstemarie)
//:: Created On: ????
//:://////////////////////////////////////////////

void AssociateTrap(string sTag, int nID)
{
    object oPlcbl = GetObjectByTag(sTag);
    object oTrap;
    int nN=1;
    int nT;
    while(GetIsObjectValid(oPlcbl))
    {
        nT = 1;
        oTrap = GetNearestObject(OBJECT_TYPE_TRIGGER|OBJECT_TYPE_DOOR|OBJECT_TYPE_PLACEABLE, oPlcbl,nT);
        while(GetIsObjectValid(oTrap))
        {
            PrintString("In "+sTag+" Checking for: "+IntToString(nID)+", found: "+GetTag(oTrap));
            if(GetIsTrapped(oTrap)&&(GetTrapBaseType(oTrap)==nID))
                break;

            PrintString("In "+sTag+" Checking for: "+IntToString(GetTrapBaseType(oTrap))+", found: "+GetTag(oTrap));


            nT++;
            oTrap = GetNearestObject(OBJECT_TYPE_ALL, oPlcbl,nT);
        }

        if(GetIsObjectValid(oTrap))
        {
            if(nID==45)
            {
                SetLocalObject(oTrap,"TRP_PLCBL_OBJ",oPlcbl);
            }
            else
            {
                SetLocalLocation(oTrap,"TRP_PLCBL_LOC",GetLocation(oPlcbl));
                DestroyObject(oPlcbl);
            }
        }
        oPlcbl = GetObjectByTag(sTag,nN);
        nN++;//meant to be this way round
    }
}

void LoadTrapporium()
{
    AssociateTrap("RazorWire",105);
    AssociateTrap("RollingRock",102);
    AssociateTrap("WallBlade",107);
    AssociateTrap("FallingBrick",101);
    AssociateTrap("SwingingRock",106);
    AssociateTrap("SwingingBlade",108);
    AssociateTrap("WhirlingBlade",110);
    AssociateTrap("Flood",109);
    AssociateTrap("RugPit",103);
    AssociateTrap("MetalPit",104);
    AssociateTrap("CrushingWall",111);
    AssociateTrap("TripWireRope",115);
    AssociateTrap("TripWireVine",116);
    AssociateTrap("TripWireGreen",117);
    AssociateTrap("SnareTrapRope",119);
    AssociateTrap("SnareTrapVine",120);
    AssociateTrap("SnareTrapGreen",121);
    AssociateTrap("SwingingSpike",118);
}

void TrapPlayAnim(object oTrap)
{
   AssignCommand(oTrap, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
}

int TrapSave(object oPC, int nDC, int nDamage)
{
    if(!ReflexSave(oPC, nDC, SAVING_THROW_TYPE_TRAP))
    {
        if (GetHasFeat(FEAT_IMPROVED_EVASION, oPC))
            nDamage /= 2;
    }
    else if (GetHasFeat(FEAT_EVASION, oPC) || GetHasFeat(FEAT_IMPROVED_EVASION, oPC))
    {
        nDamage = 0;
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_REFLEX_SAVE_THROW_USE), oPC);
    }
    else
        nDamage /= 2;

    return nDamage;
}

void ResetWhirlingBlades()
{
    object oTrap = GetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ");

    DeleteLocalInt(OBJECT_SELF,"TRP_TRIGGERED");

    if(GetIsObjectValid(oTrap))
    {
        AssignCommand(oTrap, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
        DestroyObject(oTrap,1.0);
        DeleteLocalInt(OBJECT_SELF,"TRP_PLCBL_SHOW");
    }
}

void RollingRockHitPC(object oPC, int nDamage)
{
    object oTrap = GetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ");
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_COM_BLOOD_CRT_RED), oPC);
    AssignCommand(oTrap,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL), oPC));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, 30.0f);
}

void FallingBrickHitPC(object oPC, int nDamage)
{
    object oTrap = GetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ");
    PlayVoiceChat(VOICE_CHAT_PAIN2,oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_COM_BLOOD_CRT_RED), oPC);
    AssignCommand(oTrap,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL), oPC));
}

void Drown(object oPC)
{
    if(GetLocalInt(OBJECT_SELF,"TRP_TRIGGERED")==1)
    {
        int nD = GetLocalInt(oPC,"DROWNING");
        if(nD==4) //Beginning of the 5th round
        {
            DeleteLocalInt(oPC,"DROWNING");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
        }
        else
        {
            SetLocalInt(oPC,"DROWNING",nD+1);
            AssignCommand(oPC,SpeakString("Blub!  Glug!"));
            DelayCommand(6.0,Drown(oPC));
        }
    }
    else
    {
        effect eAOE = GetFirstEffect(oPC);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == OBJECT_SELF)
            {
                    RemoveEffect(oPC, eAOE);
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oPC);
        }
        DeleteLocalInt(oPC,"DROWNING");
    }
}

//Do not uncomment - for testing only
//void main(){}
