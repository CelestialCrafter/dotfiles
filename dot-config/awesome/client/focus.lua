return function()
    -- focus follows cursor
    client.connect_signal("mouse::enter", function(c)
        c:activate({ context = "mouse_enter", raise = false })
    end)

    -- cursor follows focus
    local function warp_to_focused(c)
        if mouse.object_under_pointer() ~= c then
            local geometry = c:geometry()
            local x = geometry.x + geometry.width / 2
            local y = geometry.y + geometry.height / 2
            mouse.coords({ x = x, y = y }, true)
        end
    end

    client.connect_signal("swapped", warp_to_focused)
    client.connect_signal("focus", warp_to_focused)
end
