# curl -fsSL moppediert.github.io/dotfiles/install.sh | sh

dotfiles_dir="${HOME}/dotfiles"

if [ ! -d "${dotfiles_dir}" ]; then
  sudo pacman -Sy --noconfirm git
  git clone https://github.com/moppediert/dotfiles.git ${dotfiles_dir}
  sh -e ${dotfiles_dir}/install.sh
else
  echo "Running installation script..."
  sh -e ${dotfiles_dir}/installation/10-yay.sh
fi
