import Quickshell

PanelWindow {
    required property var modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }

    color: "#000000"

    implicitHeight: 30
    aboveWindows: false

    ClockWidget {
        anchors.centerIn: parent
    }
}
