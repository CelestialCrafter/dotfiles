local gears = require("gears")
local proxy = require("dbus_proxy")

local misc = require("misc")
local player = require("system.mpris.player")

local M = gears.object({})
M.players = {}
M.order = {}

-- @NOTE: does not accept negatives
function M:shift(n)
	for _ = 1, n do
		table.insert(self.order, 1, table.remove(self.order, #self.order))
	end

	self:emit()
end

function M:top(name)
	local pos = 1
	for i, n in ipairs(self.order) do
		if n == name then
			pos = i
			break
		end
	end

	if pos == 1 then
		return
	end

	table.remove(self.order, pos)
	table.insert(self.order, 1, name)

	self:emit()
end

function M:current()
	if #self.order == 0 then
		return
	end

	return self.players[self.order[1]]
end

function M:emit(props)
	if not props then
		props = { "metadata", "position", "playing" }
	end

	local mpris = M:current()
	for _, k in ipairs(props) do
		local v
		if mpris then
			v = player[k](mpris)
		end

		self:emit_signal(k, v)
	end
end

local function is_player(name)
	return tostring(name):match("^org%.mpris%.MediaPlayer2%.") ~= nil
end

function M:player_callback(name)
	return function(mpris, appeared)
		if appeared then
			mpris:on_properties_changed(function(_, changed)
				local shift = false
				for k, _ in pairs(changed) do
					local prop_map = {
						Metadata = "metadata",
						PlaybackStatus = "playing",
					}

					local v = prop_map[k]
					if v then
						if name ~= self.order[1] then
							shift = true
							break
						end

						self:emit_signal(v, player[v](mpris))
					end
				end

				if shift then
					self:top(name)
				end
			end)

			if name == self.order[1] then
				self:emit()
			end
		else
			self.players[name] = nil
			for i, n in ipairs(self.order) do
				if name == n then
					table.remove(self.order, i)
					break
				end
			end

			self:emit()
		end
	end
end

function M:setup()
	local dbus = proxy.Proxy:new({
		bus = proxy.Bus.SESSION,
		name = "org.freedesktop.DBus",
		interface = "org.freedesktop.DBus",
		path = "/org/freedesktop/DBus",
	})

	gears.timer({
		timeout = misc.general_update_interval,
		autostart = true,
		callback = function()
			self:emit({ "position" })
		end,
	})

	-- register players
	local function new_player(name)
		self.players[name] = player:new(name, M:player_callback(name))
		table.insert(self.order, name)
	end

	local names = dbus:ListNames()
	local players = {}
	for _, name in ipairs(names) do
		if is_player(name) then
			table.insert(players, name)
		end
	end
	for _, name in ipairs(players) do
		if is_player(name) then
			new_player(name)
		end
	end

	dbus:connect_signal(function(_, name, old, new)
		-- player added
		if is_player(name) and new ~= "" and old == "" then
			new_player(name)
		end
	end, "NameOwnerChanged")
end

setmetatable(M, {
	__index = function(self, k)
		local fn = rawget(self, k)
		if fn then
			return fn
		end

		return function(...)
			local mpris = self:current()
			if mpris and player[k] then
				return player[k](mpris, ...)
			end
		end
	end,
})

return M
