local bar = require("components.bar")
local control_center = require("components.control_center")
local dock = require("components.launcher.dock")
local launcher = require("components.launcher")
local desktop = require("components.desktop")

return function(s)
	bar(s)
	desktop(s)
	dock(s)
	launcher(s)
	control_center(s)
end
