local conform = require("conform")

local ok_registry, registry = pcall(require, "mason-registry")
if #vim.api.nvim_list_uis() > 0 and ok_registry and registry.has_package("prettier") then
  local prettier = registry.get_package("prettier")
  if not prettier:is_installed() then
    prettier:install()
  end
end

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
