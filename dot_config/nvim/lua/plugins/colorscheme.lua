return {
  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup({
        extra_groups = {
          "Normal",
          "NormalNC",
        },
        exclude_groups = {},
      })
      vim.cmd("TransparentEnable")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "traffic",
    },
  },
}
