#!/usr/bin/env fish

set -l bg
if test $argv[1] -eq 10
	set bg "$HOME/Pictures/Wallpapers/special.png"
else
	set bg "$HOME/Pictures/Wallpapers/normal.png"
end

awww img "$bg" --transition-type none
