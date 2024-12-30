local awful = require("awful")
local gears = require("gears")
local gio = require("lgi").Gio
local naughty = require("naughty")

return function()
	local date = os.date("%Y-%m-%d-%H%M%S")
	local random = string.format("%x", math.random(0, 255))
	local name = string.format("%s-%s.png", date, random)
	local path = os.getenv("HOME") .. "/Pictures/Screenshots/" .. name
	gears.filesystem.make_parent_directories(path)

	local copy = "xclip -selection clipboard -t image/png " .. path
	local maim = "maim -u -s " .. path

	awful.spawn.easy_async(maim, function(_, _, _, code)
		if code ~= 0 then
			return
		end

		awful.spawn(copy)
		naughty.notification({
			title = "Screenshot Saved",
			text = "Saved as " .. name,
			icon = path,
			-- @FIX add action for delete, and fix run function not being ran
			run = function()
				gio.AppInfo.launch_default_for_uri(path)
			end,
		})
	end)
end
