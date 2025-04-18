void main()
{
    object oItem = GetItemActivated();

    string sUsedEvent = GetLocalString(oItem, "EVENT_USED");

    //Checks to see if a onUsed Script is specificed on the activated item and runs that script if so.
    if(sUsedEvent != "") ExecuteScript(sUsedEvent, OBJECT_SELF);
}
