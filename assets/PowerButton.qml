import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

IconImage {
    id: icon

    property string popupId: "power"

    source: "file:///home/jan/nix-config/assets/v1.png"
    implicitSize: parent.height * 0.85

    LazyLoader {
        active: attributes.openPopup === popupId
        PopupWindow {
            anchor {
                item: icon
                rect {
                    x: icon.width / 2 - width / 2
                    y: icon.height
                }
            }
            implicitWidth: 200
            implicitHeight: 150 // 50 per item
            visible: attributes.openPopup === popupId

            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                Rectangle {
                    border {
                        color: "#FFFFFF"
                        width: ma1.containsMouse ? 2 : 0
                    }
                    color: "#000000"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    MouseArea {
                        id: ma1
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            attributes.locked = true
                            p1.running = true
                        }
                    }
                    Process {
                        id: p1
                        command: [ "sh", "-c", "hyprlock" ]
                    }
                    Text {
                        anchors.centerIn: parent
                        color: attributes.fontColor
                        font {
                            family: attributes.fontFamily
                            pointSize: attributes.fontPointSize
                        }
                        text: "Lock"
                    }
                }
                Rectangle {
                    border {
                        color: "#FFFFFF"
                        width: ma3.containsMouse ? 2 : 0
                    }
                    color: "#000000"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    MouseArea {
                        id: ma3
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: p3.running = true
                    }
                    Process {
                        id: p3
                        command: [ "sh", "-c", "systemctl reboot" ]
                    }
                    Text {
                        anchors.centerIn: parent
                        color: attributes.fontColor
                        font {
                            family: attributes.fontFamily
                            pointSize: attributes.fontPointSize
                        }
                        text: "Reboot"
                    }
                }
                Rectangle {
                    border {
                        color: "#FFFFFF"
                        width: ma4.containsMouse ? 2 : 0
                    }
                    color: "#000000"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    MouseArea {
                        id: ma4
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: p4.running = true
                    }
                    Process {
                        id: p4
                        command: [ "sh", "-c", "systemctl poweroff" ]
                    }
                    Text {
                        anchors.centerIn: parent
                        color: attributes.fontColor
                        font {
                            family: attributes.fontFamily
                            pointSize: attributes.fontPointSize
                        }
                        text: "Shutdown"
                    }
                }
            }
        }
    }

    TapHandler {
        gesturePolicy: TapHandler.WithinBounds
        onTapped: {
            attributes.openPopup = (attributes.openPopup === popupId ? "" : popupId)
        }
    }
}
