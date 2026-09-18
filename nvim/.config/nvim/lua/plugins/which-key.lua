local wk = require("which-key")

wk.setup({ preset = "helix" })

wk.add({
  { "<leader>b", group = "Buffer" },
  { "<leader>c", group = "Code" },
  { "<leader>d", group = "Debug" },
  { "<leader>e", group = "Diagnostics" },
  { "<leader>f", group = "Find/Format" },
  { "<leader>g", group = "Git" },
  { "<leader>p", group = "Pack" },
  { "<leader>s", group = "Split/Symbols" },
  { "<leader>u", group = "Toggle" },
  { "<leader>y", group = "Yank" },
})
