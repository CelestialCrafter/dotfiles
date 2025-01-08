local awful = require("awful")
local gears = require("gears")

local M = gears.object({})
M.cached = 0

function M.toggle_mute()
	awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
end

function M:collect()
	awful.spawn.easy_async("pactl get-sink-volume @DEFAULT_SINK@", function(stdout)
		local new = tonumber(stdout:match("(%d+)%%"))
		if new ~= self.cached then
			self.cached = new
			self:emit_signal("volume", new)
		end
	end)
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
