import Quickshell
import Quickshell.Io
import QtQuick

PanelWindow {
    id: bar
    screen: Quickshell.screens[attributes.mainScreenIndex]

    color: "#000000"

    implicitHeight: 30

    ClockWidget {
        anchors.centerIn: parent
    }

    PowerButton {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }

    TapHandler {
        onTapped: attributes.openPopup = ""
    }

    Process {
        id: p
        command: [ "nix", "shell", "nixpkgs#libnotify", "-c", "notify-send", "hello" ]
    }
}
