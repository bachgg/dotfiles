alias ..="cd .."
alias ...="cd ../.."
alias ulogout="pkill -u bach"
if [ $(uname) = "Linux" ]; then alias open="xdg-open"; fi

alias l="eza --long --icons --all --no-user"
alias ktx="kubectx"
alias mr="$HOME/dotfiles/.config/scripts/mr.sh"
alias ff="fastfetch"
alias gg="lazygit"

alias kar-server="ssh -i id_rsa_bullseye -p 32122 $(whoami)@185.228.137.28"
