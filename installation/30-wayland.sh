# Configuration
ln -s $HOME/dotfiles/.config/* $HOME/.config/

# Desktop manager
yay -S --noconfirm ly
sudo systemctl enable ly.service

# Window manager
yay -S --noconfirm niri xdg-desktop-portal-gtk xdg-desktop-portal-gnome

# Fonts
mkdir -p ~/.local/share/fonts
ln -s $HOME/dotfiles/.config/fonts/* $HOME/.local/share/fonts/

# Shell
yay -S --noconfirm zsh
sudo chsh -s /usr/bin/zsh $(whoami)

# Tools
yay -S --noconfirm alacritty
ln -s $HOME/dotfiles/.config/alacritty/alacritty-linux.toml $HOME/dotfiles/.config/alacritty/alacritty.toml
yay -S --noconfirm tmux eza fzf bat lazygit fastfetch
yay -S --noconfirm cmake ripgrep fd nodejs npm go unzip neovim

# Audio
yay -R --noconfirm jack2
yay -S --noconfirm pipewire pipewire-alsa pipewire-jack pipewire-pulse gst-plugin-pipewire libpulse wireplumber wiremix

# Brightness control
yay -S --noconfirm brillo
sudo usermod -a -G video $(whoami)

# Keymap
yay -S --noconfirm keyd
sudo ln -sf $HOME/dotfiles/.config/keyd/default.conf /etc/keyd/
sudo systemctl enable keyd --now
