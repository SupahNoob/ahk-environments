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
//
// Script details
//
__version__  := "1.0.0"
__modified__ := "2018/08/08"
__author__   := "SupahNoob"

// Details Notification
MsgBox, 49, Script Info,
( 
The following script is about to be activated.

filename: %A_ScriptName%
version: %__version__%
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
SPOTIFY_FP := Format("C:\Users\{1}\AppData\Roaming\Spotify\Spotify.exe", A_UserName)


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
Capslock::            SendInput, {Numpad9}
<^WheelUp::           SendInput, {LControl DOWN}{PgUp}{LControl UP}
<^WheelDown::         SendInput, {LControl DOWN}{PgDn}{LControl UP}
XButton1::            SendInput, {Media_Play_Pause}
XButton1 & LButton::  SendInput, {Media_Prev}
XButton1 & RButton::  SendInput, {Media_Next}
^+1::                 SendInput, {U+00B0}  // ° - degree
^+2::                 SendInput, {U+00A9}  // © - copyright
^+3::                 SendInput, {U+00AE}  // ® - registered
^+4::                 SendInput, {U+2122}  // ™ - trademark


#s:: OpenActivate(SPOTIFY_EXE, SPOTIFY_FP)
#^a:: ToggleWindowAlwaysOnTop()

// ----------------------------------------------------------------------------
// HOTSTRINGS
//
// - ending characters: Space, Period, Enter
// - use * in the hotstring syntax to denote ending character is not required
//
:B0:`:shrug::
    if (A_EndChar == ":") {
        SendInput, {BS 7}¯\_(ツ)_/¯
    }
return

:B0:`:flip::
    if (A_EndChar == ":") {
        SendInput, {BS 6}(╯°□°）╯︵ ┻━┻
    }
return
