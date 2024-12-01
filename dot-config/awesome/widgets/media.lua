local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local bar_element = require("widgets.bar_element")

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

local function media()
	local height = beautiful.spacing_xl * 5
	local width = height * 1.5

	local info = {

		{
			widget = wibox.widget.textbox,
			halign = "center",
			id = "title"
		},
		{
			{
				widget = wibox.widget.textbox,
				halign = "center",
				id = "artist"
			},
			fg = beautiful.text_subtle,
			widget = wibox.container.background
		},
		layout = wibox.layout.fixed.vertical
	}

	local controls = {
		{
			{
				halign = "center",
				widget = wibox.widget.textbox,
				id = "position"
			},
			bottom = beautiful.spacing_s,
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
		layout = wibox.layout.fixed.vertical
	}

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
			widget = wibox.container.margin,
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

	local function handle_metadata(_, metadata)
		if metadata == nil then
			return
		end

		local path = '/tmp/media-art-' .. hex(metadata.id)
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
			return
		end

		local function sm(s) return math.floor(s / 60), s % 60 end
		local cm, cs = sm(pos.current)
		local lm, ls = sm(pos.length)

		position.text = string.format("%02d:%02d/%02d:%02d", cm, cs, lm, ls)
		progress.value = 1 / (pos.length / pos.current)
	end

	local function handle_status(_, playing)
		play_pause.text = playing and "+" or "-"
	end

	player:connect_signal("metadata", handle_metadata)
	player:connect_signal("position", handle_position)
	player:connect_signal("status", handle_status)
	handle_metadata(nil, player.metadata())
	handle_position(nil, player.position())
	handle_status(nil, player.status())

	awful.popup {
		widget = widget,
		ontop = true,
		placement = awful.placement.bottom_right,
		shape = beautiful.rounded,
		bg = beautiful.surface,
		visible = true
	}

	return widget
end

local function song()
	local function format(metadata)
		return metadata.title .. ' - ' .. metadata.artist
	end

	local m = player.metadata()
	local widget = bar_element({
		text = m and format(m),
		widget = wibox.widget.textbox,
		id = "song"
	})
	widget.visible = m ~= nil

	song = widget:get_children_by_id("song")[1]
	player:connect_signal("metadata", function(_, metadata)
		song.text = format(metadata)
		widget.visible = metadata ~= nil
	end)

	return widget
end

return {
	song = song,
	media = media
}
