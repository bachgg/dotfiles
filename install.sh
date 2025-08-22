# sh <(curl -fsSL bachgg.github.io/dotfiles/install.sh)

if [ -d /run/archiso ]; then
  curl -fsSLO bachgg.github.io/dotfiles/user_configuration.json
  curl -fsSLO bachgg.github.io/dotfiles/user_credentials.json
  echo "Archinstall password: "
  read -r -s archinstall_password
  archinstall --config user_configuration.json --creds user_credentials.json --creds-decryption-key "${archinstall_password}"
  exit 0
fi

dotfiles_dir="${HOME}/dotfiles"

if [ ! -d "${dotfiles_dir}" ]; then
  sudo pacman -Sy --noconfirm git
  git clone --recurse-submodules https://github.com/bachgg/dotfiles.git "${dotfiles_dir}"
  sh -e "${dotfiles_dir}/install.sh"
  exit 0
fi

echo "Running installation script..."
for script in "${dotfiles_dir}"/installation/*; do
  sh -e "${script}"
done
