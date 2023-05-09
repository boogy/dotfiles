-- Shorten function name
local keymap = vim.keymap -- for conciseness
local map = require("utils").map
local nmap = require("utils").nmap

--------------------------------------------------------------------------------------------------
-- Keymaps
--------------------------------------------------------------------------------------------------
-- quicker save shortcut
map("n", "<C-s>", "<ESC>:w<CR>")
map("i", "<C-s>", "<Esc>:w<CR>a")

-- better C-D/u with line redraw at center of window
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- keep the curso in place when joining lines with J
map("n", "J", "mzJ`z")

--
-- Normal --
--
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
-- map("n", "<D-t>", ":tabnew<CR>")
-- map("n", "<M-t>", ":tabnew<CR>")

-- Move text up and down
map("n", "<A-j>", "<Esc>:m .+1<CR>==gi")
map("n", "<A-k>", "<Esc>:m .-2<CR>==gi")

-- Change split orientation
map("n", "<leader>tk", "<C-w>t<C-w>K") -- change vertical to horizontal
map("n", "<leader>th", "<C-w>t<C-w>H") -- change horizontal to vertical

--
-- Visual --
--
-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move text up and down
map("v", "<A-j>", ":m .+1<CR>==")
map("v", "<A-k>", ":m .-2<CR>==")
map("v", "p", '"_dP')

-- greatest remap ever
-- map("x", "<leader>p", [["_dP]])

--
-- Visual Block --
--
-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv")
map("x", "K", ":move '<-2<CR>gv-gv")
map("x", "<A-j>", ":move '>+1<CR>gv-gv")
map("x", "<A-k>", ":move '<-2<CR>gv-gv")

-- delete buffer then witch to next buffer
map("n", "<leader>Q", ":bp<bar>sp<bar>bn<bar>bd<CR>")
-- map("n", "<leader>d", ":bd!<CR>")
map("n", "<leader>w", ":bw!<CR>:bnext<CR>")

-- remove highlight from search
map("n", "<leader><CR>", ":noh<CR>")

-- close quickfix window
-- map("n", "<Leader>a", ":cclose<CR>")

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- easy replace
vim.keymap.set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

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
keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
keymap.set("n", "<leader>p", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer]" })

keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
keymap.set("n", "<leader>bk", require("telescope.builtin").keymaps, { desc = "Builtin Keymaps" })

-- telescope git commands (not on youtube nvim video)
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- List all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- List git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]'
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>") -- List git branches (use <cr> to checkout) ["gb" for git branch]'
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- 'List current changes per file with diff preview'
keymap.set("n", "<leader>gS", "<cmd>Telescope git_stash<cr>") -- 'Lists stash items in current repository with ability to apply them on <cr>'
keymap.set("n", "<leader>gF", "<cmd>Telescope git_files<cr>") -- 'Lists files managed by git
-- telescope file browser
keymap.set("n", "<space>fb", ":Telescope file_browser<CR>", { noremap = true })

--------------------------------------------------------------------------------------------------
--
-- Harpoon
--
--------------------------------------------------------------------------------------------------
keymap.set("n", "<C-e>", function()
	require("harpoon.ui").toggle_quick_menu()
end)
keymap.set("n", "<C-a>", function()
	require("harpoon.mark").add_file()
end)
for i = 1, 9 do
	nmap({
		string.format("<M-%s>", i),
		function()
			require("harpoon.ui").nav_file(i)
		end,
	})
	nmap({
		string.format("<D-%s>", i),
		function()
			require("harpoon.ui").nav_file(i)
		end,
	})
end

-------------------------------------------------------------------------------------------
--
-- LSP Diagnostics
--
-------------------------------------------------------------------------------------------
vim.g.diagnostics_visible = true

keymap.set("n", "[d", vim.diagnostic.goto_prev)
keymap.set("n", "]d", vim.diagnostic.goto_next)
keymap.set("n", "<leader>E", vim.diagnostic.open_float)
keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- disable diagnostic message and show only on hoover
vim.diagnostic.config({ virtual_text = false })

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

-- vim.api.nvim_buf_set_keymap(0, 'n', '<leader>tt', ':call v:lua.require("utils").toggle_diagnostics()<CR>', { silent = true, noremap = true })
-- vim.api.nvim_buf_set_keymap(0, 'n', '<leader>T', ':call v:lua.require("utils").toggle_virtual_text()<CR>', { silent = true, noremap = true })
keymap.set(
	"n",
	"<leader>tt",
	':call v:lua.require("utils").toggle_diagnostics()<CR>',
	{ silent = true, noremap = true }
)
keymap.set(
	"n",
	"<leader>T",
	':call v:lua.require("utils").toggle_virtual_text()<CR>',
	{ silent = true, noremap = true }
)
