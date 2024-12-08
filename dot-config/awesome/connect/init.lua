-- ref: https://github.com/awesomeWM/awesome/blob/master/lib/naughty/dbus.lua

local lgi = require("lgi")
local gio = lgi.Gio
local gobject = lgi.GObject

local bus_name = "org.awesomewm.akariconnect"

local methods = {}

function methods.Test(sender, object_path, interface, method, parameters, invocation)
    require("naughty").notify({
        text = tostring(sender)
    })

    invocation:return_value()
end

local function method_call(_, sender, object_path, interface, method, parameters, invocation)
    methods[method](sender, object_path, interface, method, parameters, invocation)
end

local function on_bus_acquire(conn, _)
    local function arg(name, sig)
        return gio.DBusArgInfo { name = name, signature = sig }
    end

    local method = gio.DBusMethodInfo
    local signal = gio.DBusSignalInfo

    local interface_info = gio.DBusInterfaceInfo {
        name = bus_name,
        methods = {
            method {
                name = "Test",
            }
        }
    }

    conn:register_object(
        "/",
        interface_info,
        gobject.Closure(method_call)
    )
end

gio.bus_own_name(
    gio.BusType.SESSION,
    bus_name,
    gio.BusNameOwnerFlags.NONE,
    gobject.Closure(on_bus_acquire)
)

