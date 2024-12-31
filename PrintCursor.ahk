#Requires AutoHotkey v2.0
#SingleInstance Force

; Set up tray
TraySetIcon(A_WinDir "\System32\shell32.dll", 137)

PrintMode(*) {
    SystemCursor("CROSS")    
    KeyWait("LButton", "D")  
    clicked_window := WinExist("A")
    if clicked_window {
        Send("^p")
    }    
    SystemCursor()
}

SystemCursor(cursor := "") {
    static CROSS := 32515, NORMAL := 32512
    if (cursor = "CROSS")
        DllCall("SetSystemCursor", "Ptr", DllCall("LoadCursor", "Ptr", 0, "Ptr", NORMAL), "Ptr", CROSS)
    else
        DllCall("SystemParametersInfo", "UInt", 0x57, "UInt", 0, "Ptr", 0, "UInt", 0)
}

; Set up both left-click and menu handling
A_TrayMenu.Add("Print Mode", PrintMode)
A_TrayMenu.ClickCount := 1  ; Respond to single clicks
A_TrayMenu.Default := "Print Mode"

; Handle left click directly
OnMessage(0x404, WM_TRAY)
WM_TRAY(wParam, lParam, *) {
    if (lParam = 0x202)  ; WM_LBUTTONUP
        PrintMode()
}

Loop {
    Sleep(1000)
}