local gears = require("gears")

local misc = require("misc")
local mpris = require("core.mpris")
local upower = require("core.upower")
local pulseaudio = require("core.pulseaudio")
local backlight = require("core.backlight")

mpris:setup()
upower:setup()

gears.timer({
	timeout = misc.general_update_interval,
	autostart = true,
	callback = function()
		pulseaudio:collect()
		backlight:collect()
	end,
})
