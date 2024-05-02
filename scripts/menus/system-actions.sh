#!/usr/bin/env bash

actions="Lock
Logout
Reboot
Shutdown
Suspend"

case $(echo "$actions" | wofi --prompt Action --show dmenu) in
	Lock)
		hyprlock
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
		hyprlock && systemctl suspend
		;;
esac
