local awful = require("awful")
local gears = require("gears")

local class = "backlight"

local M = gears.object({})
M.cached = 0

function M:collect()
	if M.enabled == false then
		return
	end

	awful.spawn.easy_async(("brightnessctl -mc %s i"):format(class), function(stdout)
		if stdout:match("Failed to read") then
			M.enabled = false
			return
		end

		M.enabled = true

		local new = tonumber(stdout:match("(%d+)%%"))
		if new ~= self.cached then
			self.cached = new
			self:emit_signal("brightness", new / 100)
		end
	end)
end

setmetatable(M, {
	__newindex = function(t, k, v)
		if k == "brightness" then
			if not t.enabled then
				return
			end

			rawset(t, "cached", math.floor(v * 100))
			awful.spawn(("brightnessctl -c %s s %s%%"):format(class, t.cached))
			return
		end

		rawset(t, k, v)
	end,
	__index = function(t, k)
		if k == "brightness" then
			return t.cached / 100
		end

		return rawget(t, k)
	end,
})

return M
