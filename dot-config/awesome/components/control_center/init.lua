local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local misc = require("misc")
local notifications = require("components.control_center.notifications")

local function gen_widget()
	local user = {
		{
			image = gears.surface.load(os.getenv("HOME") .. "/Pictures/user.png"),
			forced_height = beautiful.spacing_xl * 1.5,
			forced_width = beautiful.spacing_xl * 1.5,
			clip_shape = beautiful.rounded,
			widget = wibox.widget.imagebox,
		},
		{
			{
				{
					id = "name",
					widget = wibox.widget.textbox,
				},
				width = beautiful.spacing_xl * 6,
				height = misc.font_height(),
				widget = wibox.container.constraint,
			},
			valign = "center",
			widget = wibox.container.place,
		},
		spacing = beautiful.spacing_m,
		layout = wibox.layout.fixed.horizontal,
	}

	return wibox.widget({
		{
			user,
			notifications(),
			spacing = beautiful.spacing_m,
			forced_width = beautiful.spacing_xl * 12,
			widget = wibox.layout.fixed.vertical,
		},
		margins = beautiful.spacing_m,
		widget = wibox.container.margin,
	})
end

return function(s)
	local widget = gen_widget()

	local name = misc.children("name", widget)
	awful.spawn.easy_async("hostname", function(output)
		name.markup = ("<big>%s@%s</big>"):format(os.getenv("USER"), output)
	end)

	s.control_center = awful.popup({
		widget = widget,
		bg = beautiful.surface,
		shape = beautiful.rounded,
		ontop = true,
		placement = function(d)
			awful.placement.top_left(d, {
				margins = beautiful.useless_gap * 2,
				honor_workarea = true,
			})
		end,
	})
end
