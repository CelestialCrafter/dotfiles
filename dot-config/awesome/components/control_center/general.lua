local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local user = require("user")
local misc = require("misc")
local hover = require("components.widgets.hover")
local button = require("components.widgets.button")

return function()
	local function power_action(text, color, cmd)
		local w = wibox.widget(gears.table.crush(
			button({
				text = text,
				widget = wibox.widget.textbox,
			}, color),
			{
				id = text,
				buttons = {
					awful.button({}, 1, nil, function()
						awful.spawn(cmd)
					end),
				},
			}
		))
		hover(w, hover.bg())

		return w
	end

	local logout = power_action("L", beautiful.accent, "loginctl lock-session")
	logout:add_button(awful.button({ "Shift" }, 1, nil, function()
		awful.spawn("loginctl terminate-session")
	end))

	local poweroff = power_action("S", beautiful.primary, "systemctl poweroff")
	poweroff:add_button(awful.button({ "Shift" }, 1, nil, function()
		awful.spawn("systemctl suspend")
	end))

	local power = button.array({
		poweroff,
		power_action("R", beautiful.secondary, "systemctl reboot"),
		logout,
	})

	local size = beautiful.spacing_xl * 1.85
	return {
		{
			image = gears.surface.crop_surface({
				surface = gears.surface(user.profile),
				ratio = 1,
			}),
			forced_height = size,
			forced_width = size,
			clip_shape = beautiful.rounded,
			widget = wibox.widget.imagebox,
		},
		{
			{
				markup = misc.wrap_tag(os.getenv("USER"), "big"),
				widget = wibox.widget.textbox,
			},
			{
				power,
				hover(
					wibox.widget(gears.table.crush(
						button({
							awful.widget.layoutbox,
							valign = "center",
							halign = "center",
							widget = wibox.container.place,
						}),
						{
							buttons = {
								awful.button({}, 1, function()
									awful.layout.inc(1)
								end),
								awful.button({}, 3, function()
									awful.layout.inc(-1)
								end),
							},
						}
					)),
					hover.bg()
				),
				spacing = beautiful.spacing_m,
				layout = wibox.layout.fixed.horizontal,
			},
			spacing = beautiful.spacing_s,
			layout = wibox.layout.fixed.vertical,
		},
		spacing = beautiful.spacing_m,
		layout = wibox.layout.fixed.horizontal,
	}
end
