-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- O
-- Add any additional keymaps here

vim.api.nvim_set_keymap(
  "n",
  "<leader>z",
  "<cmd>lua require'centerpad'.toggle{ leftpad = 30, rightpad = 0 }<cr>",
  { silent = true, noremap = true }
)

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
local Terminal = require("toggleterm.terminal").Terminal
-- -- lua/config/keymaps.lua
vim.keymap.set("n", "<leader>rn", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })

vim.keymap.set("n", "<leader>inc", function()
  require("dial.map").manipulate("increment", "normal")
end)
vim.keymap.set("n", "<leader>dec", function()
  require("dial.map").manipulate("decrement", "normal")
end)
vim.keymap.set("n", "g<leader>inc", function()
  require("dial.map").manipulate("increment", "gnormal")
end)
vim.keymap.set("n", "g<leader>dec", function()
  require("dial.map").manipulate("decrement", "gnormal")
end)

vim.keymap.set("n", "<leader>n", "<C-w>h", { desc = "Focus File Tree" })
vim.keymap.set("n", "<leader>cod", "<C-w>l", { desc = "Focus Code Window" })
-- Persistent floating terminal instance
local float_term = Terminal:new({
  direction = "float",
  hidden = true,
  float_opts = {
    border = "rounded",
    width = 100,
    height = 30,
    winblend = 10,
  },
})

-- <leader>ft → floating terminal in current working dir
vim.keymap.set("n", "<leader>ft", function()
  float_term:toggle()
end, { desc = "Floating Terminal (cwd)" })

-- <leader>fT → floating terminal in root dir
vim.keymap.set("n", "<leader>fT", function()
  float_term.dir = require("lazyvim.util").root()
  float_term:toggle()
end, { desc = "Floating Terminal (Root Dir)" })

-- <C-\> → toggle same floating terminal
vim.keymap.set({ "t" }, "<Esc>", function()
  float_term:close()
end, { desc = "Toggle Floating Terminal" })
