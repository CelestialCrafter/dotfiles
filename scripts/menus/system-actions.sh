#!/usr/bin/env bash

actions="Lock
Logout
Reboot
Shutdown
Suspend"

case $(echo "$actions" | wofi --prompt Action --show dmenu) in
	Lock)
		pidof hyprlock || hyprlock
		;;
	Logout)
		loginctl terminate-user $USER
		;;
	Shutdown)
		systemctl poweroff
		;;
	Reboot)
		systemctl reboot
		;;
	Suspend)
		systemctl suspend
		pidof hyprlock || hyprlock
		;;
esac
