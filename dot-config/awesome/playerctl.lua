local gears = require("gears")
local playerctl = require("lgi").Playerctl
local misc = require("misc")

local manager = playerctl.PlayerManager()
local player = gears.object {}

local function c()
	return manager.players[1]
end

-- actions
function player.next()
	local p = c()
	if p ~= nil then
		p:next()
	end
end

function player.previous()
	local p = c()
	if p ~= nil then
		p:previous()
	end
end

function player.play_pause()
	local p = c()
	if p ~= nil then
		p:play_pause()
	end
end

function player.seek(percentage)
	local p = c()
	if p ~= nil then
		local length = p.metadata.value["mpris:length"] or 0
		p:set_position(length * percentage)
	end
end

-- info
function player.position()
	local p = c()
	if p ~= nil then
		local us_to_s = 1e+6

		local current = p:get_position() / us_to_s
		local length = (p.metadata.value["mpris:length"] or 0) / us_to_s

		return {
			current = current,
			length = length
		}
	end
end

local function format_metadata(metadata)
	local data = metadata.value

	local artists = {}
	for i = 1, #data["xesam:artist"] do
		table.insert(artists, data["xesam:artist"][i])
	end

	return {
		title = data["xesam:title"] or "",
		artist = table.concat(artists, ", "),
		art_url = data["mpris:artUrl"] or "",
		id = data["mpris:trackid"] or "",
		album = data["xesam:album"] or ""
	}
end

function player.metadata()
	local p = c()
	if p ~= nil then
		return format_metadata(p.metadata)
	end
end

local function is_playing(status)
	return status == "PLAYING"
end

function player.status()
	local p = c()
	if p ~= nil then
		return is_playing(p.playback_status)
	end
end

-- other
local function move(p)
	manager:move_player_to_top(p)
end

local function emit()
	player:emit_signal("metadata", player.metadata())
	player:emit_signal("status", player.status())
	player:emit_signal("position", player.position())
end

local function init_player(name)
	local p = playerctl.Player.new_from_name(name)
	manager:manage_player(p)
	emit()

	p.on_playback_status = function(self, status)
		move(self)
		player:emit_signal("status", is_playing(status))
	end

	p.on_metadata = function(self, metadata)
		move(self)
		player:emit_signal("metadata", format_metadata(metadata))
	end
end

local function setup()
	-- @FIX player-vanished signal isnt getting sent for some reason
	for _, name in ipairs(manager.player_names) do
		init_player(name)
	end

	function manager.on_name_appeared(_, name)
		init_player(name)
	end

	gears.timer {
		timeout = misc.media_position_update_interval,
		autostart = true,
		callback = function()
			local pos = player.position()
			if pos ~= nil then
				player:emit_signal("position", pos)
			end
		end
	}
end


return {
	setup = setup,
	player = player,
	cycle = function()
		if #manager.players < 1 then
			return
		end

		move(manager.players[#manager.players])
		emit()
	end,
}
