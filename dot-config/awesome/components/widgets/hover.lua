local beautiful = require("beautiful")

local misc = require("misc")

local M = {}

function M.bg(bg, fg, id)
	local bg_widget
	local prev = {}

	return function(widget, active)
		if not bg_widget then
			bg_widget = id and misc.children(id, widget) or widget
		end

		if active then
			prev.bg = bg_widget.bg
			prev.fg = bg_widget.fg
			bg_widget.bg = bg or bg_widget.fg or beautiful.highlight
			bg_widget.fg = fg or beautiful.text
		else
			bg_widget.bg = prev.bg
			bg_widget.fg = prev.fg
		end
	end
end

function M.tag(id, ...)
	local tb_widget
	local props = { ... }
	local prev

	return function(widget, active)
		if not tb_widget then
			tb_widget = id and misc.children(id, widget) or widget
		end

		if active then
			prev = tb_widget.markup
			tb_widget.markup = misc.wrap_tag(tb_widget.text, table.unpack(props))
		else
			tb_widget.markup = prev
		end
	end
end

function M.cursor(cursor)
	local prev = {}

	return function(_, active)
		local wibox = mouse.current_wibox
		if not wibox then
			return
		end

		if active then
			prev.wibox = wibox
			prev.cursor = wibox.cursor
			wibox.cursor = cursor or "hand2"
		else
			if prev.wibox then
				prev.wibox.cursor = prev.cursor
			end
		end
	end
end

local function hover(_, widget, ...)
	local fns = { ... }
	table.insert(fns, M.cursor())

	widget:connect_signal("mouse::enter", function()
		for _, fn in ipairs(fns) do
			fn(widget, true)
		end
	end)

	widget:connect_signal("mouse::leave", function()
		for _, fn in ipairs(fns) do
			fn(widget, false)
		end
	end)

	return widget
end

setmetatable(M, {
	__call = hover,
})

return M
