return {
  {
    "echasnovski/mini.indentscope",
    opts = {
      draw = { animation = require("mini.indentscope").gen_animation.none() },
    },
    symbol = "│",
    -- options = { try_as_border = true },
    -- enabled = true,
  },

  -- indent-blankline
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    opts = {
      scope = { enabled = false },
    },
  },
}

-- return {}
