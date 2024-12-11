-- ref: https://github.com/awesomeWM/awesome/blob/master/lib/naughty/dbus.lua

local gears = require("gears")
local lgi = require("lgi")
local mpris = require("connect.mpris")
local gio = lgi.Gio
local glib = lgi.GLib
local gobject = lgi.GObject

local connection
local bus_name = "org.awesomewm.akariconnect"
local methods = {}

function methods.Position(_, _, _, _, parameters, invocation)
    mpris.position(table.unpack(parameters.value))
    invocation:return_value(glib.Variant("()"))
end

function methods.Metadata(_, _, _, _, parameters, invocation)
    mpris.metadata(table.unpack(parameters.value))
    invocation:return_value(glib.Variant("()"))
end

function methods.Status(_, _, _, _, parameters, invocation)
    mpris.status(table.unpack(parameters.value))
    invocation:return_value(glib.Variant("()"))
end

local function method_call(_, sender, object_path, interface, method, parameters, invocation)
    methods[method](sender, object_path, interface, method, parameters, invocation)
end

local function on_bus_acquire(conn, _)
    local path = gears.filesystem.get_configuration_dir() .. "connect/definition.xml"

    local file = io.open(path, "r")
    if file == nil then
        return
    end

    local xml = file:read("*a")
    file:close()

    local node = gio.DBusNodeInfo
    local interface = node.lookup_interface(node.new_for_xml(xml), bus_name)

    conn:register_object(
        "/",
        interface,
        gobject.Closure(method_call)
    )

    connection = conn
end

gio.bus_own_name(
    gio.BusType.SESSION,
    bus_name,
    gio.BusNameOwnerFlags.NONE,
    gobject.Closure(on_bus_acquire)
)

return {
    conn = function()
        return connection
    end,
    signal = function(method, params)
        if connection == nil then
            return
        end

        connection:emit_signal(nil, "/", bus_name, method, params)
    end,
    bus_name = bus_name
}
