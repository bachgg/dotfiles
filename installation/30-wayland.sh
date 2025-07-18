# Configuration
ln -s $HOME/dotfiles/.config/* $HOME/.config/

# Add keys so ssh does not complain
ssh-keyscan -t ed25519 github.com >> ~/.ssh/known_hosts

# Some git config
git -C $HOME/dotfiles remote set-url origin $(git -C $HOME/dotfiles remote get-url origin | sed 's_https://github.com/_git@github.com:_g')
git -C $HOME/dotfiles config user.name moppediert
git -C $HOME/dotfiles config user.email $(printf %s@%s.%s moppediert gmail com)
git -C $HOME/dotfiles config pull.rebase false

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
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode
ln -sf ~/.config/.zshrc ~/.zshrc

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
