local gears = require("gears")
local lgi = require("lgi")
local gio = lgi.Gio
local glib = lgi.GLib
local gobject = lgi.GObject

local connection
local bus_name = "org.awesomewm.akariconnect"

local mpris = require("connect.mpris")
local nm = require("connect.networkmanager")
local methods = {
    Position = mpris,
    Metadata = mpris,
    Status = mpris,
    Empty = mpris,

    Networks = nm
}

local function method_call(_, sender, object_path, interface, method, parameters, invocation)
    local dest = methods[method]
    if type(dest) == "function" then
        dest(sender, object_path, interface, method, parameters, invocation)
    else
        dest[method:lower()](table.unpack(parameters.value))
        invocation:return_value(glib.Variant("()"))
    end
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
