positions=("top-left" "top-right")
position=$(shuf -e ${positions[@]} -n1)

if [[ ! -z $1 ]] then
	swww img "$1" \
	--transition-type grow \
	--transition-pos "$position" \
	--transition-duration 2 \
	--transition-fps 60
else
	echo "no wallpaper specified"
fi