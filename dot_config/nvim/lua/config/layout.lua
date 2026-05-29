local M = {}

local TEXT_WIDTH = 100
local pads = {}

local function new_pad_buf()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  return buf
end

local function style_pad_win(win)
  local wo = vim.wo[win]
  wo.number = false
  wo.relativenumber = false
  wo.signcolumn = "no"
  wo.foldcolumn = "0"
  wo.cursorline = false
  wo.colorcolumn = ""
  wo.statusline = " "
  wo.winbar = ""
  wo.wrap = false
  vim.api.nvim_win_set_option(win, "winfixwidth", true)
  vim.api.nvim_set_option_value("fillchars", "vert: ", { win = win })
end

local function is_pad(win)
  return win == pads.left or win == pads.right
end

local function remove_pads()
  for _, w in pairs(pads) do
    if w and vim.api.nvim_win_is_valid(w) then
      pcall(vim.api.nvim_win_close, w, true)
    end
  end
  pads = {}
end

function M.apply()
  local main = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(main)

  -- Only apply in normal file buffers
  if vim.bo[buf].buftype ~= "" then return end

  remove_pads()

  local pad_w = math.floor((vim.o.columns - TEXT_WIDTH) / 2)
  if pad_w < 4 then return end

  vim.cmd("keepalt leftabove vsplit")
  local lw = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(lw, new_pad_buf())
  vim.api.nvim_win_set_width(lw, pad_w)
  style_pad_win(lw)

  vim.api.nvim_set_current_win(main)
  vim.cmd("keepalt rightbelow vsplit")
  local rw = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(rw, new_pad_buf())
  vim.api.nvim_win_set_width(rw, pad_w)
  style_pad_win(rw)

  vim.api.nvim_set_current_win(main)
  vim.api.nvim_set_option_value("fillchars", "vert: ", { win = main })
  pads = { left = lw, right = rw }
end

function M.setup()
  vim.opt.textwidth = TEXT_WIDTH
  vim.opt.wrap = true
  vim.opt.linebreak = true

  -- VeryLazy already fired by the time this runs, so apply immediately
  vim.schedule(M.apply)

  -- Recalculate on terminal resize
  vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      if pads.left and vim.api.nvim_win_is_valid(pads.left) then
        local main = vim.api.nvim_get_current_win()
        if not is_pad(main) then
          vim.schedule(M.apply)
        end
      end
    end,
  })

  -- Don't let cursor land in padding windows
  vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
      if is_pad(vim.api.nvim_get_current_win()) then
        vim.cmd("wincmd p")
      end
    end,
  })

  -- Clean up pads before the last real window closes so nvim can exit
  vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
      local real = vim.tbl_filter(function(w)
        return vim.api.nvim_win_is_valid(w) and not is_pad(w)
      end, vim.api.nvim_list_wins())
      if #real <= 1 then remove_pads() end
    end,
  })
end

return M
