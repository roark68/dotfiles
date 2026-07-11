export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=robbyrussell

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# ==== NodeJS ====
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ==== Dotnet ====
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$HOME/.dotnet:$HOME/.dotnet/tools
export SSL_CERT_DIR="$HOME/.aspnet/dev-certs/trust:/etc/ssl/certs"

# ==== Rust ====
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.cargo/env:$PATH"

export AZURE_DEVOPS_ORG="MANTU"

# Init plugins
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# Added by get-aspire-cli.sh
export PATH="$HOME/.aspire/bin:$PATH"

# System alias
alias lzd="lazydocker"
alias lg="lazygit"
alias vim="nvim"
alias v="nvim"
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias ll='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias img='wslview'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias sz="source ~/.zshrc"
alias wz="nvim /mnt/c/Users/npham_mantu/.wezterm.lua"
alias gn="gitnexus analyze --index-only --drop-embeddings"
alias mt="node ~/mantu/hackathon/scripts/get-token.mjs"

alias ow='cd ~/mantu'
alias onfe='cd ~/mantu/Needs-Frontend/src/app/'
alias ocfe='cd ~/mantu/Candidates-Frontend/src/app/'
alias oife='cd ~/mantu/IMP-Frontend/src/app/'

# Token watch
alias twud='token-watch use dev'
alias twui='token-watch use inte'
alias twuq='token-watch use inte'
alias tws='token-watch status'
alias twr='token-watch refresh'
alias tww='token-watch watch'

alias cl='claude'

# Local secrets (untracked, NOT in dotfiles): defines DEEPSEEK_API_KEY etc.
[ -f "$HOME/.zsh_secrets" ] && source "$HOME/.zsh_secrets"

ds() {
  ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic \
  ANTHROPIC_AUTH_TOKEN="$DEEPSEEK_API_KEY" \
  ANTHROPIC_MODEL=deepseek-v4-pro \
  claude "$@"
}

# Mantu WSL dev: trust .NET dev cert + inteapi gateway cert (self-signed leaf, needs its own
# CApath dir because update-ca-trust only exports CA certs) + launcher scripts
export SSL_CERT_DIR="$HOME/.aspnet/dev-certs/trust:$HOME/.local/share/mantu-ca:/etc/ssl/certs"
export PATH="$HOME/mantu/Obsidian/Scripts:$PATH"
