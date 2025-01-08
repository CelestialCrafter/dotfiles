local gears = require("gears")
local proxy = require("dbus_proxy")

local M = gears.object({})
M.enabled = false

function M:percentage()
	local level = self.proxy.BatteryLevel
	if level == 1 then
		return self.proxy.Percentage
	else
		-- range is 3-8 for coarse battery reporting (inclusive)
		return (level - 2) / 6 * 100
	end
end

function M:state()
	local state = self.proxy.State == 1 and "charging" or "discharging"
	return state == "charging" and self.proxy.TimeToFull or self.TimeToEmpty, state
end

function M:setup()
	local ok
	ok, self.proxy = pcall(function(opts)
		return proxy.Proxy:new(opts)
	end, {
		bus = proxy.Bus.SYSTEM,
		name = "org.freedesktop.UPower",
		interface = "org.freedesktop.UPower.Device",
		path = "/org/freedesktop/UPower/devices/DisplayDevice",
	})

	if not ok then
		return
	end

	self.enabled = true
	self.proxy:on_properties_changed(function(_, changed)
		local percentage = false
		local state = false

		for k, _ in pairs(changed) do
			if not percentage and (k == "Percentage" or k == "BatteryLevel") then
				self:emit_signal("percentage", self:percentage())
				percentage = true
			end

			if not state and (k == "State" or k == "TimeToFull" or k == "TimeToEmpty") then
				self:emit_signal("state", self:state())
				state = true
			end
		end
	end)

	self:emit_signal("percentage", self:percentage())
	self:emit_signal("state", self:state())
end

return M
