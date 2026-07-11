local function has_sqlite_clib()
  local ok, ffi = pcall(require, "ffi")
  if not ok then
    return false
  end

  return pcall(ffi.load, vim.g.sqlite_clib_path or "libsqlite3")
end

require("yanky").setup({
  ring = {
    -- sqlite.lua needs a native sqlite3 DLL on Windows; shada works without it.
    storage = has_sqlite_clib() and "sqlite" or "shada",
  },
})

vim.keymap.set({ "n", "x" }, "<leader>p", function()
  vim.cmd("YankyRingHistory")
end, { desc = "Open Yank History" })
vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)", { remap = true, desc = "Yank text" })
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { remap = true, desc = "Put yanked text after cursor" })
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { remap = true, desc = "Put yanked text before cursor" })
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)",
  { remap = true, desc = "Put yanked text after cursor and leave cursor after" })
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)",
  { remap = true, desc = "Put yanked text before cursor and leave cursor after" })
vim.keymap.set("n", "<C-p>", "<Plug>(YankyPreviousEntry)",
  { remap = true, desc = "Select previous entry through yank history" })
vim.keymap.set("n", "<C-n>", "<Plug>(YankyNextEntry)", { remap = true, desc = "Select next entry through yank history" })
vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)",
  { remap = true, desc = "Put indented after cursor (linewise)" })
vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)",
  { remap = true, desc = "Put indented before cursor (linewise)" })
vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)",
  { remap = true, desc = "Put indented after cursor (linewise)" })
vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)",
  { remap = true, desc = "Put indented before cursor (linewise)" })
vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)", { remap = true, desc = "Put and indent right" })
vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", { remap = true, desc = "Put and indent left" })
vim.keymap.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)",
  { remap = true, desc = "Put before and indent right" })
vim.keymap.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", { remap = true, desc = "Put before and indent left" })
vim.keymap.set("n", "=p", "<Plug>(YankyPutAfterFilter)", { remap = true, desc = "Put after applying a filter" })
vim.keymap.set("n", "=P", "<Plug>(YankyPutBeforeFilter)", { remap = true, desc = "Put before applying a filter" })
