-- Leader as <Space>
vim.g.mapleader = " "

-- Border
vim.o.winborder = "rounded"

-- Disable NetRW
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable Backup/Swap files
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Encoding to UTF-8
vim.opt.encoding = "utf-8"

-- Case insensitive search
vim.opt.smartcase = true
vim.opt.ignorecase = true

-- Disable line wrap
vim.opt.wrap = false

-- Open new splits below/right and focus them
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Consistent space indentation
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.breakindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Status line
vim.opt.showmode = true
vim.opt.showcmd = true
vim.opt.ruler = true
vim.opt.number = true

-- Sign/Number column
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

-- Keep folds open when opening files
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Remove ~ at the end of files
vim.opt.fillchars = { eob = " " }

-- Yank to Clipboard
vim.g.clipboard = {
  name = "win32yank",
  copy = {
    ["+"] = "win32yank.exe -i --crlf",
    ["*"] = "win32yank.exe -i --crlf",
  },
  paste = {
    ["+"] = "win32yank.exe -o --lf",
    ["*"] = "win32yank.exe -o --lf",
  },
  cache_enabled = false,
}

vim.opt.clipboard:prepend({ "unnamed", "unnamedplus" }) -- Windows
-- vim.opt.clipboard:append({ "unnamedplus" }) -- UNIX

-- Indent commands
vim.api.nvim_create_user_command("Indent", function(opts)
  local tabsize = tonumber(opts.args)

  if not tabsize then
    return
  end

  vim.opt.tabstop = tabsize
  vim.opt.softtabstop = tabsize
  vim.opt.shiftwidth = tabsize
end, { nargs = 1 })
