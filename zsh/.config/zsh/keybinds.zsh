# Tab accepts the gray autosuggestion if one is shown, else normal completion
_tab_accept_or_complete() {
  if [[ -n $POSTDISPLAY ]]; then zle autosuggest-accept; else zle expand-or-complete; fi
}
zle -N _tab_accept_or_complete
bindkey '^I' _tab_accept_or_complete
