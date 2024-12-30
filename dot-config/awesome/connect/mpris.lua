local gears = require("gears")
local glib = require("lgi").GLib

-- avoid circular dependence
local c = function()
	return require("connect")
end

local M = gears.object({})

function M.play_pause()
	c().signal("PlayPause")
end

function M.next()
	c().signal("Next")
end

function M.previous()
	c().signal("Previous")
end

function M.seek(seconds)
	c().signal("Seek", glib.Variant("(t)", { seconds * 1e+6 }))
end

function M.shift(by)
	c().signal("Shift", glib.Variant("(n)", { by }))
end

function M.position(pos)
	M:emit_signal("position", pos / 1e+6)
end

function M.status(status)
	M:emit_signal("status", status)
end

function M.metadata(title, album, artist, length, art)
	M:emit_signal("metadata", {
		title = title,
		album = album,
		artist = artist,
		length = length,
		art = art,
	})
end

function M.empty()
	M:emit_signal("empty")
end

return M
