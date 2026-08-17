-- <C-h/j/k/l> is owned by after/plugin/herdr_nav.lua (vim-herdr-navigation);
-- vim-tmux-navigator stays for its :TmuxNavigate* commands / tmux fallback.
vim.g.tmux_navigator_no_mappings = 1

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
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/akinsho/toggleterm.nvim" },
  { src = "https://github.com/rcarriga/nvim-notify" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
  { src = "https://github.com/folke/zen-mode.nvim" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/pysan3/pathlib.nvim" },
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
  { src = "https://github.com/supermaven-inc/supermaven-nvim" },
  { src = "https://github.com/coder/claudecode.nvim" }
}

-- Project-scoped plugins. These are NOT added to 'runtimepath' at startup, so a Vue
-- repo never pays for the .NET tooling and a .NET repo never pays for the markdown
-- stack. Each group is installed + set up the first time a matching filetype is seen,
-- then the FileType event is re-fired so the buffer that triggered it gets its
-- ftplugin/LSP/keymaps as usual.
--
-- Config-only modules that just set `vim.g.*` (plugins.rust, plugins.markdown-preview)
-- stay eager below: they cost ~0.1ms and the globals must exist *before* the plugin
-- itself loads, which is the whole reason they are split out of the setup modules.
local lazy_groups = {
  {
    ft = { "cs", "fsharp", "vb", "razor", "xaml" },
    specs = { { src = "https://github.com/GustavEikaas/easy-dotnet.nvim" } },
    modules = { "plugins.dotnet" },
  },
  {
    ft = { "rust" },
    specs = { { src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range("^9") } },
    modules = {}, -- plugins.rust is globals-only and loads eagerly
  },
  {
    ft = { "markdown" },
    specs = {
      { src = "https://github.com/obsidian-nvim/obsidian.nvim" },
      { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
      { src = "https://github.com/iamcco/markdown-preview.nvim" },
    },
    modules = { "plugins.obsidian", "plugins.render-markdown" },
  },
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
safe_require("plugins.lsp")
safe_require("plugins.treesitter")
safe_require("plugins.colorscheme")
safe_require("plugins.oil")
safe_require("plugins.neo-tree")
safe_require("plugins.fold")
safe_require("plugins.gitsigns")
safe_require("plugins.conform")
safe_require("plugins.fzf")
safe_require("plugins.lualine")
safe_require("plugins.buffer")
safe_require("plugins.arrow")
safe_require("plugins.blink")
safe_require("plugins.diagnostic")
safe_require("plugins.dap")
safe_require("plugins.toggleterm")
safe_require("plugins.notify")
safe_require("plugins.indent")
safe_require("plugins.zen")
safe_require("plugins.ai")
safe_require("plugins.claudecode")

-- Globals-only modules for the lazy groups: must run before their plugin is packadd'ed.
safe_require("plugins.rust")
safe_require("plugins.markdown-preview")

local function load_group(group)
  if can_install then
    -- Post-startup `vim.pack.add` defaults to load = true, so this does a real
    -- `:packadd` and sources the plugin's plugin/ and after/plugin/ files.
    local ok, err = pcall(vim.pack.add, group.specs, { confirm = false })
    if not ok then
      vim.notify(string.format("Lazy group failed to install: %s", err), vim.log.levels.WARN)
      return
    end
  end

  for _, module in ipairs(group.modules) do
    safe_require(module)
  end
end

for _, group in ipairs(lazy_groups) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = group.ft,
    once = true,
    desc = "Lazy-load project plugins for " .. table.concat(group.ft, "/"),
    callback = function(args)
      load_group(group)
      -- Re-fire so the triggering buffer picks up ftplugins/LSP registered just now.
      vim.api.nvim_exec_autocmds("FileType", { buffer = args.buf, modeline = false })
    end,
  })
end

-- `vim.pack.update()` only sees plugins added this session, so <leader>pu would skip
-- any lazy group that has not been triggered. Pull them all in first.
vim.api.nvim_create_user_command("PackAddAll", function()
  for _, group in ipairs(lazy_groups) do
    load_group(group)
  end
  vim.notify("All lazy plugin groups loaded", vim.log.levels.INFO)
end, { desc = "Load every lazy plugin group (do this before :PackUpdate)" })
