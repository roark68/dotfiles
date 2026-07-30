require("supermaven-nvim").setup({})

vim.keymap.set("n", "<leader>ua", function()
  local api = require("supermaven-nvim.api")
  api.toggle()
  vim.notify("AI inline suggestion " .. (api.is_running() and "enabled" or "disabled"))
end, { desc = "Toggle AI inline suggestion" })
