require("claudecode").setup({
  -- terminal.provider = "auto" detects snacks.nvim (already installed) and
  -- falls back to the native terminal if it is missing.
  terminal = {
    split_side = "right",
    split_width_percentage = 0.30,
    provider = "auto",
  },
  diff_opts = {
    layout = "vertical",
  },
})

local map = vim.keymap.set

map("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Claude: toggle" })
map("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Claude: focus" })
map("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Claude: resume" })
map("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Claude: continue" })
map("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Claude: select model" })
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Claude: add current buffer" })
map("x", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Claude: send selection" })
map("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Claude: accept diff" })
map("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Claude: deny diff" })

-- In file-explorer buffers, <leader>as adds the entry under the cursor.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "oil", "minifiles", "netrw", "NvimTree", "neo-tree" },
  callback = function(args)
    vim.keymap.set("n", "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>",
      { buffer = args.buf, silent = true, desc = "Claude: add file from explorer" })
  end,
})

-- Window navigation from terminal mode (Claude pane, toggleterm, lazygit).
-- vim-tmux-navigator's global terminal maps use `<C-W>:...<CR>` which leaks
-- keys into floating terminals; buffer-local maps here win over them. Scoped to
-- snacks/toggleterm terminals so fzf keeps <C-h> as backspace.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "snacks_terminal", "toggleterm" },
  callback = function(args)
    for key, cmd in pairs({
      ["<C-h>"] = "TmuxNavigateLeft",
      ["<C-j>"] = "TmuxNavigateDown",
      ["<C-k>"] = "TmuxNavigateUp",
      ["<C-l>"] = "TmuxNavigateRight",
    }) do
      vim.keymap.set("t", key, "<C-\\><C-n><Cmd>" .. cmd .. "<CR>",
        { buffer = args.buf, silent = true, desc = "Window nav (" .. cmd .. ")" })
    end
  end,
})
