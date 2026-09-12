vim.pack.add({
  -- File navigation
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/refractalize/oil-git-status.nvim",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/otavioschwanck/arrow.nvim",

  -- Appearance
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  "https://github.com/neanias/everforest-nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/b0o/incline.nvim",
  "https://github.com/lukas-reineke/indent-blankline.nvim",
  "https://github.com/folke/zen-mode.nvim",
  "https://github.com/sphamba/smear-cursor.nvim",

  -- LSP, completion, and formatting
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/rachartier/tiny-code-action.nvim",
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
  "https://github.com/saghen/blink.lib",
  "https://github.com/mikavilpas/blink-ripgrep.nvim",

  -- Syntax and editing
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/chrisgrieser/nvim-origami",
  "https://github.com/gbprod/yanky.nvim",

  -- Diagnostics
  "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
  "https://github.com/j-hui/fidget.nvim",

  -- Git
  "https://github.com/lewis6991/gitsigns.nvim",

  -- Debugging
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/rcarriga/nvim-dap-ui",

  -- Language tools
  "https://github.com/GustavEikaas/easy-dotnet.nvim",
  { src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range("^9") },

  -- Markdown
  "https://github.com/obsidian-nvim/obsidian.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/iamcco/markdown-preview.nvim",

  -- Terminal and multiplexer
  "https://github.com/christoomey/vim-tmux-navigator",

  -- Developer utilities and libraries
  "https://github.com/folke/snacks.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/kkharji/sqlite.lua",
  "https://github.com/nvim-neotest/nvim-nio",
})

require("plugins.mini")
require("plugins.snacks")
require("plugins.yanky")
require("plugins.lsp")
require("plugins.treesitter")
require("plugins.colorscheme")
require("plugins.smear-cursor")
require("plugins.oil")
require("plugins.fold")
require("plugins.git")
require("plugins.formatting")
require("plugins.tiny-code-action")
require("plugins.fzf")
require("plugins.lualine")
require("plugins.buffer")
require("plugins.arrow")
require("plugins.blink")
require("plugins.diagnostics")
require("plugins.fidget")
require("plugins.dap")
require("plugins.indent")
require("plugins.zen")
require("plugins.dotnet")
require("plugins.rust")
require("plugins.obsidian")
