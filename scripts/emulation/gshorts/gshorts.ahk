; AutoHotkey v2 script to launch an app and minimize it to tray
#NoTrayIcon
Run "C:\apps\gshorts\gshorts.exe"
WinWait "ahk_exe gshorts.exe"
WinHide "ahk_exe gshorts.exe"