#CommentFlag // ; Change to C++ comment style.

// ----------------------------------------------------------------------------
// AUTO EXECUTE SECUTION
#NoEnv                 // avoid checking empty vars (default behavior in 2.0.0)
#Warn All              // turn on all warning messages
#SingleInstance Force  // replaces the old instance automatically
#WinActivateForce      // grab windows, might prevent taskbar from flashing
#Persistent            // run until killed in taskbar


// ----------------------------------------------------------------------------
// DOCUMENTATION
// https://autohotkey.com/docs/AutoHotkey.htm
//
// CHANGELOG
// v1.1.0 - Added function ToggleListenToDevice
// v1.0.0 - INITIAL RELEASE
//
//
// Script details
//
__version__  := "1.1.0"
__modified__ := "2019/02/26"
__author__   := "SupahNoob"
__ahk_vers__ := "1.1.29.01"  // written on version

// Details Notification
MsgBox, 49, Script Info (%A_ScriptName%),
( 
The following script is about to be activated.
It was written on AHK version %__ahk_vers__%.

path: %A_ScriptFullPath%

version: %__version__%
AHK version: %A_AhkVersion%
last modified: %__modified__%
author: %__author__%
)

ifmsgbox, OK 
{
    // do nothing
}
else
{
    MsgBox, , Script Info,
    (
    Cancelling startup, "%A_ScriptName%" will close.
    )
    ExitApp
}

// ----------------------------------------------------------------------------
// VARIABLES
//
SPOTIFY_EXE := "ahk_exe spotify.exe"
SPOTIFY_FP  := Format("C:\Users\{1}\AppData\Roaming\Spotify\Spotify.exe", A_UserName)
DOTA_EXE    := "ahk_exe dota2.exe"


// ----------------------------------------------------------------------------
// FUNCTIONS
//
OpenActivate(window, window_fp:=0) {
    /*
    Bring the <window> to the front, or open it at <window_fp>.

    Usage
    -----
    #s:: OpenActive("ahk_exe spotify.exe", "/my/path/to/spotify.exe")
    #s:: OpenActive("ahk_exe spotify.exe")

    Parameters
    ----------
    window - the full name/title/hwnd to open, include the directive
    window_fp - the location of the program to open

    Returns
    -------
    None
    */
    if WinExist(window) {
        WinActivate, %window%
    } else {
        if window_fp != 0
            Run, %window_fp%
    }
}


ToggleWindowAlwaysOnTop() {
    /*
    Toggles the current window to be always on top.

    Parameters
    ----------
    None

    Returns
    -------
    None
    */

    // Get the current window's HWND (A is an alias for "Active")
    WinGetPos, x, y, w, h, A
    WinGet, this_window_HWND, ID, A
    WinGet, this_window_ExStyle, ExStyle, ahk_id %this_window_HWND%

    centered := (x + (w / 2) - 150)
    adjusted := (y + 15)
    red := "FF0000"
    green := "008000"
    WS_EX_TOPMOST := 0x8

    // dynamic notification to toggle the active window
    // SplashImage docs: https://autohotkey.com/docs/commands/progress.htm
    if (this_window_ExStyle & WS_EX_TOPMOST) {
        SplashImage, , X%centered% Y%adjusted% B1 CW%red%, ALWAYS ON TOP: OFF
        Sleep, 750
        SplashImage, Off
    }
    else {
        SplashImage, , x%centered% y%adjusted% b1 CW%green%, ALWAYS ON TOP: ON
        Sleep, 750
        SplashImage, Off
    }

    // do the toggling
    WinSet, AlwaysOnTop, Toggle, ahk_id %this_window_HWND%
}


ToggleListenToDevice(device_name) {
    /*
    Toggles recording <device_name> ON|OFF.

    Usage
    -----
    #r:: ToggleListenToDevice("Stereo Mix")

    Parameters
    ----------
    device_name : str
        device to listen to

    Returns
    -------
    None

    */
    // subroutine to open up the "Sound: Recording" panel
    SUBR := "rundll32.exe shell32.dll, Control_RunDLL mmsys.cpl,,recording"
    REC_CLASS := "ahk_class #32770"
    PROPERTIES := device_name . " Properties"

    // run the subroutine and assign it's PID to <recording_panel_PID>
    Run, %SUBR%
    WinWait, %REC_CLASS%

    // assign a list of elements to <items>
    ControlGet, items, List, , SysListView321, %REC_CLASS%

    // Loop through Recording devices, until finding the target device name
    //     and once found, move into the Properties menu, select
    //    "Listen to this Device" as denoted by Button1, select Apply, and
    //    finally exiting all menus.
    Loop, Parse, items, `n
    {
        ControlSend, SysListView321, {Down}
        if InStr(A_LoopField, device_name) {
            ControlClick, &Properties
            WinWait, %PROPERTIES%
            ControlSend, , {CTRL DOWN}{Tab}{CTRL UP}, %PROPERTIES%
            ControlSend, Button1, {Space}
            ControlSend, , {Enter}
            ControlSend, , {Escape}, %REC_CLASS%
        }
    }
}

// ----------------------------------------------------------------------------
// REBINDS
//
// -- syntax notes --
//   <, > are LEFT and RIGHT directives
//
//   ^ is Control        + is Shift
//   # is Win            < use the left key of the pair    
//   ! is Alt            > use the right key of the pair
//
//   & can be used to combine 2 keys
//
//   Window-specific hotkeys are possible, but must use the IfWinActive <name>
//   directive in order to work properly.
//  
Capslock::              Numpad9
PrintScreen::           Media_Play_Pause
PrintScreen & LButton:: Media_Prev
PrintScreen & RButton:: Media_Next

<^WheelUp::   SendInput, {LControl DOWN}{PgUp}{LControl UP}
<^WheelDown:: SendInput, {LControl DOWN}{PgDn}{LControl UP}

#If WinActive("ahk_exe dota2.exe")
    <!Tab::
        SendInput, {Tab}
    return
#If

#s::  OpenActivate(SPOTIFY_EXE, SPOTIFY_FP)
#^a:: ToggleWindowAlwaysOnTop()
#p::  ToggleListenToDevice("Stereo Mix")
