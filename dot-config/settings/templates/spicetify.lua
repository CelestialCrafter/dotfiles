local M = {}

function M.processor(value)
	return value:gsub("^#", "")
end

M.data = [[[custom]
text = %colors.text%
subtext = %colors.text_subtle%
main = %colors.base%
sidebar = %colors.base%
player = %colors.base%
card = %colors.base%
shadow = %colors.base%
selected-row = %colors.accent%
button = %colors.accent%
button-active = %colors.accent%
button-disabled = %colors.surface%
tab-active = %colors.accent%
notification = %colors.base%
notification-error = %colors.red%
misc = %colors.base%]]

function M.install(resolved)
	local file = assert(io.open(os.getenv("HOME") .. "/.config/spicetify/Themes/ziro/color.ini", "w"))
	file:write(resolved)
	file:close()
end

return M
