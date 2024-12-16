local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local element = require("widgets.element")

local function user()
	local w = wibox.widget {
		{
			image = gears.surface.load(os.getenv("HOME") .. "/Pictures/user.png"),
			forced_height = beautiful.spacing_xl * 1.5,
			forced_width = beautiful.spacing_xl * 1.5,
			clip_shape = beautiful.rounded,
			widget = wibox.widget.imagebox
		},
		{
			{
				{
					id = "user-host",
					widget = wibox.widget.textbox
				},
				width = beautiful.spacing_xl * 6,
				height = beautiful.get_font_height(beautiful.font),
				widget = wibox.container.constraint
			},
			valign = "center",
			widget = wibox.container.place
		},
		spacing = beautiful.spacing_m,
		layout = wibox.layout.fixed.horizontal
	}

	awful.spawn.easy_async("hostname", function(output)
		local textbox = w:get_children_by_id("user-host")[1]
		textbox.markup = string.format("<big>%s@%s</big>", os.getenv("USER"), output)
	end)

	return w
end

local function power()
	local function fg(w, color)
		return {
			w,
			fg = color,
			widget = wibox.container.background
		}
	end

	return {
		element(wibox.widget.textbox("() 76%")),
		element({
			fg(wibox.widget.textbox("-"), beautiful.primary),
			fg(wibox.widget.textbox("()"), beautiful.secondary),
			fg(wibox.widget.textbox("{"), beautiful.accent),
			spacing = beautiful.spacing_s,
			layout = wibox.layout.fixed.horizontal
		}),
		spacing = beautiful.spacing_s,
		layout = wibox.layout.fixed.horizontal
	}
end

return function()
	local widget = wibox.widget {
		{
			{
				{
					user(),
					nil,
					{
						{
							power(),
							left = beautiful.spacing_xl,
							widget = wibox.container.margin
						},
						valign = "center",
						widget = wibox.container.place
					},
					layout = wibox.layout.align.horizontal
				},
				bottom = beautiful.spacing_s,
				widget = wibox.container.margin
			},
			{
				{
					spacing = beautiful.spacing_s,
					layout = wibox.layout.fixed.horizontal,
					id = "pages"
				},
				halign = "center",
				widget = wibox.container.place
			},
			wibox.widget {},
			spacing = beautiful.spacing_s,
			layout = wibox.layout.fixed.vertical,
			id = "content"
		},
		margins = beautiful.spacing_m,
		widget = wibox.container.margin
	}

	local content = widget:get_children_by_id("content")[1]
	local pages = widget:get_children_by_id("pages")[1]

	local page_data = {
		{
			widget = element(wibox.widget.textbox("^ My Network")),
			id = "network"
		},
		{
			widget = element(wibox.widget.textbox("$ Wireless Headphones")),
			id = "bluetooth"
		},
		{
			widget = element(wibox.widget.textbox("< Audio", true)),
			id = "audio"
		}
	}
	-- not using a keyed table to preserve order
	for i, v in pairs(page_data) do
		local w = require("popups.control_center." .. v.id)()

		local function set_page()
			for j, p in ipairs(pages.children) do
				p.bg = i == j and beautiful.primary or beautiful.overlay
			end
			content:set(3, w)
		end

		v.widget:add_button(awful.button({}, 1, nil, set_page))
		pages:add(v.widget)

		set_page()
	end

	local popup = awful.popup {
		widget = widget,
		ontop = true,
		placement = function(d) awful.placement.top_left(d, {
			margins = beautiful.useless_gap * 2,
			honor_workarea = true
		}) end,
		shape = beautiful.rounded,
	}

	return popup
end
