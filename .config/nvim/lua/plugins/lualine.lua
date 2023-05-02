-- Set lualine as statusline
-- See `:help lualine.txt`

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    -- theme = 'onedark',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {
      { 'mode', icons_enabled = true },
    },
    lualine_b = {
      'branch',
      {
        'diff',
        colored = true,
        diff_color = {
          added = 'DiffAdd',
          modified = 'DiffChange',
          removed = 'DiffDelete',
        },
        symbols = { added = '+', modified = '~', removed = '-' },
      },
      'diagnostics',
      -- {
      --   'buffers',
      --   show_modified_status = true,
      --   hide_filename_extension = false,
      --   mode = 2,
      --   symbols = {
      --     modified = ' ●',    -- Text to show when the buffer is modified
      --     alternate_file = '#', -- Text to show to identify the alternate file
      --     directory = '',    -- Text to show when the buffer is a directory
      --   },
      -- }
    },
    lualine_c = {}, -- filename
    lualine_x = { 'encoding', 'fileformat', 'filetype', 'searchcount' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {
      {
        'buffers',
        show_modified_status = true,
        hide_filename_extension = false,
        mode = 2,
        symbols = {
          modified = ' ●',    -- Text to show when the buffer is modified
          alternate_file = '#', -- Text to show to identify the alternate file
          directory = '',    -- Text to show when the buffer is a directory
        },
      }
    },
    lualine_b = { --[[ {"tabs", mode = 2} ]] },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  winbar = {},
  inactive_winbar = {},
  extensions = { 'quickfix', 'fugitive' }
}
