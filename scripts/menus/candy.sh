actions="neofetch
cava"

action=$(echo "$actions" | wofi --show dmenu)

case $action in
	neofetch)
		kitty --class kitty_neofetch -o window_padding_width=20 neofetch --gap 2 --special
		;;
	cava)
		kitty --class kitty_cava -o window_padding_width=0 cava
		;;
esac