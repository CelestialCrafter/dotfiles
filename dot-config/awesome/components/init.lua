local bar = require("components.bar")
local control_center = require("components.control_center")
local dock = require("components.launcher.dock")
local launcher = require("components.launcher")
local desktop = require("components.desktop")
local execute = require("components.execute")
local media = require("components.media")
local osd = require("components.osd")

return function(s)
	bar(s)
	desktop(s)
	s.dock = dock(s)
	s.osd = osd()

	s.execute = execute()
	s.media = media(s)
	s.launcher = launcher(s)
	s.control_center = control_center()

	local exclusive = { s.execute, s.media, s.launcher, s.control_center }
	local current

	for i, popup in ipairs(exclusive) do
		popup:connect_signal("property::visible", function()
			if not popup.visible then
				return
			end

			current = i
			for j, p in ipairs(exclusive) do
				p.visible = i == j
			end
		end)
	end
end
