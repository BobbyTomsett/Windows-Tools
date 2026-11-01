#Requires AutoHotkey v2.0
#NoTrayIcon

; PrintScreen -> Screenshot snip mode
PrintScreen::
{
    Send "#+S"
}

; Left Shift + PrintScreen -> Screen recording mode
<+PrintScreen::
{
    Send "#+R"
}

; Left Control + PrintScreen -> Open Captures folder
^PrintScreen::
{
    Run("dopus.exe D:\Captures")
}
