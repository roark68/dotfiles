require("render-markdown").setup({
  file_types = { "markdown" },
  completions = {
    lsp = { enabled = true },
    blink = { enabled = true },
  },
  win_options = { conceallevel = { rendered = 2 } },
})
