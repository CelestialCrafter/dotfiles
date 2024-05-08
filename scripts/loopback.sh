OPTION=$1

if [[ "unloop" == $OPTION ]] then
	OPTION="unloop"
else
	OPTION="loop"
fi

function unload {
	pactl unload-module module-loopback
}

case $OPTION in
	loop)
		unload
		pactl load-module module-loopback latency_msec=100
		;;
	unloop)
		unload
		;;
	*)
		exit
esac
