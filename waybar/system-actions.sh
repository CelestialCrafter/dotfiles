#!/usr/bin/env bash

actions="Lock
Logout
Reboot
Shutdown"

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
esac