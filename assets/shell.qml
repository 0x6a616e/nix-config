import Quickshell
import QtQuick

Scope {
    QtObject {
        id: attributes
        readonly property string fontFamily: "VCR OSD Mono"
        readonly property real fontPointSize: 16
        readonly property string fontColor: "#FFFFFF"
        property int mainScreenIndex: 1
        property string openPopup: ""
    }

    Bar {
        anchors {
            top: true
            left: true
            right: true
        }
    }

    VolumeOSD { }
}
