local wibox = require("wibox")

local upower = require("core.upower")

local function init()
	local model = {}

	local widget = wibox.widget.textbox()
	return model,
		widget,
		function()
			if not model.percentage then
				widget.visible = false
			else
				widget.text = string.format("%d%%", model.percentage)
			end
		end
end

return function()
	local model, widget, view = init()

	upower:connect_signal("percentage", function(_, percentage)
		model.percentage = percentage
		view()
	end)

	model.percentage = upower:percentage()
	view()

	return widget
end
