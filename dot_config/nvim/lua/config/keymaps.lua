-- undo tree
vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle)

-- global note
local global_note = require("global-note")
vim.keymap.set("n", "<leader>gn", global_note.toggle_note, {
  desc = "Toggle global note",
})

-- oil
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
local Terminal = require("toggleterm.terminal").Terminal

-- focusing file tree
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

-- taskwarrior (brain dump)
-- aliased to `tw` in zsh since `task` is go-task; but shell aliases aren't
-- available to vim.fn.system (runs via /bin/sh), so hit the binary directly.
local tw = "/opt/homebrew/opt/task/bin/task"

-- add a task to inbox, annotated with where you were (file:line)
local function tw_add(desc)
  if desc == nil or desc == "" then
    return
  end
  local out = vim.fn.system(("%s add project:inbox %s"):format(tw, vim.fn.shellescape(desc)))
  local id = out:match("Created task (%d+)")
  if id then
    local loc = vim.fn.expand("%:.") .. ":" .. vim.fn.line(".")
    vim.fn.system(("%s %s annotate %s"):format(tw, id, vim.fn.shellescape(loc)))
    vim.notify(("tw: added #%s → %s"):format(id, desc), vim.log.levels.INFO)
  else
    vim.notify("tw add failed: " .. out, vim.log.levels.ERROR)
  end
end

-- <leader>ta → prompt for a task, dump to inbox
vim.keymap.set("n", "<leader>ta", function()
  tw_add(vim.fn.input("tw: "))
end, { desc = "Task: add to inbox" })

-- <leader>ta (visual) → dump the selected text as the task description
vim.keymap.set("x", "<leader>ta", function()
  vim.cmd('normal! "zy')
  tw_add(vim.fn.getreg("z"):gsub("%s+", " "))
end, { desc = "Task: add selection to inbox" })

-- <leader>tl → ready list in the floating terminal
vim.keymap.set("n", "<leader>tl", function()
  Terminal:new({ cmd = tw .. " ready; echo; read -k1", direction = "float", close_on_exit = false }):toggle()
end, { desc = "Task: list ready" })
