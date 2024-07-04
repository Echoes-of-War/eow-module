//::///////////////////////////////////////////////
//:: Name: PLC sound effect
//:: FileName: q_userplaysound
//:://////////////////////////////////////////////
/*
    causes placeable to play a sound when used. to
    use, place a string variable on the PLC named
    "sSound" and set the vaule to the name of the
    desired sound. this script should be placed in
    the "OnUsed" event of the placeable object.
*/
//:://////////////////////////////////////////////
//:: Created By: John Hawkins
//:: Created On: Feb 01, 2010
//:://////////////////////////////////////////////
void main()
{
  PlaySound(GetLocalString(OBJECT_SELF,"sSound"));
}
