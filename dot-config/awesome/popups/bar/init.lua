local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local user = require("user")
local media = require("popups.media")
local song = require("popups.bar.song")
local current_client = require("popups.bar.current_client")
local element = require("widgets.element")

return function(s)
	local apps = element(wibox.widget.textbox("Applications"))
	apps:add_button(awful.button({}, 1, nil, function()
		s.launcher.visible = not s.launcher.visible
	end))

	local full_media = media()
	local short_media = wibox.container.constraint(song(), "max", nil, beautiful.spacing_xl * 10)
	short_media:add_button(awful.button({}, 1, nil, function()
		full_media.visible = not full_media.visible
	end))

	s.prompt = awful.widget.prompt()
	local clock = element(wibox.widget.textclock("%I:%M%P"))

	local bar = awful.wibar({
		height = beautiful.spacing_xl + beautiful.spacing_m,
		position = user.bar_position,
		screen = s,
		shape = function(cr, w, h)
			local tl, tr, bl, br
			if user.bar_position == "top" then
				tl, tr, bl, br = false, false, true, true
			elseif user.bar_position == "bottom" then
				tl, tr, bl, br = true, true, false, false
			end

			gears.shape.partially_rounded_rect(cr, w, h, tl, tr, bl, br, beautiful.spacing_m)
		end,
	})

	bar:setup({
		{
			{
				apps,
				s.prompt,
				spacing = beautiful.spacing_s,
				layout = wibox.layout.fixed.horizontal,
			},
			current_client(s),
			{
				short_media,
				clock,
				spacing = beautiful.spacing_s,
				layout = wibox.layout.fixed.horizontal,
			},
			expand = "none",
			layout = wibox.layout.align.horizontal,
		},
		margins = beautiful.spacing_s,
		layout = wibox.container.margin,
	})
end
