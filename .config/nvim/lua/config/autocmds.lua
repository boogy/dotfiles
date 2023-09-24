-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-- set tabstop for json, xml, yaml files
vim.cmd([[
    autocmd FileType json,xml,yaml set tabstop=2 shiftwidth=2
]])

-- Add new line to the end of the file
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_add_new_line_end_of_file"),
  pattern = "*",
  callback = function()
    local n_lines = vim.api.nvim_buf_line_count(0)
    local last_nonblank = vim.fn.prevnonblank(n_lines)
    if last_nonblank <= n_lines then
      vim.api.nvim_buf_set_lines(0, last_nonblank, n_lines, true, { "" })
    end
  end,
})
