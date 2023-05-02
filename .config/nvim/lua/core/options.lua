-- [[ Setting options ]]
-- See `:help vim.o`

-- local g   = vim.g   -- Global variables
-- local opt = vim.opt -- Set options (global/buffer/windows-scoped)

-- vim.cmd([[
-- let g:loaded_perl_provider = 0
--
-- let $PATH = '/opt/homebrew/bin:' . $PATH
-- let g:node_host_prog = '/opt/homebrew/bin/neovim-node-host'
-- let g:python3_host_prog = '/opt/homebrew/bin/python3'
-- ]])

vim.o.autoread = true                           -- Automatically reload changes if detected
vim.o.mouse = 'a'                               -- Enable mouse support
vim.o.mousehide = true
vim.o.clipboard = 'unnamedplus'                 -- Copy/paste to system clipboard
vim.o.completeopt = 'menuone,noinsert,noselect' -- Autocomplete options
vim.o.backspace = "eol,start,indent"
vim.o.lcs = "tab:> ,trail:-,nbsp:+"

vim.cmd('set shell=/bin/zsh')

-----------------------------------------------------------
-- Neovide UI
-----------------------------------------------------------
if vim.g.neovide then
    vim.o.guifont = "Hack Nerd Font:h15"
    vim.opt.linespace = 0
    -- vim.g.neovide_scale_factor = 1.0
    -- vim.g.neovide_transparency = 0.8
    vim.g.neovide_scroll_animation_length = 0.3
    vim.g.neovide_hide_mouse_when_typing = false
    vim.g.neovide_confirm_quit = false
    vim.g.neovide_fullscreen = false
    vim.g.neovide_remember_window_size = true
    vim.g.neovide_input_macos_alt_is_meta = false
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_cursor_trail_size = 0.5
    vim.g.neovide_cursor_antialiasing = true

    -- Keymaps
    vim.api.nvim_set_keymap("n", "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>", { silent = true })

    vim.keymap.set("n", "<D-c>", '"*y :let @+=@*<CR>', { noremap = true, silent = true })
    vim.keymap.set("n", "<D-v>", '"+p', { noremap = true, silent = true })
    vim.keymap.set("i", "<D-v>", '<ESC>"*p<CR>i<CR>', { noremap = true, silent = true })

    vim.keymap.set("n", "<D-t>", ":tabnew<CR>")

end

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
vim.o.number = true         -- Show line number
vim.o.showmatch = true      -- Highlight matching parenthesis
vim.o.foldmethod = 'marker' -- Enable folding (default 'foldmarker')
vim.o.splitright = true     -- Vertical split to the right
vim.o.splitbelow = true     -- Horizontal split to the bottom
vim.o.ignorecase = true     -- Ignore case letters when search
vim.o.smartcase = true      -- Ignore lowercase for the whole pattern
vim.o.linebreak = true      -- Wrap on word boundary
vim.o.termguicolors = true  -- Enable 24-bit RGB colors
vim.o.laststatus = 3        -- Set global statusline
-----------------------------------------------------------
vim.o.termguicolors = true
vim.o.nu = true
vim.o.relativenumber = true
vim.o.ruler = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.syntax = true
vim.o.ruler = true
vim.o.cursorline = true
vim.o.swapfile = false
vim.o.wrap = false
vim.o.hidden = true
vim.o.showtabline = true
vim.o.backup = false
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartindent = true
vim.o.incsearch = true
vim.o.lazyredraw = true
vim.o.updatetime = 250
-- Enable break indent
vim.o.breakindent = true
-- Save undo history
vim.o.undofile = true
vim.o.scrolloff = 8
-- vim.o.updatetime = 300
-- vim.o.timeoutlen = 500
vim.o.cmdheight = 2

-- Make line numbers default
vim.wo.number = true

-- Decrease update time
vim.wo.signcolumn = 'yes'
