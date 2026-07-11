require("config.functions").set_indent(2, true)

vim.keymap.set("n", "<leader>dd", "<cmd>Dotnet<cr>", { buffer = true, silent = true, desc = "Dotnet picker" })
