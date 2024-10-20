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

function l
  eza --long --icons --all --no-user
end

set -U fish_greeting
set fish_vi_force_cursor true
set fish_cursor_default block
set fish_cursor_insert line

fzf --fish | source
set --export FZF_DEFAULT_OPTS '--cycle --height=90% --marker="*" --border=sharp --preview-window=hidden --border=none'
set fzf_history_opts --with-nth=4..
fzf_configure_bindings

set --export STARSHIP_CONFIG ~/.config/starship/starship.toml
starship init fish | source

