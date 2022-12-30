-- nvim-tree is also there in modified buffers so this function filter it out
local modifiedBufs = function(bufs)
    local t = 0
    for k, v in pairs(bufs) do
        if v.name:match("NvimTree_") == nil then
            t = t + 1
        end
    end
    return t
end

vim.api.nvim_create_autocmd("BufEnter", {
    nested = true,
    callback = function()
        if #vim.api.nvim_list_wins() == 1 and
            vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil and
            modifiedBufs(vim.fn.getbufinfo({ bufmodified = 1 })) == 0 then
            vim.cmd "quit"
        end
    end
})

vim.cmd [[
    autocmd BufWritePre * :%s/\s\+$//e
]]

-- Auto PackerCompile run when plugins.lua is changed
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Source packer.lua when written and run PackerSync
vim.cmd([[
  augroup packer_edited_user_config
    autocmd!
    autocmd BufWritePost packer.lua source <afile> | PackerSync
  augroup end
]])


-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

