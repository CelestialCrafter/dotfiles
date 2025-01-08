local gears = require("gears")

local misc = require("misc")
local mpris = require("system.mpris")
local pulseaudio = require("system.pulseaudio")
local backlight = require("system.backlight")

mpris:setup()

gears.timer({
	timeout = misc.general_update_interval,
	autostart = true,
	callback = function()
		pulseaudio:collect()
		backlight:collect()
	end,
})
