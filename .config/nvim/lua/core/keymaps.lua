-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Shorten function name
local keymap = vim.keymap -- for conciseness
local map = require("utils").map

--------------------------------------------------------------------------------------------------
-- Keymaps
--------------------------------------------------------------------------------------------------
-- sync all modules
map("n", "<leader>pu", ":PackerSync<CR>", { desc = "Update all packer moduls" })

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


-- Visual --
-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move text up and down
map("v", "<A-j>", ":m .+1<CR>==")
map("v", "<A-k>", ":m .-2<CR>==")
map("v", "p", '"_dP')

-- greatest remap ever
-- map("x", "<leader>p", [["_dP]])

-- Visual Block --
-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv")
map("x", "K", ":move '<-2<CR>gv-gv")
map("x", "<A-j>", ":move '>+1<CR>gv-gv")
map("x", "<A-k>", ":move '<-2<CR>gv-gv")

-- delete buffer then witch to next buffer
map("n", "<leader>Q", ":bp<bar>sp<bar>bn<bar>bd<CR>")
map("n", "<leader>d", ":bd!<CR>")
map("n", "<leader>w", ":bw!<CR>:bnext<CR>")

-- remove highlight from search
map("n", "<leader><CR>", ":noh<CR>")

-- close quickfix window
map("n", "<Leader>a", ":cclose<CR>")


--------------------------------------------------------------------------------------------------
-- GUI Zoom
--------------------------------------------------------------------------------------------------
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

-- format current buffer
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")


--------------------------------------------------------------------------------------------------
--
-- Vim Telescope
--
--------------------------------------------------------------------------------------------------
keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
keymap.set('n', '<leader>p', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer]' })

keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
keymap.set('n', '<leader>bk', require('telescope.builtin').keymaps, { desc = 'Builtin Keymaps' })


-- telescope git commands (not on youtube nvim video)
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>",
    { desc = 'List all git commits (use <cr> to checkout) ["gc" for git commits]' })

keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>",
    { desc = 'List git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]' })

keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>",
    { desc = 'List git branches (use <cr> to checkout) ["gb" for git branch]' })

keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>",
    { desc = 'List current changes per file with diff preview' })

keymap.set("n", "<leader>gS", "<cmd>Telescope git_stash<cr>",
    { desc = 'Lists stash items in current repository with ability to apply them on <cr>' })


--------------------------------------------------------------------------------------------------
--
-- Harpoon
--
--------------------------------------------------------------------------------------------------
keymap.set("n", "<C-e>", require('harpoon.ui').toggle_quick_menu)

keymap.set("n", "<leader>a", require('harpoon.mark').add_file)
-- keymap.set("n", "<M-a>", function() require('harpoon.ui').nav_file(1) end )
-- keymap.set("n", "<M-s>", function() require('harpoon.ui').nav_file(2) end )
-- keymap.set("n", "<M-d>", function() require('harpoon.ui').nav_file(3) end )

keymap.set("n", "<M-1>", function() require('harpoon.ui').nav_file(1) end )
keymap.set("n", "<M-2>", function() require('harpoon.ui').nav_file(2) end )
keymap.set("n", "<M-3>", function() require('harpoon.ui').nav_file(3) end )
keymap.set("n", "<M-4>", function() require('harpoon.ui').nav_file(4) end )
keymap.set("n", "<M-5>", function() require('harpoon.ui').nav_file(5) end )
keymap.set("n", "<M-6>", function() require('harpoon.ui').nav_file(6) end )
keymap.set("n", "<M-7>", function() require('harpoon.ui').nav_file(7) end )
keymap.set("n", "<M-8>", function() require('harpoon.ui').nav_file(8) end )
keymap.set("n", "<M-9>", function() require('harpoon.ui').nav_file(9) end )

-- keymap.set("n", "<leader>1", ":call v:lua.require('harpoon.ui').nav_file(1)<CR>")
-- keymap.set("n", "<leader>2", ":call v:lua.require('harpoon.ui').nav_file(2)<CR>")
-- keymap.set("n", "<leader>3", ":call v:lua.require('harpoon.ui').nav_file(3)<CR>")

-- keymap.set("n", "<M-n>", require('harpoon.ui').nav_next)
-- keymap.set("n", "<M-p>", require('harpoon.ui').nav_prev)


-------------------------------------------------------------------------------------------
--
-- LSP Diagnostics
--
-------------------------------------------------------------------------------------------
vim.g.diagnostics_visible = true

keymap.set('n', '[d', vim.diagnostic.goto_prev)
keymap.set('n', ']d', vim.diagnostic.goto_next)
keymap.set('n', '<leader>E', vim.diagnostic.open_float)
keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- disable diagnostic message and show only on hoover
vim.diagnostic.config({ virtual_text = false })

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- Show all diagnostics on current line in floating window
-- vim.api.nvim_set_keymap( 'n', '<leader>d', ':lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })

-- Go to next diagnostic (if there are multiple on the same line, only shows
-- one at a time in the floating window)
-- vim.api.nvim_set_keymap( 'n', '<Leader>n', ':lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })

-- Go to prev diagnostic (if there are multiple on the same line, only shows
-- one at a time in the floating window)
-- vim.api.nvim_set_keymap( 'n', '<Leader>p', ':lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>tt', ':call v:lua.require("utils").toggle_diagnostics()<CR>',
    { silent = true, noremap = true })
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>L', ':call v:lua.require("utils").toggle_virtual_text()<CR>',
    { silent = true, noremap = true })
