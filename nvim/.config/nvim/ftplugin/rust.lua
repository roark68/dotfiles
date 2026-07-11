require("config.functions").set_indent(4)

local map = require("config.functions").bufmap()

map("n", "<leader>rr", "<cmd>botright split | terminal cargo run<cr>", "Rust run")
map("n", "<leader>rt", "<cmd>botright split | terminal cargo test<cr>", "Rust test")
map("n", "<leader>rc", "<cmd>botright split | terminal cargo check<cr>", "Rust check")
map("n", "<leader>rb", "<cmd>botright split | terminal cargo build<cr>", "Rust build")

local group = vim.api.nvim_create_augroup("RustFormatOnSave", { clear = false })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  buffer = 0,
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
