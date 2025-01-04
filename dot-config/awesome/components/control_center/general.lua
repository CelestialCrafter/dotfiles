local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local misc = require("misc")
local element = require("components.widgets.element")
local hover = require("components.widgets.hover")

return function()
	local name = {
		{
			markup = "<big>" .. os.getenv("USER") .. "</big>",
			forced_height = misc.font_height(),
			widget = wibox.widget.textbox,
		},
		halign = "left",
		valign = "center",
		widget = wibox.container.place,
	}

	local function power_action(text, color, cmd)
		local w = wibox.widget({
			{
				text = text,
				halign = "center",
				widget = wibox.widget.textbox,
			},
			fg = color,
			widget = wibox.container.background,
		})

		w:add_button(awful.button({}, 1, nil, function()
			awful.spawn(cmd)
		end))

		return hover(w)
	end

	local logout = power_action("L", beautiful.accent, "loginctl lock-session")
	logout:add_button({ "Shift" }, 1, nil, function()
		awful.spawn("loginctl terminate-session")
	end)

	local power = element({
		{
			power_action("S", beautiful.primary, "systemctl poweroff"),
			power_action("R", beautiful.secondary, "systemctl reboot"),
			logout,
			layout = wibox.layout.flex.horizontal,
		},
		right = beautiful.spacing_s,
		left = beautiful.spacing_s,
		widget = wibox.container.margin,
	}, nil)

	local size = beautiful.spacing_xl * 1.5
	local user = {
		{
			image = gears.surface.load(os.getenv("HOME") .. "/Pictures/user.png"),
			forced_height = size,
			forced_width = size,
			clip_shape = beautiful.rounded,
			widget = wibox.widget.imagebox,
		},
		{
			name,
			power,
			-- set to 0 so widgets take minimal space
			forced_width = 0,
			spacing = beautiful.spacing_s,
			layout = wibox.layout.fixed.vertical,
		},
		fill_space = true,
		spacing = beautiful.spacing_m,
		layout = wibox.layout.fixed.horizontal,
	}

	return wibox.widget(user)
end
