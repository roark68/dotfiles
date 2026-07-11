require("origami").setup({
  foldtext = {
    enabled = true,
    padding = { width = 3 },
    lineCount = {
      template = "󰦸 %d lines",
      hlgroup = "Comment",
    },
    diagnosticsCount = true,
    gitsignsCount = true,
    disableOnFt = { "snacks_picker_input" },
  },
  autoFold = {
    enabled = false,
    kinds = { "comment", "imports", "region" },
  },
})
