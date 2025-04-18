void main()
{
    object oPlaceable = OBJECT_SELF; // The placeable that is being closed

    // Check if the placeable has any items inside
    object oItem = GetFirstItemInInventory(oPlaceable);

    // If no items are found, destroy the placeable
    if (!GetIsObjectValid(oItem))
    {
        DestroyObject(oPlaceable);
    }
}
