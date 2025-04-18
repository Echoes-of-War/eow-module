void main()
{
    object oArea = GetArea(OBJECT_SELF);
    object oExit = GetExitingObject();
    if (GetIsPC(oExit) == TRUE)
        DestroyArea(oArea);
}
