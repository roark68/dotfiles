local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    cs = { "csharpier" },
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

local function format_hunks()
  local hunks = require("gitsigns").get_hunks()
  if not hunks then
    conform.format({})
    return
  end
  for i = #hunks, 1, -1 do
    local a = hunks[i].added
    if a.count > 0 then
      conform.format({ range = { start = { a.start, 0 }, ["end"] = { a.start + a.count - 1, 0 } } })
    end
  end
end

vim.keymap.set("n", "<leader>fh", format_hunks, { desc = "Format changed hunks" })

