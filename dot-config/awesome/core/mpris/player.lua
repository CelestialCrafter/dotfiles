local proxy = require("dbus_proxy")

local M = {}

function M:Get(property)
	return self.proxy:Get(self.proxy.interface, property)
end

function M:metadata()
	if not self.proxy.is_connected then
		return
	end

	local m = self.proxy.Metadata
	return {
		id = m["mpris:trackid"],
		length = (m["mpris:length"] or 0) / 1e6,
		art = m["mpris:artUrl"],
		artists = m["xesam:artist"],
		album = m["xesam:album"],
		title = m["xesam:title"],
	}
end

function M:playing()
	return self.proxy.is_connected and self.proxy.PlaybackStatus == "Playing"
end

function M:position()
	if self.proxy.is_connected then
		return (self:Get("Position") or 0) / 1e6
	end
end

function M:next()
	if self.proxy.is_connected then
		self.proxy:Next()
	end
end

function M:prev()
	if self.proxy.is_connected then
		self.proxy:Previous()
	end
end

function M:seek(percentage)
	if not self.proxy.is_connected then
		return
	end

	local m = self.proxy.Metadata
	local id = m["mpris:trackid"]
	local length = m["mpris:length"]
	if not length then
		return
	end

	self.proxy:SetPosition(id, length * percentage)
end

function M:play_pause()
	if self.proxy.is_connected then
		self.proxy:PlayPause()
	end
end

function M:new(name, cb)
	local ret = {}
	setmetatable(ret, self)
	self.__index = self

	ret.proxy = proxy.monitored.new({
		bus = proxy.Bus.SESSION,
		name = name,
		interface = "org.mpris.MediaPlayer2.Player",
		path = "/org/mpris/MediaPlayer2",
	}, cb)

	ret.proxy.is_connected = false

	return ret
end

return M
