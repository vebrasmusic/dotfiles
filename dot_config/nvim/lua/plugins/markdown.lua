return {
  -- Disable markdownlint for markdown files
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft["markdown"] = {}
    end,
  },

  -- Disable auto line-wrapping and spell for markdown
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.opt_local.textwidth = 0
          vim.opt_local.wrapmargin = 0
          vim.opt_local.formatoptions:remove({ "t", "c" })
          vim.opt_local.spell = false
        end,
      })
    end,
  },
}
