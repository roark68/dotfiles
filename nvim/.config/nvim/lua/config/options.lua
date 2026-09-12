vim.g.mapleader = " "

vim.o.winborder = "rounded"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

vim.opt.encoding = "utf-8"

vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.wrap = false

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.breakindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.showmode = true
vim.opt.showcmd = true
vim.opt.ruler = true
vim.opt.number = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

vim.opt.cursorline = true

vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

vim.opt.fillchars = { eob = " " }

vim.g.clipboard = {
  name = "osc52-win32yank",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = "win32yank.exe -o --lf",
    ["*"] = "win32yank.exe -o --lf",
  },
  cache_enabled = true,
}

vim.opt.clipboard:prepend({ "unnamedplus" })

vim.api.nvim_create_user_command("Indent", function(opts)
  local tabsize = tonumber(opts.args)

  if not tabsize then
    return
  end

  vim.opt.tabstop = tabsize
  vim.opt.softtabstop = tabsize
  vim.opt.shiftwidth = tabsize
end, { nargs = 1 })

require("vim._core.ui2").enable({})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.fn.mode() ~= "c" and vim.bo.buftype == "" then
      vim.cmd.checktime()
    end
  end,
})
