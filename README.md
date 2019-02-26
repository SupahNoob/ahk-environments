# AutoHotkey Environments
---

Over the years, I've toyed around using the AHK scripting language to accomplish certain tasks quickly and customize my digital workstation. As an office worker mostly in the Windows environment, AHK has been pretty great in helping me be more efficient with my time and energy.

A lot of my scripts are commented to explain their logic and what they do, but I've highlighted a few below. There is no documentation "standard" in AHK per se, but I try to keep as close to some of the guidelines you'd find in Python as possible.

***OpenActivate***

**Use case**: *quickly access windows, even if they're not already active.*
```
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
```

***ToggleWindowAlwaysOnTop***

**Use case**: *keep windows in view of each other even when manipulating windows in the "background". This is especially useful when you are required to work on a single monitor, or if you just don't have enough screen real estate.*
```
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
```

***ToggleListenToDevice***

**Use case**: *toggle listening to another recording device - used to mirror audio output to USB speakers*
```
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
```

---

## [AutoHotkey][1]
> ... is a free, open-source custom scripting language for Microsoft Windows, initially aimed at providing easy keyboard shortcuts or hotkeys, fast macro-creation and software automation that allows users of most levels of computer skill to automate repetitive tasks in any Windows application.
\
> Autohotkey gives you the freedom to automate any desktop task. It's small, fast and runs out-of-the-box. Best of all, it's free, open-source (GNU GPLv2), and beginner-friendly. Why not give it a try?

[1]: https://www.autohotkey.com/
