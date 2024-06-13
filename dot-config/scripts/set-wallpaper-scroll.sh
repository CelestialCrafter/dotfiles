if [[ -z $1 ]] then
	echo no tag index given
	exit 1
fi

# PLEASE keep this in sync with the one in generate-wallpaper-scroll
IMAGE_SPAN_TAGS=4
swww img ~/.cache/wallpaper-scroll/$(($1 % IMAGE_SPAN_TAGS)).jpg \
	--transition-type none
