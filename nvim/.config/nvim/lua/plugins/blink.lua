local blink = require("blink.cmp")

blink.setup({
  keymap = {
    preset = "enter",
    ["<CR>"] = { "select_and_accept", "fallback" },
  },
  fuzzy = { implementation = "prefer_rust" },
  sources = {
    default = { "lsp", "easy-dotnet", "path" },
    per_filetype = {
      markdown = { inherit_defaults = true },
    },
    providers = {
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
