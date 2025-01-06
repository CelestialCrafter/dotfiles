local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local user = require("user")
local media = require("components.media")
local song = require("components.bar.song")
local volume = require("components.bar.volume")
local current_client = require("components.bar.current_client")
local element = require("components.widgets.element")
local hover = require("components.widgets.hover")

return function(s)
	local apps = wibox.widget(element(wibox.widget.textbox("Applications")))
	apps:add_button(awful.button({}, 1, nil, function()
		s.launcher.visible = not s.launcher.visible
	end))

	local control_center = wibox.widget(element(wibox.widget.textbox("O")))
	control_center:add_button(awful.button({}, 1, nil, function()
		s.control_center.visible = not s.control_center.visible
	end))

	local media_widget = media()
	local song_widget = wibox.container.constraint(song(), "max", nil, beautiful.spacing_xl * 10)
	song_widget:add_button(awful.button({}, 1, nil, function()
		media_widget.visible = not media_widget.visible
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
				hover(control_center),
				hover(apps),
				s.prompt,
				spacing = beautiful.spacing_s,
				layout = wibox.layout.fixed.horizontal,
			},
			current_client(s),
			{
				hover(song_widget),
				hover(volume()),
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
