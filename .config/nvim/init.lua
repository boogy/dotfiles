-- vim: ts=2 sts=2 sw=2 et
--
vim.cmd([[
let g:loaded_perl_provider = 0

let $PATH = '/opt/homebrew/bin:' . $PATH
let g:node_host_prog = '/opt/homebrew/bin/neovim-node-host'
let g:python3_host_prog = '/opt/homebrew/bin/python3'
]])

-- Import configuration
require "core.plugins"
require "core.color"
require "core.keymaps"
require "core.autocmd"
require "core.options"
require "core.lsp"
-- require "core.gui-zoom"

-- plugins configuration
require "plugins.nvim-treesitter"
require "plugins.telescope"
require "plugins.nvim-tree"
require "plugins.gitsigns"
require "plugins.lualine"
require "plugins.indent-blankline"
require "plugins.comment"

require "plugins.neodev"
require "plugins.nvim-cmp"
require "plugins.nvim-autopairs"
require "plugins.nvim-markdown"
require "plugins.null-ls"
require "plugins.filetype"
-- require "plugins.mason"
