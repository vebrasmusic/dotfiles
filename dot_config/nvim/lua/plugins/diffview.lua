return {
  "sindrets/diffview.nvim",
  keys = {
    {
      "<leader>df",
      function()
        local lib = require("diffview.lib")

        -- helper to toggle Snacks Zen safely
        local function trigger_zen()
          if _G.Snacks and _G.Snacks.zen then
            _G.Snacks.zen()
          end
        end

        if lib.get_current_view() then
          -- Diffview is open -> close it, then trigger Zen AFTER we switch away
          -- try the plugin's User event first, and also set a TabEnter fallback
          local grp = vim.api.nvim_create_augroup("DiffviewZenOnce", { clear = true })
          local fired = false
          local function once()
            if fired then
              return
            end
            fired = true
            vim.schedule(trigger_zen)
            pcall(vim.api.nvim_del_augroup_by_id, grp)
          end

          -- fire when Diffview reports it closed
          vim.api.nvim_create_autocmd("User", {
            group = grp,
            pattern = { "DiffviewViewClosed", "DiffviewViewLeave" },
            once = true,
            callback = once,
          })

          -- fallback: when we land on the previous tab after close
          vim.api.nvim_create_autocmd("TabEnter", {
            group = grp,
            once = true,
            callback = once,
          })

          vim.cmd("DiffviewClose")
        else
          -- Diffview is not open -> open it
          vim.cmd("DiffviewOpen")
        end
      end,
      desc = "Toggle Diffview (and Zen on close)",
    },
  },
  config = function()
    require("diffview").setup({})
  end,
}
