# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).
Location: `~/mantu/dotfiles` (WSL).

## Layout

```
dotfiles/
├── nvim/                     # STOW package, target: $HOME
│   └── .config/nvim/         # -> symlinked to ~/.config/nvim
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
make install      # install everything (stow nvim + copy wezterm)
make nvim         # stow nvim -> ~/.config/nvim (symlink)
make wezterm      # copy wezterm config -> Windows home
make restow       # re-link nvim (fixes drifted/renamed links)
make uninstall    # remove the nvim symlink
make install DRYRUN=1   # preview the nvim stow step
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
