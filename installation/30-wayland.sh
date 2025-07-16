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
chsh -s /usr/bin/zsh

# Tools
yay -S --noconfirm tmux fzf cmake ripgrep fd nodejs npm go unzip neovim
