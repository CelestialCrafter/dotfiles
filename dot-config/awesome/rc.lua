-- register luarocks stuff if its installed
pcall(require, "luarocks.loader")

-- keep errors at the top, just incase
require("errors")
require("layout")
require("misc")
require("keybinds")
require("screen")
require("client")
require("rules")
