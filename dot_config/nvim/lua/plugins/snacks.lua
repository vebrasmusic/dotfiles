return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    styles = {
      zen = {
        width = 100,
      },
    },
    explorer = {
      enabled = false,
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("UIEnter", {
      callback = function()
        require("snacks").zen()
      end,
    })
  end,
}
