local gears = require("gears")

local misc = require("misc")
local user = require("user")
local mpris = require("system.mpris")
local upower = require("system.upower")
local pulseaudio = require("system.pulseaudio")
local backlight = require("system.backlight")

mpris:setup()
if user.battery_enabled then
	upower:setup()
end

gears.timer({
	timeout = misc.general_update_interval,
	autostart = true,
	callback = function()
		pulseaudio:collect()
		backlight:collect()
	end,
})
