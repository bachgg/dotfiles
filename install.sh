# sh <(curl -fsSL moppediert.github.io/dotfiles/install.sh)

if [ -d /run/archiso ]; then
  curl -fsSLO moppediert.github.io/dotfiles/user_configuration.json
  curl -fsSLO moppediert.github.io/dotfiles/user_credentials.json
  echo "Archinstall password: "
  read -s archinstall_password
  archinstall --config user_configuration.json --creds user_credentials.json --creds-decryption-key "${archinstall_password}"
  exit 0
fi

dotfiles_dir="${HOME}/dotfiles"

if [ ! -d "${dotfiles_dir}" ]; then
  sudo pacman -Sy --noconfirm git
  git clone https://github.com/moppediert/dotfiles.git ${dotfiles_dir}
  sh -e ${dotfiles_dir}/install.sh
  exit 0
fi

echo "Running installation script..."
for script in $(ls ${dotfiles_dir}/installation/*); do
  sh -e ${script}
done
