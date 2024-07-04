//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////
//:://////////////////////////////////////////////////
//:: Modified By: Tom_Banjo & sixesthrice
//:: Created On: 10/17/2009
//:://////////////////////////////////////////////////
void main()
{
    // projectQ start
    int iApp = GetAppearanceType(OBJECT_SELF);

    // Take human form for now...
    if((GetIsDawn()|| GetIsDay() || GetIsAreaInterior(GetArea(OBJECT_SELF))) && iApp == 934)
    {
        ApplyEffectToObject(0,EffectVisualEffect(33),OBJECT_SELF);
        SetCreatureAppearanceType(OBJECT_SELF,933);
    }

    // ...before transforming in the moonlight!
    else if((GetIsDusk() || GetIsNight()) && iApp == 933 && !GetIsAreaInterior(GetArea(OBJECT_SELF)))
    {
        ApplyEffectToObject(0,EffectVisualEffect(33),OBJECT_SELF);
        SetCreatureAppearanceType(OBJECT_SELF,934);
    }
    // projectQ end

   ExecuteScript("nw_c2_default1", OBJECT_SELF);
}

