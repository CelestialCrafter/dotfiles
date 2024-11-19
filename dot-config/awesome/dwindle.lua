local spiral = {}

local function do_spiral(p, is_spiral)
    local wa = p.workarea
    local t = p.tag or screen[p.screen].selected_tag
    local n = #p.clients
    local old_width, old_height = wa.width, 2 * wa.height
    local mwfactor = t.master_width_factor

    for i, c in ipairs(p.clients) do
        if i % 2 == 0 then
            wa.width, old_width = math.ceil(old_width * (1 - mwfactor)), wa.width
            if i ~= n then
                wa.height, old_height = math.floor(wa.height / 2), wa.height
            end
        else
            wa.height, old_height = math.ceil(old_height / 2), wa.height
            if i ~= n then
                wa.width, old_width = math.floor(wa.width * mwfactor), wa.width
            end
        end

        if i % 4 == 0 and is_spiral then
            wa.x = wa.x - wa.width
        elseif i % 2 == 0 then
            wa.x = wa.x + old_width
        elseif i % 4 == 3 and i < n and is_spiral then
            wa.x = wa.x + math.ceil(old_width / 2)
        end

        if i % 4 == 1 and i ~= 1 and is_spiral then
            wa.y = wa.y - wa.height
        elseif i % 2 == 1 and i ~= 1 then
            wa.y = wa.y + old_height
        elseif i % 4 == 0 and i < n and is_spiral then
            wa.y = wa.y + math.ceil(old_height / 2)
        end

        p.geometries[c] = {
            x = wa.x,
            y = wa.y,
            width = wa.width,
            height = wa.height
        }
    end
end

spiral.name = "dwindle"
function spiral.arrange(p)
    return do_spiral(p, false)
end

return spiral

