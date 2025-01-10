local awful = require("awful")
local gears = require("gears")

local M = gears.object({})
M._volume = 0
M._muted = false

function M.toggle_mute()
	awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
end

function M:collect()
	awful.spawn.easy_async("pactl --format json list sinks", function(stdout)
		self._volume = tonumber(stdout:match("(%d+)%%"))
		self:emit_signal("volume", self.volume)
	end)

	awful.spawn.easy_async("pactl get-sink-mute @DEFAULT_SINK@", function(stdout)
		local muted = stdout:match("no") or stdout:match("yes")
		if muted then
			self._muted = muted == "yes"
			self:emit_signal("muted", self.muted)
		end
	end)
end

function M:setup()
	-- https://github.com/Stardust-kyun/calla/blob/main/usr/share/calla/desktop/signal/volume.lua
	awful.spawn.easy_async({ "pkill", "--full", "--uid", os.getenv("USER"), "^pactl subscribe" }, function()
		awful.spawn.with_line_callback("pactl subscribe", {
			stdout = function(line)
				if gears.string.startswith(line, "Event 'change' on sink") then
					M:collect()
				end
			end,
		})
	end)

	M:collect()
end

setmetatable(M, {
	__newindex = function(t, k, v)
		if k == "volume" then
			t._volume = math.floor(v)
			awful.spawn(("pactl set-sink-volume @DEFAULT_SINK@ %d%%"):format(t._volume))
			return
		elseif k == "muted" then
			t._muted = v
			awful.spawn(("pactl set-sink-mute @DEFAULT_SINK@ %s"):format(v))
			return
		end

		rawset(t, k, v)
	end,
	__index = function(t, k)
		if k == "volume" then
			return t._volume
		elseif k == "muted" then
			return t._muted
		end
	end,
})

return M
