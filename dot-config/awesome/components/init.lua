local bar = require("components.bar")
local control_center = require("components.control_center")
local apps = require("components.launcher.apps")
local dock = require("components.launcher.dock")
local launcher = require("components.launcher")

return function(s)
	bar(s)
	dock(s)
	launcher(s)
	control_center(s)

	apps.setup()
end
