# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).
Location: `~/mantu/dotfiles` (WSL).

## Layout

```
dotfiles/
├── nvim/                     # STOW package, target: $HOME
│   └── .config/nvim/         # -> symlinked to ~/.config/nvim
├── tmux/
│   └── .tmux.conf            # -> ~/.tmux.conf
├── zsh/
│   ├── .zshrc                # -> ~/.zshrc
│   └── .zshenv               # -> ~/.zshenv
├── starship/
│   └── .config/starship.toml # -> ~/.config/starship.toml
├── bin/
│   └── .local/bin/
│       ├── wl-copy           # -> ~/.local/bin/wl-copy   (clipboard shim)
│       └── wl-paste          # -> ~/.local/bin/wl-paste  (clipboard shim)
└── wezterm/                  # plain storage (NOT stowed)
    └── .wezterm.lua          # copied to /mnt/c/Users/npham_mantu/.wezterm.lua
```

- **nvim** is a stow package: inside it, recreate the path the file should have
  **under its target** (`$HOME`). It's symlinked, so edits are live both ways.
- **wezterm** is *not* symlinked. WezTerm.exe on Windows can't follow WSL-style
  symlinks, so the repo just **stores** the config and `make wezterm` copies it
  to the Windows home. Edit `wezterm/.wezterm.lua` here, then `make wezterm` to
  deploy (this overwrites the Windows copy).

## Usage

```sh
make install      # install everything (stow packages + copy wezterm + fetch win32yank)
make nvim         # stow one package (also: tmux, zsh, starship, bin)
make wezterm      # copy wezterm config -> Windows home
make win32yank    # fetch the clipboard fallback binary -> ~/.local/bin
make restow       # re-link all $HOME packages (fixes drifted/renamed links)
make uninstall    # remove all $HOME symlinks
make install DRYRUN=1   # preview the stow steps
```

## Adding a new stow package

1. `mkdir -p <pkg>/<path-under-target>` and move the real config in.
2. Add a rule in the `Makefile` (and to `install`).
3. `make <pkg> DRYRUN=1` to preview, then `make <pkg>`.

## Notes / caveats

- `nvim/.config/nvim` is stowed as a **single directory symlink** (tree folding),
  so everything inside it — including the built-in `vim.pack` lock
  (`nvim-pack-lock.json`) — is live through the link.
- **wezterm is a copy, not a link.** Editing the Windows copy directly won't
  update the repo; edit `wezterm/.wezterm.lua` and run `make wezterm`.
- Logs (`*.log`, `.nvimlog`) are git-ignored.

## Clipboard on WSL2

`bin/.local/bin/wl-{copy,paste}` are shims that put the *Windows* clipboard
behind the familiar `wl-clipboard` names. They shadow `/usr/bin/wl-copy` on
`PATH`, and pick a backend at run time:

1. **Real `wl-clipboard` over WSLg** (`/usr/bin/wl-copy`, absolute path — the
   shim must never call `wl-copy` by name or it recurses). WSLg bridges its
   Wayland clipboard to Windows, so this reaches the same clipboard as
   win32yank, natively UTF-8 and without spawning a Windows process
   (~4ms vs ~220ms).
2. **`win32yank.exe`** — used when there is no WSLg session (WSLg disabled in
   `.wslconfig`, or a bare `ssh` into WSL), where backend 1 exits 1.

The shims normalize line endings themselves (LF→CRLF on copy, CRLF→LF on paste)
because **WSLg passes the clipboard through verbatim** while `win32yank -i
--crlf` / `-o --lf` convert. Without that, a paste into a Windows app would
depend on which backend happened to run. They also trim one trailing newline on
copy (`some-cmd | wl-copy` otherwise pastes a stray line break — use
`--no-trim` for exact bytes) and append one on paste unless `-n`.

- **win32yank is not tracked here** — it's a 1.1M PE binary. `make win32yank`
  fetches a pinned release, checks its SHA-256, and installs it to
  `~/.local/bin`. It's a no-op if the right version is already there.
- **nvim does not use the shims.** `vim.g.clipboard` in `nvim/.config/nvim/lua/
  config/options.lua` execs `win32yank.exe` directly, so nvim has no WSLg
  fallback: if that binary goes missing, nvim's `+` register breaks even though
  the shell shims keep working. Run `make win32yank` to restore it.
