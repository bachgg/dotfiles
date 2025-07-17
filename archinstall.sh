# curl -fsSL moppediert.github.io/dotfiles/archinstall.sh | sh

# read -p "Wifi network: " wifi_network
# iwctl station wlan0 connect "${wifi_network}"

archinstall \
  --config-url https://moppediert.github.io/dotfiles/user_configuration.json \
  --creds-url https://moppediert.github.io/dotfiles/user_credentials.json
