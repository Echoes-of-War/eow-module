#include "x0_i0_position"
#include "_i_time"
#include "_i_rest"

float GetRestDuration(int iHD)
{
    float fDuration = StringToFloat(Get2DAString("restduration", "DURATION", iHD));
    fDuration /= 1000;
    return fDuration;
}

void main()
{
    object oPC = GetLastPCRested();
    object oArea = GetArea(oPC);
    object oRestLoc;
    object oFood = GetLocalObject(oPC, "FOOD");

    int iEventType = GetLastRestEventType();
    int iIsInterior = GetIsAreaInterior(oArea);
    int iHP = GetCurrentHitPoints(oPC);
    int iHitDice = GetHitDice(oPC);
    int iFatigueDamage;
    int iItemStackSize;
    int i;

    string sRestCoolDown = GetLocalString(oPC, "REST_COOLDOWN");
    string sApprovedFoodList = GetLocalString(OBJECT_SELF, "FOOD_TAG_LIST");

    float fRestLocFacing;
    float fDistance;

    vector vPC;

    location lRest;

    effect eFatigue;

    switch(iEventType)
    {
        //Runs at the beginning of a rest
        case REST_EVENTTYPE_REST_STARTED:
            //Saves the Current hitpoints for use after the rest is complete.
            SetLocalInt(oPC, "REST_CURRENT_HP", iHP);

            // Player must have marked food to eat, and it must still be in their inventory
            if (oFood == OBJECT_INVALID || GetItemPossessedBy(oPC, GetTag(oFood)) == OBJECT_INVALID)
            {
                AssignCommand(oPC, ClearAllActions());
                SendMessageToPC(oPC, "No food selected or detected. Food must be marked to rest. Activate the food you want to consume.");
                return;
            }

            switch(iIsInterior)
            {
                //resting in an exterior area.
                case FALSE:
                    oRestLoc = GetCurrentTent(oPC);

                    //Ensures the tent is in range to rest.
                    if(GetDistanceBetween(oPC, oRestLoc) <= 3.0 && GetIsObjectValid(oRestLoc))
                    {
                        //Only allow resting if the cooldown is up.
                        if(!GetIsTimeUp(sRestCoolDown))
                        {
                            AssignCommand(oPC, ClearAllActions());
                            SendMessageToPC(oPC, "Resting outdoors will not provide adquate rest currently. To rest, find a suitable resting location or wait " + GetRemainingTime(sRestCoolDown) + " to be able to rest outdoors.");
                            return;
                        }
                    }

                    //Get the position to move the PC to for resting.
                    vPC = GetPosition(oRestLoc);
                    fRestLocFacing = GetFacing(oRestLoc)+180;

                    break;
                //resting in an interior area.
                case TRUE:
                    oRestLoc = GetNearestObjectByTag("plc_restloc", oPC);

                    //Get the position to move the PC to for resting.
                    fRestLocFacing = GetFacing(oRestLoc)+180;
                    vPC = GetChangedPosition(GetPosition(oRestLoc), 2.0, fRestLocFacing);
                    break;
            }


            //Look to see if the rest location is within range in order to rest.
            if(GetDistanceBetween(oPC, oRestLoc) > 3.0 || !GetIsObjectValid(oRestLoc))
            {
                AssignCommand(oPC, ClearAllActions());
                SendMessageToPC(oPC, "Their is no suitable resting location nearby, please find a bed or other available accomodation.");
            }
            else
            {
                //Move the PC to the location and set them to do the resting animation.
                lRest = Location(oArea, vPC, fRestLocFacing);
                AssignCommand(oPC, JumpToLocation(lRest));
            }
            break;
        //Runs if the rest is cancelled
        case REST_EVENTTYPE_REST_CANCELLED:
            //Sets the resting cooldown for exterior areas only.
            if(!iIsInterior)
            {
                iFatigueDamage = iHP - GetLocalInt(oPC, "REST_CURRENT_HP");
                eFatigue = EffectDamage(iFatigueDamage);
                DeleteLocalInt(oPC, "REST_CURRENT_HP");

                if(iFatigueDamage > 0) ApplyEffectToObject(DURATION_TYPE_INSTANT, eFatigue, oPC);
            }
            break;
        //Runs at the end of a rest.
        case REST_EVENTTYPE_REST_FINISHED:
            //Sets the resting cooldown for exterior areas only.
            if(!iIsInterior)
            {
                iFatigueDamage = GetMaxHitPoints(oPC) - GetLocalInt(oPC, "REST_CURRENT_HP") - 5*iHitDice - GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
                eFatigue = EffectDamage(iFatigueDamage);
                DeleteLocalInt(oPC, "REST_CURRENT_HP");

                if(iFatigueDamage > 0) ApplyEffectToObject(DURATION_TYPE_INSTANT, eFatigue, oPC);
                SetLocalString(oPC, "REST_COOLDOWN", GetTimeString(0, 0, 8));
            }

            //consume food.
            oFood = GetLocalObject(oPC, "FOOD");
            ApplyFoodBuffs(oPC, oFood);
            iItemStackSize = GetItemStackSize(oFood);
            if(iItemStackSize > 1)
            {
                iItemStackSize--;
                SetItemStackSize(oFood, iItemStackSize);
            }
            else
            {
                DestroyObject(oFood);
                DeleteLocalObject(oPC, "FOOD");
            }
            break;
    }
}
