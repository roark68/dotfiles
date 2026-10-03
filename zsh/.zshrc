# Config lives in ~/.config/zsh/ — loaded in this order.
for f in env omz prompt aliases functions; do
  source "$HOME/.config/zsh/$f.zsh"
done
unset f
