local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    markdown = { "prettier" },
    ["markdown.mdx"] = { "prettier" },
    vue = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
  },
  formatters = {
    prettier = {
      prepend_args = { "--prose-wrap", "preserve" },
    },
  },
})

vim.keymap.set({ "n", "x" }, "<leader>fm", function()
  conform.format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })
