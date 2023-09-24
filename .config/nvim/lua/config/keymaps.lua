-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Util = require("lazyvim.util")
local map = require("utils").map

-- Better window navigation
-- map("n", "<C-h>", "<C-w>h")
-- map("n", "<C-j>", "<C-w>j")
-- map("n", "<C-l>", "<C-w>l")
-- map("n", "<C-k>", "<C-w>k")

-- Resize with arrows
map("n", "<Up>", ":resize -2<CR>", { desc = "Resize pane up -2" })
map("n", "<Down>", ":resize +2<CR>", { desc = "Resize pane down +2" })
map("n", "<Left>", ":vertical resize -2<CR>", { desc = "Resize pane left -2" })
map("n", "<Right>", ":vertical resize +2<CR>", { desc = "Resize pane right +2" })

-- keep the curso in place when joining lines with J
map("n", "J", "mzJ`z", { desc = "Keep the cursor in place when joining lines with J", silent = true })

-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move line up", silent = true })
map("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move line down", silent = true })

map("v", "<A-j>", ":m .+1<CR>==", { desc = "Move line up", noremap = true })
map("v", "<A-k>", ":m .-2<CR>==", { desc = "Move line down", noremap = true })
map("v", "p", '"_dP')

-- Navigate tabs
map("n", "<C-n>", ":tabnext<CR>", { desc = "Tab Next", silent = true })
map("n", "<C-p>", ":tabprev<CR>", { desc = "Tab Previous" })

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>", { desc = "Buffer next", silent = true })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Buffer previous", silent = true })

-- easy replace
map("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Easy replace" })

-- Change split orientation
map("n", "<leader>tk", "<C-w>t<C-w>K", { desc = "Change split orientation left", silent = true }) -- change vertical to horizontal
map("n", "<leader>th", "<C-w>t<C-w>H", { desc = "Change split orientation right", silent = true }) -- change horizontal to vertical

-- format current buffer
map("n", "<leader>f", vim.lsp.buf.format, { desc = "Format current buffer", silent = true })

--------------------------------------------------------------------------------------------------
-- Floating terminal
--------------------------------------------------------------------------------------------------
map("n", "<leader>fP", function()
  Util.float_term("ipython3", { cwd = Util.get_root() })
end, { desc = "Terminal ipython3 (cwd)", silent = true })

--------------------------------------------------------------------------------------------------
-- Harpoon
--------------------------------------------------------------------------------------------------
map("n", "<C-e>", function()
  require("harpoon.ui").toggle_quick_menu()
end, { desc = "Harpoon toggle quick menu", silent = true })

map("n", "<C-a>", function()
  require("harpoon.mark").add_file()
end, { desc = "Add file to harpoon", silent = true })

map("n", "<leader>hn", function()
  require("harpoon.ui").nav_next()
end, { desc = "Harpoon navigate next", silent = true })

map("n", "<leader>hp", function()
  require("harpoon.ui").nav_prev()
end, { desc = "Harpoon navigate previous", silent = true })

for i = 1, 9 do
  map("n", string.format("<M-%s>", i), function()
    require("harpoon.ui").nav_file(i)
  end, { desc = string.format("Navigate to file # %s", i), silent = true })
end

--------------------------------------------------------------------------------------------------
-- Telescope
--------------------------------------------------------------------------------------------------
map("n", "<space>fB", ":Telescope file_browser<CR>", { desc = "Open Telescope File Browser", noremap = true })

-- open file_browser with the path of the current buffer
map(
  "n",
  "<space>p",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { desc = "Open telescope file browser from the current buffer", noremap = true }
)
