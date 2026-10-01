import Quickshell
import Quickshell.Wayland
import QtQuick

Scope {
    IdleMonitor {
        timeout: 5 * 60
        onIsIdleChanged: {
            if (isIdle) {
                Quickshell.execDetached(["sh", "-c", "hyprlock"]);
            }
        }
    }

    IdleMonitor {
        timeout: 10 * 60
        onIsIdleChanged: {
            if (isIdle) {
                Quickshell.execDetached(["sh", "-c", "niri msg action power-off-monitors"])
            } else {
                Quickshell.execDetached(["sh", "-c", "niri msg action power-on-monitors"])
            }
        }
    }

    IdleMonitor {
        timeout: 60 * 60
        onIsIdleChanged: {
            if (isIdle) {
                Quickshell.execDetached(["sh", "-c", "systemctl suspend-then-hibernate"])
            }
        }
    }
}
