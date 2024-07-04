//::///////////////////////////////////////////////
//:: Tailoring - Copy the PCs Helmet
//:: tlr_copypchelm.nss
//:://////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//The Mad Poet - Modified for Avernostra and Project Q                        //
////////////////////////////////////////////////////////////////////////////////

//Build String Function
////////////////////////////////////////////////////////////////////////////////
string BuildString(string sPart,string sAppearance)
{
 string sNull;
 string sBuild;
  if (GetStringLength(sPart)==1) sNull="00";
  if (GetStringLength(sPart)==2) sNull="0";
  if (GetStringLength(sPart)==3) sNull="";
 sBuild=sAppearance+sNull+sPart;
 return (sBuild);
}

// Start Main
////////////////////////////////////////////////////////////////////////////////
void main()
{
 object oPC = GetPCSpeaker();
 if (!GetIsPC(oPC)) return;
 object oArmor  = GetItemInSlot (INVENTORY_SLOT_HEAD, oPC);
 object oHelm = GetItemInSlot (INVENTORY_SLOT_HEAD, OBJECT_SELF);
 string sPart;
 string sAppearance;
 int iApply;
 int iPart;
 object oChest  = GetObjectByTag ("Chest_Of_The_Poet");
 object oModify;

//Get Helm Model
////////////////////////////////////////////////////////////////////////////////

 sPart = IntToString(GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, 0));
 sAppearance=BuildString(sPart,sAppearance);

//Get Helm Colors
////////////////////////////////////////////////////////////////////////////////

 sPart = IntToString(GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1));
 sAppearance=BuildString(sPart,sAppearance);

 sPart = IntToString(GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2));
 sAppearance=BuildString(sPart,sAppearance);

 sPart = IntToString(GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1));
 sAppearance=BuildString(sPart,sAppearance);

 sPart = IntToString(GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2));
 sAppearance=BuildString(sPart,sAppearance);

 sPart = IntToString(GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1));
 sAppearance=BuildString(sPart,sAppearance);

 sPart = IntToString(GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2));
 sAppearance=BuildString(sPart,sAppearance);

//Temp store the appearance so it can be applied to the Model
////////////////////////////////////////////////////////////////////////////////
 SetLocalString(OBJECT_SELF, "StoredHelmAppearance",sAppearance);

//Copy Helm to the Model
////////////////////////////////////////////////////////////////////////////////

 string sNewAppearance = GetLocalString(OBJECT_SELF, "StoredHelmAppearance");
 oModify = CopyItem (oHelm, oChest, 1);
 DestroyObject (oModify, 0.01);

//Set Model
 iPart= StringToInt(GetSubString(sNewAppearance,0,3));
 oModify = CopyItemAndModify (oModify, ITEM_APPR_TYPE_ARMOR_MODEL,0, iPart, 1);
 DestroyObject (oModify, 0.01);

 // Set Colours
iPart= StringToInt(GetSubString(sNewAppearance,3,3));
 oModify = CopyItemAndModify (oModify, ITEM_APPR_TYPE_ARMOR_COLOR,ITEM_APPR_ARMOR_COLOR_CLOTH1, iPart, 1);
 DestroyObject (oModify, 0.01);

iPart= StringToInt(GetSubString(sNewAppearance,6,3));
 oModify = CopyItemAndModify (oModify, ITEM_APPR_TYPE_ARMOR_COLOR,ITEM_APPR_ARMOR_COLOR_CLOTH2, iPart, 1);
 DestroyObject (oModify, 0.01);

iPart= StringToInt(GetSubString(sNewAppearance,9,3));
 oModify = CopyItemAndModify (oModify, ITEM_APPR_TYPE_ARMOR_COLOR,ITEM_APPR_ARMOR_COLOR_LEATHER1, iPart, 1);
 DestroyObject (oModify, 0.01);

iPart= StringToInt(GetSubString(sNewAppearance,12,3));
 oModify = CopyItemAndModify (oModify, ITEM_APPR_TYPE_ARMOR_COLOR,ITEM_APPR_ARMOR_COLOR_LEATHER2, iPart, 1);
 DestroyObject (oModify, 0.01);

iPart= StringToInt(GetSubString(sNewAppearance,15,3));
 oModify = CopyItemAndModify (oModify, ITEM_APPR_TYPE_ARMOR_COLOR,ITEM_APPR_ARMOR_COLOR_METAL1, iPart, 1);
 DestroyObject (oModify, 0.01);

iPart= StringToInt(GetSubString(sNewAppearance,18,3));
 oModify = CopyItemAndModify (oModify, ITEM_APPR_TYPE_ARMOR_COLOR,ITEM_APPR_ARMOR_COLOR_METAL2, iPart, 1);
 DestroyObject (oModify, 0.01);

 oModify = CopyItem (oModify, OBJECT_SELF, 1);

 if (GetIsObjectValid (oModify))
    {
     AssignCommand (OBJECT_SELF, ActionEquipItem (oModify, INVENTORY_SLOT_HEAD));
     DestroyObject (oHelm);
    }
}
