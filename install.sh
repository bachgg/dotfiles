# curl -fsSL moppediert.github.io/dotfiles/install.sh | sh

dotfiles_dir="${HOME}/dotfiles"

if [ ! -d "${dotfiles_dir}" ]; then
  sudo pacman -Sy --noconfirm git
  git clone https://github.com/moppediert/dotfiles.git ${dotfiles_dir}
  sh -e ${dotfiles_dir}/install.sh
else
  echo "Running installation script..."
  for script in $(ls ${dotfiles_dir}/installation/*); do
    sh -e ${script}
  done
fi
