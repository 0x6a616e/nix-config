import QtQuick
import Quickshell

Text {
    color: attributes.fontColor
    font {
        family: attributes.fontFamily
        pointSize: attributes.fontPointSize
    }
    text: Qt.formatDateTime(clock.date, "hh:mm")

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
