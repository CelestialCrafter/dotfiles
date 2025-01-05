local proxy = require("dbus_proxy")

local M = {}

function M:metadata()
	if not self.is_connected then
		return
	end

	local m = self.Metadata
	return {
		id = m["mpris:trackid"],
		length = (m["mpris:length"] or 0) / 1e6,
		art = m["mpris:artUrl"],
		artists = m["xesam:artist"],
		album = m["xesam:album"],
		title = m["xesam:title"],
	}
end

function M:Get(property)
	return self.proxy:Get(self.interface, property)
end

function M:playing()
	return self.is_connected and self.PlaybackStatus == "Playing"
end

function M:position()
	if self.is_connected then
		return (self:Get("Position") or 0) / 1e6
	end
end

function M:next()
	if self.is_connected then
		self:Next()
	end
end

function M:prev()
	if self.is_connected then
		self:Previous()
	end
end

function M:seek(percentage)
	if not self.is_connected then
		return
	end

	local m = self.Metadata
	local id = m["mpris:trackid"]
	local length = m["mpris:length"]
	if not length then
		return
	end

	self:SetPosition(id, length * percentage)
end

function M:play_pause()
	if self.is_connected then
		self:PlayPause()
	end
end

function M:new(name, cb)
	local mpris = proxy.monitored.new({
		bus = proxy.Bus.SESSION,
		name = name,
		interface = "org.mpris.MediaPlayer2.Player",
		path = "/org/mpris/MediaPlayer2",
	}, cb)

	mpris.is_connected = false
	mpris.Get = self.Get -- override
	setmetatable(mpris, { __index = self })

	return mpris
end

return M
