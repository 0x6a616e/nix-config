import Quickshell
import Quickshell.Io
import QtQuick

PanelWindow {
    id: bar

    // TODO: rename font attributes
    QtObject {
        id: attributes
        readonly property string family: "VCR OSD Mono"
        readonly property real pointSize: 16
        readonly property string color: "#FFFFFF"
        property string openPopup: ""
    }

    anchors {
        top: true
        left: true
        right: true
    }

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
