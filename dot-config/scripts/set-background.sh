#!/usr/bin/env bash

if [ $1 == 10 ]; then
	bgname="$HOME/Pictures/Wallpapers/special.png"
else
	bgname="$HOME/Pictures/Wallpapers/normal.png"
fi

swww img "$bgname" --transition-type none
