require("snacks").setup({
  -- Performance: handle huge files and render before plugins load.
  bigfile = { enabled = true },
  quickfile = { enabled = true },

  -- Nicer vim.ui.input prompts.
  input = { enabled = true },

  -- Highlight other references to the word under the cursor (LSP).
  words = { enabled = true },

  -- Picker stays enabled; snacks.terminal (used by claudecode.nvim) and
  -- snacks.scratch are available on demand without explicit setup.
  picker = { enabled = true },

  -- Lazygit float defaults to no border; add a rounded one to match winborder.
  lazygit = {
    win = { border = "rounded" },
  },

  -- Intentionally left to dedicated plugins:
  --   notifier -> nvim-notify   indent -> indent-blankline
})

vim.keymap.set("n", "<leader>.", function()
  require("snacks").scratch()
end, { desc = "Toggle scratch buffer" })
vim.keymap.set("n", "<leader>bs", function()
  require("snacks").scratch.select()
end, { desc = "Select scratch buffer" })

-- Lazygit (replaces the toggleterm lazygit terminal).
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
