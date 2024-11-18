local bait = require("bait")
local ansikit = require("ansikit")

-- vim cursor style
bait.catch("hilbish.vimMode", function(mode)
	if mode ~= "insert" then
		ansikit.cursorStyle(ansikit.blockCursor)
	else
		ansikit.cursorStyle(ansikit.lineCursor)
	end
end)

