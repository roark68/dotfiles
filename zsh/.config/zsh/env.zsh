# ==== Core ====
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export LANG=en_US.UTF-8

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

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

# ==== Java ====
export JAVA_HOME=/usr/lib/jvm/default

# ==== Mantu ====
export AZURE_DEVOPS_ORG="MANTU"
export PATH="$HOME/mantu/Obsidian/Scripts:$PATH"
export SSL_CERT_DIR="$HOME/.aspnet/dev-certs/trust:$HOME/.local/share/mantu-ca:/etc/ssl/certs"
