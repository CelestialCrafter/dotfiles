local wibox = require("wibox")
local beautiful = require("beautiful")

local element = require("components.widgets.element")
local hover = require("components.widgets.hover")

local styles = {}
styles.normal = {
	pre = function(w)
		return hover(w, hover.tag(nil, "b"))
	end,
	post = function(w)
		return hover(w, hover.bg(nil, beautiful.primary))
	end,
	shape = beautiful.rounded,
}
styles.focus = {
	shape = beautiful.rounded,
	fg = beautiful.primary,
	bg = beautiful.highlight,
}

local function decorate(widget, flag)
	local style = styles[flag] or {}

	if style.pre then
		widget = style.pre(widget)
	end

	widget = wibox.widget({
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

	if style.post then
		widget = style.post(widget)
	end

	return widget
end

return function()
	return element({
		date = os.date("*t"),
		fn_embed = decorate,
		widget = wibox.widget.calendar.month,
	}, beautiful.surface)
end
