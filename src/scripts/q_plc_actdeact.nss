/*
    SAFE TO REMOVE

    Note as of v1.7 this script is no longer required. Any placeables using this
    script should use x2_plc_used_act.nss instead.
*/


//::///////////////////////////////////////////////
//:: Name: MTP Placeable Activate/Deactivate
//:: Filename: Q_plc_ActDeact.nss (mtp_actdeact.nss)
//:: Website: http://www.qnwn.net
//:: Contact: projectq@qnwn.net
//:://////////////////////////////////////////////
/*
    Project Q - Release 1.5

    Turns the placeable object's animation activate/deactivate
*/
//:://////////////////////////////////////////////
//:: Created By:  Tiberius Morghun
//:: Created On:  2011
//:://////////////////////////////////////////////

void main()
{
    object oSelf = OBJECT_SELF;
    if (GetLocalInt(OBJECT_SELF,"MTP_PLC_ACTIVATED") == 0)
    {
        object oSelf = OBJECT_SELF;
        PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
        SetLocalInt(OBJECT_SELF,"MTP_PLC_ACTIVATED",1);
    }
    else
    {
        object oSelf = OBJECT_SELF;
        PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
        SetLocalInt(OBJECT_SELF,"MTP_PLC_ACTIVATED",0);
    }
}
