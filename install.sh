# curl -fsSL moppediert.github.io/dotfiles/install.sh | sh

set -e

dotfiles_dir="${HOME}/dotfiles"

if [ ! -d "${dotfiles_dir}" ]; then
  pacman -Sy --noconfirm git gum
  gum spin --spinner dot --show-output --title "Updating databases..." -- pacman -Syyu
  gum spin --spinner dot --show-output --title "Cloning repo..." -- git clone https://github.com/moppediert/dotfiles.git ${dotfiles_dir}
  sh ${dotfiles_dir}/install.sh
else
  echo "Running installation script..."
fi
