//::///////////////////////////////////////////////
//:: lcs_wpn_include
//:: FileName
//:: Copyright (c) 2008 RedOne
//:://////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//The Mad Poet - Modified for Avernostra and Project Q                        //
////////////////////////////////////////////////////////////////////////////////
// Original Work by Ahhz
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
const int WPN_MIN_APP = 1;
const int WPN_MAX_APP_DEF = 25;
const int WPN_MIN_COL = 1;
const int WPN_MAX_COL = 4;

int r1_CheckForWeapon(object oWeapon){
    if(!GetIsObjectValid(oWeapon)){
        return FALSE;
    }
    int tWeapon = GetBaseItemType(oWeapon);
    if(tWeapon != BASE_ITEM_SMALLSHIELD && tWeapon != BASE_ITEM_LARGESHIELD && tWeapon != BASE_ITEM_TOWERSHIELD){
        return TRUE;
    }
    return FALSE;
}

int r1_getWeaponHigherAppearanceLimit(object oWeapon, int weaponPart){
    int nWeaponType = GetBaseItemType(oWeapon);
    if(weaponPart == ITEM_APPR_WEAPON_MODEL_TOP)
    {
        switch(nWeaponType)
        {
            default: return WPN_MAX_APP_DEF;
        }
    }
    else if(weaponPart == ITEM_APPR_WEAPON_MODEL_MIDDLE)
    {
        switch(nWeaponType)
        {
            default: return WPN_MAX_APP_DEF;
        }
    }
    else if(weaponPart == ITEM_APPR_WEAPON_MODEL_BOTTOM)
    {
        switch(nWeaponType)
        {
            default: return WPN_MAX_APP_DEF;
        }
    }
    return 1;
}

void r1_ModifyWeaponAppearance(object oPC, int weaponPart, int forward, int rightHandWeapon=TRUE){
    object oWeapon;
    if(rightHandWeapon){
        oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    }else{
        oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    }
    if(!r1_CheckForWeapon(oWeapon)){
        return;
    }
    if(weaponPart != ITEM_APPR_WEAPON_MODEL_TOP
            && weaponPart != ITEM_APPR_WEAPON_MODEL_MIDDLE
            && weaponPart != ITEM_APPR_WEAPON_MODEL_BOTTOM){
        return;
    }
    int app = GetItemAppearance(oWeapon, ITEM_APPR_TYPE_WEAPON_MODEL, weaponPart);
    int sApp = app;
    object newWeapon;
    int weapMaxApp = r1_getWeaponHigherAppearanceLimit(oWeapon, weaponPart);
    while(!GetIsObjectValid(newWeapon)){
        if(forward){
            app = app+1;
            if(app > weapMaxApp){
                app = WPN_MIN_APP;
                }
        }else{
            app = app-1;
            if(app < WPN_MIN_APP){
                app = weapMaxApp;
                }
            }
        if(app == sApp || WPN_MIN_APP == weapMaxApp){
            return;
            }
        newWeapon = CopyItemAndModify(oWeapon, ITEM_APPR_TYPE_WEAPON_MODEL, weaponPart, app, TRUE);
        }
    SendMessageToPC(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC), "Appearance: " + IntToString(app));
    DestroyObject(oWeapon);
    SetCommandable(TRUE, oPC);
    if(rightHandWeapon){
        AssignCommand(oPC, ActionEquipItem(newWeapon, INVENTORY_SLOT_RIGHTHAND));
    }else{
        AssignCommand(oPC, ActionEquipItem(newWeapon, INVENTORY_SLOT_LEFTHAND));
    }
}

void r1_ModifyWeaponAppearanceNext(object oPC, int weaponPart){
    r1_ModifyWeaponAppearance(oPC, weaponPart, TRUE);
}

void r1_ModifyWeaponAppearancePrevious(object oPC, int weaponPart){
    r1_ModifyWeaponAppearance(oPC, weaponPart, FALSE);
}


void r1_ModifyWeaponColor(object oPC, int weaponPart, int forward, int rightHandWeapon=TRUE){
    object oWeapon;
    if(rightHandWeapon){
        oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    }else{
        oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    }
    if(!r1_CheckForWeapon(oWeapon)){
        return;
    }
    if(weaponPart != ITEM_APPR_WEAPON_COLOR_TOP
            && weaponPart != ITEM_APPR_WEAPON_COLOR_MIDDLE
            && weaponPart != ITEM_APPR_WEAPON_COLOR_BOTTOM){
        return;
    }
    int col = GetItemAppearance(oWeapon, ITEM_APPR_TYPE_WEAPON_COLOR, weaponPart);
    int sCol = col;
    object newWeapon;
    while(!GetIsObjectValid(newWeapon)){
        if(forward){
            col = col+1;
            if(col > WPN_MAX_COL){
                col = WPN_MIN_COL;
                }
        }else{
            col = col-1;
            if(col < WPN_MIN_COL){
                col = WPN_MAX_COL;
                }
            }
        if(col == sCol){
            return;
            }
        newWeapon = CopyItemAndModify(oWeapon, ITEM_APPR_TYPE_WEAPON_COLOR, weaponPart, col, TRUE);
        }
    SendMessageToPC(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC), "Color: " + IntToString(col));
    DestroyObject(oWeapon);
    SetCommandable(TRUE, oPC);
    if(rightHandWeapon){
        AssignCommand(oPC, ActionEquipItem(newWeapon, INVENTORY_SLOT_RIGHTHAND));
    }else{
        AssignCommand(oPC, ActionEquipItem(newWeapon, INVENTORY_SLOT_LEFTHAND));
    }
}

void r1_ModifyWeaponColorNext(object oPC, int weaponPart){
    r1_ModifyWeaponColor(oPC, weaponPart, TRUE);
}

void r1_ModifyWeaponColorPrevious(object oPC, int weaponPart){
    r1_ModifyWeaponColor(oPC, weaponPart, FALSE);
}

