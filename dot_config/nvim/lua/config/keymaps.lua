-- for neorg
vim.keymap.set("n", "<leader>or", "<Plug>(neorg.dirman.new-note)", { desc = "New Ne[or]g Note" })

-- for nvumi
vim.keymap.set("n", "<leader>on", "<CMD>Nvumi<CR>", { desc = "[O]pen [N]vumi" })

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
local Terminal = require("toggleterm.terminal").Terminal

vim.keymap.set("n", "<leader>n", "<C-w>h", { desc = "Focus File Tree" })
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
