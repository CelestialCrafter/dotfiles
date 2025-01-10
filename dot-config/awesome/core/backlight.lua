local awful = require("awful")
local gears = require("gears")

local M = gears.object({})
M._brightness = 0

function M:collect()
	if M.enabled == false then
		return
	end

	awful.spawn.easy_async("brightnessctl -mc backlight i", function(stdout, _, _, code)
		if code == 1 then
			M.enabled = false
			return
		end
		M.enabled = true

		self._brightness = tonumber(stdout:match("(%d+)%%"))
		self:emit_signal("brightness", self._brightness)
	end)
end

setmetatable(M, {
	__newindex = function(t, k, v)
		if k == "brightness" then
			if not t.enabled then
				return
			end

			t._brightness = math.floor(v)
			awful.spawn(("brightnessctl -c backlight s %s%%"):format(t._brightness))
			return
		end

		rawset(t, k, v)
	end,
	__index = function(t, k)
		if k == "brightness" then
			return t._brightness
		end

		return rawget(t, k)
	end,
})

return M
