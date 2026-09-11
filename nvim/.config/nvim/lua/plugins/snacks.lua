require("snacks").setup({
  bigfile = { enabled = true },
  quickfile = { enabled = true },

  input = { enabled = true },

  words = { enabled = true },

  lazygit = {
    win = { border = "rounded" },
  },
})

vim.keymap.set("n", "<leader>.", function()
  require("snacks").scratch()
end, { desc = "Toggle scratch buffer" })
vim.keymap.set("n", "<leader>bs", function()
  require("snacks").scratch.select()
end, { desc = "Select scratch buffer" })

vim.keymap.set("n", "<leader>gg", function()
  if vim.fn.executable("lazygit") == 0 then
    vim.notify("Lazygit is not installed yet", vim.log.levels.WARN)
    return
  end
  require("snacks").lazygit()
end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gl", function()
  if vim.fn.executable("lazygit") == 0 then
    vim.notify("Lazygit is not installed yet", vim.log.levels.WARN)
    return
  end
  require("snacks").lazygit.log_file()
end, { desc = "Lazygit file history" })
