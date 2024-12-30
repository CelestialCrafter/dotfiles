local wibox = require("wibox")
local beautiful = require("beautiful")

return function(w, bg)
	if not bg then
		bg = beautiful.overlay
	end

	return wibox.widget({
		{
			w,
			margins = beautiful.spacing_m,
			widget = wibox.container.margin,
		},
		bg = bg,
		shape = beautiful.rounded,
		widget = wibox.container.background,
	})
end
