require("config.functions").set_indent(2, true)
vim.bo.commentstring = "<!-- %s -->"
vim.b.undo_ftplugin = vim.b.undo_ftplugin .. " commentstring<"

local root = vim.fs.root(0, { "package.json", "pnpm-lock.yaml", "yarn.lock", "bun.lock", "bun.lockb" })

local function has_file(name)
  return root and vim.uv.fs_stat(root .. "/" .. name) ~= nil
end

local runner = "npm run"
if has_file("pnpm-lock.yaml") then
  runner = "pnpm"
elseif has_file("yarn.lock") then
  runner = "yarn"
elseif has_file("bun.lock") or has_file("bun.lockb") then
  runner = "bun run"
end

local function run_script(script)
  vim.cmd("botright split")
  vim.fn.termopen(runner .. " " .. script, { cwd = root or vim.fn.getcwd() })
  vim.cmd("startinsert")
end

local map = require("config.functions").bufmap()

map("n", "<leader>vd", function() run_script("dev") end, "Vue dev")
map("n", "<leader>vb", function() run_script("build") end, "Vue build")
map("n", "<leader>vt", function() run_script("test") end, "Vue test")
