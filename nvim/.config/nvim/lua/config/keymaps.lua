local keymap = vim.keymap
local fn = require("config.functions")

-- Files and buffers
keymap.set("n", "<leader>w", "<cmd>wa<cr>", { desc = "Save all" })
keymap.set("n", "<leader>bd", fn.buf_delete, { desc = "Delete buffer (keep win)" })
keymap.set("n", "<leader>yp", function() vim.fn.setreg("+", vim.fn.expand("%:p")) end, { desc = "Yank file path" })
keymap.set("n", "<leader>yP", function() vim.fn.setreg("+", vim.fn.expand("%:p:h")) end, { desc = "Yank folder path" })
keymap.set("n", "''", ":checktime<CR>", { silent = true, desc = "Reload from disk" })

-- Motion and scrolling
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
keymap.set("n", "L", "$", { desc = "End of line" })
keymap.set("n", "H", "^", { desc = "Start of line" })
keymap.set("x", "L", "$", { desc = "End of line" })
keymap.set("x", "H", "^", { desc = "Start of line" })

-- Search
keymap.set("n", "n", "nzzzv", { desc = "Next match" })
keymap.set("n", "N", "Nzzzv", { desc = "Prev match" })
keymap.set("n", "<ESC>", "<cmd>nohl<cr>", { silent = true, desc = "Clear search" })

-- Editing
keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })
keymap.set("n", "x", '"_x', { desc = "Delete char (no yank)" })
keymap.set("n", "X", '"_X', { desc = "Backspace char (no yank)" })
keymap.set("x", "p", '"_dP', { desc = "Paste (keep register)" })
keymap.set("x", "P", '"_dP', { desc = "Paste (keep register)" })

-- Windows
keymap.set("n", "<leader>sh", ":split<Return>", { silent = true, desc = "Split below" })
keymap.set("n", "<leader>sv", ":vsplit<Return>", { silent = true, desc = "Split right" })
keymap.set("n", "<C-Up>", ":resize -5<CR>", { silent = true, desc = "Shrink height" })
keymap.set("n", "<C-Down>", ":resize +5<CR>", { silent = true, desc = "Grow height" })
keymap.set("n", "<C-Left>", ":vertical resize -5<CR>", { silent = true, desc = "Shrink width" })
keymap.set("n", "<C-Right>", ":vertical resize +5<CR>", { silent = true, desc = "Grow width" })

-- Plugin manager
keymap.set("n", "<leader>pu", fn.pack_update, { desc = "Pack update" })
keymap.set("n", "<leader>pc", fn.pack_clean, { desc = "Pack clean" })

-- Toggles
keymap.set("n", "<leader>uh", fn.toggle_inlay_hint, { desc = "Toggle inlay hints" })
keymap.set("n", "<leader>uw", "<cmd>set wrap!<cr>", { desc = "Toggle wrap line" })

-- Quit confirm
for _, c in ipairs({ "q", "qa", "wqa" }) do
  local name = c:upper()
  vim.api.nvim_create_user_command(name, function(o)
    local quits = c ~= "q" or (vim.fn.winnr("$") == 1 and vim.fn.tabpagenr("$") == 1)
    if o.bang or not quits or vim.fn.confirm("Quit " .. c .. "?", "&Yes\n&No", 2) == 1 then
      vim.cmd(c .. (o.bang and "!" or ""))
    end
  end, { bang = true })
  vim.cmd(("cnoreabbrev <expr> %s (getcmdtype() == ':' && getcmdline() == '%s') ? '%s' : '%s'"):format(c, c, name, c))
end
