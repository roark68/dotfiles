# Neovim Config

Personal Neovim configuration. Runs on WSL2 (Linux) with the Windows clipboard. Targets Neovim 0.12+ (uses the native `vim.pack` plugin manager and `vim.lsp.config`/`vim.lsp.enable`).

## Architecture
- `init.lua` — entry point; requires `config.*` modules in order, ending with `config.pack`.
- `lua/config/` — core settings: `options.lua`, `keymaps.lua`, `functions.lua` (helpers exposed as `M`), `ime.lua`, `pack.lua`.
- `lua/config/pack.lua` — declares all plugins in `pack_specs` AND `safe_require`s each plugin setup module. **Adding a plugin = edit this file in two places.**
- `lua/plugins/<name>.lua` — one module per plugin; runs its own `setup()` when required. These are NOT lazy-loaded specs — they execute immediately when required by `pack.lua`.
- `ftplugin/<ft>.lua` — per-filetype overrides (indent, etc.), loaded automatically by Neovim.
- `nvim-pack-lock.json` — managed by `vim.pack`, do not hand-edit.

## Conventions
- Plugins are installed via `vim.pack.add` (native), NOT lazy.nvim/packer. There is no `return { ... }` lazy spec.
- Plugin modules `require` their plugin directly (no inner `pcall` guard) — `pack.lua` wraps every module in `safe_require`, so a missing plugin only warns instead of aborting startup.
- Shared helpers live in `lua/config/functions.lua`: `bufmap(buf)` returns a buffer-local keymap setter; `set_indent(size, expand)` sets indentation + `undo_ftplugin`. Use these in ftplugins and `LspAttach` instead of re-rolling the boilerplate.
- LSP servers are configured in `lua/plugins/lsp.lua` via the `servers` table, installed through `mason-lspconfig` (`automatic_enable = false`), then enabled with `vim.lsp.config`/`vim.lsp.enable`. Add a server by adding a key to `servers`.
- LSP keymaps are set in the `LspAttach` autocmd (buffer-local), preferring `fzf-lua` pickers when available.
- Formatting is via `conform.nvim` (`prettier` for web/markdown/json); `<leader>fm` formats with LSP fallback.
- Indentation: 2-space, `expandtab` (see `options.lua`). Match the surrounding file.

## Adding a plugin
1. Add a spec line to `pack_specs` in `lua/config/pack.lua`.
2. Create `lua/plugins/<name>.lua` with a `pcall`-guarded `setup()`.
3. Add `safe_require("plugins.<name>")` to the require list at the bottom of `pack.lua`.

## Key bindings
- Leader is `<Space>`.
- `<leader>pu` — update plugins (`vim.pack.update`); `<leader>pc` — clean unused (`functions.pack_clean`).
- `<leader>w` save all; `<leader>bd` delete buffer keeping the window.

## Important
- Clipboard uses `win32yank.exe` (WSL → Windows). Do not change `vim.g.clipboard` to a Linux tool — it would break copy/paste on this machine.
- `pack.lua` gates `vim.pack.add` behind a write-probe of the pack dir, so the config loads cleanly in read-only/sandboxed environments. Keep that guard intact.
- This repo IS the live `~/.config/nvim`. Changes take effect on next launch — there is no build step.
