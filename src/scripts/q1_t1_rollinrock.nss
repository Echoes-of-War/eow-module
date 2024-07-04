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
        oTrap = CreateObject(OBJECT_TYPE_PLACEABLE,"rollingrockpcbl",lPlcbl);
        SetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ",oTrap);
    }
    else
        oTrap = GetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ");

    AssignCommand(oTrap,PlaySound("as_na_rockcavlg1"));
    AssignCommand(oTrap,DelayCommand(1.0,TrapPlayAnim(oTrap)));

    int nDC=25;
    int nDamage = d6(2);
    location lEnd;
    vector vVector,vOrigin, vAngle;
    float fFacing;
    object oArea;

    lEnd = GetLocation(oTrap);
    fFacing = GetFacingFromLocation(lEnd);
    vVector = GetPositionFromLocation(lEnd);
    vAngle = AngleToVector(fFacing);
    oArea = GetAreaFromLocation(lEnd);
    lEnd = Location(oArea,Vector(vVector.x+(-20.0*vAngle.x),vVector.y+(-20.0*vAngle.y),vVector.z),-fFacing);

    vOrigin = Vector(vVector.x+(-24.0*vAngle.x),vVector.y+(-24.0*vAngle.y),vVector.z);

    object oPC = GetFirstObjectInShape(SHAPE_SPELLCYLINDER,24.5,lEnd,FALSE,OBJECT_TYPE_CREATURE,vOrigin);
    while(GetIsObjectValid(oPC))
    {
        nDamage = TrapSave(oPC, nDC, nDamage);

        if(nDamage>0)
        {
            DelayCommand(1.5,RollingRockHitPC(oPC,nDamage));
        }
        oPC = GetNextObjectInShape(SHAPE_SPELLCYLINDER,24.5,lEnd,FALSE,OBJECT_TYPE_CREATURE,vOrigin);
    }
}


