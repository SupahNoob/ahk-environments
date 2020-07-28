#CommentFlag // ; Change to C++ comment style.

// ----------------------------------------------------------------------------
// AUTO EXECUTE SECUTION
#NoEnv                 // avoid checking empty vars (default behavior in 2.0.0)
#Warn All              // turn on all warning messages
#SingleInstance Force  // replaces the old instance automatically
#WinActivateForce      // grab windows, might prevent taskbar from flashing
#Persistent            // run until killed in taskbar


array_join(arr, sep) {
    for i, e in arr
        if (i == 1) {
            out := e
        } else {
            out := out . sep . e
        }

    return out
}


SendJoinText(text, api_key, device_ids*) {
    /*

    This function requires that Python 3.7+ by installed with the library
    called "joinpython" in the global installed packages.
    */
    shell := ComObjCreate("wscript.shell")
    args  := ["-api " . api_key, "-te " . text, "-d " . array_join(device_ids, " ")]
    cmd   := ComSpec . " /C join.py " . array_join(args, " ")
    shell.run(cmd, 0)
}


_api_key := "<joaoapps join API key>" // personal API key
_device  := "<joaoapps join device ID>" // Pixel 2 XL
SendJoinText("evt_zoom_meeting_stop", _api_key, _device)

ONE_SECOND := 1000
ONE_MINUTE := ONE_SECOND * 60
ONE_HOUR   := ONE_MINUTE * 60

process_name := "Zoom.exe"

while true {
    if (A_Hour < 7 or A_Hour > 20) {
        sleep, ONE_HOUR
    } else {
        Process, Exist, %process_name%
        process_id := Errorlevel

        // zoom is open, wait for it to close
        if (process_id != 0) {
            SendJoinText("evt_zoom_meeting_start", _api_key, _device)
            Process, WaitClose, %process_id%
            SendJoinText("evt_zoom_meeting_stop", _api_key, _device)
        }

        sleep, ONE_SECOND * 5
    }
}
