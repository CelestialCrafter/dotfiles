#!/usr/bin/env fish
# workaround until environment replacement gets into yambar release

pkill yambar
for monitor in $argv
	set -l output_path ~/.cache/yambar-config-$monitor.yml
	string replace {{MONITOR}} $monitor (cat ~/.config/yambar/config.yml.template) > $output_path
	riverctl spawn "yambar -c $output_path"
end
