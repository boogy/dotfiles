-- Do not source the default filetype.vim
vim.g.did_load_filetypes = 1


-- In init.lua or filetype.nvim's config file
require("filetype").setup({
    overrides = {
        complex = {
            -- Set the filetype of any full filename matching the regex to gitconfig
            [".*git/config"] = "gitconfig", -- Included in the plugin
        },

        -- The same as the ones above except the keys map to functions
        function_extensions = {
            ["pdf"] = function()
                vim.bo.filetype = "pdf"
                -- Open in PDF viewer (Skim.app) automatically
                vim.fn.jobstart(
                    "open -a skim " .. '"' .. vim.fn.expand("%") .. '"'
                )
            end,
        },
        function_literal = {
            Brewfile = function()
                vim.cmd("syntax off")
            end,
        },

        shebang = {
            -- Set the filetype of files with a dash shebang to sh
            dash = "sh",
        },
    },
})
