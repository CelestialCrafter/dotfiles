local utils = require("utils")

local function key(lhs_suffix, mode)
	return {
		"<leader>t" .. lhs_suffix,
		function()
			local trouble = require("trouble")

			if trouble.is_open(mode) then
				trouble.close()
			else
				trouble.close()
				trouble.open(mode)
			end
		end,
		mode = utils.default_mode,
	}
end

return {
	"folke/trouble.nvim",
	opts = {
		win = { scratch = false },
		-- STOP FUCKING WITH MY WINDOW POSITIONSS IM GONNA KMSSSS
		modes = { symbols = { win = { position = "bottom" } } },
	},
	keys = function()
		return {
			key("d", "diagnostics"),
			key("s", "symbols"),
			key("l", "lsp"),
			key("t", "telescope"),
		}
	end,
}
