# curl -fsSL moppediert.github.io/dotfiles/install.sh | sh

set -e

DOTFILES="${HOME}/dotfiles"

if [ ! -d "${DOTFILES}" ]; then
  echo "Cloning script repository..."
  pacman -Sy && pacman -S --noconfirm git
  git clone https://github.com/moppediert/dotfiles.git ${DOTFILES}
  sh ${DOTFILES}/install.sh
else
  echo "Running installation script..."
fi
