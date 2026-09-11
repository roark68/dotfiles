require("blink.cmp").setup({
  keymap = {
    preset = "default",
    ["<Tab>"] = { "accept", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
    ["<S-Tab>"] = { "show" },
    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-k>"] = { "select_prev", "fallback" },
  },
  completion = {
    menu = {
      auto_show = true,
      draw = {
        treesitter = { "lsp" },
        columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
      },
    },
    documentation = { auto_show = true },
  },
  signature = { enabled = true },
  fuzzy = { implementation = "prefer_rust" },
  sources = {
    default = {
      "lsp",
      "path",
      "buffer",
      "ripgrep",
      "easy-dotnet",
    },
    per_filetype = {
      sql = { "lsp", "buffer" },
      markdown = { inherit_defaults = true },
    },
    providers = {
      lsp = {
        score_offset = 90,
      },
      ripgrep = {
        module = "blink-ripgrep",
        name = "Ripgrep",
        opts = {
          prefix_min_len = 3,
          backend = {
            use = "gitgrep-or-ripgrep",
          },
        },
      },
      ["easy-dotnet"] = {
        name = "easy-dotnet",
        enabled = true,
        module = "easy-dotnet.completion.blink",
        score_offset = 10000,
        async = true,
      },
    },
  },
})
