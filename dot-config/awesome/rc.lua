-- register luarocks stuff if its installed
pcall(require, "luarocks.loader")

-- keep errors at the top, just incase
require("errors")
require("misc")
require("screen")
require("client")
require("keybinds")
require("rules")
