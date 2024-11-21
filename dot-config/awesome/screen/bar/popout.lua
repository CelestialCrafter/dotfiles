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
			page:emit_signal("open")
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
			spacing = beautiful.spacing_m,
			forced_width = beautiful.spacing_l,
			layout = wibox.layout.flex.vertical,
			id = "sections"
		},
		wibox.widget {},
		spacing = beautiful.spacing_s,
		layout = wibox.layout.fixed.horizontal,
	}

	local separator_height = beautiful.spacing_s / 2
	local height = (beautiful.spacing_xl * 8) + beautiful.spacing_m
	s.popout = wibox({
		visible = false,
		ontop = true,
		height = height + separator_height,
		width = s.geometry.width,
		bg = beautiful.base
	})
	s.popout:setup({
		{
			s.selector,
			margins = beautiful.spacing_s,
			forced_height = height,
			layout = wibox.container.margin
		},
		wibox.widget {
			thickness = separator_height,
			color = beautiful.subtle,
			widget = wibox.widget.separator
		},
		layout = wibox.layout.fixed.vertical
	})

	s.popout:connect_signal("toggle", function()
		if s.popout.visible then
			s.popout.visible = false
			widget.bg = beautiful.overlay
			bar.y = 0
			bar.ontop = false
		else
			s.popout.visible = true
			widget.bg = beautiful.secondary
			bar.y = s.popout.height
			bar.ontop = true
			s.selector.sections.children[1]:emit_signal("section", 1)
		end
	end)

	widget:buttons(gears.table.join(awful.button(
		{},
		1,
		nil,
		function() s.popout:emit_signal("toggle") end
	)))
end
