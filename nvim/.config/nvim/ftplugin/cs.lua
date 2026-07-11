require("config.functions").set_indent(4, true)

local map = require("config.functions").bufmap()

map("n", "<leader>dd", "<cmd>Dotnet<cr>", "Dotnet picker")
map("n", "<leader>db", "<cmd>Dotnet build<cr>", "Dotnet build")
map("n", "<leader>dt", "<cmd>Dotnet test<cr>", "Dotnet test")
map("n", "<leader>dr", "<cmd>Dotnet run<cr>", "Dotnet run")
map("n", "<leader>dn", function()
  local ok, dotnet = pcall(require, "easy-dotnet")
  if not ok then
    vim.notify("easy-dotnet is not available", vim.log.levels.WARN)
    return
  end
  dotnet.create_new_item(vim.fn.expand("%:p:h"))
end, "Dotnet new item")
