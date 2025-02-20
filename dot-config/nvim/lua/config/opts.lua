vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local o = vim.opt

o.shiftwidth = 4
o.tabstop = 4

o.number = true
o.relativenumber = true

o.updatetime = 200
o.timeoutlen = 300

o.ignorecase = true
o.smartcase = true

o.breakindent = true
o.undofile = true

o.cmdheight = 0
o.scrolloff = 12
o.laststatus = 3
o.gdefault = true
o.signcolumn = "yes:1"

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		o.formatoptions:remove({ "c", "r", "o" })
	end,
})
