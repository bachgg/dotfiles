#!/usr/bin/env -a zsh
alias ..="cd .."
alias ...="cd ../.."
alias ulogout="pkill -u \$(whoami)"
if [ "$(uname)" = "Linux" ]; then alias open="xdg-open"; fi

alias l="eza --long --icons --all --no-user"
alias ktx="kubectx"
alias ff="fastfetch"
alias gg="lazygit"

alias kar-server="ssh -i id_rsa_bullseye -p 32122 \$(whoami)@185.228.137.28"
alias kn="ktx && k9s -A --logoless --splashless"
alias repo="\$HOME/.config/scripts/repo.sh"
alias tssh="\$HOME/.config/scripts/tssh.sh"
alias s="\$HOME/.config/scripts/ssh.sh"
alias oms="\$HOME/go/bin/cli"
