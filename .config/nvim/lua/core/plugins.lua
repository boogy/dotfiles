local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- install plugins
require("lazy").setup({

    -- LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "j-hui/fidget.nvim",
            "folke/neodev.nvim",
        },
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            -- additional autocompletions
            "hrsh7th/cmp-path",
            -- 'hrsh7th/cmp-cmdline',
            "hrsh7th/cmp-buffer",
        },
    },

    -- Highlight, edit, and navigate code
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            pcall(require("nvim-treesitter.install").update { with_sync = true })
        end,
    },

    -- Additional text objects via treesitter
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    -- null-ls
    {
        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    },

    -- Easily speed up your neovim startup time!
    -- replacement for filetype.vim
    "nathom/filetype.nvim",
    -- Getting you where you want with the fewest keystrokes
    "ThePrimeagen/harpoon",

    -- Color Scheme
    { "ellisonleao/gruvbox.nvim",                 priority = 1000 },
    -- use 'navarasu/onedark.nvim' -- Theme inspired by Atom

    -- Some of the best vim plugins
    "tpope/vim-fugitive",
    "tpope/vim-surround",
    "tpope/vim-repeat",
    "tpope/vim-git",
    "tpope/vim-rhubarb",

    "lewis6991/gitsigns.nvim",
    "nvim-lualine/lualine.nvim",           -- Fancier statusline
    "lukas-reineke/indent-blankline.nvim", -- Add indentation guides even on blank lines
    "numToStr/Comment.nvim",               -- "gc" to comment visual regions/lines
    'tpope/vim-sleuth',                    -- Detect tabstop and shiftwidth automatically

    -- Fuzzy Finder (files, lsp, etc)
    { "nvim-telescope/telescope.nvim",            dependencies = { "nvim-lua/plenary.nvim" } },

    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { 'nvim-tree/nvim-tree.lua',                  dependencies = { 'nvim-tree/nvim-web-devicons', } },

    -- additional plugins
    "godlygeek/tabular",
    "akinsho/toggleterm.nvim",
    "ryanoasis/vim-devicons",
    "rafamadriz/friendly-snippets",
    "L3MON4D3/LuaSnip",
    "windwp/nvim-autopairs",
    -- some better markdown support
    "plasticboy/vim-markdown",
})

-- vim.cmd("colorscheme gruvbox")
