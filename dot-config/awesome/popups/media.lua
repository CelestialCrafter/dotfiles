local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local player = require("playerctl").player

local function hex(str)
	return (str:gsub('.', function (c)
		return string.format('%02x', string.byte(c))
	end))
end

local function file_exists(name)
	local f = io.open(name, "r")
	return f ~= nil and io.close(f)
end

local font_height = beautiful.get_font_height(beautiful.font)
local height = beautiful.spacing_xl * 5
local width = height * 2

local info = {
	{
		widget = wibox.widget.textbox,
		forced_height = font_height,
		halign = "center",
		id = "title"
	},
	{
		{
			widget = wibox.widget.textbox,
			forced_height = font_height,
			halign = "center",
			id = "artist"
		},
		fg = beautiful.text_subtle,
		widget = wibox.container.background
	},
	layout = wibox.layout.fixed.vertical,
	forced_width = width
}

local controls = {
	{
		{
			halign = "center",
			widget = wibox.widget.textbox,
			id = "position"
		},
		widget = wibox.container.margin
	},
	{
		forced_width = width,
		forced_height = beautiful.spacing_l,
		widget = wibox.widget.progressbar,
		color = beautiful.accent,
		background_color = beautiful.subtle,
		shape = beautiful.rounded,
		id = "progress"
	},
	{
		{
			{
				id = "prev",
				text = "<",
				widget = wibox.widget.textbox
			},
			{
				id = "play_pause",
				widget = wibox.widget.textbox
			},
			{
				id = "next",
				text = ">",
				widget = wibox.widget.textbox
			},
			layout = wibox.layout.fixed.horizontal,
		},
		halign = "center",
		widget = wibox.container.place
	},
	spacing = beautiful.spacing_s,
	layout = wibox.layout.fixed.vertical
}

return function()
	local widget = wibox.widget {
		{
			resize = true,
			forced_height = height,
			forced_width = height,
			widget = wibox.widget.imagebox,
			id = "image"
		},
		{
			{
				info,
				nil,
				controls,
				layout = wibox.layout.align.vertical
			},
			margins = beautiful.spacing_l,
			widget = wibox.container.margin
		},
		layout = wibox.layout.fixed.horizontal,
	}

	local function c(name) return widget:get_children_by_id(name)[1] end

	local image = c("image")
	local title = c("title")
	local artist = c("artist")
	local position = c("position")
	local progress = c("progress")

	local prev = c("prev")
	local play_pause = c("play_pause")
	local next = c("next")

	prev:add_button(awful.button({}, 1, nil, player.previous))
	play_pause:add_button(awful.button({}, 1, nil, player.play_pause))
	next:add_button(awful.button({}, 1, nil, player.next))
	progress:connect_signal("button::press", function(self, x)
		player.seek(1 / (self.forced_width / x))
	end)

	local cache_path = gears.filesystem.get_cache_dir() .. '/media-art/'
	gears.filesystem.make_directories(cache_path)

	local function handle_metadata(_, metadata)
		if metadata == nil then
			image.image = nil
			title.markup = ""
			artist.text = ""
			return
		end

		local path = cache_path .. hex(metadata.art_url)
		local function set() image.image = gears.surface.load(path) end

		if not file_exists(path) then
			local cmd = string.format("curl -L -s %s -o %s", metadata.art_url, path)
			awful.spawn.with_line_callback(cmd, {
				exit = function ()
					-- make sure song is still the same after download finished
					if player.metadata().id == metadata.id then
						set()
					end
				end
			})
		else
			set()
		end

		title.markup = "<big>" .. metadata.title .. "</big>"
		artist.text = metadata.artist
	end

	local function handle_position(_, pos)
		if pos == nil then
			position.text = ""
			progress.value = 0
			return
		end

		local function sm(s) return math.floor(s / 60), s % 60 end
		local cm, cs = sm(pos.current)
		local lm, ls = sm(pos.length)

		position.text = string.format("%02d:%02d/%02d:%02d", cm, cs, lm, ls)
		progress.value = 1 / (pos.length / pos.current)
	end

	local function handle_status(_, playing)
		if playing == nil then
			play_pause.text = ""
			return
		end

		play_pause.text = playing and "+" or "-"
	end

	player:connect_signal("metadata", handle_metadata)
	player:connect_signal("position", handle_position)
	player:connect_signal("status", handle_status)
	handle_metadata(nil, player.metadata())
	handle_position(nil, player.position())
	handle_status(nil, player.status())

	return awful.popup {
		widget = widget,
		ontop = true,
		placement = function(d) awful.placement.top_right(d, {
			margins = beautiful.useless_gap * 2,
			honor_workarea = true
		}) end,
		shape = beautiful.rounded,
		visible = false
	}
end
