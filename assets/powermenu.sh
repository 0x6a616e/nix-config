#!/bin/sh

# Power menu script using rofi

CHOSEN=$(printf "Suspend\nReboot\nShutdown\nLog Out" | rofi -dmenu -i -p "Power Menu:")

case "$CHOSEN" in
	"Suspend") systemctl suspend-then-hibernate ;;
	"Reboot") reboot ;;
	"Shutdown") poweroff ;;
	"Log Out") hyprctl dispatch exit ;;
	*) exit 1 ;;
esac
