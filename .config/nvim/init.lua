-- vim: ts=2 sts=2 sw=2 et
--
vim.cmd([[
let g:loaded_perl_provider = 0

let $PATH = '/opt/homebrew/bin:' . $PATH
let g:node_host_prog = '/opt/homebrew/bin/neovim-node-host'
let g:python3_host_prog = '/opt/homebrew/bin/python3'
]])

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Import configuration
require("core.plugins")
require("core.keymaps")
require("core.options")
require("core.color")
require("core.autocmd")
require("core.lsp")

-- plugins configuration
require("plugins.nvim-treesitter")
require("plugins.telescope")
-- require "plugins.nvim-tree"
require("plugins.neo-tree")
require("plugins.gitsigns")
require("plugins.lualine")
require("plugins.indent-blankline")
require("plugins.comment")

require("plugins.neodev")
require("plugins.nvim-cmp")
require("plugins.nvim-autopairs")
require("plugins.nvim-markdown")
require("plugins.null-ls")
require("plugins.filetype")
require("plugins.harpoon")
require("plugins.toggleterm")
require("plugins.goto-preview")

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])
