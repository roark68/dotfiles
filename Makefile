# Dotfiles.
# nvim   -> managed with GNU Stow (symlink into $HOME).
# wezterm-> plain copy into the Windows home; the repo just stores the config,
#           WezTerm.exe (Windows) reads its own real file (no symlink).

DOTFILES     := $(CURDIR)
HOME_TARGET  := $(HOME)
WIN_HOME     := /mnt/c/Users/npham_mantu

STOW := stow --dir=$(DOTFILES)

.PHONY: help install nvim wezterm restow uninstall

help:
	@echo "make install    - install all packages"
	@echo "make nvim       - stow nvim  -> $(HOME_TARGET)/.config/nvim"
	@echo "make wezterm    - copy       -> $(WIN_HOME)/.wezterm.lua"
	@echo "make restow     - re-stow nvim (fix drifted links)"
	@echo "make uninstall  - remove nvim symlink"
	@echo "Add DRYRUN=1 to preview nvim, e.g. 'make install DRYRUN=1'"

# DRYRUN=1 -> pass -n -v (simulate + verbose) to stow
STOWFLAGS := $(if $(DRYRUN),-n -v,)

install: nvim wezterm

nvim:
	$(STOW) --target=$(HOME_TARGET) $(STOWFLAGS) nvim

# Plain copy (not a symlink): WezTerm on Windows can't follow WSL symlinks.
wezterm:
	cp $(DOTFILES)/wezterm/.wezterm.lua $(WIN_HOME)/.wezterm.lua
	@echo "wezterm config copied -> $(WIN_HOME)/.wezterm.lua"

restow:
	$(STOW) --target=$(HOME_TARGET) --restow $(STOWFLAGS) nvim

uninstall:
	$(STOW) --target=$(HOME_TARGET) --delete $(STOWFLAGS) nvim
