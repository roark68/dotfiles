local fzf = require("fzf-lua")
local actions = require("fzf-lua.actions")

local fd_opts = [[--color=never --type f --type l --exclude .git --exclude bin --exclude obj --exclude target --exclude node_modules]]

fzf.setup({
  fzf_opts = {
    ["--no-scrollbar"] = true,
  },
  defaults = {
    formatter = "path.dirname_first",
  },
  winopts = {
    width = 0.8,
    height = 0.8,
    backdrop = false,
    preview = {
      vertical = "up:65%",
      layout = "vertical",
      delay = 80,
    },
  },
  files = {
    cwd_prompt = false,
    find_opts = [[-type f -not -path '*/.git/*' -not -path '*/bin/*' -not -path '*/obj/*' -not -path '*/target/*' -not -path '*/node_modules/*']],
    rg_opts = [[--color=never --files -g "!.git" -g "!bin" -g "!obj" -g "!target" -g "!node_modules"]],
    cmd = "fd " .. fd_opts,
    fd_opts = fd_opts,
    actions = {
      ["alt-i"] = { actions.toggle_ignore },
      ["alt-o"] = { actions.toggle_hidden },
    },
  },
  grep = {
    rg_opts = [[--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --glob "!**/bin/**" --glob "!**/obj/**" --glob "!**/target/**" --glob "!**/node_modules/**" -e]],
    actions = {
      ["alt-i"] = { actions.toggle_ignore },
      ["alt-o"] = { actions.toggle_hidden },
    },
  },
})

fzf.register_ui_select()

vim.keymap.set("n", "<leader><space>", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>,", function()
  fzf.buffers({ sort_mru = true, sort_lastused = true })
end, { desc = "Switch buffer" })

vim.keymap.set("n", "<leader>fF", function()
  fzf.files({ cwd = vim.uv.cwd() })
end, { desc = "Find files (cwd)" })
vim.keymap.set("n", "<leader>fb", function()
  fzf.buffers({ sort_mru = true, sort_lastused = true })
end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fg", fzf.git_files, { desc = "Find git files" })
vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })

vim.keymap.set("n", "<leader>/", fzf.live_grep, { desc = "Grep (root)" })
vim.keymap.set("n", "<leader>sw", fzf.grep_cword, { desc = "Word under cursor" })
vim.keymap.set("x", "<leader>sw", fzf.grep_visual, { desc = "Grep selection" })

vim.keymap.set("n", "<leader>fd", fzf.diagnostics_document, { desc = "Buffer diagnostics" })
vim.keymap.set("n", "<leader>sd", fzf.diagnostics_workspace, { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "Keymaps" })
vim.keymap.set("n", ";;", fzf.resume, { desc = "Resume picker" })
