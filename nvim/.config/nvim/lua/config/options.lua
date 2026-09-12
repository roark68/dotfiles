-- Leader
vim.g.mapleader = " "

-- Disabled builtins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Files and backups
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Search
vim.opt.smartcase = true
vim.opt.ignorecase = true

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Indentation
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.breakindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true

-- UI
vim.o.winborder = "rounded"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.fillchars = { eob = " " }
vim.g.tmux_navigator_save_on_switch = 1
vim.g.tmux_navigator_disable_when_zoomed = 1

require("vim._core.ui2").enable({})

-- Folding
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Clipboard
local function win32yank_paste()
  local res = vim.system({ "win32yank.exe", "-o", "--lf" }, { text = true }):wait()
  local out = res.code == 0 and res.stdout or ""
  return vim.split((out:gsub("\n$", "")), "\n")
end

vim.g.clipboard = {
  name = "osc52-win32yank",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = win32yank_paste,
    ["*"] = win32yank_paste,
  },
  cache_enabled = true,
}

vim.opt.clipboard:prepend({ "unnamedplus" })

-- Commands
vim.api.nvim_create_user_command("Indent", function(opts)
  local size = tonumber(opts.args)

  if size then
    require("config.functions").set_indent(size)
  end
end, { nargs = 1 })

-- Autocmds
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.fn.mode() ~= "c" and vim.bo.buftype == "" then
      vim.cmd.checktime()
    end
  end,
})
