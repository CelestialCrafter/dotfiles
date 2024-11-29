-- register luarocks stuff if its installed
pcall(require, "luarocks.loader")

-- keep errors at the top, just incase
require("errors")
require("awful.autofocus")
require("playerctl").setup()
require("misc").setup()
require("theme")
require("layout")
require("keybinds")
require("screen")
require("client")
require("rules")
