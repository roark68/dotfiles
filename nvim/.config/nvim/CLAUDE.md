# Neovim Config

Personal Neovim configuration. Runs on WSL2 (Linux) with the Windows clipboard. Targets Neovim 0.12+ (uses the native `vim.pack` plugin manager and `vim.lsp.config`/`vim.lsp.enable`).

## Architecture
- `init.lua` — entry point; two lines: `require("config")` then `require("plugins")`.
- `lua/config/init.lua` — requires `options`, `ime`, `keymaps` in order.
- `lua/config/` — core settings: `options.lua`, `keymaps.lua`, `functions.lua` (helpers exposed as `M`), `ime.lua`.
- `lua/plugins/init.lua` — one flat `vim.pack.add` list of every plugin, then a plain `require("plugins.<name>")` per setup module. **Adding a plugin = edit this file in two places.**
- `lsp/<server>.lua` — one file per LSP server, returning its config table (native Neovim `lsp/` runtime dir).
- `lua/plugins/<name>.lua` — one module per plugin; requires the plugin and runs its `setup()`. Not lazy specs — everything executes at startup.
- `ftplugin/<ft>.lua` — per-filetype overrides (indent, etc.), loaded automatically by Neovim.
- `nvim-pack-lock.json` — managed by `vim.pack`, do not hand-edit.

## Conventions
- Plugins are installed via `vim.pack.add` (native), NOT lazy.nvim/packer. There is no `return { ... }` lazy spec.
- Everything loads eagerly. No `safe_require`, no `pcall` guards, no lazy groups — a broken module is meant to be a loud error, not a warning.
- The config is deliberately comment-free. The only comments are the category headers in the `vim.pack.add` list; don't add explanatory ones elsewhere.
- Shared helpers live in `lua/config/functions.lua`: `bufmap(buf)` returns a buffer-local keymap setter; `set_indent(size, expand)` sets indentation + `undo_ftplugin`. Use these in ftplugins and `LspAttach` instead of re-rolling the boilerplate.
- LSP servers each get a `lsp/<name>.lua` returning their config table. `lua/plugins/lsp.lua` globs that directory, feeds the names to `mason-lspconfig` (`automatic_enable = false`), and calls `vim.lsp.enable`. **Add a server = add one file to `lsp/`**, nothing else.
- LSP keymaps are set in the `LspAttach` autocmd (buffer-local), preferring `fzf-lua` pickers when available.
- Formatting is via `conform.nvim` (`lua/plugins/formatting.lua`, `prettier` for web/markdown/json); `<leader>fm` formats with LSP fallback.
- Indentation: 2-space, `expandtab` (see `options.lua`). Match the surrounding file.

## Adding a plugin
1. Add the URL to the `vim.pack.add` list in `lua/plugins/init.lua`.
2. Create `lua/plugins/<name>.lua` that requires the plugin and calls its `setup()`.
3. Add `require("plugins.<name>")` to the list at the bottom of `lua/plugins/init.lua`.

## Key bindings
- Leader is `<Space>`.
- `<leader>pu` — update plugins (`vim.pack.update`); `<leader>pc` — clean unused (`functions.pack_clean`).
- `<leader>w` save all; `<leader>bd` delete buffer keeping the window.

## Important
- Clipboard: copy via OSC52 (terminal escape, no process spawn — needs tmux `allow-passthrough on` + `set-clipboard on`), paste via `win32yank.exe -o`. Do not swap the paste side for a Linux tool (`wl-copy`/`xclip`) — benchmarked slower and it breaks outside WSLg.
- Require order in `lua/plugins/init.lua` is load order: `plugins.buffer` reads the catppuccin palette, so it must stay after `plugins.colorscheme`.
- This repo IS the live `~/.config/nvim`. Changes take effect on next launch — there is no build step.
