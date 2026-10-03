# ==== System ====
alias lzd="lazydocker"
alias lg="lazygit"
alias vim="nvim"
alias v="nvim"
alias ls='eza -lh --group-directories-first --icons=auto'
alias ll='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias img='wslview'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cr="cargo run"

# ==== Dotfiles ====
alias sz="source ~/.zshrc"
alias wz="nvim /mnt/c/Users/npham_mantu/.wezterm.lua"

# ==== Git ====
alias gdd="git diff develop"
alias gdh="git diff HEAD"
alias gn="gitnexus analyze --index-only --drop-embeddings"
alias noskip='git ls-files -v | grep '^S' | cut -c3- | tr '\n' '\0' | xargs -0 git update-index --no-skip-worktree'

# ==== Mantu repos ====
alias ow='cd ~/mantu'
alias onfe='cd ~/mantu/Needs-Frontend/src/app/'
alias onbe='cd ~/mantu/Needs'
alias ocfe='cd ~/mantu/Candidates-Frontend/src/app/'
alias ocbe='cd ~/mantu/Candidates/'
alias oife='cd ~/mantu/IMP-Frontend/src/app/'
alias ojbe='cd ~/mantu/JobOffers/'
alias orfe='cd ~/mantu/Repply-Frontend/src/app/'
alias orac='cd ~/mantu/RecruitmentActivities.Components/'

# ==== token-watch ====
alias twud='token-watch use dev'
alias twui='token-watch use inte'
alias twuq='token-watch use qa'
alias tws='token-watch status'
alias twr='token-watch refresh'
alias tww='token-watch watch'
alias twg='token-watch generate'

# ==== Agents ====
alias cl='claude'
