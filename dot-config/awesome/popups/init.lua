local bar = require("popups.bar")
local control_center = require("popups.control_center")
local apps = require("popups.launcher.apps")
local dock = require("popups.launcher.dock")
local launcher = require("popups.launcher")

return function(s)
	bar(s)
	dock(s)
	launcher(s)
	control_center(s)

	apps.setup()
end
