local beautiful = require("beautiful")
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local menu_gen = require("menubar.menu_gen")

local margin = beautiful.spacing_m
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
			shape = beautiful.rounded_rect,
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

local launcher = wibox.widget {
	{
		markup = "<big>Search: </big>",
		id = "search",
		widget = wibox.widget.textbox
	},
	{
		{
			{
				spacing = margin,
				forced_num_cols = 16,
				layout = wibox.layout.grid.vertical,
				id = "entries",
			},
			widget = wibox.container.margin,
			margins = margin,
		},
		bg = beautiful.surface,
		shape = beautiful.rounded_rect,
		widget = wibox.container.background,
	},
	fill_space = true,
	layout = wibox.layout.fixed.vertical
}

local function handle_search(query)
	local pattern = gears.string.query_to_pattern(query)
	-- @TODO priority system?
	local add_entry = function(entry)
		local nm = string.match(entry.name, pattern)
		local cm = string.match(entry.cmdline, pattern)

		return nm and cm
	end

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

	launcher:get_children_by_id("entries")[1]:set_children(widgets)
end

launcher.search:buttons(gears.table.join(
	awful.button({}, 1, nil, function()
		launcher:emit_signal("open")
	end)
))

launcher:connect_signal("open", function()
	handle_search("")

	local current_text = launcher.search.markup
	awful.prompt.run {
		prompt = current_text,
		textbox = launcher.search,
		changed_callback = handle_search,
		highlighter = function(before, after)
			before = "<big>" .. before
			after = after .. "</big>"
			return before, after
		end,
		exe_callback = function()
			if current ~= nil then
				awful.spawn(current.cmdline)
				awful.screen.focused().popout:emit_signal("toggle")
			end
		end,
		done_callback = function()
			launcher.search.markup = current_text
			handle_search("")
		end
	}
end)

menu_gen.generate(function(new_entries)
	entries = new_entries
end)

return launcher
