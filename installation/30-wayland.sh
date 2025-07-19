# Some git config
git -C ~/dotfiles remote set-url origin $(git -C ~/dotfiles remote get-url origin | sed 's_https://github.com/_git@github.com:_g')
git -C ~/dotfiles config user.name moppediert
git -C ~/dotfiles config user.email $(printf %s@%s.%s moppediert gmail com)
git -C ~/dotfiles config pull.rebase false

# Desktop manager
yay -S --noconfirm ly
sudo systemctl enable ly.service
sudo ln -sf ~/dotfiles/.config/ly/config.ini /etc/ly/config.ini

# Window manager
yay -S --noconfirm niri xdg-desktop-portal-gtk xdg-desktop-portal-gnome mako fyi nautilus

# Fonts
mkdir -p ~/.local/share/fonts
ln -s ~/dotfiles/.config/fonts/* ~/.local/share/fonts/

# Shell
yay -S --noconfirm zsh
sudo chsh -s /usr/bin/zsh $(whoami)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
git clone https://github.com/jeffreytse/zsh-vi-mode ~/.oh-my-zsh/custom/plugins/zsh-vi-mode
ln -sf ~/.config/.zshrc ~/.zshrc

# Tools
yay -S --noconfirm alacritty
ln -sf ~/dotfiles/.config/alacritty/alacritty-linux.toml ~/dotfiles/.config/alacritty/alacritty.toml
yay -S --noconfirm tmux eza fzf bat lazygit fastfetch man openssh
yay -S --noconfirm cmake ripgrep fd nodejs npm go unzip neovim
yay -S --noconfirm docker
sudo systemctl enable docker.socket
sudo usermod -a -G docker $(whoami)
yay -S --noconfirm brave-bin pantheon-polkit-agent 1password 1password-cli tofi

# Look and feel
yay -S --noconfirm gnome-themes-extra adwaita-qt5-git adwaita-qt6-git

# Audio
yay -Rdd --noconfirm jack2
yay -S --noconfirm pipewire pipewire-alsa pipewire-jack pipewire-pulse gst-plugin-pipewire libpulse wireplumber wiremix

# Brightness control
yay -S --noconfirm brillo
sudo usermod -a -G video $(whoami)

# Keymap
yay -S --noconfirm keyd
sudo ln -sf ~/dotfiles/.config/keyd/default.conf /etc/keyd/
sudo systemctl enable keyd
