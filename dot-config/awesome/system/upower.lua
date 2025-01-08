local gears = require("gears")
local proxy = require("dbus_proxy")

local M = gears.object({})

function M:percentage()
	if self.is_connected then
		local level = self.BatteryLevel
		if level == 1 then
			return self.Percentage
		else
			-- range is 3-8 for coarse battery reporting
			return (level - 2) / 6 * 100
		end
	end
end

function M:time_to_target()
	return self.is_connected and (self.State == 1 and self.TimeToFull or self.TimeToEmpty) or 0
end

function M:setup()
	local upower = proxy.Proxy:new({
		bus = proxy.Bus.SYSTEM,
		name = "org.freedesktop.UPower",
		interface = "org.freedesktop.UPower.Device",
		path = "/org/freedesktop/UPower/devices/DisplayDevice",
	})

	upower:on_properties_changed(function(_, changed)
		for k, _ in pairs(changed) do
			if k == "Percentage" or k == "BatteryLevel" then
				self:emit_signal("percentage", self:percentage())
				break
			end
		end
	end)

	setmetatable(upower, { __index = self })
	return upower
end

return M
