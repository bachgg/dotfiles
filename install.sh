# curl -fsSL moppediert.github.io/dotfiles/install.sh | sh

set -e

dotfiles_dir="${HOME}/dotfiles"

if [ ! -d "${dotfiles_dir}" ]; then
  echo "Cloning script repository..."
  pacman -Sy --noconfirm git
  git clone https://github.com/moppediert/dotfiles.git ${dotfiles_dir}
  sh ${dotfiles_dir}/install.sh
else
  echo "Running installation script..."
fi
