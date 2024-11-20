local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

local function selector_section(s, id, color)
	local section = wibox.widget {
		wibox.widget.base.make_widget(),
		shape = function(cr, w, h)
			gears.shape.rounded_rect(cr, w, h, beautiful.margin_m)
		end,
		bg = beautiful.subtle,
		widget = wibox.container.background,
	}

	section:connect_signal("section", function(_, section_id)
		if section_id == id then
			section.bg = color
		else
			section.bg = beautiful.subtle
		end
	end)

	section:buttons(gears.table.join(
		awful.button({}, 1, nil, function()
			for _, v in ipairs(s.selector.sections.children) do
				v:emit_signal_recursive("section", id)
			end
		end)
	))

	return section
end

return function(s, bar, widget)
	s.selector = wibox.widget {
		{
			selector_section(s, 1, beautiful.primary),
			selector_section(s, 2, beautiful.secondary),
			selector_section(s, 3, beautiful.accent),
			spacing = beautiful.margin_m,
			forced_width = beautiful.margin_l,
			layout = wibox.layout.flex.vertical,
			id = "sections"
		},
		layout = wibox.layout.fixed.horizontal,
	}

	s.selector.sections.children[1].bg = beautiful.primary

	local popout = wibox({
		visible = false,
		ontop = true,
		height = (beautiful.margin_xl * 8) + beautiful.margin_m,
		width = s.geometry.width,
		bg = beautiful.base
	})
	popout:setup({
		{
			s.selector,
			margins = beautiful.margin_s,
			layout = wibox.container.margin,
		},
		bottom = 1,
		color = beautiful.subtle,
		layout = wibox.container.margin,
	})

	widget:buttons(gears.table.join(
	awful.button({}, 1, nil, function()
		if popout.visible then
			popout.visible = false
			bar.y = 0
			bar.ontop = false
		else
			popout.visible = true
			bar.y = popout.height
			bar.ontop = true
		end
	end)
	))
end
