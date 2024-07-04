#include "q_inc_traps"

void main()
{
    if(GetLocalInt(OBJECT_SELF,"TRP_TRIGGERED"))
        return;

    SetLocalInt(OBJECT_SELF,"TRP_TRIGGERED",1);


    object oTrap;

    if(GetLocalInt(OBJECT_SELF,"TRP_PLCBL_SHOW")==0)
    {
        location lPlcbl = GetLocalLocation(OBJECT_SELF,"TRP_PLCBL_LOC");
        SetLocalInt(OBJECT_SELF,"TRP_PLCBL_SHOW",1);
        oTrap = CreateObject(OBJECT_TYPE_PLACEABLE,"floodpcbl",lPlcbl);
        SetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ",oTrap);
    }
    else
        oTrap = GetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ");

    AssignCommand(oTrap, PlaySound("al_na_fountainlg"));
    AssignCommand(oTrap,DelayCommand(1.0,TrapPlayAnim(oTrap)));

    location lWater;

    vector v = GetPosition(oTrap);
    vector w = AngleToVector(GetFacing(oTrap));

    lWater = Location(GetArea(oTrap),Vector(v.x+(8.0*w.x),v.y+(8.0*w.y),v.z),GetFacing(oTrap));
    object oDoor = GetNearestObject(OBJECT_TYPE_DOOR);
    AssignCommand(oDoor,ActionCloseDoor(oDoor));
    AssignCommand(oDoor,SetLocked(oDoor,TRUE));

    object oPC = GetFirstObjectInShape(SHAPE_CUBE,8.0,lWater,TRUE);
    while(GetIsObjectValid(oPC))
    {
        if(GetLocalInt(oPC,"DROWNING"))
            DeleteLocalInt(oPC,"DROWNING");
        else
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectSlow(),oPC);
            DelayCommand(6.0,Drown(oPC));
        }
        oPC = GetNextObjectInShape(SHAPE_CUBE,8.0,lWater,TRUE);
    }
}


