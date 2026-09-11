require("fidget").setup({
  progress = {
    display = {
      done_ttl = 2,
      progress_icon = { pattern = "dots", period = 1 },
    },
  },
  notification = {
    override_vim_notify = false,
    window = {
      winblend = 0,
      border = "none",
    },
  },
})
