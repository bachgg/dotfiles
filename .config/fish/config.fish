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


set -U fish_greeting
set fish_vi_force_cursor true
set fish_cursor_default block
set fish_cursor_insert line

fzf --fish | source

set STARSHIP_CONFIG "~/.config/starship/starship.toml"
starship init fish | source

