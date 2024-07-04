//::///////////////////////////////////////////////
//:: lcs_shld_inc_c
//:: FileName
//:: Copyright (c) 2008 RedOne
//:://////////////////////////////////////////////
const int SHLD_MIN_APP = 1;
const int SHLD_MIN_COL = 0;
const int SHLD_MAX_COL = 4;

// Returns true if oShield is a valid shield object
//
int shldCheckForShield(object oShield){
    if(!GetIsObjectValid(oShield)){
        return FALSE;
    }
    int tShield = GetBaseItemType(oShield);
    if(tShield != BASE_ITEM_SMALLSHIELD && tShield != BASE_ITEM_LARGESHIELD && tShield != BASE_ITEM_TOWERSHIELD){
        return FALSE;
    }
    return TRUE;
}

int getColorFromAppearance(int appearance){
    return appearance%10;
}

int getModelFromAppearance(int appearance){
    return appearance/10;
}

int getAppearanceFromModelColor(int model, int color){
    if(model == 0 && color == 0){
        return 10;
    }
    return model * 10 + color;
}

void r1_ModifyShieldColor(object oPC, int forward=TRUE){
    object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    if(!shldCheckForShield(oShield)){
        SendMessageToPC(oPC, "No valid shield equipped!");
        return;
    }
    int app = GetItemAppearance(oShield, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
    int col = getColorFromAppearance(app);
    int mod = getModelFromAppearance(app);
    int sCol = col;
    object newShield;
    while(!GetIsObjectValid(newShield)){
        if(forward){
            col = col+1;
            if(col > SHLD_MAX_COL){
                col = SHLD_MIN_COL;
                }
        }else{
            col = col-1;
            if(col < SHLD_MIN_COL){
                col = SHLD_MAX_COL;
                }
            }
        if(col == sCol){
            return;
            }
        //SendMessageToPC(oPC, "Color: " + IntToString(col) + " old: " + IntToString(sCol));
        newShield = CopyItemAndModify(oShield, ITEM_APPR_TYPE_SIMPLE_MODEL, 0,
                        getAppearanceFromModelColor(mod, col), TRUE);
        }
    SendMessageToPC(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC), "Color: " + IntToString(col));
    DestroyObject(oShield);
    SetCommandable(TRUE, oPC);
    AssignCommand(oPC, ActionEquipItem(newShield, INVENTORY_SLOT_LEFTHAND));
}

void r1_ModifyShieldColorNext(object oPC){
    r1_ModifyShieldColor(oPC);
}

void r1_ModifyShieldColorPrevious(object oPC){
    r1_ModifyShieldColor(oPC, FALSE);
}
