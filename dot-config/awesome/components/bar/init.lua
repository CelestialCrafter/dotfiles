local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local user = require("user")
local upower = require("core.upower")
local song = require("components.bar.song")
local battery = require("components.bar.battery")
local current_client = require("components.bar.current_client")
local element = require("components.widgets.element")
local hover = require("components.widgets.hover")

local eh = function(template, button)
	return hover(wibox.widget(gears.table.crush(element(template), { buttons = button })), hover.bg())
end

return function(s)
	local widgets = {}

	widgets.control_center = eh(
		{
			text = "O",
			widget = wibox.widget.textbox,
		},
		awful.button({}, 1, nil, function()
			s.control_center.visible = not s.control_center.visible
		end)
	)

	widgets.apps = eh(
		{
			text = "Applications",
			widget = wibox.widget.textbox,
		},
		awful.button({}, 1, nil, function()
			s.launcher.visible = not s.launcher.visible
		end)
	)

	widgets.current_client = current_client(s)
	widgets.song = eh(
		song(),
		awful.button({}, 1, nil, function()
			s.media.visible = not s.media.visible
		end)
	)

	if upower.enabled then
		widgets.battery = eh(battery())
	end

	widgets.clock = eh({
		format = "%I:%M%P",
		widget = wibox.widget.textclock,
	})

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
				widgets.control_center,
				widgets.apps,
				spacing = beautiful.spacing_s,
				layout = wibox.layout.fixed.horizontal,
			},
			widgets.current_client,
			{
				widgets.song,
				widgets.battery,
				widgets.clock,
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
