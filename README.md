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
├── herdr/
│   └── .config/herdr/
│       └── config.toml       # -> ~/.config/herdr/config.toml (file link only)
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
make install      # install everything (stow nvim/tmux/zsh/starship/herdr + copy wezterm)
make nvim         # stow one package (also: tmux, zsh, starship, herdr)
make wezterm      # copy wezterm config -> Windows home
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
- **herdr links one file, not the directory.** `~/.config/herdr` also holds live
  runtime state (`herdr.sock`, `session.json`, `plugins.json`, `plugins/`, logs)
  that must stay machine-local, so only `config.toml` is symlinked — tree folding
  is prevented by that directory already existing. `.gitignore` whitelists just
  `config.toml` inside the package. Note `plugins/config/*/tokens.json` holds
  OAuth tokens — never move the plugin tree into the repo.
- After editing `herdr/.config/herdr/config.toml`, reload herdr with
  `` prefix+q `` (prefix is `` ` ``) to pick up the change.
- Logs (`*.log`, `.nvimlog`) are git-ignored.
