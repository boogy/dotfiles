local function augroup(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-- nvim-tree is also there in modified buffers so this function filter it out
local modifiedBufs = function(bufs)
    local t = 0
    for _, v in pairs(bufs) do
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


-- local generalSettingsGroup = vim.api.nvim_create_augroup('General settings', { clear = true })
-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = { '*.json' },
--     callback = function()
--         vim.opt.tabstop = 2
--         vim.opt.shiftwidth = 2
--     end,
--     group = generalSettingsGroup,
-- })

vim.cmd([[
    autocmd FileType json,xml,yaml set tabstop=2 shiftwidth=2
]])
