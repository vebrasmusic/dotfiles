return {
  "ibhagwan/fzf-lua",
  keys = {
    {
      "<leader>fo",
      function()
        require("fzf-lua").fzf_exec("fd --type d", {
          prompt = "Dirs> ",
          actions = {
            ["default"] = function(selected)
              local dir = selected[1]
              if dir then
                vim.cmd("Oil " .. vim.fn.fnameescape(dir))
              end
            end,
          },
        })
      end,
      desc = "Find Directory → Open in Oil",
    },
  },
}
