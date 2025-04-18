//::////////////////////////////////////////////////////////////////////////////
//:: _m_load
//::////////////////////////////////////////////////////////////////////////////
/*

    Module load  event script.

*/
//::////////////////////////////////////////////////////////////////////////////
//:: Created:   Galefer (03/12/24)
//::////////////////////////////////////////////////////////////////////////////

// EXECUTION  ------------------------------------------------------------------

void main()
{
    object oArea = GetFirstArea();
    while (oArea != OBJECT_INVALID)
    {
        SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_ENTER, "_a_enter");
        SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_EXIT, "_a_exit");
        SetTag(oArea, GetResRef(oArea));
        oArea = GetNextArea();
    }
}
