require("zen-mode").setup({
  window = {
    backdrop = 1,
    width = 0.9,
    height = 1,
    options = {
      number = true,
      relativenumber = true,
      signcolumn = "yes",
    },
  },
  plugins = {
    gitsigns = true,
    tmux = { enabled = false },
    kitty = {
      enabled = false,
      font = "+4",
    },
    wezterm = { enabled = false, font = "+2" },
    twilight = { enabled = false },
  },
})

vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Zen Mode" })
