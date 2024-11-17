-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Set $PATH
vim.env.PATH = vim.env.PATH .. ":/opt/homebrew/opt/node@22/bin"
vim.env.PATH = vim.env.PATH .. ":/opt/homebrew/bin"

-----------------------------------------------------------
-- Neovide UI
-----------------------------------------------------------
if vim.g.neovide then
  opt.guifont = "Hack Nerd Font:h15"
  opt.linespace = 0
  -- vim.g.neovide_scale_factor = 1.0
  -- vim.g.neovide_transparency = 0.8
  -- vim.g.neovide_theme = "auto"
  vim.g.neovide_scroll_animation_length = 0.2
  vim.g.neovide_hide_mouse_when_typing = false
  vim.g.neovide_confirm_quit = false
  vim.g.neovide_fullscreen = false
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_input_macos_alt_is_meta = false
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0.5
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_unlink_border_highlights = true

  -- Keymaps
  vim.api.nvim_set_keymap(
    "n",
    "<C-+>",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>",
    { silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<C-->",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>",
    { silent = true }
  )
  vim.api.nvim_set_keymap("n", "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>", { silent = true })

  vim.keymap.set("v", "<D-c>", "y", { noremap = true, silent = true })
  vim.keymap.set("n", "<D-c>", '"*y :let @+=@*<CR>', { noremap = true, silent = true })
  vim.keymap.set("n", "<D-v>", '"+p', { noremap = true, silent = true })
  vim.keymap.set("i", "<D-v>", '<ESC>"*pa', { noremap = true, silent = true })

  vim.keymap.set("n", "<D-t>", ":tabnew<CR>")
end

-- opt.fixendofline = true
-- opt.endofline = true

vim.opt.foldlevel = 20
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
