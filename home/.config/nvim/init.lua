-- Simple editing: sensible defaults and Catppuccin, no plugin manager.
-- The colorscheme is a native package cloned by install.sh.

vim.g.mapleader = " "

local o = vim.opt
o.number = true
o.cursorline = true
o.signcolumn = "yes"
o.scrolloff = 8
o.mouse = "a"
o.termguicolors = true

o.ignorecase = true
o.smartcase = true

o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true

o.undofile = true
o.splitright = true
o.splitbelow = true

o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Esc clears the search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- briefly highlight what was yanked
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() (vim.hl or vim.highlight).on_yank() end,
})

pcall(vim.cmd.colorscheme, "catppuccin-mocha")
