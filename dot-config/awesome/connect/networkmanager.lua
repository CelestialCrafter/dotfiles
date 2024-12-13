local M = {}

function M.networks(networks)
    for _, network in networks:ipairs() do
        require("naughty").notify({text = tostring(network[2])})
    end
end

return M
