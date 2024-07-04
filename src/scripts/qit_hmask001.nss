//:://////////////////////////////////////////////
//:: Created By: Pstemarie
//:: Created On: 5/9/2014
//:://////////////////////////////////////////////
void main()
{
    object oPC     = GetItemActivator();
    object oItem   = GetItemActivated();
    int    iSex    = GetGender(oPC);
    int    iRace   = GetAppearanceType(oPC);
    int    nEffect;
    string sItem;

    if(GetLocalInt(oPC,"USEDQITMASK") == 1)
    {
        SetLocalInt(oPC,"USEDQITMASK",0);
        sItem = GetLocalString(oPC, "QITMASK_ID");
        effect eEff = GetFirstEffect(oPC);
        while(GetIsEffectValid(eEff) == TRUE)
        {
            if(GetEffectType(eEff) == EFFECT_TYPE_VISUALEFFECT && GetTag(GetEffectCreator(eEff)) == sItem)
            {
                RemoveEffect(oPC,eEff);
            }
            eEff = GetNextEffect(oPC);
        }
        DeleteLocalString(oPC,"USEDQITMASK");
        return;
    }

    SetLocalInt(oPC,"USEDQITMASK",1);
    SetLocalString(oPC, "QITMASK_ID", GetTag(oItem));

    switch (iSex)
    {
        case GENDER_MALE:
        {
            switch (iRace)
            {
                case APPEARANCE_TYPE_HALFLING: nEffect = 738; break;
                case APPEARANCE_TYPE_DWARF: nEffect = 740; break;
                case APPEARANCE_TYPE_ELF: nEffect = 742; break;
                case APPEARANCE_TYPE_GNOME: nEffect = 744; break;
                case APPEARANCE_TYPE_HUMAN:
                case APPEARANCE_TYPE_HALF_ELF: nEffect = 746; break;
                case APPEARANCE_TYPE_HALF_ORC: nEffect = 748; break;
            }
        }
        break;

        case GENDER_FEMALE:
        {
            switch (iRace)
            {
                case APPEARANCE_TYPE_HALFLING: nEffect = 739; break;
                case APPEARANCE_TYPE_DWARF: nEffect = 741; break;
                case APPEARANCE_TYPE_ELF: nEffect = 743; break;
                case APPEARANCE_TYPE_GNOME: nEffect = 745; break;
                case APPEARANCE_TYPE_HUMAN:
                case APPEARANCE_TYPE_HALF_ELF: nEffect = 747; break;
                case APPEARANCE_TYPE_HALF_ORC: nEffect = 749; break;
            }
        }
        break;
    }
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectVisualEffect(nEffect),oPC);
    return;
}
