return {
  -- add gruvbox

  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.everforest_enable_italic = true
    end,
  }, -- Configure LazyVim to load gruvbox
  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup({
        extra_groups = {
          "Normal",
          "NormalNC",
          "NormalFloat",
          "NvimTreeNormal",
          "TelescopeNormal",
          "TelescopeBorder",
          "FloatBorder",
          "StatusLine",
          "EndOfBuffer",
        },
        exclude_groups = {},
      })
      vim.cmd("TransparentEnable")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
  },
  {
    "olivercederborg/poimandres.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local p = require("poimandres.palette")
      require("poimandres").setup({
        bold_vert_split = false, -- use bold vertical separators
        disable_float_background = false, -- disable background for floats
        highlight_groups = {
          LspReferenceText = { bg = p.background1 },
          LspReferenceRead = { bg = p.background1 },
          LspReferenceWrite = { bg = p.background1 },
        },
      })
    end,
  },
  {
    "2giosangmitom/nightfall.nvim",
    lazy = false,
    priority = 1000,
    opts = {}, -- Add custom configuration here
    config = function(_, opts)
      require("nightfall").setup(opts)
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "poimandres",
    },
  },
}
