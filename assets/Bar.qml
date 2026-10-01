import Quickshell
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: bar
    screen: Quickshell.screens[attributes.mainScreenIndex]

    color: "#000000"

    implicitHeight: 30

    TapHandler {
        onTapped: attributes.openPopup = ""
    }

    ClockWidget {
        anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter
    }

    RowLayout {
        anchors {
            bottom: parent.bottom
            right: parent.right
            top: parent.top
        }
        spacing: 20

        WifiWidget {
        }

        PowerButton {
            implicitSize: parent.height * 0.85
        }
    }

}
