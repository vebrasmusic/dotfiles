return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      default_file_explorer = true, -- important: don't override netrw or launch automatically
      view_options = {
        show_hidden = true,
        sort = {
          {
            "name",
            "asc",
          },
        },
      },
    },
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    lazy = false,
  },
}
