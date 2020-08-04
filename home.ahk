#CommentFlag // ; Change to C++ comment style.

// ----------------------------------------------------------------------------
// AUTO EXECUTE SECUTION
#NoEnv                 // avoid checking empty vars (default behavior in 2.0.0)
#Warn All              // turn on all warning messages
#SingleInstance Force  // replaces the old instance automatically
#WinActivateForce      // grab windows, might prevent taskbar from flashing
#Persistent            // run until killed in taskbar

// listen for changes to Zoom.exe
Run, webcam_monitor.ahk, C:\Users\%A_UserName%\Desktop\

// ----------------------------------------------------------------------------
// DOCUMENTATION
// https://autohotkey.com/docs/AutoHotkey.htm
//
// CHANGELOG
// v1.2.2 - Adding a call to webcam_monitor.ahk
// v1.2.1 - Updating keybinds for a new mouse
// v1.2.0 - Added SysVol changer
// v1.1.0 - Added function ToggleListenToDevice
// v1.0.0 - INITIAL RELEASE
//
//
// Script details
//
__version__  := "1.2.1"
__modified__ := "2020/07/28"
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
} else {
    MsgBox, , Script Info, Cancelling startup, "%A_ScriptName%" will close.
    ExitApp
}

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
    } else {
        SplashImage, , x%centered% y%adjusted% b1 CW%green%, ALWAYS ON TOP: ON
        Sleep, 750
        SplashImage, Off
    }

    // do the toggling
    WinSet, AlwaysOnTop, Toggle, ahk_id %this_window_HWND%
}


TogglePlaybackDevice(device_names*) {
    /*
    Toggle default Playback device to one of devices.

    This function requires that Python 3.7+ by installed with the library
    called "sounddevice" in the global installed packages.

    Usage
    -----
    #r:: SetDefaultPlaybackDevice("Stereo Mix")

    Parameters
    ----------
    device_names* : str
        given arguments of the device names to toggle between

    Returns
    -------
    None

    */
    shell := ComObjCreate("wscript.shell")

    // Path to the nircmd utility
    nircmd := Format("C:\Users\{1}\AppData\Local\nircmd\nircmd.exe", A_UserName)

    // Get the current device name
    device_table := shell.Exec("python -m sounddevice").StdOut.ReadAll()
    device_arr := StrSplit(device_table, "`n")

    // loop through our toggleable devices, finding the current Playback device
    // (this is denoted in sounddevice as "<" or "output")
    for idx, device in device_arr
        if InStr(device, "<") {
            RegExMatch(device, "<\s*\d+\s(?<name>.*?)\s\(.*", sub_pattern)
            current_device_name := sub_patternName
        }

    // loop through our device list and set the new device
    for idx, device in device_names
        if ("" . device = current_device_name) {
            if (idx = device_names.MaxIndex()) {
                pos := 1
            }
            else {
                pos := idx + 1
            }
        }

    device_name := device_names[pos]

    // actually do the setting... :~)
    Run, %nircmd% setdefaultsounddevice `"%device_name%`" 0
    Run, %nircmd% setdefaultsounddevice `"%device_name%`" 2
}

// ----------------------------------------------------------------------------
// VARIABLES
//
SPOTIFY_EXE := "ahk_exe spotify.exe"
SPOTIFY_FP  := Format("C:\Users\{1}\AppData\Roaming\Spotify\Spotify.exe", A_UserName)
DOTA_EXE    := "ahk_exe dota2.exe"

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
Capslock::      Numpad9
F13::           Media_Play_Pause
F13 & LButton:: Media_Prev
F13 & RButton:: Media_Next
F15:: LAlt

// rebinding Razer mouse buttons
// F1:: F13  // use this to set the button in Synapse
// F13:: MsgBox, , F13, RazerSynapse labels this 6 [Sensitivity Up]
// F14:: MsgBox, , F14, RazerSynapse labels this 7 [Sensitivity Down]
// F15:: MsgBox, , F15, RazerSynapse labels this 4 [Mouse 4]
// F16:: MsgBox, , F16, RazerSynapse labels this 5 [Mouse 5]


<^WheelUp::   SendInput, {LControl DOWN}{PgUp}{LControl UP}
<^WheelDown:: SendInput, {LControl DOWN}{PgDn}{LControl UP}

#If WinActive("ahk_exe dota2.exe")
    <!Tab::
        SendInput, {Tab}
    return
#If

#s::  OpenActivate(SPOTIFY_EXE, SPOTIFY_FP)
#^a:: ToggleWindowAlwaysOnTop()
#p::  TogglePlaybackDevice("AKG Headphones", "USB Desk Speakers")
