if [[ -z $1 ]] then
	echo no tag index given
	exit 1
fi

# PLEASE keep this in sync with the one in generate-wallpaper-scroll
IMAGE_SPAN_TAGS=4

WBG_PID=$(pgrep wbg)
wbg ~/.cache/wallpaper-scroll/$(($1 % IMAGE_SPAN_TAGS)).jpg &
if [[ ! -z $WBG_PID ]] then
	# prevent flicker due to wbg being spawned in the background
	sleep 0.075
	kill $WBG_PID
fi
