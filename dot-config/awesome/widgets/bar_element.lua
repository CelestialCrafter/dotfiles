local wibox = require("wibox")
local beautiful = require("beautiful")

return function(w)
	return wibox.widget {
		{
			w,
			margins = beautiful.spacing_m,
			widget = wibox.container.margin
		},
		bg = beautiful.overlay,
		shape = beautiful.rounded,
		widget = wibox.container.background
	}
end

