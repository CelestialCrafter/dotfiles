local overview = require("popups.overview")
local launcher = require("popups.launcher")
local bar = require("popups.bar")
local screenshot = require("popups.screenshot")

return function(s)
	s.screenshot = screenshot()
	s.overview = overview(s)
	bar(s)
	launcher(s)
end
