# ==== Core ====
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export LANG=en_US.UTF-8

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# ==== Oh My Zsh ====
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=robbyrussell
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# ==== NodeJS ====
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ==== Dotnet ====
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$HOME/.dotnet:$HOME/.dotnet/tools
export PATH="$HOME/.aspire/bin:$PATH"
export ASPNETCORE_ENVIRONMENT=Development

# ==== Rust ====
export PATH="$HOME/.cargo/bin:$PATH"

# ==== Mantu ====
export AZURE_DEVOPS_ORG="MANTU"
export PATH="$HOME/mantu/Obsidian/Scripts:$PATH"
export SSL_CERT_DIR="$HOME/.aspnet/dev-certs/trust:$HOME/.local/share/mantu-ca:/etc/ssl/certs"

# ==== Prompt & navigation ====
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# ==== Aliases: system ====
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

# ==== Aliases: dotfiles ====
alias sz="source ~/.zshrc"
alias wz="nvim /mnt/c/Users/npham_mantu/.wezterm.lua"

# ==== Aliases: git ====
alias gdd="git diff develop"
alias gdh="git diff HEAD"
alias gn="gitnexus analyze --index-only --drop-embeddings"
alias noskip='git ls-files -v | grep '^S' | cut -c3- | tr '\n' '\0' | xargs -0 git update-index --no-skip-worktree'

# ==== Aliases: mantu repos ====
alias ow='cd ~/mantu'
alias onfe='cd ~/mantu/Needs-Frontend/src/app/'
alias onbe='cd ~/mantu/Needs'
alias ocfe='cd ~/mantu/Candidates-Frontend/src/app/'
alias ocbe='cd ~/mantu/Candidates/'
alias oife='cd ~/mantu/IMP-Frontend/src/app/'
alias ojbe='cd ~/mantu/JobOffers/'
alias orfe='cd ~/mantu/Repply-Frontend/src/app/'
alias orac='cd ~/mantu/RecruitmentActivities.Components/'

# ==== Aliases: token-watch ====
alias twud='token-watch use dev'
alias twui='token-watch use inte'
alias twuq='token-watch use qa'
alias tws='token-watch status'
alias twr='token-watch refresh'
alias tww='token-watch watch'
alias twg='token-watch generate'

# ==== Agents ====
alias cl='claude'

ds() {
  ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic \
  ANTHROPIC_AUTH_TOKEN="$(pass show agent/deepseek)" \
  ANTHROPIC_MODEL=deepseek-v4-pro \
  claude "$@"
}
