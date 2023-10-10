return {

  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files

      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },

    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        -- layout_config = { prompt_position = "bottom" },
        -- sorting_strategy = "ascending",
        -- winblend = 0,
        mappings = {
          n = {
            ["<C-i>"] = require("telescope.actions.layout").toggle_preview,
          },
          i = {
            ["<C-u>"] = false,
            -- ["<esc>"] = require("telescope.actions").close,
            -- ["<C-d>"] = require("telescope.actions").delete_buffer + require("telescope.actions").move_to_top, -- ['<C-d>'] = false
            -- ["<C-i>"] = require("telescope.actions.layout").toggle_preview,
          },
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--trim",
        },
      },
      pickers = {
        find_files = {
          find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
          -- find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          -- layout_strategy='vertical',
          layout_config = { width = 0.8 },
        },
      },
      file_ignore_patterns = { "node%_modules/.*" },
    },
  },

  -- add telescope-fzf-native
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    opts = {
      extensions = {
        file_browser = {
          theme = "ivy",
          -- disables netrw and use telescope-file-browser in its place
          hijack_netrw = true,
          mappings = {
            ["i"] = {
              -- your custom insert mode mappings
            },
            ["n"] = {
              -- your custom normal mode mappings
            },
          },
        },
      },
    },
    config = function()
      require("telescope").load_extension("file_browser")
    end,
  },
}

