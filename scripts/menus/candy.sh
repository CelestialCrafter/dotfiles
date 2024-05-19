actions="neofetch
cava
cbonsai"

action=$(echo "$actions" | wofi --show dmenu)

case $action in
	neofetch)
		kitty --class candy_neofetch -o window_padding_width=20 neofetch --gap 2 --special
		;;
	cava)
		kitty --class candy_cava -o window_padding_width=20 cava
		;;
	cbonsai)
		kitty --class candy_cbonsai -o window_padding_width=20 cbonsai -l -b 2 -L 48 -t 0.06
esac
