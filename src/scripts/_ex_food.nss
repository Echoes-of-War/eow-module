void main()
{
    object oItem = GetItemActivated();
    object oPC = GetItemActivator();
    // Mark the player with the food item
    SetLocalObject(oPC, "FOOD", oItem);
}
