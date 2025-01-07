local wibox = require("wibox")
local beautiful = require("beautiful")

return function(w, bg, fg)
	if not bg then
		bg = beautiful.overlay
	end

	return {
		{
			w,
			margins = beautiful.spacing_m,
			widget = wibox.container.margin,
		},
		bg = bg,
		fg = fg,
		shape = beautiful.rounded,
		widget = wibox.container.background,
	}
end
