local beautiful = require("beautiful")
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local menu_gen = require("menubar.menu_gen")

local margin = beautiful.spacing_l
-- i dont know?
local size = (beautiful.spacing_xl * 2) - beautiful.spacing_m - beautiful.spacing_s

local entries = {}
local current = nil

local function generate_widget(entry)
	local image = {
		image  = entry.icon,
		resize = true,
		forced_height = size,
		widget = wibox.widget.imagebox
	}

	if entry.focused then
		image = {
			image,
			bg = beautiful.accent,
			shape = beautiful.rounded,
			widget = wibox.container.background
		}
	end

	return wibox.widget {
		image,
		{
			text = entry.name,
			align  = 'center',
			widget = wibox.widget.textbox
		},
		forced_width = size,
		layout = wibox.layout.fixed.vertical
	}
end

local function handle_search(query)
	local pattern = gears.string.query_to_pattern(query)
	-- @TODO priority system?
	local add_entry = function(entry)
		local nm = string.match(entry.name, pattern)
		local cm = string.match(entry.cmdline, pattern)

		return nm or cm
	end

	-- @TODO max entries based on priority
	local matched = {}
	for _, entry in ipairs(entries) do
		if query == "" or add_entry(entry) then
			entry.focused = false
			table.insert(matched, entry)
		end
	end

	current = matched[1]
	if current ~= nil then
		current.focused = true
	end

	local widgets = {}
	for _, entry in ipairs(matched) do
		table.insert(widgets, generate_widget(entry))
		entry.focused = false
	end

	if #widgets == 0 then
		table.insert(widgets, generate_widget({}))
	end

	return widgets
end

menu_gen.generate(function(new_entries)
	entries = new_entries
end)

return function(button)
	local widget = wibox.widget {
		{
			{
				markup = "<big>Search: </big>",
				id = "search",
				widget = wibox.widget.textbox
			},
			{
				spacing = margin,
				forced_num_cols = 6,
				layout = wibox.layout.grid.vertical,
				id = "entries",
			},
			fill_space = true,
			spacing = beautiful.spacing_m,
			layout = wibox.layout.fixed.vertical
		},
		widget = wibox.container.margin,
		margins = margin,
	}

	local launcher = awful.popup {
		widget = widget,
		bg = beautiful.surface,
		shape = beautiful.rounded,
		preferred_anchors = {'middle'},
		ontop = true,
		visible = false
	}

	launcher:bind_to_widget(button)
	button:buttons(gears.table.join(awful.button(
		{},
		1,
		nil,
		function() launcher.visible = true end
	)))

	local search = widget:get_children_by_id("search")[1]
	local function set_entries(query)
		widget:get_children_by_id("entries")[1]:set_children(handle_search(query))
	end

	launcher:connect_signal("property::visible", function()
		if not launcher.visible then
			launcher.placement = nil
			return
		end

		set_entries("")

		local current_text = search.markup
		awful.prompt.run {
			prompt = current_text,
			textbox = search,
			changed_callback = set_entries,
			highlighter = function(before, after)
				before = "<big>" .. before
				after = after .. "</big>"
				return before, after
			end,
			exe_callback = function()
				if current ~= nil then
					awful.spawn(current.cmdline)
				end
			end,
			done_callback = function()
				search.markup = current_text
				launcher.visible = false
			end
		}
	end)

	return launcher
end
