local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

local launcher = require("screen.bar.launcher")

local function selector_section(s, id, color, page)
	local section = wibox.widget {
		wibox.widget {},
		shape = gears.shape.rounded_bar,
		bg = beautiful.subtle,
		widget = wibox.container.background,
	}

	section:connect_signal("section", function(_, section_id)
		if section_id == id then
			section.bg = color
			s.selector:set(2, page)
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
			selector_section(s, 1, beautiful.primary, launcher),
			selector_section(s, 2, beautiful.secondary, wibox.widget {}),
			selector_section(s, 3, beautiful.accent, wibox.widget {}),
			spacing = beautiful.margin_m,
			forced_width = beautiful.margin_l,
			layout = wibox.layout.flex.vertical,
			id = "sections"
		},
		wibox.widget {},
		spacing = beautiful.margin_s,
		layout = wibox.layout.fixed.horizontal,
	}

	s.selector.sections.children[1]:emit_signal("section", 1)

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
			layout = wibox.container.margin
		},
		wibox.widget {
			thickness = beautiful.margin_s / 2,
			color = beautiful.subtle,
			widget = wibox.widget.separator
		},
		layout = wibox.layout.fixed.vertical
	})

	widget:buttons(gears.table.join(
	awful.button({}, 1, nil, function()
		if popout.visible then
			popout.visible = false
			widget.bg = beautiful.overlay
			bar.y = 0
			bar.ontop = false
		else
			popout.visible = true
			widget.bg = beautiful.secondary
			bar.y = popout.height
			bar.ontop = true
		end
	end)
	))
end
