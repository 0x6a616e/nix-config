import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Scope {
	id: root

	property bool shouldShowOsd: false

	PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}

	Connections {
		target: Pipewire.defaultAudioSink?.audio

		function onVolumeChanged() {
			root.shouldShowOsd = true;
			hideTimer.restart();
		}
	}

	Timer {
		id: hideTimer
		interval: 1000
		onTriggered: root.shouldShowOsd = false
	}

	LazyLoader {
		active: root.shouldShowOsd

        PanelWindow {
            screen: Quickshell.screens[attributes.mainScreenIndex]
            implicitWidth: 400
            implicitHeight: 50
            color: "transparent"
            mask: Region { }

            Rectangle {
                anchors.fill: parent
                border {
                    color: "#FFFFFF"
                    width: 2
                }
                color: "#000000"

                Rectangle {
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        top: parent.top
                    }
                    color: "#FFFFFF"
                    implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
                }
            }
        }
	}
}
