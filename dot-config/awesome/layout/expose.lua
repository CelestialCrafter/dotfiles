local expose = {}

local function do_expose(p)
    local wa = p.workarea
    local cls = p.clients

    if #cls <= 0 then
        return
    end

    local cols, rows
    if #cls == 2 then
        cols, rows = 2, 1
    else
        cols = math.ceil(math.sqrt(#cls))
        rows = math.ceil(#cls / cols)
    end

    for i, c in ipairs(cls) do
        i = i - 1
        local g = {}

        local col = i % cols
        local row = math.floor(i / cols)

        if #cls == 2 then
            g.height = wa.height / 2
            g.y = g.height / 2
        else
            g.height = math.ceil(wa.height / rows)
            g.y = g.height * row
        end

        g.width = math.ceil(wa.width / cols)
        g.x = g.width * col

        local offset = 0
        local extra = (cols * rows) - #cls
        if row + 1 == rows and extra > 0 then
            offset = (g.width * extra) / 2
        end

        g.y = g.y + wa.y
        g.x = g.x + wa.x + offset

        p.geometries[c] = g
    end
end

expose.name = "expose"
function expose.arrange(p)
    return do_expose(p)
end

return expose
