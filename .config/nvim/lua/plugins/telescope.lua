-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
      -- layout_strategy='vertical',
      layout_config={width=0.8}
    },
  },
  file_ignore_patterns = { "node%_modules/.*" }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

local keymap = vim.keymap -- for conciseness

-- See `:help telescope.builtin`
keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
keymap.set('n', '<leader>p', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
keymap.set('n', '<leader>bk', require('telescope.builtin').keymaps, { desc = 'Builtin Keymaps' })


-- telescope git commands (not on youtube nvim video)
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = 'List all git commits (use <cr> to checkout) ["gc" for git commits]'})
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>", { desc = 'List git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]' })
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", {desc = 'List git branches (use <cr> to checkout) ["gb" for git branch]'})
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>", {desc = 'List current changes per file with diff preview'})
keymap.set("n", "<leader>gS", "<cmd>Telescope git_stash<cr>", {desc = 'Lists stash items in current repository with ability to apply them on <cr>'})
