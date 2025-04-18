void main()
{
    ExecuteScript("x2_mod_def_act", OBJECT_SELF);
    ExecuteScript("cnr_module_onact", OBJECT_SELF);
    ExecuteScript("mod_itm_activate", OBJECT_SELF);

    object oItem = GetItemActivated();
    string sResRef = GetResRef(oItem);

    // Food
    if (GetStringLeft(sResRef, 4) == "food")
    {
        ExecuteScript("_ex_food", OBJECT_SELF);
    }
}
