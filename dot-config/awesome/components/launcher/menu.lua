local beautiful = require("beautiful")
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local misc = require("misc")
local apps = require("misc.apps")
local element = require("components.widgets.element")
local hover = require("components.widgets.hover")

local size = beautiful.spacing_xl * 2
local cols = 12
local rows = 6
local max_entries = rows * cols

local current = nil

local function app_widget(entry, s)
	local widget = {
		{
			{
				{
					image = entry.icon,
					resize = true,
					forced_height = size,
					widget = wibox.widget.imagebox,
				},
				halign = "center",
				widget = wibox.container.place,
			},
			top = beautiful.spacing_m,
			right = beautiful.spacing_m,
			left = beautiful.spacing_m,
			widget = wibox.container.margin,
		},
		{
			markup = entry.focused and "<b>" .. entry.name .. "</b>" or entry.name,
			halign = "center",
			widget = wibox.widget.textbox,
		},
		layout = wibox.layout.fixed.vertical,
		forced_width = size + misc.font_height() * 1.5,
	}

	if entry.focused then
		widget = {
			widget,
			bg = beautiful.primary,
			fg = beautiful.base,
			shape = beautiful.rounded,
			widget = wibox.container.background,
		}
	end

	widget = wibox.widget(widget)
	widget:add_button(awful.button({}, 1, nil, function()
		entry.launch()
		s.launcher.visible = false
	end))

	return hover(widget)
end

-- https://gist.github.com/Badgerati/3261142
local function levenshtein(str1, str2)
	local len1 = string.len(str1)
	local len2 = string.len(str2)
	local matrix = {}
	local cost

	-- quick cut-offs to save time
	if len1 == 0 then
		return len2
	elseif len2 == 0 then
		return len1
	elseif str1 == str2 then
		return 0
	end

	-- initialise the base matrix values
	for i = 0, len1, 1 do
		matrix[i] = {}
		matrix[i][0] = i
	end
	for j = 0, len2, 1 do
		matrix[0][j] = j
	end

	-- actual Levenshtein algorithm
	for i = 1, len1, 1 do
		for j = 1, len2, 1 do
			if str1:byte(i) == str2:byte(j) then
				cost = 0
			else
				cost = 1
			end

			matrix[i][j] = math.min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1, matrix[i - 1][j - 1] + cost)
		end
	end

	return matrix[len1][len2]
end

local function handle_search(query, s)
	local matched = {}

	for _, entry in pairs(apps.entries) do
		query = query:gsub("%W", "")

		if string.find(entry.name:lower(), query:lower(), 1, true) ~= nil then
			table.insert(matched, entry)
		end
	end

	table.sort(matched, function(a, b)
		return levenshtein(query, a.name) < levenshtein(query, b.name)
	end)

	current = matched[1]
	if current ~= nil then
		current.focused = true
	else
		-- empty entry so theres no weird ui shift with when nothing matched
		table.insert(matched, {
			icon = gears.surface.load_from_shape(size, size, gears.shape.rounded_rect, "#00000000"),
			name = " ",
		})
	end

	local app_widgets = {}
	for i, entry in ipairs(matched) do
		if i > max_entries then
			break
		end

		table.insert(app_widgets, app_widget(entry, s))
		entry.focused = false
	end

	return app_widgets
end

return function(s)
	local search_box = wibox.widget({
		text = "Search: ",
		ellipsize = "start",
		widget = wibox.widget.textbox,
	})

	local search = wibox.widget({
		{
			{
				{
					{
						{
							element(search_box),
							width = beautiful.spacing_xl * 24,
							height = beautiful.spacing_xl * 4,
							widget = wibox.container.constraint,
						},
						strategy = "min",
						width = beautiful.spacing_xl * 12,
						widget = wibox.container.constraint,
					},
					halign = "center",
					widget = wibox.container.place,
				},
				{
					column_count = cols,
					row_count = rows,
					spacing = beautiful.spacing_m,
					layout = wibox.layout.grid.vertical,
					id = "entries",
				},
				spacing = beautiful.spacing_m,
				layout = wibox.layout.fixed.vertical,
			},
			margins = beautiful.spacing_m,
			widget = wibox.container.margin,
		},
		shape = beautiful.rounded,
		bg = beautiful.surface,
		widget = wibox.container.background,
	})

	local function set_entries(query)
		search:get_children_by_id("entries")[1]:set_children(handle_search(query, s))
	end

	set_entries("")
	local function run_search()
		set_entries("")

		local original_text = search_box.text
		awful.prompt.run({
			prompt = original_text,
			textbox = search_box,
			changed_callback = set_entries,
			exe_callback = function()
				if current ~= nil then
					current.launch()
				end
				s.launcher.visible = false
			end,
			done_callback = function()
				search_box.text = original_text
				s.launcher.visible = false
			end,
		})
	end

	return search, run_search
end
