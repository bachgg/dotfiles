fish_add_path \
  /opt/homebrew/bin \
  /opt/homebrew/opt/fzf/bin \
  /opt/homebrew/opt/openjdk/bin \
  /opt/homebrew/opt/ruby/bin \
  /usr/bin \
  /usr/sbin \
  /sbin \
  /usr/local/bin \
  ~/.local/bin \
  ~/.bin \
  ~/go/bin \
  ~/.cargo/bin

set --export XDG_CONFIG_HOME "$HOME/.config" # For lazygit

bind \cf accept-autosuggestion
bind -M insert -m insert \cf accept-autosuggestion
bind -M insert -m insert \e\[32\;5u accept-autosuggestion

function l
  eza --long --icons --all --no-user $argv[1]
end

set -U fish_greeting
set fish_vi_force_cursor true
set fish_cursor_default block
set fish_cursor_insert line

fzf --fish | source
set --export FZF_DEFAULT_OPTS '--cycle --height=90% --marker="*" --border=sharp --preview-window=hidden --border=none'
set fzf_history_opts --with-nth=4..
fzf_configure_bindings

pyenv init - | source

set UAI_HOME $HOME/uai
function uai_mypy
  poetry run mypy --config-file $UAI_HOME/workspace/mypy-config/mypy_strict.ini $argv[1]
end
function uai_black
  poetry run black --config $UAI_HOME/workspace/black_config/pyproject.toml $argv[1]
end

set --export STARSHIP_CONFIG ~/.config/starship/starship.toml
starship init fish | source

