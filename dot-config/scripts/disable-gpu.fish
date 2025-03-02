#!/usr/bin/env fish

set -l programs "dev.vencord.Vesktop.desktop|com.spotify.Client|md.obsidian.Obsidian|org.google.Chrome|org.kde.krita"

for path in (string split ":" $XDG_DATA_DIRS)
    if not test -d $path
        continue
    end

    for file in (fd -t f -t l -e desktop . $path)
    	if not string match -q -r $programs (basename $file)
    	    continue
    	end

        if string match -q "*--disable-gpu*" (cat "$file")
            continue
        end

        set -l output (cat "$file" | string replace -r '(Exec=.*)' '$1 --disable-gpu-compositing --disable-gpu')
        echo "patched " (basename "$file")
    end
end
