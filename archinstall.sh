# curl -fsSL moppediert.github.io/dotfiles/archinstall.sh | sh

# read -p "Wifi network: " wifi_network
# iwctl station wlan0 connect "${wifi_network}"
curl -fsSLO moppediert.github.io/dotfiles/user_configuration.json
curl -fsSLO moppediert.github.io/dotfiles/user_credentials.json

read -s -p "Archinstall password: " archinstall_password
archinstall --config user_configuration.json --creds user_credentials.json --creds-decryption-key "${archinstall_password}"
