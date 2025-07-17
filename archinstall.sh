# curl -fsSL moppediert.github.io/dotfiles/archinstall.sh | sh

# read -p "Wifi network: " wifi_network
# iwctl station wlan0 connect "${wifi_network}"
if [ ! -e archinstall.sh ]; then
  curl -fsSLO moppediert.github.io/dotfiles/archinstall.sh
  curl -fsSLO moppediert.github.io/dotfiles/user_configuration.json
  curl -fsSLO moppediert.github.io/dotfiles/user_credentials.json
else
  echo "Archinstall password: "
  read -s archinstall_password
  archinstall --config user_configuration.json --creds user_credentials.json --creds-decryption-key "${archinstall_password}"
fi
