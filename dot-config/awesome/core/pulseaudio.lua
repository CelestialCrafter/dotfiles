local awful = require("awful")
local gears = require("gears")

local M = gears.object({})
M.cached = 0

function M.toggle_mute()
	awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
end

function M:collect()
	awful.spawn.easy_async("pactl get-sink-volume @DEFAULT_SINK@", function(stdout)
		self.cached = tonumber(stdout:match("(%d+)%%"))
		self:emit_signal("volume", self.cached)
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
			rawset(t, "cached", math.floor(v))
			awful.spawn(("pactl set-sink-volume @DEFAULT_SINK@ %d%%"):format(t.cached))
			return
		end

		rawset(t, k, v)
	end,
	__index = function(t, k)
		if k == "volume" then
			return t.cached
		end

		return rawget(t, k)
	end,
})

return M
