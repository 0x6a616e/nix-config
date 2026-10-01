import Quickshell
import Quickshell.Networking
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: ww

    readonly property WifiDevice wifiDevice: {
        Networking.devices.values.find((v) => v.type === DeviceType.Wifi);
    }

    readonly property Network connectedNetwork: {
        wifiDevice?.networks.values.find((v) => v.connected === true);
    }
    readonly property string popupId: "wifi"

    Layout.fillHeight: true

    IconImage {
        implicitSize: parent.height

        source: "file:///home/jan/nix-config/assets/wifi.png"
    }

    Text {
        color: attributes.fontColor
        font {
            family: attributes.fontFamily
            pointSize: attributes.fontPointSize
        }
        text: connectedNetwork?.name ?? ""
    }

    TapHandler {
        gesturePolicy: TapHandler.WithinBounds
        onTapped: {
            attributes.openPopup = (attributes.openPopup === popupId ? "" : popupId);
            if (wifiDevice != null) {
                wifiDevice.scannerEnabled = attributes.openPopup === popupId;
            }
        }
    }

    LazyLoader {
        active: attributes.openPopup === popupId
        PopupWindow {
            property var networks: wifiDevice?.networks ?? [ ]
            anchor {
                item: ww
                rect {
                    x: ww.width / 2 - width / 2
                    y: ww.height
                }
            }
            implicitWidth: 400
            implicitHeight: 30 * networks.values.length
            visible: attributes.openPopup === popupId

            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                Repeater {
                    model: networks
                    Rectangle {
                        required property var modelData

                        border {
                            color: "#FFFFFF"
                            width: ma.containsMouse ? 2 : 0
                        }
                        color: "#000000"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        MouseArea {
                            id: ma
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                modelData.connect();
                            }
                        }
                        Text {
                            anchors.centerIn: parent
                            color: attributes.fontColor
                            font {
                                family: attributes.fontFamily
                                pointSize: attributes.fontPointSize
                            }
                            text: modelData.name
                        }
                    }
                }
            }
        }
    }
}
