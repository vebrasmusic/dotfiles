-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.root_spec = { "cwd" }

vim.g.lazyvim_mini_snippets_in_completion = false

vim.opt.wrap = true

vim.g.dbs = {
  dev = "postgresql://usr:pass@localhost:5432/postgres",
}

-- Neovim 0.12.5 rejects serverstart() with a bare name, which is what fzf-lua passes
-- ("fzf-lua.<time>"), so every fzf-lua picker failed with "loop or previous error loading
-- module 'fzf-lua'". fzf-lua skips its own serverstart() when this is already set, so hand it
-- this instance's server address instead. Safe to delete once fzf-lua passes a full path.
if vim.v.servername ~= "" then
  vim.g.fzf_lua_server = vim.v.servername
end
