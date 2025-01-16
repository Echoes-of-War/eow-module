void DelayCopyItem(object oItem, object oContainer)
{
    CopyItem(oItem, oContainer);
}

void main()
{
    object oSelf = OBJECT_SELF;
    object oItem = GetInventoryDisturbItem();
    object oPC = GetLastDisturbed();
    int iType = GetInventoryDisturbType();

    if (iType == INVENTORY_DISTURB_TYPE_REMOVED)
    {
        DelayCommand(0.1, DelayCopyItem(oItem, oSelf));
    }
}
