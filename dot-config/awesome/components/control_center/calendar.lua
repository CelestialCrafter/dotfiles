local wibox = require("wibox")
local beautiful = require("beautiful")

local misc = require("misc")
local element = require("components.widgets.element")

local styles = {}
styles.focus = {
	shape = beautiful.rounded,
	fg = beautiful.primary,
	bg = beautiful.overlay,
	markup = function(t)
		return misc.wrap_tag("b", t)
	end,
}

local function decorate(widget, flag)
	local style = styles[flag] or {}
	if widget.text then
		if style.markup then
			widget.markup = style.markup(widget.text)
		end
	end

	return wibox.widget({
		{
			widget,
			margins = beautiful.spacing_s,
			widget = wibox.container.margin,
		},
		shape = style.shape,
		fg = style.fg,
		bg = style.bg,
		widget = wibox.container.background,
	})
end

return function()
	return element({
		date = os.date("*t"),
		fn_embed = decorate,
		widget = wibox.widget.calendar.month,
	}, beautiful.surface)
end
