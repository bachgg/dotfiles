# Configuration
ln -s ~/dotfiles/.config ~/
ln -s ~/dotfiles/.ssh ~/

# https://github.com/basecamp/omarchy/blob/master/install/1-yay.sh
sudo pacman -Sy --needed --noconfirm base-devel

if ! command -v yay &>/dev/null; then
  cd "$(mktemp -d)" || (echo "Could not create temp dir" && exit 1)
  git clone https://aur.archlinux.org/yay-bin.git .
  makepkg -s --noconfirm
  sudo pacman -U --noconfirm "$(ls yay-bin-[0-9]*.zst)"

  # Add fun and color to the pacman installer
  sudo sed -i '/^\[options\]/a Color\nILoveCandy' /etc/pacman.conf
fi
