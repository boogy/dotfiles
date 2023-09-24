local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  return
end

toggleterm.setup {
  open_mapping = [[<c-t>]],
  hide_numbers = true,   -- hide the number column in toggleterm buffers
  autochdir = false,     -- when neovim changes it current directory the terminal will change it's own when next it's opened
  start_in_insert = true,
  persist_size = true,
  -- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
  direction = 'float',
  auto_scroll = true,
}

-- Custom terminal usage
-- local Terminal  = require('toggleterm.terminal').Terminal
-- local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
--
-- function _lazygit_toggle()
--   lazygit:toggle()
-- end
--
-- vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new {
  cmd = "lazygit",
  hidden = true,
  direction = "float",
  float_opts = {
    border = "none",
    width = 100000,
    height = 100000,
  },
  on_open = function(_)
    vim.cmd "startinsert!"
    -- vim.cmd "set laststatus=0"
  end,
  on_close = function(_)
    -- vim.cmd "set laststatus=3"
  end,
  count = 99,
}

function _LAZYGIT_TOGGLE()
  lazygit:toggle()
end

local python = Terminal:new { cmd = "python3", hidden = true }
function _PYTHON_TOGGLE()
  python:toggle()
end

local float_term = Terminal:new {
  direction = "float",
  on_open = function(term)
    vim.cmd "startinsert!"
    vim.api.nvim_buf_set_keymap(
      term.bufnr,
      "n",
      "<m-1>",
      "<cmd>1ToggleTerm direction=float<cr>",
      { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
      term.bufnr,
      "t",
      "<m-1>",
      "<cmd>1ToggleTerm direction=float<cr>",
      { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
      term.bufnr,
      "i",
      "<m-1>",
      "<cmd>1ToggleTerm direction=float<cr>",
      { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(term.bufnr, "", "<m-2>", "<nop>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(term.bufnr, "", "<m-3>", "<nop>", { noremap = true, silent = true })
  end,
  count = 1,
}

function _FLOAT_TERM()
  float_term:toggle()
end

local vertical_term = Terminal:new {
  direction = "vertical",
  on_open = function(term)
    vim.cmd "startinsert!"
    vim.api.nvim_buf_set_keymap(
      term.bufnr,
      "n",
      "<m-2>",
      "<cmd>2ToggleTerm size=60 direction=vertical<cr>",
      { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
      term.bufnr,
      "t",
      "<m-2>",
      "<cmd>2ToggleTerm size=60 direction=vertical<cr>",
      { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
      term.bufnr,
      "i",
      "<m-2>",
      "<cmd>2ToggleTerm size=60 direction=vertical<cr>",
      { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(term.bufnr, "", "<m-3>", "<nop>", { noremap = true, silent = true })
  end,
  count = 2,
}

function _VERTICAL_TERM()
  vertical_term:toggle(60)
end

local horizontal_term = Terminal:new {
  direction = "horizontal",
  on_open = function(term)
    vim.cmd "startinsert!"
    vim.api.nvim_buf_set_keymap(
      term.bufnr,
      "n",
      "<m-3>",
      "<cmd>3ToggleTerm size=10 direction=horizontal<cr>",
      { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
      term.bufnr,
      "t",
      "<m-3>",
      "<cmd>3ToggleTerm size=10 direction=horizontal<cr>",
      { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
      term.bufnr,
      "i",
      "<m-3>",
      "<cmd>3ToggleTerm size=10 direction=horizontal<cr>",
      { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(term.bufnr, "", "<m-2>", "<nop>", { noremap = true, silent = true })
  end,
  count = 3,
}

function _HORIZONTAL_TERM()
  horizontal_term:toggle(10)
end
