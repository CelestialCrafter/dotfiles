local awful = require("awful")
local wibox = require("wibox")

local element = require("components.widgets.element")

return function()
	return awful.widget.watch("pamixer --get-volume", 1, function(widget, stdout)
		widget.children[1].children[1].text = stdout:gsub("%s", "") .. "%"
	end, wibox.widget(element(wibox.widget.textbox())))
end
