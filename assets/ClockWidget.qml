import QtQuick
import Quickshell
import Quickshell.Io

Text {
    id: c
    color: Fonts.color
    font.family: Fonts.family
    font.pointSize: Fonts.pointSize
    text: Qt.formatDateTime(clock.date, "hh:mm:ss")

    TapHandler {
        onTapped: p.running = true
    }

    Process {
        id: p
        command: [ "nix", "shell", "nixpkgs#libnotify", "-c", "notify-send", "hello" ]
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
