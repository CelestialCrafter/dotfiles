local overview = require("popups.overview")
local launcher = require("popups.launcher")
local bar = require("popups.bar")
local control_center = require("popups.control_center")

return function(s)
	bar(s)
	s.control_center = control_center(s)
	s.launcher = launcher()
	s.overview = overview(s)
end
