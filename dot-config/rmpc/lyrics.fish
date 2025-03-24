#!/usr/bin/env fish

set LRCLIB_INSTANCE "https://lrclib.net"

function error
	rmpc remote --pid $PID status "Failed to download lyrics for $ARTIST - $TITLE" --level error
	exit
end

if test "$HAS_LRC" = "false"
    mkdir -p (dirname "$LRC_FILE")

    set response (curl --silent --get \
        -H "Lrclib-Client: rmpc-$VERSION" \
        --data-urlencode "artist_name=$ARTIST" \
        --data-urlencode "track_name=$TITLE" \
        --data-urlencode "album_name=$ALBUM" \
        "$LRCLIB_INSTANCE/api/get")

    set code (echo $response | jq -r '.statusCode')
    if test $code = 404
		error
    end

    set synced (echo $response | jq -r '.syncedLyrics' | string collect)
    set plain (echo $response | jq -r '.plainLyrics' | string collect)

    echo "[ar:$ARTIST]
[al:$ALBUM]
[ti:$TITLE]" > $LRC_FILE

	set -l type
    if test $synced != null
        echo $synced >> $LRC_FILE
		set type "synced"
	else if $plain != null 
		echo $plain | awk '{print "[00:00.00] " $0}' >> $LRC_FILE
		set type "plain"
	else
		error
    end

    rmpc remote --pid $PID status "Downloaded $type lyrics for $ARTIST - $TITLE" --level info
    rmpc remote --pid $PID indexlrc --path $LRC_FILE
end
