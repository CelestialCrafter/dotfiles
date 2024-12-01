local overview = require("popups.overview")
local launcher = require("popups.launcher")
local bar = require("popups.bar")

return function(s)
	s.overview = overview(s)
	bar(s)
	launcher(s)
end
