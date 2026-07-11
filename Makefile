# Dotfiles.
# HOME_PKGS -> managed with GNU Stow (symlinked into $HOME).
# wezterm   -> plain copy into the Windows home; the repo just stores the config,
#              WezTerm.exe (Windows) reads its own real file (no symlink).

DOTFILES     := $(CURDIR)
HOME_TARGET  := $(HOME)
WIN_HOME     := /mnt/c/Users/npham_mantu

# stow packages that target $HOME
HOME_PKGS := nvim tmux zsh starship

STOW := stow --dir=$(DOTFILES)

.PHONY: help install wezterm restow uninstall $(HOME_PKGS)

help:
	@echo "make install    - install everything (stow $(HOME_PKGS) + copy wezterm)"
	@echo "make <pkg>      - stow one package: $(HOME_PKGS)"
	@echo "make wezterm    - copy wezterm config -> $(WIN_HOME)/.wezterm.lua"
	@echo "make restow     - re-stow all \$$HOME packages (fix drifted links)"
	@echo "make uninstall  - remove all \$$HOME symlinks"
	@echo "Add DRYRUN=1 to preview stow, e.g. 'make install DRYRUN=1'"

# DRYRUN=1 -> pass -n -v (simulate + verbose) to stow
STOWFLAGS := $(if $(DRYRUN),-n -v,)

install: $(HOME_PKGS) wezterm

$(HOME_PKGS):
	$(STOW) --target=$(HOME_TARGET) $(STOWFLAGS) $@

# Plain copy (not a symlink): WezTerm on Windows can't follow WSL symlinks.
wezterm:
	cp $(DOTFILES)/wezterm/.wezterm.lua $(WIN_HOME)/.wezterm.lua
	@echo "wezterm config copied -> $(WIN_HOME)/.wezterm.lua"

restow:
	$(STOW) --target=$(HOME_TARGET) --restow $(STOWFLAGS) $(HOME_PKGS)

uninstall:
	$(STOW) --target=$(HOME_TARGET) --delete $(STOWFLAGS) $(HOME_PKGS)
