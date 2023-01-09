-- [[ Keymaps ]]
--
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Shorten function name
-- local keymap = vim.api.nvim_set_keymap

-- local function map(mode, lhs, rhs, map_opts)
--   local options = { noremap=true, silent=true }
--   if map_opts then
--     options = vim.tbl_extend('force', options, map_opts)
--   end
--   vim.api.nvim_set_keymap(mode, lhs, rhs, options)
-- end

local map = require("utils").map

-- -- Disable arrow keys
-- map('', '<up>', '<nop>')
-- map('', '<down>', '<nop>')
-- map('', '<left>', '<nop>')
-- map('', '<right>', '<nop>')

-- Y yanks entire line
-- map("n", "<S-Y>", "yy")

-- quicker save shortcut
map("n", "<C-s>", "<ESC>:w<CR>")
map("i", "<C-s>", "<Esc>:w<CR>a")


-- better C-D/u with line redraw at center of window
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- keep the curso in place when joining lines with J
map("n", "J", "mzJ`z")

-- Normal --
-- Better window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-k>", "<C-w>k")

-- Resize with arrows
map("n", "<Up>", ":resize -2<CR>")
map("n", "<Down>", ":resize +2<CR>")
map("n", "<Left>", ":vertical resize -2<CR>")
map("n", "<Right>", ":vertical resize +2<CR>")

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")

-- Navigate tabs
map("n", "<C-n>", ":tabnext<CR>")
map("n", "<C-p>", ":tabprev<CR>")

-- Move text up and down
map("n", "<A-j>", "<Esc>:m .+1<CR>==gi")
map("n", "<A-k>", "<Esc>:m .-2<CR>==gi")

-- Change split orientation
map('n', '<leader>tk', '<C-w>t<C-w>K') -- change vertical to horizontal
map('n', '<leader>th', '<C-w>t<C-w>H') -- change horizontal to vertical

-- Insert --
-- Press jk fast to exit insert mode
-- keymap("i", "jk", "<ESC>", opts)
-- keymap("i", "kj", "<ESC>", opts)


-- Visual --
-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move text up and down
map("v", "<A-j>", ":m .+1<CR>==")
map("v", "<A-k>", ":m .-2<CR>==")
map("v", "p", '"_dP')

-- Visual Block --
-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv")
map("x", "K", ":move '<-2<CR>gv-gv")
map("x", "<A-j>", ":move '>+1<CR>gv-gv")
map("x", "<A-k>", ":move '<-2<CR>gv-gv")

-- delete buffer then witch to next buffer
map("n", "<leader>d", ":bd!<CR>")
map("n", "<leader>w", ":bw!<CR>:bnext<CR>")

-- remove highlight from search
map("n", "<leader><CR>", ":noh<CR>")

-- close quickfix window
map("n", "<Leader>a", ":cclose<CR>")


-- GUI Zoom
-- vim.keymap.set("n", "<C-+>", vim.fn.ZoomIn)
-- vim.keymap.set("n", "<C-->", vim.fn.ZoomOut)
-- vim.keymap.set("n", "<C-=>", vim.fn.ZoomReset)


vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- easy replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- set or remove executable for file
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>-x", "<cmd>!chmod -x %<CR>", { silent = true })


