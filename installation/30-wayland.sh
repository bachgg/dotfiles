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
yay -S --noconfirm alacritty tmux eza fzf bat lazygit fastfetch
yay -S --noconfirm cmake ripgrep fd nodejs npm go unzip neovim

# Audio
yay -S --noconfirm pipewire wireplumber
