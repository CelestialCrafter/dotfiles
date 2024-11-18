-- if luarocks is installed, register luarocks packages
pcall(require, "luarocks.loader")

-- keep errors at the top, just incase
require("errors")

require("misc")
require("bar")
require("clients")
require("keybinds")
require("rules")
