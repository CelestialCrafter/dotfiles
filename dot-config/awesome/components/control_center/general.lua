local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

return function()
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
				markup = "<big>" .. os.getenv("USER") .. "</big>",
				widget = wibox.widget.textbox,
			},
			valign = "center",
			widget = wibox.container.place,
		},
		spacing = beautiful.spacing_m,
		layout = wibox.layout.fixed.horizontal,
	}

	return wibox.widget(user)
end
