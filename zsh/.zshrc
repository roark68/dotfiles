# Config lives in ~/.config/zsh/ — order matters (omz before keybinds).
for f in env omz prompt keybinds aliases functions; do
  source "$HOME/.config/zsh/$f.zsh"
done
unset f
