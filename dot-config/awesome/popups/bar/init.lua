local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local user = require("user")
local media = require("popups.media")
local song = require("popups.bar.song")
local element = require("popups.bar.element")

return function(s)
	local overview = element(wibox.widget.textbox("Overview"))
	overview:add_button(awful.button(
		{}, 1, nil,
		function() s.overview.visible = not s.overview.visible end
	))

	local full_media = media()
	local short_media = wibox.container.constraint(song(), "max", nil, beautiful.spacing_xl * 10)
	short_media:add_button(awful.button(
		{}, 1, nil,
		function() full_media.visible = not full_media.visible end
	))

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
		end
	})

	bar:setup({
		{
			{
				overview,
				s.prompt,
				spacing = beautiful.spacing_s,
				layout = wibox.layout.fixed.horizontal
			},
			nil,
			{
				short_media,
				clock,
				spacing = beautiful.spacing_s,
				layout = wibox.layout.fixed.horizontal,
			},
			layout = wibox.layout.align.horizontal,
		},
		margins = beautiful.spacing_s,
		layout = wibox.container.margin
	})
end

