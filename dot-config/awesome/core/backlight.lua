local awful = require("awful")
local gears = require("gears")

local M = gears.object({})
M.cached = 0

function M:collect()
	if M.enabled == false then
		return
	end

	awful.spawn.easy_async("brightnessctl -mc backlight i", function(stdout)
		if stdout:match("Failed to read") then
			M.enabled = false
			return
		end
		M.enabled = true

		self.cached = tonumber(stdout:match("(%d+)%%"))
		self:emit_signal("brightness", self.cached)
	end)
end

setmetatable(M, {
	__newindex = function(t, k, v)
		if k == "brightness" then
			if not t.enabled then
				return
			end

			rawset(t, "cached", math.floor(v))
			awful.spawn(("brightnessctl -c backlight s %s%%"):format(t.cached))
			return
		end

		rawset(t, k, v)
	end,
	__index = function(t, k)
		if k == "brightness" then
			return t.cached
		end

		return rawget(t, k)
	end,
})

return M
