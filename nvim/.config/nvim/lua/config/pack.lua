local pack_specs = {
  { src = "https://github.com/catppuccin/nvim",                          name = "catppuccin" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/b0o/incline.nvim" },
  { src = "https://github.com/otavioschwanck/arrow.nvim" },
  { src = "https://github.com/nvim-mini/mini.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/chrisgrieser/nvim-origami" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/christoomey/vim-tmux-navigator" },
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/kkharji/sqlite.lua" },
  { src = "https://github.com/gbprod/yanky.nvim" },
  { src = "https://github.com/saghen/blink.cmp",                        version = vim.version.range("^1") },
  { src = "https://github.com/saghen/blink.lib" },
  { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
  { src = "https://github.com/mrcjkb/rustaceanvim",                      version = vim.version.range("^9") },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/GustavEikaas/easy-dotnet.nvim" },
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/akinsho/toggleterm.nvim" },
  { src = "https://github.com/rcarriga/nvim-notify" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
  { src = "https://github.com/folke/zen-mode.nvim" },
  { src = "https://github.com/obsidian-nvim/obsidian.nvim", },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { src = "https://github.com/iamcco/markdown-preview.nvim" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/pysan3/pathlib.nvim" },
  { src = "https://github.com/supermaven-inc/supermaven-nvim" },
  { src = "https://github.com/coder/claudecode.nvim" }
}

local pack_root = vim.fn.stdpath("data") .. "/site/pack/core"
local can_install = false
do
  local probe_dir = pack_root .. "/.codex-write-test"
  local ok, created = pcall(vim.fn.mkdir, probe_dir, "p")
  if ok and created == 1 then
    vim.fn.delete(probe_dir, "rf")
    can_install = true
  end
end

if can_install then
  vim.pack.add(pack_specs)
end

local function safe_require(module)
  local ok, value = pcall(require, module)
  if not ok then
    vim.notify(string.format("Skipping %s: %s", module, value), vim.log.levels.WARN)
    return nil
  end

  return value
end

local ui2 = safe_require("vim._core.ui2")
if ui2 then
  ui2.enable({})
end
safe_require("plugins.mini")
safe_require("plugins.snacks")
safe_require("plugins.yanky")
safe_require("plugins.rust")
safe_require("plugins.lsp")
safe_require("plugins.treesitter")
safe_require("plugins.colorscheme")
safe_require("plugins.oil")
safe_require("plugins.fold")
safe_require("plugins.gitsigns")
safe_require("plugins.conform")
safe_require("plugins.fzf")
safe_require("plugins.lualine")
safe_require("plugins.buffer")
safe_require("plugins.arrow")
safe_require("plugins.blink")
safe_require("plugins.diagnostic")
safe_require("plugins.dotnet")
safe_require("plugins.dap")
safe_require("plugins.toggleterm")
safe_require("plugins.notify")
safe_require("plugins.indent")
safe_require("plugins.zen")
safe_require("plugins.obsidian")
safe_require("plugins.render-markdown")
safe_require("plugins.markdown-preview")
safe_require("plugins.ai")
safe_require("plugins.claudecode")
