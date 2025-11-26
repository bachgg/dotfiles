# Some git config
_git() {
  git -C "$HOME/dotfiles" "$@"
}
_git remote set-url origin "$(_git remote get-url origin | sed 's_https://github.com/_git@github.com:_g')"
_git config user.name bachgg
_git config user.email "$(printf %s@%s.%s github bach gg)"
_git config pull.rebase false
ln -s ~/.config/.gitconfig ~/.gitconfig

# Desktop manager
yay -S --noconfirm ly
sudo systemctl enable ly.service
sudo ln -sf ~/dotfiles/.config/ly/config.ini /etc/ly/config.ini

# Window manager
yay -S --noconfirm niri niriswitcher xdg-desktop-portal-gtk xdg-desktop-portal-gnome mako fyi swaylock swayidle grim

# Shell
yay -S --noconfirm zsh
sudo chsh -s /usr/bin/zsh "$(whoami)"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
yay -S --noconfirm zsh-vi-mode zsh-fast-syntax-highlighting
ln -sf ~/.config/.zshrc ~/.zshrc

# Tools
yay -S --noconfirm alacritty
ln -sf ~/dotfiles/.config/alacritty/alacritty-linux.toml ~/dotfiles/.config/alacritty/alacritty.toml
ln -sf ~/dotfiles/.config/ghostty/config-linux ~/dotfiles/.config/ghostty/config
yay -S --noconfirm tmux eza fzf bat lazygit fastfetch man openssh dust jq go-yq wev git-delta github-cli k3sup
yay -S --noconfirm cmake ripgrep fd nodejs npm go unzip neovim rust-analyzer
yay -S --noconfirm docker docker-compose
sudo systemctl enable docker.service docker.socket
sudo usermod -a -G docker "$(whoami)"
yay -S --noconfirm brave-bin pantheon-polkit-agent 1password 1password-cli tofi
yay -S --noconfirm bluez bluez-utils blueman
sudo systemctl enable bluetooth
systemctl --user enable mpris-proxy
yay -S --noconfirm bind zk socat jnv jwt-cli wl-clipboard

# Look and feel
yay -S --noconfirm gnome-themes-extra adwaita-qt5-git adwaita-qt6-git
yay -S --noconfirm noto-fonts noto-fonts-emoji ttf-roboto ttf-jetbrains-mono-nerd

# Audio
yay -Rdd --noconfirm jack2
yay -S --noconfirm pipewire pipewire-alsa pipewire-jack pipewire-pulse gst-plugin-pipewire libpulse wireplumber wiremix playerctl sof-firmware

# Brightness control
yay -S --noconfirm brillo
sudo usermod -a -G video "$(whoami)"

# Keymap
yay -S --noconfirm keyd
sudo ln -sf ~/dotfiles/.config/keyd/default.conf /etc/keyd/
sudo systemctl enable keyd

# Desktop
yay -S --noconfirm nautilus eog totem evince amberol swww btop networkmanager satty
sudo systemctl enable NetworkManager
sudo systemctl disable systemd-networkd.service NetworkManager-wait-online.service # To decrease boot time
yay -S --noconfirm switchboard switchboard-plug-bluetooth switchboard-plug-network switchboard-plug-sound gnome-settings-daemon

# Moonlander configuration
sudo ln -s ~/.config/etc/udev/rules.d/50-zsa.rules /etc/udev/rules.d/
sudo groupadd plugdev
sudo usermod -aG plugdev "$(whoami)"

# More stuff
yay -S --noconfirm ruby gum biome
yay -S --noconfirm cronie
sudo systemctl enable cronie
