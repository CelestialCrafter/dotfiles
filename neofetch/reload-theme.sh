#!/usr/bin/env bash

check_command() {
	if [ $? -eq 0 ]; then
		if [ ! -z "$1" ]; then
			exit 0
		fi
	else
		exit 1
	fi
}

PFP=$(python -u ~/.config/neofetch/pfp.py 2> /dev/null)
check_command
curl "$PFP" -o ~/.cache/neofetch-picture.png 2> /dev/null
check_command a
