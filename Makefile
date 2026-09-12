# Dotfiles.
# HOME_PKGS -> managed with GNU Stow (symlinked into $HOME).
# wezterm   -> plain copy into the Windows home; the repo just stores the config,
#              WezTerm.exe (Windows) reads its own real file (no symlink).
# win32yank -> fetched binary, not a config file; see the win32yank target below.

DOTFILES     := $(CURDIR)
HOME_TARGET  := $(HOME)
WIN_HOME     := /mnt/c/Users/npham_mantu

# stow packages that target $HOME
HOME_PKGS := nvim tmux zsh starship bin

STOW := stow --dir=$(DOTFILES)

.PHONY: help install wezterm win32yank restow uninstall $(HOME_PKGS)

help:
	@echo "make install    - install everything (stow $(HOME_PKGS) + wezterm + win32yank)"
	@echo "make <pkg>      - stow one package: $(HOME_PKGS)"
	@echo "make wezterm    - copy wezterm config -> $(WIN_HOME)/.wezterm.lua"
	@echo "make win32yank  - fetch the clipboard bridge -> $(WIN32YANK_BIN)"
	@echo "make restow     - re-stow all \$$HOME packages (fix drifted links)"
	@echo "make uninstall  - remove all \$$HOME symlinks"
	@echo "Add DRYRUN=1 to preview stow, e.g. 'make install DRYRUN=1'"

# DRYRUN=1 -> pass -n -v (simulate + verbose) to stow
STOWFLAGS := $(if $(DRYRUN),-n -v,)

install: $(HOME_PKGS) wezterm win32yank

$(HOME_PKGS):
	$(STOW) --target=$(HOME_TARGET) $(STOWFLAGS) $@

# Plain copy (not a symlink): WezTerm on Windows can't follow WSL symlinks.
wezterm:
	cp $(DOTFILES)/wezterm/.wezterm.lua $(WIN_HOME)/.wezterm.lua
	@echo "wezterm config copied -> $(WIN_HOME)/.wezterm.lua"

# The WSL -> Windows clipboard bridge. bin/.local/bin/wl-{copy,paste} prefer
# WSLg's real wl-clipboard and only fall back to this, but nvim's vim.g.clipboard
# execs win32yank.exe by name, so without it every yank and paste in nvim breaks.
# It's a 1.1M PE binary, not config, so it isn't tracked here — we fetch a pinned
# release and verify it before installing.
WIN32YANK_VER     := v0.1.1
WIN32YANK_URL     := https://github.com/equalsraf/win32yank/releases/download/$(WIN32YANK_VER)/win32yank-x64.zip
WIN32YANK_ZIP_SHA := 247c9a05b94387a884b49d3db13f806b1677dfc38020f955f719be6902260cd6
WIN32YANK_EXE_SHA := dade5ae8b0bc1c029d18f260e30be1e89a3b9512bcc2904c038be75e80b02ff4
WIN32YANK_BIN     := $(HOME)/.local/bin/win32yank.exe

win32yank:
	@if [ -x "$(WIN32YANK_BIN)" ] && \
	    echo "$(WIN32YANK_EXE_SHA)  $(WIN32YANK_BIN)" | sha256sum -c --status -; then \
		echo "win32yank $(WIN32YANK_VER) already installed -> $(WIN32YANK_BIN)"; \
	else \
		set -e; \
		tmp=$$(mktemp -d); \
		trap 'rm -rf "$$tmp"' EXIT; \
		curl -fsSL -o "$$tmp/win32yank.zip" "$(WIN32YANK_URL)"; \
		echo "$(WIN32YANK_ZIP_SHA)  $$tmp/win32yank.zip" | sha256sum -c --status -; \
		unzip -qo "$$tmp/win32yank.zip" win32yank.exe -d "$$tmp"; \
		mkdir -p "$(dir $(WIN32YANK_BIN))"; \
		install -m 755 "$$tmp/win32yank.exe" "$(WIN32YANK_BIN)"; \
		echo "win32yank $(WIN32YANK_VER) installed -> $(WIN32YANK_BIN)"; \
	fi

restow:
	$(STOW) --target=$(HOME_TARGET) --restow $(STOWFLAGS) $(HOME_PKGS)

uninstall:
	$(STOW) --target=$(HOME_TARGET) --delete $(STOWFLAGS) $(HOME_PKGS)
