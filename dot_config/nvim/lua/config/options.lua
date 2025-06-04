-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.root_spec = { "cwd" }

vim.g.lazyvim_mini_snippets_in_completion = false

vim.g.dbs = {
  dev = "postgresql://usr:pass@localhost:5432/postgres",
}
