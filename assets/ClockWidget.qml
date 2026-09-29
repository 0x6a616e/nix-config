import QtQuick
import Quickshell

Text {
    color: attributes.color
    font {
        family: attributes.family
        pointSize: attributes.pointSize
    }
    text: Qt.formatDateTime(clock.date, "hh:mm")

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
