--------------- Keymaps ---------------
local keymap = vim.keymap
local opts = { noremap = true, silent = true }
local fn = package.loaded["config.functions"]
if type(fn) ~= "table" then
  package.loaded["config.functions"] = nil
  fn = require("config.functions")
end

-- Save all
keymap.set("n", "<leader>w", "<cmd>wa<cr>")

-- Remove buffer (keep the window/split open)
keymap.set("n", "<leader>bd", fn.buf_delete, { desc = "Delete buffer, keep window" })

-- Select all
keymap.set("n", "<C-a>", "ggVG")

-- Moving
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "L", "$")
keymap.set("n", "H", "^")
keymap.set("x", "L", "$")
keymap.set("x", "H", "^")

-- Search
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")
keymap.set("n", "<ESC>", "<cmd>nohl<cr>", opts)

-- Checktime
keymap.set("n", "''", ":checktime<CR>", opts)

-- Do not yank when x/X & p/P
keymap.set("n", "x", '"_x')
keymap.set("n", "X", '"_X')
keymap.set("x", "p", '"_dP')
keymap.set("x", "P", '"_dP')

-- Split window
keymap.set("n", "sh", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Resize screen
keymap.set("n", "<C-Up>", ":resize -5<CR>")
keymap.set("n", "<C-Down>", ":resize +5<CR>")
keymap.set("n", "<C-Left>", ":vertical resize -5<CR>")
keymap.set("n", "<C-Right>", ":vertical resize +5<CR>")

-- Vim Pack
keymap.set("n", "<leader>pu", vim.pack.update, { desc = "Pack update" })
keymap.set("n", "<leader>pc", fn.pack_clean, { desc = "Pack clean" })

-- LSP
keymap.set("n", "<leader>cl", "<cmd>checkhealth vim.lsp<cr>", { desc = "LSP Info" })

-- UI
keymap.set("n", "<leader>uh", function()
  if not vim.lsp.inlay_hint then
    vim.notify("Inlay hint is not supported in this Neovim version", vim.log.levels.WARN)
    return
  end

  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
end, { desc = "Toggle inlay hints" })

keymap.set("n", "<leader>uw", function()
  vim.opt.wrap = not vim.opt.wrap:get()
end, { desc = "Toggle wrap line" })

