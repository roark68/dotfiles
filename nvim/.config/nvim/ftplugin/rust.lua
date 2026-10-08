require("config.functions").set_indent(4)

local map = require("config.functions").bufmap()

local function cargo(cmd)
  return function()
    require("config.functions").run_term("cargo " .. cmd)
  end
end

map("n", "<leader>rr", cargo("run"), "Rust run")
map("n", "<leader>rt", cargo("test"), "Rust test")
map("n", "<leader>rc", cargo("check"), "Rust check")
map("n", "<leader>rb", cargo("build"), "Rust build")

-- local group = vim.api.nvim_create_augroup("RustFormatOnSave", { clear = false })
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = group,
--   buffer = 0,
--   callback = function()
--     vim.lsp.buf.format({ async = false })
--   end,
-- })
