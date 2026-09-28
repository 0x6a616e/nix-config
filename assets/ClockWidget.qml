import QtQuick
import Quickshell

Text {
    color: Fonts.color
    font.family: Fonts.family
    font.pointSize: Fonts.pointSize
    text: Qt.formatDateTime(clock.date, "hh:mm")

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
